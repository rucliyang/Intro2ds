dashboardPage(
	dashboardHeader(title = "舆情系统示例"), #设置总标题
	#设置菜单中各个模块的布局（从上到下）
	dashboardSidebar(
		sidebarMenu(
			menuItem("主页", #模块名称 
			         tabName = "homepage", #模块在代码中的对象名 
			         icon = icon("file") #图标
			         ),
			menuItem("舆情监测", #模块名称
			         icon = icon("line-chart"), #图标
               menuSubItem("情感动态", #子模块名称
                           tabName = "yuqing-mot" #子模块对象名
                           ),
               menuSubItem("情感走势", 
                           tabName = "yuqing-con"),
			         menuSubItem("信息详情", 
			                     tabName = "yuqing-sum")
			),
			menuItem("设置", 
			         icon = icon("line-chart"),
			   menuSubItem("监控词设置", 
			               tabName = "setting-keyword"),
			   menuSubItem("爬虫监控", 
			               tabName = "setting-source")
			)
		)
	),
	#每一个模块的具体内容
	dashboardBody(
	  #每一个tabItem代指一个模块，由上面定义的对象名唯一确定
		tabItems(
			tabItem(tabName = "homepage", #对应“主页”
			  #fluidRow将页面分成了不同的行
				fluidRow(
					br(),
					#fluidRow内部可以用column来分列
					column(offset = 1, width = 10, 
					       #输入日期
					       dateInput("date1", "日期:", 
					                 value  = "2017-06-01", 
					                 min = "2017-01-01", 
					                 max  = "2017-12-31", 
					                 format = "yyyy-mm-dd"))
				),
				fluidRow(
					br(),
					column(offset = 1, width = 5, 
					       #输出server端的表格stat3
					       DT::dataTableOutput('stat3')),
					column(br(),br(), width = 5, 
					       #输出server端的词云图wordcloud1
					       wordcloud2::wordcloud2Output('wordcloud1', width = "100%", height = "600px"))
				)
			),
			tabItem(tabName = "yuqing-sum", #对应“信息详情”
				fluidRow(
					br(),
					column(offset = 1, width = 8, 
					       DT::dataTableOutput('sum1'))
				)
			),
			tabItem(tabName = "yuqing-con", #对应“情感走势”
				fluidRow(
					br(),
					column(offset = 1, width = 8, 
					       #输出server端所绘的线图line1
					       recharts::eChartOutput('line1'))
				),
				fluidRow(
					br(),
					column(offset = 1, width = 8, 
					       #输出server端所绘的线图line2
					       recharts::eChartOutput('line2'))
				)
			),
			tabItem(tabName = "yuqing-mot", #对应“情感动态”
				fluidRow(
					br(),br(),
					column(offset = 1, width = 8, 
					       #输出server端所绘的气泡图line3
					       plotly::plotlyOutput('line3'))
				),
				fluidRow(
					br(),
					column(offset = 1, width = 8, 
					       #创建滑动型输入，输入所绘气泡图对应的时间点
					       sliderInput("slide1", "", 
					                   min = as.Date("2017-01-05"), 
					                   max = as.Date("2017-06-27"), 
					                   value = as.Date("2017-01-05"), 
					                   width = 1000))
				)
			),
			tabItem(tabName = "setting-keyword", #对应“监控词设置”
				fluidRow(
					br(),
					column(offset = 1, width = 3, 
					       #创建文本型输入，用于添加监控词
					       textInput("keywordin1", "添加监控词:", "")),
					column(br(), width = 1, 
					       #创建“提交”按钮
					       actionButton("button1", "提交"))
				),			
				fluidRow(
					br(),
					column(offset = 1, width = 9, 
					       #输入server端的表格keyword1，显示已提交的监控词
					       DT::dataTableOutput('keyword1'))
				)
			),
			tabItem(tabName = "setting-source", #对应“爬虫监控”
				fluidRow(
					br(),
					column(offset = 1, width = 4, 
					       #输出server端的更新时间图
					       recharts::eChartOutput('gauge1')),
					column(width = 4, 
					       #输出server端的媒体分布图
					       recharts::eChartOutput('gauge12'))
				),				
				fluidRow(
					br(),
					column(offset = 1, width = 9, 
					       #输出server端的表格crawler3
					       DT::dataTableOutput('crawler3'))
				)
			)
		)
	)
)

