
# transactions
tr <- read.transactions("AssociationRules.csv", sep=' ', header = FALSE)
df <- read.csv("AssociationRules.csv", sep=" ", header=FALSE)

install.packages("arules")
library(arules)

summary(tr)
itemFrequencyPlot(tr, topN = 10, type="absolute")

# most frequent item13
tr_df <- as(tr, "data.frame")
tr_df["size"] <- sapply(unlist(tr_df["items"]), function(itemset) length(unlist(strsplit(itemset, split=","))))
# largest transaction size 25

rules <- apriori(tr, parameter=list(supp=0.01, conf=0))
inspect(rules)
# 11524 rules
rules <- apriori(tr, parameter=list(supp=0.01, conf=0.5))
inspection <- inspect(rules)
# 1165 rules

library(ggplot2)
library(plotly)

plt <- ggplot(inspection, aes(
  text=paste(unlist(inspection["lhs"]), unlist(inspection["rhs"]), sep="->"), 
  unlist(inspection["support"]), 
  unlist(inspection["confidence"]), 
  colour = unlist(inspection["lift"])))
scatter_plot <- plt + geom_point() + labs(x="support", y="confidence", color="lift")
ggplotly(scatter_plot)
ggsave("support_confidence_plt.png")

plt <- ggplot(inspection, aes(
  text=paste(unlist(inspection["lhs"]), unlist(inspection["rhs"]), sep="->"), 
  unlist(inspection["support"]), 
  unlist(inspection["lift"]), 
  colour=unlist(inspection["confidence"])),
  )
scatter_plot <- plt + geom_point() + labs(x="support", y="lift", color="confidence")
ggplotly(scatter_plot)
ggsave("support_lift_plt.png")

rules <- apriori(tr, parameter=list(supp=0.01, conf=0.8))
rules <- sort(rules, by="lift")
inspection <- inspect(rules)

plt <- ggplot(inspection,
              aes(
                text=unlist(inspection["lift"]),
                unlist(inspection["lhs"]),
                unlist(inspection["rhs"]),
                #colour = unlist(inspection["lift"]),
                fill = unlist(inspection["lift"])
              ))
matrix_based_plt <- plt + 
  geom_raster() + 
  labs(x="lhs", y="rhs", fill="lift") + 
  theme(axis.text.x = element_blank(), axis.text.y = element_blank())
ggplotly(matrix_based_plt)
ggsave("matrix_based_viz_lift_plt.png")
# top lift rules
# {item15, item30, item49} -> {item56}
# {item15, item49} -> {item56}
# {item30, item49, item84} -> {item56}
# {item30, item49, item56} -> {item15}
# vary from step 3 because those didn't have confidence more than 0.8, so they didn't occured here

plt <- ggplot(inspection,
              aes(
                text=unlist(inspection["confidence"]),
                unlist(inspection["lhs"]),
                unlist(inspection["rhs"]),
                #colour = unlist(inspection["lift"]),
                fill = unlist(inspection["confidence"])
              ))
matrix_based_plt <- plt + 
  geom_raster() + 
  labs(x="lhs", y="rhs", fill="confidence") + 
  theme(axis.text.x = element_blank(), axis.text.y = element_blank())
ggplotly(matrix_based_plt)
ggsave("matrix_based_viz_conf_plt.png")
# top confidence rules
# {item15, item49, item56} -> {item30}
# {item49, item56, item84} -> {item30}
# {item49, item56} -> {item30}
# {item15, item49, item84} -> {item30}
# {item15, item30, item49} -> {item56}


library(igraph)

lhs <- unlist(inspection["lhs"])
rhs <- unlist(inspection["rhs"])
vertecies <- c(lhs, rhs)
matr <- matrix(0, nrow=length(unique(vertecies)), ncol=length(unique(vertecies)))
rownames(matr) <- unique(vertecies)
colnames(matr) <- unique(vertecies)
names(lhs) <- lhs
names(rhs) <- rhs

for (g in c(1:40)) {
  matr[lhs[g], rhs[g]] <- 1
}
network <- graph_from_adjacency_matrix(matr)
par(cex=0.5)
plot(network, layout=layout.kamada.kawai, vertex.color="green")

library(visNetwork)

# Prepare node and edge data
nodes <- data.frame(
  id = 1:vcount(network),
  label = unique(vertecies),
  size = degree(network) * 3
)
edges <- as_data_frame(network, what = "edges")
edges["from"] <- sapply(edges["from"], function(from) nodes[from,]["id"])
edges["to"] <- sapply(edges["to"], function(to) nodes[to,]["id"])
graph <- visNetwork(nodes, edges)
graph
htmltools::save_html(graph, "graph.html")

training <- tr[1:8000]
test <- tr[-c(1:8000)]

training_rules <- apriori(training, parameter=list(supp=0.01, conf=0.5))
test_rules <- apriori(test, parameter=list(supp=0.01, conf=0.5))
training_inspection <- inspect(training_rules)
test_inspection <- inspect(test_rules)


