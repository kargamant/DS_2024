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
