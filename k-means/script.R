library(ggplot2)


# clustering
clusterisation <- kmeans(income_elec_state, 10, nstart=50)

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
ggsave("plt_k_10.png")

# finding optimal k
k_vals <- c(1:30)

# WSS
wss <- sapply(k_vals, function(val) sum(unlist(kmeans(income_elec_state, val, nstart=50)["withinss"])))

df <- data.frame(k=k_vals, wss=wss)
elbow_plt <- ggplot(df, aes(k_vals, wss))
elbow_plt + geom_point() + labs(x="k") + scale_x_continuous(breaks=c(1:30))
ggsave("elbow_plt.png")

# the optimal k is 8


# trying on log scale
income_elec_state["log_income"] <- lapply(income_elec_state["income"], log10)
income_elec_state["log_elec"] <- lapply(income_elec_state["elec"], log10)

df <- data.frame(log_income=income_elec_state["log_income"], log_elec=income_elec_state["log_elec"])

clusterisation <- kmeans(df, 10, nstart=50)

centers_income <- as.data.frame(clusterisation["centers"])["centers.log_income"]
centers_elec <- as.data.frame(clusterisation["centers"])["centers.log_elec"]

centers_income <- lapply(clusterisation["cluster"], function(cluster) centers_income[cluster,])
centers_elec <- lapply(clusterisation["cluster"], function(cluster) centers_elec[cluster,])

df["center_x"] <- centers_income
df["center_y"] <- centers_elec

plt <- ggplot(df, aes(unlist(df["log_income"]), unlist(df["log_elec"]), colour = unlist(df["cluster"])))
plt + geom_point() + geom_point(aes(unlist(df["center_x"]), unlist(df["center_y"])), colour="black") + labs(title="clusters", x="log_income", y="log_elec", colour="cluster")
ggsave("plt_k_10_log.png")

