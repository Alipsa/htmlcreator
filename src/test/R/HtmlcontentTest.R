library('hamcrest')
library('se.alipsa.renjin:htmlcontent')

test.htmlText <- function() {
  
  html.clear()
  html.add("<html><body>")
  html.add("<div>Hello</div")
  html.add("</html></body>")

  expected <- "<html><body><div>Hello</div</html></body>"
  assertThat(html$getContent(), equalTo(expected))

  html.clear()
  html.add("<html><body>")$add("<div>Hello</div")$add("</html></body>")
  assertThat(html$getContent(), equalTo(expected))
}


test.dataFrameToTable <- function() {

  employee <- c('John Doe','Peter Smith','Jane Doe')
  salary <- c(21000, 23400, 26800)
  startdate <- as.Date(c('2013-11-1','2018-3-25','2017-3-14'))
  endDate <- as.POSIXct(c('2020-01-10 00:00:00', '2020-04-12 12:10:13', '2020-10-06 10:00:05'), tz='UTC' )
  df <- data.frame(employee, salary, startdate, endDate)
  content <- html.table(df, "myTable")
  assertThat(content, equalTo("<table id='myTable'><thead><tr><th>employee</th><th>salary</th><th>startdate</th><th>endDate</th></tr></thead><tbody><tr><td>John Doe</td><td>21000</td><td>2013-11-01</td><td>2020-01-10</td></tr><tr><td>Peter Smith</td><td>23400</td><td>2018-03-25</td><td>2020-04-12 12:10:13</td></tr><tr><td>Jane Doe</td><td>26800</td><td>2017-03-14</td><td>2020-10-06 10:00:05</td></tr></tbody></table>"))

  htm <- Html$new()
  htm$add("<html><body>")
  htm$add(html.table(df))
  htm$add("</html></body>")

  html.clear()
  html.add("<html><body>")
  html.add(df)
  html.add("</html></body>")

  assertThat(html$getContent(), equalTo("<html><body><table><thead><tr><th>employee</th><th>salary</th><th>startdate</th><th>endDate</th></tr></thead><tbody><tr><td>John Doe</td><td>21000</td><td>2013-11-01</td><td>2020-01-10</td></tr><tr><td>Peter Smith</td><td>23400</td><td>2018-03-25</td><td>2020-04-12 12:10:13</td></tr><tr><td>Jane Doe</td><td>26800</td><td>2017-03-14</td><td>2020-10-06 10:00:05</td></tr></tbody></table></html></body>"))
  assertThat(html$getContent(), equalTo(htm$getContent()))
}

test.plotToImage <- function() {
  html.clear()
  html.add("<html><body>")
  html.add(
    barplot,
    table(mtcars$vs, mtcars$gear),
    main="Car Distribution by Gears and VS",
    col=c("darkblue","red")
  )
  html.add("</html></body>")
  #outFile <- tempfile("plot", fileext = ".html")
  #write(html$getContent(), outFile)
  #print(paste("Wrote", outFile))
  assertThat(nchar(html$getContent()), equalTo(5762))

}