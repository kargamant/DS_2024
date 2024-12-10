df <- read.csv("survey.csv", sep=",")
train <- df[1:600,]
test <- df[601:nrow(df),]
library(rpart)
tree <- rpart(MYDEPV ~ Price + Income + Age, data=train, method="class", parms=list(split="information"), minsplit=3)
printcp(tree)
library(rattle)
library(rpart.plot)
library(RColorBrewer)
fancyRpartPlot(tree)

pr <- predict(tree, train, type="class")
library('caret')
library('caTools')
confusionMatrix(as.factor(unlist(pr)), as.factor(unlist(train["MYDEPV"])))

install.packages("ROCR")
library("ROCR")
pr <- predict(tree, train, type="vector")
#pr <- sapply(1:nrow(train), function(x) names(which.max(pr[x,])))
#confusionMatrix(as.factor(pr), as.factor(unlist(train["MYDEPV"])))

labels <- unlist(train["MYDEPV"])
labels <- replace(labels, labels==1, 2)
labels <- replace(labels, labels==0, 1)

probj <- prediction(pr, as.factor(labels))
perf <- performance(probj, "tpr", "fpr")
plot(perf)

auc_curve <- performance(probj, measure="auc")
auc <- auc_curve@y.values[[1]]
auc

pr <- predict(tree, test, type="class")
confusionMatrix(as.factor(unlist(pr)), as.factor(unlist(test["MYDEPV"])))

tree_gini <- rpart(MYDEPV ~ Price + Income + Age, data=train, method="class", parms=list(split="gini"), minsplit=3)
fancyRpartPlot(tree_gini)
pr <- predict(tree_gini, train, type="class")
confusionMatrix(as.factor(unlist(pr)), as.factor(unlist(train["MYDEPV"])))

pr <- predict(tree_gini, train, type="vector")

labels <- unlist(train["MYDEPV"])
labels <- replace(labels, labels==1, 2)
labels <- replace(labels, labels==0, 1)

probj <- prediction(pr, as.factor(labels))
perf <- performance(probj, "tpr", "fpr")
plot(perf)
auc <- auc_curve@y.values[[1]]
auc

pr <- predict(tree_gini, test, type="class")
confusionMatrix(as.factor(unlist(pr)), as.factor(unlist(test["MYDEPV"])))
printcp(tree_gini)
pruned_tree_gini <- prune(tree_gini, cp=0.03)
pruned_tree_gini

pr <- predict(pruned_tree_gini, train, type="class")
confusionMatrix(as.factor(unlist(pr)), as.factor(unlist(train["MYDEPV"])))
