matr <- dist(income_elec_state)

matr
h_clust <- hclust(matr, method="centroid")
plot(h_clust)
clusters <- 7
cut <- cutree(h_clust, k=clusters)
income_elec_state["cluster"] <- cut

palette <- brewer.pal(10, 'Spectral')
us_cols <- sapply(unlist(income_elec_state['cluster']), function(cluster) palette[cluster])

map('state', col=us_cols, regions=us_states, fill=TRUE, bg='black')

legend("bottomright", legend=sort(unique(unlist(income_elec_state["cluster"]))), fill=pallette, cex=0.7)
