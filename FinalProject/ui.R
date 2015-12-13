library(shiny)

content_select=c("Topic of Interest"= "topic", "User of Interest"="usertag")
country_list = c("USA", "Canada", "France", "Japan","South Africa")

shinyUI(
  fluidPage(
    titlePanel(
      "Twitter Mysteries"
    ),
    icon("twitter", class ="twitter fa-5x"),
    icon("question", class ="question fa-5x"),
  sidebarLayout (
    sidebarPanel(
      selectInput("content", h4("Select for WordCloud Content"), content_select),
      conditionalPanel(
        condition = "input.content == 'topic'",
        textInput("Topic", h4("Enter Topic of Interest:"),value = "statistics")
      ),
      h4(),
      sliderInput("n_tweets", "Number of Tweets to be collected:", min=100, max=1000, value=100, step=100),
      h4(),
      conditionalPanel(
        condition="input.content == 'usertag'",
        textInput("tHandle", h4("Enter Twitter Handle: #"), value = "rundel")
      ),
      
      checkboxInput(inputId = "word_freq_assc",
                    label = strong("Choose word for frequency association"),
                    value = FALSE),
      h4(),
      conditionalPanel(
        condition = "input.word_freq_assc == true",
        textInput("freq_word",label = "Word to be associated:"),
        sliderInput("coorelation",label = "Correlation",min = 0,max = 1, value = 0.2)
      ),
      
      h4(),
      
      sliderInput("freq",
                  "Minimum Frequency in WordCloud:",
                  min = 1,  max = 50, value = 2),
      sliderInput("max",
                  "Maximum Number of Words in WordCloud:",
                  min = 1,  max = 300,  value = 100),
      sliderInput("cluster",
                  "Maximum Number of Clusters:",
                  min = 1,  max = 10,  value = 2)
      
    ),
    mainPanel(
      tabsetPanel(type = "tabs", 
                  tabPanel("WordCloud", plotOutput("wordcloud_plot")),
                  tabPanel("Words Frequency Association",
                             plotOutput("word_association"),
                             h4(),
                             tableOutput("word_assc_table")
                           ), 
                  tabPanel("Text Clustering", 
                           plotOutput("text_clustering"),
                           h4(),
                           plotOutput("pam_plot"))
    )
    )
  )
  )
)



