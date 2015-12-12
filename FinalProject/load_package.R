######################################################################
############### Stage 0: Load the Necessary Package ##################
######################################################################

## Now we load the packages
EnsurePackage<-function(x)
{x <- as.character(x)
  if (!require(x,character.only=TRUE))
  {
    install.packages(pkgs=x,repos="http://cran.r-project.org")
    require(x,character.only=TRUE)
  }
}

#Identifying packages required 
PrepareTwitter<-function()
{
  EnsurePackage("httr")
  EnsurePackage("devtools")
  EnsurePackage("twitteR")
  EnsurePackage("base64enc")
  EnsurePackage("stringr")
  EnsurePackage("ROAuth")
  EnsurePackage("RCurl")
  EnsurePackage("ggplot2")
  EnsurePackage("tm")
  EnsurePackage("RJSONIO")
  EnsurePackage("wordcloud")
  EnsurePackage("ggplot2") 
  EnsurePackage("streamR")
  EnsurePackage("NYU160J")
  EnsurePackage("grid")
}

PrepareTwitter()

