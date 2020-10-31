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
    
    add = function(htmlString) {
      content <<- paste0(content, htmlString)
      invisible(.self)
    },

    clear = function() {
      content <<- ""
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
  if (!exists("html")) {
    html <- Html$new()
    assign("html", html, envir = .GlobalEnv)
  }
}

setGeneric("html.add", function(x, ...) standardGeneric("html.add"))

setMethod('html.add', signature("character"),
  function(x, ...) {
    checkVar()
    html$add(x, ...)
  }
)

setMethod('html.add', signature("data.frame"),
  function(x, ...) {
    checkVar()
    html$add(html.table(x, ...))
  }
)

setMethod('html.add', signature("function"),
  function(x, ...) {
    checkVar()
    html$add(html.img(x, ...))
  }
)

html.clear <- function() {
  html <- Html$new()
  assign("html", html, envir = .GlobalEnv)
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

