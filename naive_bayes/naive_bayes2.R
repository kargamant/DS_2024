cl <- naiveBayes(sex ~ age + educ + income, data=train)
cl
prediction <- predict(cl, test, type='class')
confusionMatrix(as.factor(prediction), as.factor(unlist(test["sex"])))

train <- as.data.frame(train)
test <- as.data.frame(test)
males <- train[unlist(train["sex"]) == "M",]
females <- train[unlist(train["sex"]) == "F",]

train_males <- males[sample(nrow(males),3500),]
train_females <- females[sample(nrow(females),3500),]
new_train <- rbind(train_males, train_females)
new_cl <- naiveBayes(sex ~ age + educ + income, data=new_train)
new_cl
new_prediction <- predict(new_cl, test, type='class')
confusionMatrix(as.factor(new_prediction), as.factor(unlist(test["sex"])))
