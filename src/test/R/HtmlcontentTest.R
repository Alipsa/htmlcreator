library('hamcrest')
library('se.alipsa:htmlcreator')


str.beginsWith <- function(expected) {
  if(is.na(expected)) {
    stop("expected is NA, str.beginsWith NA makes no sense")
  }
  function(actual) {
    startsWith(as.character(actual), as.character(expected))
  }
}

str.endsWith <- function(expected) {
  if(is.na(expected)) {
    stop("expected is NA, str.endsWith NA makes no sense")
  }
  function(actual) {
    endsWith(as.character(actual), as.character(expected))
  }
}

test.htmlText <- function() {

  html.clear()
  html.add("<html><body>")
  html.add("<div>Hello</div>")
  html.add("</body></html>")

  expected <- "<html><body><div>Hello</div></body></html>"
  assertThat(html.content(), equalTo(expected))

  html.clear()
  html.add("<html><body>")$add("<div>Hello</div>")$add("</body></html>")
  assertThat(html.content(), equalTo(expected))
}


test.dataFrameToTable <- function() {

  employee <- c('John Doe','Peter Smith','Jane Doe')
  salary <- c(21000, 23400, 26800)
  startdate <- as.Date(c('2013-11-1','2018-3-25','2017-3-14'))
  endDate <- as.POSIXct(c('2020-01-10 00:00:00', '2020-04-12 12:10:13', '2020-10-06 10:00:05'), tz='UTC' )
  df <- data.frame(employee, salary, startdate, endDate)
  ## hidden will not be added as an attribute since it is not named
  content <- html.table(df, list(id="myTable", "hidden"))
  assertThat(content, equalTo("<table id='myTable'><thead><tr><th>employee</th><th>salary</th><th>startdate</th><th>endDate</th></tr></thead><tbody><tr><td>John Doe</td><td>21000</td><td>2013-11-01</td><td>2020-01-10</td></tr><tr><td>Peter Smith</td><td>23400</td><td>2018-03-25</td><td>2020-04-12 12:10:13</td></tr><tr><td>Jane Doe</td><td>26800</td><td>2017-03-14</td><td>2020-10-06 10:00:05</td></tr></tbody></table>"))

  htm <- Html$new()
  htm$add("<html><body>")
  htm$add(42)
  htm$add(html.table(df))
  htm$add("</body></html>")
  assertThat(htm$getContent(), equalTo("<html><body>42<table><thead><tr><th>employee</th><th>salary</th><th>startdate</th><th>endDate</th></tr></thead><tbody><tr><td>John Doe</td><td>21000</td><td>2013-11-01</td><td>2020-01-10</td></tr><tr><td>Peter Smith</td><td>23400</td><td>2018-03-25</td><td>2020-04-12 12:10:13</td></tr><tr><td>Jane Doe</td><td>26800</td><td>2017-03-14</td><td>2020-10-06 10:00:05</td></tr></tbody></table></body></html>"))

  html.clear()
  html.add("<html><body>")
  html.add(df)
  html.add("</body></html>")

  assertThat(html.content(), equalTo("<html><body><table><thead><tr><th>employee</th><th>salary</th><th>startdate</th><th>endDate</th></tr></thead><tbody><tr><td>John Doe</td><td>21000</td><td>2013-11-01</td><td>2020-01-10</td></tr><tr><td>Peter Smith</td><td>23400</td><td>2018-03-25</td><td>2020-04-12 12:10:13</td></tr><tr><td>Jane Doe</td><td>26800</td><td>2017-03-14</td><td>2020-10-06 10:00:05</td></tr></tbody></table></body></html>"))
}

test.plotToImage <- function() {
  html.new(
    barplot,
    table(mtcars$vs, mtcars$gear),
    main="Car Distribution by Gears and VS",
    col=c("darkblue","red")
  )
  outFile <- paste0(getwd(), "/test.plotToImage.html")
  write(html.content(), outFile)
  print(paste("Wrote", outFile))
  assertThat(html.content(), str.beginsWith("<html><img src='data:image/png;base64,"))
  assertThat(html.content(), str.endsWith("</img></html>"))

}

test.imgUrl <- function() {
  html.clear()
  html.add(html.imgUrl("/common/style.css", list("id" = "mystyle", "class" = "image")))
  assertThat(html.content(), equalTo("<html><img id='mystyle' class='image' src='/common/style.css'></img></html>"))
}

test.matrix <- function() {
  html.clear()
  html.add("<h2>PlantGrowth weight</h2>")
  html.add(
    hist,
    PlantGrowth$weight
  )
  html.add(format(summary(PlantGrowth)))
  outFile <- paste0(getwd(), "/test.matrix.html")
  print(paste("Writing to", outFile))
  write(html.content(), outFile)
  assertThat(html.content(), str.beginsWith("<html><h2>PlantGrowth weight</h2><img src='data:image/png;base64,"))
  assertThat(html.content(), str.endsWith("</td></tr></tbody></table></html>"))

}
