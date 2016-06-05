R语言：网页抓取之不同提取方法解析

接上篇，用R获取网页数据之后的处理

（一）XML解析网页并提取数据

当获取表格数据时，可以用readHTMLTable来获取数据，很方便。当数据不是表格化的时，则常用xmlTreeParse（xmlParse）和getNodeSet配合来获取相应的数据。xmlTreeParse 来抓取页面数据，并且形成树。getNodeSet来对树结构数据，根据XPath语法来选取特定的节点集。下面举个实际例子来讲解一下这两个最重要函数的应用。

library(XML)

URL = 'http://www.w3school.com.cn/example/xmle/books.xml'

doc <- xmlParse(URL);##解析网页##还有其他参数，如encoding##

##(1)选取属于bookstore子元素的第一个book元素 

getNodeSet(doc,'/bookstore/book[1]') ##此方法不常用

##获取根节点

top <- xmlRoot(doc)

##获取某个节点下数据

top[2]

##使用XPath语句查询

##(2)先筛选符合条件的节点

###注意下面的单引号和双引号可能在R里会导致没有执行结果的问题###

Node <- getNodeSet(top, path = "//title[@lang='en']")

##然后取出其中元素

sapply(Node, xmlValue)

##(3)或者直接取出数据##取出title里面lang = ‘en’的内容##

xpathSApply(top, path = "//title[@lang='en']", xmlValue)



推荐阅读

http://www.52ij.com/jishu/XML/12424.html

http://cran.r-project.org/web/packages/XML/XML.pdf R语言的XML包的帮助文档





（二）正则表达式提取数据（其实就是字符串匹配）

URL = 'http://movie.**.com/top250?format=text%27'

##获取网页源码，存储起来##

web <- readLines(url,encoding="UTF-8")

# 找到包含电影名称的行编号以及电影名称

nameRow <- grep('<span class=\"title\">',web)

name <- web[nameRow]

##正则匹配提取电影名称##位置和长度##>move.name<

gregout <- gregexpr('>\\w+', name)

len = length(gregout)

move.name = matrix(0, nrow = len, ncol = 1)

for(i in 1:len){
  
  move.name[i,1] = substring(name[i], gregout[[i]]+1, (gregout[[i]]+attr(gregout[[i]], 'match.length'))[[1]]-1)
  
}

##去掉空缺值##

move.name <- move.name[nchar(move.name)>1]



辅助工具

自动生成正则表达式，但是不支持中文。

http://www.txt2re.com/index-java.php3

支持编程语言非常多的一个测试正则表达式的工具

RegexBuddy



推荐阅读

http://www.tuicool.com/articles/vEziEj 一个详细的例子

http://developer.51cto.com/art/201305/393692.htm R语言的字符串处理函数

http://www.jb51.net/tools/zhengze.html正则帮助文档





优缺点比较：

XML方法有时候会解析错误，但是简单易用。

正则选择方法需要懂点正则语法，写起来比较费劲，重在灵活。