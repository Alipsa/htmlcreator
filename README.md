# Renjin html creator
Renjin R package to create html  

This package provides a simple way to create html content.
Here is an example:
```r
  library('se.alipsa:htmlcreator')

  html.add("<html><body>")
  html.add("<h2>A Sample report with a table and an image</h2>")
  html.add(
    barplot,
    table(mtcars$vs, mtcars$gear),
    main="Car Distribution by Gears and VS",
    col=c("darkblue","red")
  )
  html.add(mtcars)
  html.add("</html></body>")
  # save the html to a file
  outFile <- tempfile("plot", fileext = ".html")
  write(html.content(), outFile)
  print(paste("Wrote", outFile))
```
To be able to do this, add the dependency to your pom.xml as follows:
```xml
<dependency>
  <groupId>se.alipsa</groupId>
  <artifactId>htmlcreator</artifactId>
  <version>1.3</version>
</dependency>
```
As you can see, the mail method is the overloaded `html.add`. It can take
1. strings (charvectors) as parameters (which are treated as raw html),
1. a data.frame (which is converted into a html table), 
or 
1. a plot function (which converts the plot into an img tag). Notice that the plot function is passed in separately from 
its arguments, this to allow the plot function to be executed by the html.add method (which converts the result of the plot to an image and
base64 encodes it into a string which is then made part of the img tag) rather than executed before the function is called which
would have been the result of passing the plotfunction and its arguments together to html.add.

Besides this, there is the html.clear() function which resets the 
underlying html object (clears the content).

html attributes can be set by passing setting the parameter `htmlattr` to a list of attribute, e.g:
```r
# add id and class to a table:
html.add(mtcars, htmlattr=list(id="cardetails", class="table table-striped"))

# add alt attribute to an img:
html.add(
  barplot,
  table(mtcars$vs, mtcars$gear),
  main="Car Distribution by Gears and VS",
  col=c("darkblue","red"),
  htmlattr = list(alt="an mtcars plot")
)
```

It is also possible to use the underlying reference class (Html) and the specific
html creating methods directly. The underlying html creating methods are:
- html.table - converts a data.frame to a table
- html.imgPlot - converts a plot to an img tag
- html.imgFile - converts a file to an img tag
- html.imgUrl - creates an img tag

# Version history

## 1.4
- Add a html.new() function (convenience method that does html.clear() followed by html.add())
- fix broken tests

## 1.3
- use a dedicated env to avoid accidental overwrites
- Remove space in base 64 file encoding (no space works in all browsers whereas the space caused problems in (at least) Firefox)

## 1.2
- Fixes to img handling, rename internal functions for clarity

## 1.1
- bugfix for matrix's
- add ability to add element attributes (e.g class, id etc)

## 1.0 initial release