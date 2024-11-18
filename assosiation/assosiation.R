
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

plt <- ggplot(inspection, aes(unlist(inspection["support"]), unlist(inspection["confidence"]), colour = unlist(inspection["lift"])))
plt + geom_point() + labs(x="support", y="confidence")


