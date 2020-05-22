
# setwd("D:\\Storage\\Nutstore\\Book\\rucds\\work\\shiny\\sentiment")

library(shinydashboard)
library(shiny)
library(recharts)
library(plotly)
library(wordcloud2)
library(dplyr)
library(DT)

load("WebDataLite.rda")
load("WebWords.rda")

#articles <- WebDataLite[WebDataLite$day_id >= format(Sys.time() - 31 * 24 *3600, "%Y%m%d"), ]
articles <- WebDataLite
articles <- articles[articles$polarity_stan != 0, ]
articles$day_old <- NULL
words <- WebWords[WebWords$id %in% WebDataLite$id, ]

names(articles) <- c("id", "day_id", "website", "title", "content", "time", "polarity_ave", "polarity_sd", "polarity_stan")
articles <- articles[!is.na(articles$website), ]

WebSites <- function() {
	OUT <- data.frame(website = c("36kr", "aiwan", "autohome", "hupu", "huxiu", "sinaent", "guancha", "weiyulu"),
			name = c("36\u6C2A", "\u7231\u73A9\u7F51", "\u6C7D\u8F66\u4E4B\u5BB6", "\u864E\u6251\u4F53\u80B2", "\u864E\u55C5\u7F51", "\u65B0\u6D6A\u5A31\u4E50", "\u89C2\u5BDF\u8005\u7F51", "\u5FAE\u8BED\u5F55"),
			url = c("", "", "", "", "", "", "", ""), 
			stringsAsFactors = FALSE)
	return(OUT)
}

