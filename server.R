shinyServer(function(input, output) {
	#创建renderPlot对象并命名为plot1，准备在ui端输出
	output$plot1 <- renderPlot({
		hist(faithful$eruptions, #对R自带的faithful数据中的eruptions变量画直方图
			probability = TRUE, 
			breaks = as.numeric(input$nbreaks), #以ui端输入的nbreaks作为breaks参数的实际值
			xlab = "Duration (minutes)", #x轴标题
			main = "Geyser eruption duration") #图片标题
  })
})

