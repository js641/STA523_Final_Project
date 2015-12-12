requestURL <- "https://api.twitter.com/oauth/request_token"
accessURL <- "http://api.twitter.com/oauth/access_token"
authURL <- "http://api.twitter.com/oauth/authorize"
consumerKey <- "zSeAWHNpaL5G7GpHuCO4zTffT"
consumerSecret <- "dZnarPgWiQCnb1bJ0tvN3xFBmWVMRQCDDWl9UsFtkiTGpzztfG"
my_oauth <- OAuthFactory$new(consumerKey=consumerKey,
                             consumerSecret=consumerSecret, requestURL=requestURL,
                             accessURL=accessURL, authURL=authURL)