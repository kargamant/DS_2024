library("tm")
library("wordcloud")
data("crude")

# top10 words(from python)
# [('oil', 12), 
# ('said', 11), 
# ('opec', 10), 
# ('production', 5), 
# ('prices', 5), 
# ('analysts', 4), 
# ('problem', 4), 
# ('mln', 4), 
# ('demand', 4), 
# ('may', 3)]
article <- crude[['144']]
wordcloud(article, scale=c(3,.2), max.words=20)

article <- removePunctuation(crude[['144']])
article <- removeWords(crude[['144']], stopwords())
wordcloud(article, scale=c(3,.2), max.words=20)

article <- crude[['144']]
dtm <- DocumentTermMatrix(crude)
weights <- weightTfIdf(dtm)
ar_w <- as.matrix(weights)["144",]
top_20_tf_idf <- tail(sort(ar_w), 20)

wordcloud(names(top_20_tf_idf), scale=c(1,.2), max.words=20)


# transformation of words
crude <- tm_map(crude, content_transformer(tolower))
crude <- tm_map(crude, removePunctuation)
crude <- tm_map(crude, removeNumbers)
crude <- tm_map(crude, function(cr) removeWords(cr, stopwords("en")))

dtm <- DocumentTermMatrix(crude)

weights <- weightTfIdf(dtm)
ar_w <- as.matrix(weights)["144",]
top_20_tf_idf <- tail(sort(ar_w), 20)


wordcloud(names(top_20_tf_idf), scale=c(1,.2), max.words=20)

# the word oil is perfect example of low tf_idf, but high tf

as.matrix(weights)[,"oil"]
weights <- weightTf(dtm)
matr_tf <- as.matrix(weights)
top_20_tf <- sapply(rownames(matr_tf), function(doc) tail(sort(matr_tf[doc,]), 20))
top_20_tf
