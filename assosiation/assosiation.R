
# transactions
tr <- read.transactions("AssociationRules.csv", sep=' ', header = FALSE)
df <- read.csv("AssociationRules.csv", sep=" ", header=FALSE)

install.packages("arules")
library(arules)

summary(tr)
itemFrequencyPlot(tr, topN = 10, type="absolute")

# most frequent item13
# largest transaction size 14

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
  unlist(inspection["lift"]), ))
scatter_plot <- plt + geom_point() + labs(x="support", y="lift")
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

