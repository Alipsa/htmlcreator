# remember to add export(function name) to NAMESPACE to make them available

Html <- setRefClass(
  Class = "Html",
  fields = list (
    content = "character"
  ),
  methods = list(
    
    initialize = function() {
       content <<- ""
    },
    
    add = function(prime, ...) {
      klass <- class(prime)
      if (klass == "function") {
        htmlString <- html.imgPlot(prime, ...)
      } else if (klass == "data.frame") {
        htmlString <- html.table(prime, ...)
      } else if (klass == "matrix") {
        htmlString <- html.table(as.data.frame(prime), ...)
      } else {
        htmlString <- paste0(as.character(prime), collapse = "")
      }
      content <<- paste0(content, htmlString)
      invisible(.self)
    },

    addPlot = function(func, ...) {
      htmlString <- html.imgPlotComplex(func, ...)
      content <<- paste0(content, htmlString)
      invisible(.self)
    },

    addImageFile = function(fileName) {
      if(!file.exists(fileName)) {
        stop(paste("File", fileName, "does not exist"))
      }
      content <<- paste0(content, html.imgFile(fileName))
      invisible(.self)
    },

    clear = function() {
      content <<- ""
      invisible(.self)
    },
    
    getContent = function() {
      content
    },
    
    show = function(...) {
      cat(content)
      invisible(.self)
    }
  )
)

checkVar <- function() {
  if (!exists(".htmlcreatorEnv", mode="environment")) {
    .htmlcreatorEnv <- new.env()
    assign(".htmlcreatorEnv", .htmlcreatorEnv, envir = .GlobalEnv)
  }
  if (!exists("html", envir = .htmlcreatorEnv)) {
    .htmlcreatorEnv$html <- Html$new()
  }
}

createTag <- function(tagName, htmlattr=NA) {
  tag <- Element$new(tagName)
  if (is.list(htmlattr)) {
    for (idx in 1:length(htmlattr)) {
      name <- names(htmlattr)[idx]
      val <- as.character(htmlattr[idx])
      if (trimws(name) == "") {
        warning(paste("skipping due to invalid parameter name for", val))
      } else {
        tag$setAttribute(name, val)
      }
    }
  }
  return(tag)
}

setGeneric("html.add", function(x, ...) standardGeneric("html.add"))

setMethod('html.add', signature("character"),
  function(x) {
    checkVar()
    .htmlcreatorEnv$html$add(x)
  }
)

setMethod('html.add', signature("numeric"),
  function(x) {
    checkVar()
    .htmlcreatorEnv$html$add(x)
  }
)

setMethod('html.add', signature("data.frame"),
  function(x, ...) {
    checkVar()
    .htmlcreatorEnv$html$add(x, ...)
  }
)

setMethod('html.add', signature("matrix"),
  function(x, ...) {
    checkVar()
    .htmlcreatorEnv$html$add(x, ...)
  }
)

# arguments that the generic dispatches on can’t be lazily evaluated (http://adv-r.had.co.nz/S4.html)
# so we work around this by separating the function and its arguments, otherwise the signature to match on
# would be the result of the plot/hist call e.g. numeric which is not what we want
setMethod('html.add', signature("function"),
  function(x, ...) {
    checkVar()
    .htmlcreatorEnv$html$add(x, ...)
  }
)

html.addPlot <- function(x, ...) {
  if (!is.call(substitute(x))) {
    # this is not a 100% guarantee that the code plock is a plot but we want the flexibility to
    # call ggplot2, lattice etc. so cannot do better than this check
    stop(paste("first argument is not an anonymous code block, this does not look correct"))
  }
  checkVar()
  .htmlcreatorEnv$html$addPlot(x, ...)
}

html.clear <- function() {
  checkVar()
  .htmlcreatorEnv$html <- Html$new()
}

html.new <- function(x, ...) {
  html.clear()
  html.add(x, ...)
}

setMethod('as.vector', signature("Html"),
  function(x) {
    x$getContent()
  }
)

setMethod('as.character', signature("Html"),
  function(x) {
    x$getContent()
  }
)

setMethod('format', signature("Html"),
  function(x) {
    x$getContent()
  }
)

html.content <- function() {
  checkVar()
  content <- .htmlcreatorEnv$html$getContent()
  if (!startsWith(content, "<html")) {
    content <- paste0("<html>", content)
  }
  if (!endsWith(content, "</html>")) {
    content <- paste0(content, "</html>")
  }
  content
}

