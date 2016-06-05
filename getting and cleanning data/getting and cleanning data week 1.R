#1.��װ��
packages <- c("data.table", "xlsx", "XML")
sapply(packages, require, character.only = TRUE, quietly = TRUE)
#2.��������csv����
url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06hid.csv"
f <- file.path(getwd(), "ss06hid.csv") 
download.file(url, f) #�����ļ���ָ��Ŀ¼
dt <- data.table(read.csv(f)) #��ȡ�ļ�
#3.ĳ��������ֵΪ���ٵĸ�����val=24��������
setkey(dt, VAL) #��val��������,VAL��key
dt[, .N, key(dt)]#key(dt)��ÿ��ֵ�ĸ���������key��val���������У�val=24�ĸ���Ϊ53

#or

sum(!is.na(dt$VAL[dt$VAL==24]))#(dt$VAL[dt$VAL==24])��val==24���������������ݿ�sum�����val==24�ĸ����ܺ�
#setkey() sorts a data.table and marks it as sorted (with an attribute sorted). The sorted columns are the key. The key can be any columns in any order.
#4.��ȡָ��������������xlsx
url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FDATA.gov_NGAP.xlsx"
f <- file.path(getwd(), "DATA.gov_NGAP.xlsx")
download.file(url, f, mode = "wb")
rows <- 18:23
cols <- 7:15
dat <- read.xlsx(f,1,colIndex = cols, rowIndex = rows)#1��sheetIndex
sum(dat$Zip * dat$Ext, na.rm = T)
#5.��ȡXML������
#Use http instead of https
url <- "http://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Frestaurants.xml"
doc <- xmlInternalTreeParse(url)
rootNode <- xmlRoot(doc)
#6.��ȡ�ļ���
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
#8.fread()���ܵ�ͬ��read.csv()
url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06pid.csv"
f <- file.path(getwd(), "ss06pid.csv")
download.file(url, f)
DT <- fread(f)
#9.д��������������ʱ��
check <- function(y, t) {
  message(sprintf("Elapsed time: %.10f", t[3]))
  print(y)
}
t <- system.time(y <- sapply(split(DT$pwgtp15, DT$SEX), mean))
t <- system.time(DT[,mean(pwgtp15),by=SEX])
check(y, t)

