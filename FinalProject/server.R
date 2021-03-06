## Now we load the packages
## Load all the packages in load_package.R before Run App 
library(tm)
library(SnowballC)
library(stringr)
#install.packages("fpc")
library(fpc)
#install.packages("topicmodels")
library(topicmodels)
library(mime)


# http://www.bioconductor.org/packages/release/bioc/html/graph.html
#source("https://bioconductor.org/biocLite.R")
#biocLite("Rgraphviz")
library(graph)
library(Rgraphviz)

shinyServer(
  function(input, output, session) 
  {
    #twitter user authentication
    consumer_key="zSeAWHNpaL5G7GpHuCO4zTffT"
    consumer_secret="dZnarPgWiQCnb1bJ0tvN3xFBmWVMRQCDDWl9UsFtkiTGpzztfG"
    access_token="1071126529-DLvrKbaT9ju1yQsAHBWZz5h3vHGEWWyWYeTHP4Z" 
    access_secret="h3XgPKhsKkF66ShXfbFPEnby2VUofGD6AYvu53CFvUFX7" 
    requestURL = "https://api.twitter.com/oauth/request_token"
    accessURL = "https://api.twitter.com/oauth/access_token"
    authURL = "https://api.twitter.com/oauth/authorize"
    #direct web setup
    setup_twitter_oauth(consumer_key, consumer_secret, access_token,access_secret)
    #Parse twitts with functions from "twitteR" package.
    tweets = reactive({
      if (input$content == "topic") {
        searchTwitter(input$Topic, n = input$n_tweets, lang = "en")
      } else {
        userTimeline(input$tHandle, n = input$n_tweets)
      } 
    })
######################################################################################
######             WORD CLOUD CODE STARTS FROM HERE        ###########################
######################################################################################
    #turn the parsed tweets into dataframe and clean up some irregular text.
    tweets.df = reactive ({
      tmp = twListToDF(tweets())
      if (input$content == "topic") {
        tmp[,1] = str_replace_all(tmp[,1],"[^[:graph:]]", " ") 
        tmp
      } else { tmp }
    })
    #a function to remove URL
    removeURL = function(x) gsub("http[[:alnum:]]*", "", x)
    #Use text mining package "tm" to remove punctuations, numbers and irregular expressions used in tweets.
    myCorpus1 = reactive({
      Corpus(VectorSource(tweets.df()[,1])) %>%
      tm_map(content_transformer(tolower)) %>%      
      tm_map(content_transformer(removePunctuation)) %>%
      tm_map(content_transformer(removeNumbers)) %>% 
      tm_map(content_transformer(removeURL))
    })
    #initiates stopwwords, especially garbage words in tweets.
      myStopwords = reactive({
        c(stopwords("english"), tolower(input$Topic), "just","rt","amp","twitter", "tweets", "tweet", "retweet",
          "tweeting", "account", "via", "cc", "ht")
      })
    #clean the text using the stopwords.
      myCorpus = reactive ({
      myCorpus1()%>% 
      tm_map(removeWords, myStopwords()) %>% 
      tm_map(content_transformer(stemDocument))
    })
    
    tdm = reactive ({
      TermDocumentMatrix(myCorpus(), control = list(wordLengths = c(1, Inf))) 
    })
    
    m = reactive ({
      as.matrix(tdm())
      })
    
    word.freq = reactive ({
      sort(rowSums(m()), decreasing = T)
    }) 
    #minumum freqency of the words in tweets.
    min_word_freq= reactive({
      input$freq
    })
    #maximum number of words chosen by the user.
    max_word_num = reactive ({
      input$max
    })
######################################################################################
######             WORD CLOUD CODE ENDS                    ###########################
######################################################################################

######################################################################################
######             WORD Freq CODE STARTS                   ###########################
######################################################################################
    #define the frequency terms
    freq.terms = reactive ({
      if (input$content=="topic") {
        findFreqTerms(tdm(), lowfreq = input$n_tweets/25)
      } else {
        findFreqTerms(tdm(), lowfreq = 2)
      }
    })
    
######################################################################################
######             Text Clustering CODE STARTS                   ###########################
######################################################################################
    
    # cluster analysis
    
    
    #remove spare terms
    m2 =reactive({
      removeSparseTerms(tdm(), sparse = 0.95)%>%as.matrix()
      })
    # cluster terms
    
    distMatrix = reactive({
      dist(scale(m2()))
      })
    
    fit = reactive({
      hclust(distMatrix(), method="ward.D2")
      })
    
    
############################################################################
##Output Plot 
###########################################################################
    output$wordcloud_plot = renderPlot({
      wordcloud(words = names(word.freq()),random.color = TRUE, colors=rainbow(10), 
                freq = word.freq(), min.freq = min_word_freq(),max.words = max_word_num(),
                random.order = F)
    })
    
    output$word_association= renderPlot({
      plot(tdm(), term = freq.terms(), corThreshold = 0.12, weighting = T)
    })
    
    output$word_assc_table = renderTable({
      as.data.frame(findAssocs(tdm(), tolower(input$freq_word), input$coorelation))
    })
    
    output$text_clustering = renderPlot({
      plot(fit(),xlab="",ylab="frequency")
      rect.hclust(fit(),input$cluster)
      })
    
}
)






