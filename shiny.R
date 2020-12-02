library(shiny)
library(ggplot2)

# ui=fluidPage("text") # div标签中, 有"text"
server=function(input,output){ # 奇怪的语法部分原因就是因为server是一个函数, 函数就不需要有逗号了
  # output$hist=hist(rnorm(input$num)) # # 有bug, 不能直接使用, 一定需要放在一个reactive function中 需要套在render中才可以正常运行
  # nv=reactive() # 这不行, 因为server中的每一行都必须在reactive函数中, reactive可以存很多 
  # 可以把nv当做函数来记忆, 因此后面都是nv(), 但实际上可以是对象, 可以是R的任何对象, 比如list, 甚至是函数
  # 而且在ui中也得改
  output$hist=renderPlot(hist(rnorm(input$num),main=isolate(input$title)))
  # 但是括起来renderPlot是没用的, 相当于整个外面做了隔离, 但有什么影响呢, 它已经变了, 重新运行了
  # output$summary=renderPrint(summary(nv()))
}


# main用isolate(input$title), 那么就不会及时通知, 它监听了2个. 因此会重新执行, 数据会变

# 分为两部分, ui, 控件, ui相当于一个网页

# slider 数目, 做一个直方图
ui=fluidPage(
  sliderInput(inputId = "num", label = "Numeber of observations", min=10, max=500, value=100), # 然后是slider特有的变量, min是下限, max是上限, value是初始值 
  # 给它的值的变量名, 就可以引用. server怎么找, 就
  # 是input$num(那个server函数上), label是给用户看的
  # 图是输出类, 都叫*output
  # plotOutput和imageOutput, 前者是画出来的图, 后者是载入的图像文件, 不是R化的
  textInput("title", "Title", "Histogram"),
  plotOutput("hist") # 需要在server中存进
  
  # verbatimTextOutput("summary")
) # 其实得到的就是html的代码
# 每一个控件是直接换行还是加, 是用,
# 因为每一个元素都可以看做一个变量


shinyApp(ui=ui,server=server)
# 如果希望不是运行在本机上, shiny有免费的服务器托管, 会控制流量, 就会要求app.R, 只能叫这个名字
# 所有的文件全在同一个文件夹下(平的结构), ui.R, server.R
# 如果是自己的服务器, 那么也是无所谓的

# 以一种通知的过程, 啥意思, 它会通知reactive function, 因为reactive function是能监听的, 它就会在运行
# 因此input$num并不是简单的数字, 它也是个通知器


