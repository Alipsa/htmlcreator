
html.img <- function(plotFunction, ...) {
  outFile <- tempfile("plot", fileext = ".png")
  png(outFile)
  plotFunction(...)
  dev.off()
  img <- FileEncoder$contentAsBase64(outFile)
  file.remove(outFile)
  paste0("<img src='", img, "' alt='plot' />")
}

html.imgFile <- function(fileName) {
  img <- FileEncoder$contentAsBase64(fileName)
  paste0("<img src='", img, "' alt='plot' />")
}