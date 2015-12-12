install.packages("twitteR")
library(twitteR)


consumer_key<-"zSeAWHNpaL5G7GpHuCO4zTffT"
consumer_secret<-"dZnarPgWiQCnb1bJ0tvN3xFBmWVMRQCDDWl9UsFtkiTGpzztfG"
access_token<-"1071126529-DLvrKbaT9ju1yQsAHBWZz5h3vHGEWWyWYeTHP4Z" 
access_secret<-"h3XgPKhsKkF66ShXfbFPEnby2VUofGD6AYvu53CFvUFX7" 
requestURL <- "https://api.twitter.com/oauth/request_token"
accessURL <- "https://api.twitter.com/oauth/access_token"
authURL <- "https://api.twitter.com/oauth/authorize"

setup_twitter_oauth(consumer_key, consumer_secret, access_token,access_secret)

##Seach for random Topic
tweets = userTimeline("rundel",n = 1000)
##Search for users use 
#install.packages("tm")

#install.packages("SnowballC")
library(tm)
library(SnowballC)
library(stringr)

n.tweet = length(tweets)
tweets[1:5]
tweets.df = twListToDF(tweets)
tweets.df$text=str_replace_all(tweets.df$text,"[^[:graph:]]", " ") 
library(magrittr)
removeURL = function(x) gsub("http[[:alnum:]]*", "", x)
myStopwords = c(stopwords("english"), "isis","rt","amp","twitter", "tweets", "tweet", "retweet",
                "tweeting", "account", "via", "cc", "ht")

myCorpus = Corpus(VectorSource(tweets.df$text)) %>%
           tm_map(content_transformer(tolower)) %>%
           tm_map(content_transformer(removePunctuation)) %>%
           tm_map(content_transformer(removeNumbers)) %>% 
           tm_map(content_transformer(removeURL)) %>%
           tm_map(removeWords, myStopwords) %>% 
           tm_map(content_transformer(stemDocument))

for(i in 1:5) {
  cat(paste("[[", i, "]]", sep = ""))
  writeLines(as.character(myCorpus[[i]]))
}

#myCorpus <- tm_map(myCorpus, content_transformer(stemCompletion), dictionary = myCorpusCopy, lazy=TRUE)
tdm <- TermDocumentMatrix(myCorpus, control = list(wordLengths = c(1, Inf)))
m = as.matrix(tdm)

word.freq = sort(rowSums(m), decreasing = T)
wordcloud(words = names(word.freq),random.color = TRUE, colors=rainbow(10), freq = word.freq, min.freq = 10, random.order = F)

#idx = which(dimnames(tdm)$Terms == "family")
#inspect(tdm[idx+(0:5), 101:110])

freq.terms <- findFreqTerms(tdm, lowfreq=3)
term.freq = rowSums(as.matrix(tdm))
term.freq = subset(term.freq, term.freq >= 80)
df = data.frame(term = names(term.freq), freq = term.freq)

library(ggplot2)
ggplot(df, aes(x = term, y = freq)) + geom_bar(stat = "identity") + xlab("Terms") + ylab("Count") + coord_flip()

us=as.data.frame(findAssocs(tdm, "us", 0.2))

findAssocs(tdm, "obama", 0.25)

# http://www.bioconductor.org/packages/release/bioc/html/graph.html
#source("https://bioconductor.org/biocLite.R")
#biocLite("graph")
library(graph)

library(Rgraphviz)
plot(tdm, term = freq.terms, corThreshold = 0.12, weighting = T)

library(wordcloud)

m = as.matrix(tdm)

word.freq = sort(rowSums(m), decreasing = T)
wordcloud(words = names(word.freq),random.color = TRUE, colors=rainbow(10), freq = word.freq, min.freq = 10, random.order = F)
