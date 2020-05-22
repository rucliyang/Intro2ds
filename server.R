library(tmcn)
library(DT)
library(recharts)
library(wordcloud2)

shinyServer(function(input, output) {
	
	DataSet <- reactive({
		load("keyword.rda")
		A0 <- articles[grepl(paste0(keyword$word, collapse = "|"), articles$content),]
		W0 <- words[words$id %in% A0$id, ]
		list(A0 = A0, W0 = W0)
	}) #载入数据

	output$line1 <- renderEChart({
		
		d0 <- DataSet()$A0
		d0$date <- substr(d0$time, 1, 10)
		d0$sen <- cut(d0$polarity_stan, c(-Inf, -0.1, 0.1, Inf))
		d1 <- summarise(group_by(d0, date, sen), num = length(date))
		
		l1 <- d1[d1$sen == "(-Inf,-0.1]", c("date", "num")]
		l2 <- d1[d1$sen == "(-0.1,0.1]", c("date", "num")]
		l3 <- d1[d1$sen == "(0.1, Inf]", c("date", "num")]
		
		outdf0 <- data.frame(date = as.character(seq(from = as.Date(min(d1$date), format = "%Y-%m-%d"), to = as.Date(max(d1$date), format = "%Y-%m-%d"), by = 1)), stringsAsFactors = FALSE)
		outdf1 <- merge(outdf0, l1, all.x = TRUE)
		outdf2 <- merge(outdf0, l2, all.x = TRUE)
		outdf3 <- merge(outdf0, l3, all.x = TRUE)
		outdf1$class <- "正面"
		outdf2$class <- "中性"
		outdf3$class <- "负面"
		outdf <- rbind(outdf1, outdf2, outdf3)
		outdf$num[is.na(outdf$num)] <- 0

		eLine(outdf, xvar = ~date, yvar = ~num, series=~class, theme=2, toolbox = FALSE, legend = TRUE, legend.x = "center", legend.y = "bottom", subtitle = "舆情走势")

	}) #“情感走势”线图之“舆情走势”，并命名为line1
	
	output$line2 <- renderEChart({
		
		d0 <- DataSet()$A0
		d0$date <- substr(d0$time, 1, 10)
		d1 <- summarise(group_by(d0, date, website), score = mean(polarity_stan))
		d1 <- merge(d1, WebSites(), all.x = TRUE)
		if (length(unique(d1$name)) == 1) {
			eLine(d1, xvar = ~date, yvar = ~score, theme=1, toolbox = FALSE, legend = TRUE, legend.x = "center", legend.y = "bottom", subtitle = "不同站点情感得分")
		} else {
			eLine(d1, xvar = ~date, yvar = ~score, series=~name, theme=2, toolbox = FALSE, legend = TRUE, legend.x = "center", legend.y = "bottom", subtitle = "不同站点情感得分")
		}

	}) #“情感走势”线图之“不同站点情感得分”，并命名为line2
	
	output$line3 <- renderPlotly({
		
		d0 <- DataSet()$A0
		d0$date <- substr(d0$time, 1, 10)
		d1 <- summarise(group_by(d0, date, website), pos = sum(polarity_ave > 0), neg = sum(polarity_ave < 0), count = length(id))
		d1 <- merge(d1, WebSites(), all.x = TRUE)
		d1$pos <- round(log(d1$pos), 1)
		d1$neg <- round(log(d1$neg), 1)
		d2 <- d1[d1$date == input$slide1, ]
		
		plot_ly() %>%
				add_markers(x= d2$pos, y = d2$neg, size = d2$count*2, color = factor(d2$name), name = d2$name) %>%
				layout(xaxis = list(range = c(0, max(d1$pos)*1.1)), yaxis = list(range = c(0, max(d1$neg)*1.1)))
	}) #“情感动态”气泡图，并命名为line3
	
	output$wordcloud1 <- renderWordcloud2({
		
		d0 <- DataSet()$W0
		d0 <- d0[d0$date == input$date1, ]
		d0 <- d0[, c("word", "num")]
		d0 <- d0[nchar(d0$word) > 1, ]
		d0 <- d0[! d0$word %in% c("比赛", "虎扑"), ]
		d0 <- d0[1:min(nrow(d0), 500), ]
		d0$date <- NULL
		names(d0) <- c("word", "freq")
		
		wordcloud2(d0, backgroundColor = "transparent")

	}) #“主页”中的词云图，并命名为wordcloud1
	
	output$keyword1 = DT::renderDataTable({
		
		input$button1
		strnewword <- isolate(strstrip(input$keywordin1))
		
		if (file.exists("keyword.rda")) {
			load("keyword.rda")
		} else {
			keyword <- data.frame(word = character(), time = character(), stringsAsFactors = FALSE)
		}
			
		if (nzchar(strnewword)) {
			if (! strnewword %in% keyword$word) {
				keyword <- rbind(data.frame(word = strnewword, time = format(Sys.time(), "%Y-%m-%d %H:%M:%S"), stringsAsFactors = FALSE), keyword)
				keyword <- keyword[1:min(5, nrow(keyword)), ]
				save(keyword, file = "keyword.rda")
			}
		}		
		
		names(keyword) <- c("监控词", "添加时间")
		datatable(keyword, rownames = FALSE, options = list(pageLength = 5, dom = 'tip'), filter = "none")
	}) #“监控词设置”中的已提交监控词的表格，并命名为keyword1
	
	# output$stat1 = DT::renderDataTable({
	# 	
	# 	#tbl1 <- as.data.frame(matrix(0, 7, 5))
	# 	#tbl1[[1]] <- c("全部", "微信", "微博", "网页", "报刊", "客户端", "论坛")
	# 	#names(tbl1) <- c("数据来源", "今天", "近7天", "近30天", "全部")
	# 	
	# 	d0 <- DataSet()$A0
	# 	tmp.src <- data.frame(website = unique(d0$website), stringsAsFactors = FALSE)
	# 	tmp.src <- merge(tmp.src, WebSites(), all.x = TRUE)
	# 	tbl1 <- as.data.frame(matrix(0, nrow(tmp.src) + 1, 5))
	# 	tbl1[[1]] <- c("全部", tmp.src$name)
	# 	names(tbl1) <- c("数据来源", "今天", "近7天", "近30天", "全部")
	# 	tbl1[1, 2] <- sum(d0$day_id == format(Sys.time(), "%Y%m%d"))
	# 	tbl1[1, 3] <- sum(d0$day_id >= format(Sys.time() - 7 * 24 *3600, "%Y%m%d"))
	# 	tbl1[1, 4] <- sum(d0$day_id >= format(Sys.time() - 30 * 24 *3600, "%Y%m%d"))
	# 	tbl1[1, 5] <- nrow(d0)
	# 	for (i in 2:nrow(tbl1)) {
	# 		tbl1[i, 2] <- sum(d0$day_id == format(Sys.time(), "%Y%m%d") & d0$website == tmp.src$website[i-1])
	# 		tbl1[i, 3] <- sum(d0$day_id >= format(Sys.time() - 7 * 24 *3600, "%Y%m%d")& d0$website == tmp.src$website[i-1])
	# 		tbl1[i, 4] <- sum(d0$day_id >= format(Sys.time() - 30 * 24 *3600, "%Y%m%d")& d0$website == tmp.src$website[i-1])
	# 		tbl1[i, 5] <- sum(d0$website == tmp.src$website[i-1])
	# 	}
	# 
	# 	datatable(tbl1, rownames = FALSE, options = list(pageLength = 7, dom = ''), filter = "none", caption = "舆情统计")
	# })
	# 
	# output$stat2 = DT::renderDataTable({
	# 	
	# 	tbl2 <- DataSet()$A0
	# 	tbl2 <- tbl2[order(tbl2$polarity_stan), ][1:7, c("title", "website", "time")]
	# 	tbl2 <- merge(tbl2, WebSites(), all.x = TRUE)
	# 	tbl2 <- tbl2[, c("title", "name", "time")]
	# 	names(tbl2) <- c("舆情", "来源", "时间")
	# 	datatable(tbl2, rownames = FALSE, options = list(pageLength = 7, dom = ''), filter = "none", caption = "重要舆情")
	# })
	
	output$stat3 = DT::renderDataTable({
		
		tbl3 <- DataSet()$A0
		tbl3 <- tbl3[grepl(input$date1, tbl3$time), ]
		tbl3 <- tbl3[order(tbl3$time, decreasing = TRUE), ][1:15, c("title", "website", "time")]
		tbl3 <- merge(tbl3, WebSites(), all.x = TRUE)
		tbl3 <- tbl3[, c("title", "name", "time")]
		names(tbl3) <- c("舆情", "来源", "时间")
		tbl3[[1]] <- substr(tbl3[[1]], 1, 30)
		datatable(tbl3, rownames = FALSE, options = list(pageLength = 15, dom = ''), filter = "none", caption = "最新舆情")
	}) #“主页”中的“最新舆情”表格，并命名为stat3
	
	output$sum1 = DT::renderDataTable({
		d0 <- DataSet()$A0[, c("title", "time", "polarity_stan")]
		d0$sen <- cut(d0$polarity_stan, c(-Inf, -0.1, 0.1, Inf))
		levels(d0$sen) <- c("负面", "中性", "正面")
		d0 <- d0[order(d0$time, decreasing = TRUE), ][, c("sen", "title", "time", "polarity_stan")]

		names(d0) <- c("情感", "舆情", "时间", "权重")
		datatable(d0, rownames = FALSE, options = list(pageLength = 10, dom = 'tip'), filter = "none", caption = "")
	}) #“信息详情”表格，并命名为sum1
	
	# output$con1 <- renderEChart({
	# 
	# 	d0 <- DataSet()$A0[, c("title", "time", "polarity_stan")]
	# 	d0$sen <- cut(d0$polarity_stan, c(-Inf, -0.1, 0.1, Inf))
	# 	levels(d0$sen) <- c("负面", "中性", "正面")
	# 	
	# 	d1 <- summarise(group_by(d0, sen), num = length(sen))
	# 	ePie(d1, ~sen, ~num, toolbox = FALSE, legend = FALSE, legend.x = "center", legend.y = "bottom", subtitle = "情感分布")
	# 	
	# })
	
	# output$crawler1 <- renderEChart({
	# 
	# 	d0 <- DataSet()$A0
	# 	d1 <- summarise(group_by(d0, website), todaynum = length(website))
	# 	d1 <- merge(d1, WebSites(), all.x = TRUE)
	# 	ePie(d1, ~name, ~todaynum, toolbox = FALSE, legend = FALSE, legend.x = "center", legend.y = "bottom", subtitle = "媒体分布")
	# 	
	# })
	
	output$crawler3 = DT::renderDataTable({
		
		d1 <- summarise(group_by(articles, website), num = length(website), time = max(time))
		d2 <- summarise(group_by(articles[articles$date == as.character(Sys.Date()),], website), todaynum = length(website))
		outdf <- merge(d1, d2, all.x = TRUE)
		outdf <- merge(outdf, WebSites(), all.x = TRUE)
		outdf <- outdf[, c("name", "num", "todaynum", "time")]
		names(outdf) <- c("站点", "总文章数", "今日文章数", "最后更新")
		
		datatable(outdf, rownames = FALSE, options = list(pageLength = 10, dom = 'tip'), filter = "none")
	}) #“爬虫监控”中的文章汇总信息表，并命名为crawler3
	
	output$gauge1 <- renderEChart({
	
		d1 <- summarise(group_by(articles, website), time = max(time))
		v1 <- as.numeric(difftime(Sys.time(), strptime(min(d1$time), format = "%Y-%m-%d %H:%M:%S"), units = "days"))
		v1 <- min(v1, 7) / 7
		v1 <- round(v1 * 100, 2)
		eGauge(v1, "比例", "更新时间", toolbox = FALSE)
	}) #“爬虫监控”中的“更新时间”表盘，并命名为gauge1
	
	output$gauge12 <- renderEChart({
		d1 <- summarise(group_by(articles, website), todaynum = length(website))
		d1 <- merge(d1, WebSites(), all.x = TRUE)
		ePie(d1, ~name, ~todaynum, toolbox = FALSE, legend = FALSE, legend.x = "center", legend.y = "bottom", subtitle = "媒体分布")
	}) #“爬虫监控”中的“媒体分布”饼图，并命名为gauge2
	
})
