df <- read.csv("nbtrain.csv", sep=",")

install.packages("e1071")
install.packages("caret")
install.packages("caTools")
library('e1071')
library('caret')
library('caTools')
train <- df[1:9010, ]
test <- df[9011:nrow(df),]
cl <- naiveBayes(income ~ age + sex + educ, data=train)
cl
prediction <- predict(cl, test, type='class')
prediction


#labels <- sapply(1:nrow(test), function(x) names(which.max(prediction[x,])))

confusionMatrix(as.factor(labels), as.factor(unlist(test["income"])))
#summary(as.factor(unlist(df[9011:10000,]["income"])))
