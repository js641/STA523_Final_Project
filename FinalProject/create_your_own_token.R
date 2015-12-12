#####################################
### CREATING YOUR OWN OAUTH TOKEN ###
#####################################

## I will not discuss this in the lab session, but I add it here in case you
## want to create your own token in the future

## Step 1: go to apps.twitter.com and sign in
## Step 2: click on "Create New App"
## Step 3: fill name, description, and website (it can be anything, even google.com)
##    	(make sure you leave 'Callback URL' empty)
## Step 4: Agree to user conditions
## Step 5: copy consumer key and consumer secret and paste below

library(ROAuth)
requestURL <- "https://api.twitter.com/oauth/request_token"
accessURL <- "https://api.twitter.com/oauth/access_token"
authURL <- "https://api.twitter.com/oauth/authorize"
consumerKey <- "zSeAWHNpaL5G7GpHuCO4zTffT"
consumerSecret <- "dZnarPgWiQCnb1bJ0tvN3xFBmWVMRQCDDWl9UsFtkiTGpzztfG"
my_oauth <- OAuthFactory$new(consumerKey=consumerKey,
                             consumerSecret=consumerSecret, requestURL=requestURL,
                             accessURL=accessURL, authURL=authURL)

## run this line and go to the URL that appears on screen
my_oauth$handshake(cainfo = system.file("CurlSSL", "cacert.pem", package = "RCurl"))


## now you can save oauth token for use in future sessions with twitteR or streamR
save(my_oauth, file="oauth_token_JieSun.Rdata")
load("~/oauth_token_JieSun.Rdata")
