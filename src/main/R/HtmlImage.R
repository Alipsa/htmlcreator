library('se.alipsa:xmlr')


createImgTag <- function(imgContent, htmlattr=NA) {
  img <- createTag("img", htmlattr)
  img$setAttribute("src", imgContent)
  return(img)
}

html.imgPlot <- function(plotFunction, ..., htmlattr=NA) {
  outFile <- tempfile("plot", fileext = ".png")
  png(outFile)
  # alt
  # height: exists both is img and barplot
  plotFunction(...)
  dev.off()
  imgContent <- FileEncoder$contentAsBase64(outFile)
  file.remove(outFile)
  img <- createImgTag(imgContent, htmlattr)

  #paste0("<img src='", img, "' alt='plot' />")

  return(img$toString())
}

html.imgPlotComplex <- function(plotFunction, ..., htmlattr=NA) {
  outFile <- tempfile("plot", fileext = ".png")
  png(outFile, ...)
  # alt
  # height: exists both in img and barplot
  eval(plotFunction)
  dev.off()
  imgContent <- FileEncoder$contentAsBase64(outFile)
  file.remove(outFile)
  img <- createImgTag(imgContent, htmlattr)
  return(img$toString())
}

html.imgFile <- function(fileName, htmlattr=NA) {
  imgContent <- FileEncoder$contentAsBase64(fileName)
  #paste0("<img src='", img, "' alt='plot' />")
  img <- createImgTag(imgContent, htmlattr)

  return(img$toString())
}

html.imgUrl <- function(url, htmlattr=NA) {
  img <- createImgTag(url, htmlattr)
  return(img$toString())
}