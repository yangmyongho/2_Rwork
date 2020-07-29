# chap03_DataIO


# 1. data 불러오기(키보드 입력, 파일 가져오기)

# 1) 키보드 입력 
x <- scan() # 숫자 입력 
x[3]
sum(x)
mean(x)

# 문자 입력 
string <- scan(what = character())
string

# 2) 파일 읽기 
setwd("C:/ITWILL/2_Rwork/Part-I")

# (1) read.table() : 칼럼 구분(공백, 특수문자) 

# 제목없음, 구분자 : 공백 
student <- read.table("student.txt") # 제목 없음, 공백 구분 
student 
# 기본 제목 : V1   V2  V3 V4

# 제목 있는 경우, 구분자 : 특수문자  
student2 <- read.table("student2.txt", header = TRUE, sep = ";")
student2

# 결측치 처리하기 : -, &
student3 <- read.table("student3.txt", header = TRUE,
                       na.strings = c("-", "&"))
student3
mean(student3$키, na.rm=T) 

str(student3)
class(student3) # "data.frame"

# (2) read.csv() : 구분자 : 콤마(,)
student4 <- read.csv("student4.txt", na.strings = c("-", "&")) #, header = T, sep = ",")
student4

# 탐색기 이용 : 파일 선택 
excel <- read.csv(file.choose()) # excel.csv
excel

# (3) read.xlsx() : 패키지 설치 
install.packages("xlsx")
#install.packages("rJava")

library(rJava)
library(xlsx)

kospi <- read.xlsx("sam_kospi.xlsx", sheetIndex = 1)
kospi

# 한글이 포함된 xlsx 파일 읽기 
st_excel <- read.xlsx("studentexcel.xlsx", sheetIndex = 1, 
          encoding = 'UTF-8')
st_excel


# 3) 인터넷 파일 읽기 
# 데이터 셋 제공 사이트 
# http://www.public.iastate.edu/~hofmann/data_in_r_sortable.html - Datasets in R packages
# https://vincentarelbundock.github.io/Rdatasets/datasets.html
# https://r-dir.com/reference/datasets.html - Dataset site
# http://www.rdatamining.com/resources/data

titanic <- read.csv("https://vincentarelbundock.github.io/Rdatasets/csv/COUNT/titanic.csv")
str(titanic)
dim(titanic) # 1316    5
head(titanic)

# 생존여부 
table(titanic$survived)
# no yes 
#817 499

# 성별 구분 
table(titanic$sex)

# class 구분 
table(titanic$class)
#1st class 2nd class 3rd class 
#    325       285       706

# 성별 vs 생존여부 : 교차분할표 
tab <- table(titanic$survived, titanic$sex)
#    man women
#no  694   123
#yes 175   324

# 막대차트 
barplot(tab, col = rainbow(2))

titanic

getOption("max.print") # 1000
200*5

# 행 제한 풀기 
options(max.print = 999999999)

titanic

# 2. 데이터 저장(출력)하기 

# 1) 화면 출력 
x = 20
y = 30
z = x + y

cat('z =', z) # z= 50

print(z) # 함수 내에서 출력 
print(z**2) # 수식 가능 
#print('z = ', z) # Error


# 2) 파일 저장(출력)
#read.table -> write.table : 구분자(공백, 특수문자)
#read.csv -> write.csv : 구분자(콤마)
#read.xlsx -> write.xlsx : 엑셀(패키지 필요) 

# (1) write.table() : 공백 
setwd("C:/ITWILL/2_Rwork/output")

write.table(titanic, "titanic.txt", row.names = FALSE)
write.table(titanic, "titanic2.txt", 
            quote = FALSE, row.names = FALSE)

# (2) write.csv() : 콤마 
head(titanic)
titanic_df <- titanic[-1] # X 칼럼 제외 
titanic_df
str(titanic_df)

write.csv(titanic_df, "titanic_df.csv", 
          row.names = F,
          quote = F)

# (3) write.xlsx : 엑셀 파일 
search() # "package:xlsx"

write.xlsx(titanic, "titanic.xlsx", 
           sheetName = "titanic",
           row.names = FALSE)











