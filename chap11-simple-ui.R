shinyUI(bootstrapPage(
  #选择型输入（即一个待选列表，供选择输入参数的实际值）
  selectInput(inputId = "nbreaks", #输入参数在server端的对象名
              label = "Number of bins:", #输入参数在ui端的文字提示
              choices = c(10, 20, 35, 50), #输入参数的可选范围
              selected = 20), #输入参数的默认值
  #图片输出
  plotOutput(outputId = "plot1") #输出server中端名为plot1的图片对象
))

