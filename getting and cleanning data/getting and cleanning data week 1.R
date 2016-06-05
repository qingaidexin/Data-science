#1.安装包
packages <- c("data.table", "xlsx", "XML")
sapply(packages, require, character.only = TRUE, quietly = TRUE)
#2.网上下载csv数据
url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06hid.csv"
f <- file.path(getwd(), "ss06hid.csv") 
download.file(url, f) #下载文件到指定目录
dt <- data.table(read.csv(f)) #读取文件
#3.某个变量的值为多少的个数：val=24的样本量
setkey(dt, VAL) #用val进行排序,VAL是key
dt[, .N, key(dt)]#key(dt)下每个值的个数，这里key是val，在数据中，val=24的个数为53

#or

sum(!is.na(dt$VAL[dt$VAL==24]))#(dt$VAL[dt$VAL==24])是val==24的向量，不是数据框，sum求的是val==24的个数总和
#setkey() sorts a data.table and marks it as sorted (with an attribute sorted). The sorted columns are the key. The key can be any columns in any order.
#4.读取指定行数和列数的xlsx
url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FDATA.gov_NGAP.xlsx"
f <- file.path(getwd(), "DATA.gov_NGAP.xlsx")
download.file(url, f, mode = "wb")
rows <- 18:23
cols <- 7:15
dat <- read.xlsx(f,1,colIndex = cols, rowIndex = rows)#1是sheetIndex
sum(dat$Zip * dat$Ext, na.rm = T)
#5.读取XML的数据
#Use http instead of https
url <- "http://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Frestaurants.xml"
doc <- xmlInternalTreeParse(url)
rootNode <- xmlRoot(doc)
#6.读取文件名
names(rootNode)
##   row 
## "row"
names(rootNode[[1]][[1]])
##              name           zipcode      neighborhood   councildistrict 
##            "name"         "zipcode"    "neighborhood" "councildistrict" 
##    policedistrict        location_1 
##  "policedistrict"      "location_1"
#7.How many restaurants have zipcode 21231? 
zipcode <- xpathSApply(rootNode, "//zipcode", xmlValue)
table(zipcode == 21231)

#or

sum(xpathSApply(rootNode, "//zipcode", xmlValue)==21231)
#8.fread()功能等同于read.csv()
url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06pid.csv"
f <- file.path(getwd(), "ss06pid.csv")
download.file(url, f)
DT <- fread(f)
#9.写个函数计算运行时间
check <- function(y, t) {
  message(sprintf("Elapsed time: %.10f", t[3]))
  print(y)
}
t <- system.time(y <- sapply(split(DT$pwgtp15, DT$SEX), mean))
t <- system.time(DT[,mean(pwgtp15),by=SEX])
check(y, t)


