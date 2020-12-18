library('se.alipsa:xmlr')

html.table <- function(df, htmlattr=NA) {
  table <- createTag("table", htmlattr)

  thead <- Element$new("thead")
  table$addContent(thead)

  headTr <- Element$new("tr")
  thead$addContent(headTr)

  for (name in names(df)) {
    headTr$addContent(Element$new("th")$setText(name))
  }

  tbody <- Element$new("tbody")
  table$addContent(tbody)

  for(row in 1:nrow(df)) {
    tr <- Element$new("tr")
    tbody$addContent(tr)
    for (col in 1:ncol(df)) {
      td <- Element$new("td")
      tr$addContent(td)
      td$setText(as.character(df[row,col]))
    }
  }

  return(table$toString())
}