library(ggplot2)

k<-7
itr_max <- 20
# clustering
clusterisation <- kmeans(income_elec_state, k, nstart=50, iter.max = itr_max)

# assigning cluster to every state
income_elec_state["cluster"] <- as.factor(unlist(clusterisation["cluster"]))

# pulling up centroids' coordinates
centers_income <- as.data.frame(clusterisation["centers"])["centers.income"]
centers_elec <- as.data.frame(clusterisation["centers"])["centers.elec"]

centers_income <- sapply(clusterisation["cluster"], function(cluster) centers_income[cluster,])
centers_elec <- sapply(clusterisation["cluster"], function(cluster) centers_elec[cluster,])

income_elec_state["center_x"] <- centers_income
income_elec_state["center_y"] <- centers_elec

plt_data <- ggplot(income_elec_state, aes(unlist(income_elec_state["income"]), unlist(income_elec_state["elec"]), color=unlist(income_elec_state["cluster"])))
plt_centroids <- ggplot(income_elec_state, aes(unlist(income_elec_state["center_x"]), unlist(income_elec_state["center_y"])))
plt_data + geom_point() + geom_point(aes(unlist(income_elec_state["center_x"]), unlist(income_elec_state["center_y"])), colour="black") + labs(title="clusters", x="income", y="elec", colour="cluster")
ggsave(paste("plt_k_", as.character(k), ".png"))

# finding optimal k
k_vals <- c(1:30)

# WSS
wss <- sapply(k_vals, function(val) sum(unlist(kmeans(income_elec_state, val, nstart=50)["withinss"])))

df <- data.frame(k=k_vals, wss=wss)
elbow_plt <- ggplot(df, aes(k_vals, wss))
elbow_plt + geom_point() + labs(x="k") + scale_x_continuous(breaks=c(1:30))
ggsave("elbow_plt.png")

# the optimal k is 7


# trying on log scale
income_elec_state["log_income"] <- lapply(income_elec_state["income"], log10)
income_elec_state["log_elec"] <- lapply(income_elec_state["elec"], log10)

df <- data.frame(log_income=income_elec_state["log_income"], log_elec=income_elec_state["log_elec"])

clusterisation <- kmeans(df, k, nstart=50, iter.max = itr_max)

centers_income <- as.data.frame(clusterisation["centers"])["centers.log_income"]
centers_elec <- as.data.frame(clusterisation["centers"])["centers.log_elec"]

centers_income <- lapply(clusterisation["cluster"], function(cluster) centers_income[cluster,])
centers_elec <- lapply(clusterisation["cluster"], function(cluster) centers_elec[cluster,])

df['cluster'] <- as.factor(unlist(clusterisation['cluster']))
df["center_x"] <- centers_income
df["center_y"] <- centers_elec

plt <- ggplot(df, aes(unlist(df["log_income"]), unlist(df["log_elec"]), color = unlist(df["cluster"])))
plt + geom_point() + geom_point(aes(unlist(df["center_x"]), unlist(df["center_y"])), color="black") + labs(title="clusters", x="log_income", y="log_elec", colour="cluster")
ggsave(paste("plt_k_", as.character(k), "_log.png"))

# finding optimal k for log scale
df <- subset(df, df["log_income"]>4.5 & df["log_elec"]>2.8)

k_vals <- c(1:30)
df <- data.frame(log_income=df["log_income"], log_elec=df["log_elec"])

wss <- sapply(k_vals, function(val) sum(unlist(kmeans(df, val, nstart=50)["withinss"])))

df <- data.frame(k=k_vals, wss=wss)
elbow_plt <- ggplot(df, aes(k_vals, wss))
elbow_plt + geom_point() + labs(x="k") + scale_x_continuous(breaks=c(1:30))
ggsave("elbow_plt_log.png")
# without obvious outliers


install.packages('maps')
library(maps)

us_states <- rownames(df)
us_col <- unlist(df["cluster"])

us_states <- replace(us_states, us_states=="TX", "TEX")
us_states <- replace(us_states, us_states=="KY", "Kentucky")
us_states <- replace(us_states, us_states=="KS", "Kansas")
us_states <- replace(us_states, us_states=="IA", "Iowa")
us_states <- replace(us_states, us_states=="ND", "North Dakota")
us_states <- replace(us_states, us_states=="SD", "South Dakota")
us_states <- replace(us_states, us_states=="LA", "Louisiana")
us_states <- replace(us_states, us_states=="TN", "Tennessee")
us_states <- replace(us_states, us_states=="VA", "Virginia")
us_states <- replace(us_states, us_states=="WV", "West Virginia")
us_states <- replace(us_states, us_states=="PA", "Pennsylvania")
us_states <- replace(us_states, us_states=="NC", "North Carolina")
us_states <- replace(us_states, us_states=="SC", "South Carolina")
us_states <- replace(us_states, us_states=="VT", "Vermont")
us_states <- replace(us_states, us_states=="GA", "Georgia")
us_states <- replace(us_states, us_states=="RI", "Rhode Island")

library(RColorBrewer)

pallette <- brewer.pal(k, "Spectral")
us_col <- sapply(unlist(income_elec_state["cluster"]), function(col) pallette[as.numeric(col)])

map('state', regions=us_states, col=us_col, fill=TRUE, bg="black")
legend("bottomright", legend=sort(unique(unlist(income_elec_state["cluster"]))), fill=pallette, cex=0.7)

income_elec_state['cluster'] <- NULL
income_elec_state['center_x'] <- NULL
income_elec_state['center_y'] <- NULL
income_elec_state['log_income'] <- NULL
income_elec_state['log_elec'] <- NULL
