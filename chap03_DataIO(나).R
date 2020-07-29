# chap03_DataIO


# 1. data 불러오기 (키보드 입력, 파일 가져오기)


# 1) 키보드 입력

# 숫자입력 <조건생략하면 자동으로 숫자> 
x <- scan()
x
x[3] # 30
sum(x) # 60
mean(x) # 20
# 문자입력
string <- scan(what = character())
string
string[2] # "이순신" 

# 2) 파일 읽기
setwd("c:/ITWILL/2_Rwork/Part-I")

#(1) read.table() : 칼럼구분(공백, 특수문자)
# -제목없음, 구분자 : 공백 <기본제목 : V1  V2  V3  V4>
student <- read.table("student.txt") 
student 
# -제목있음, 구분자 : 특수문자
student2 <- read.table("student2.txt", header = TRUE, sep = ";")
student2
student2 <- read.table("student2.txt", header = TRUE, sep = ",") # 콤마로 연결 불가능

# 결측치 처리하기 : -,& <특수문자가있으면 숫자가아닌 문자열로 처리해서 연산 불가능>
student3 <- read.table("student3.txt", header = TRUE, na.strings = c("-","&")) 
#결측치 자리에 오는 특수문자입력하면됌
student3
mean(student3$'키', na.rm=T) # 177.6667  <na.rm=t na값없앰>
str(student3)
class(student3) # "data.frame"
# (2) read.csv() : 구분자 : 콤마(,)
student4 <- read.csv("student4.txt", header = TRUE, sep = ",", na.strings = c("-","&"))
student4
# 탐색기 이용 : 파일 선택 
exel <- read.csv(file.choose()) # exel.csv <제목입력안하면 파일선택하는창이뜬다>
exel
# (3) read.xlsx() : 패키지 설치 
install.packages("xlsx")
library(rJava)
library(xlsx)
kospi <- read.xlsx("sam_kospi.xlsx", sheetIndex = 1)
kospi
# 한글이 포함된 xlsx 파일 읽기 
st_excel <- read.xlsx("studentexcel.xlsx", sheetIndex = 1, encoding = 'UTF-8')
st_excel

# 3) 인터넷 파일 읽기
# 데이터 셋 제공 사이트 
# http://www.public.iastate.edu/~hofmann/data_in_r_sortable.html - Datasets in R packages
# https://vincentarelbundock.github.io/Rdatasets/datasets.html
# https://r-dir.com/reference/datasets.html - Dataset site
# http://www.rdatamining.com/resources/data
titanic <- read.csv("https://vincentarelbundock.github.io/Rdatasets/csv/COUNT/titanic.csv")
# titanic / Titanic  대문자 소문자 구분!! 
str(titanic)
dim(titanic)
head(titanic)
# 생존여부 
table(titanic$survived)
# no  yes 
# 817 499 
# 성별구분
table(titanic$sex)
# man women 
# 869   447 
# class 구분
table(titanic$class)
# 1st class 2nd class 3rd class 
# 325       285       706 
# 성별 vs 생존여부 : 교차분할표
tab <- table(titanic$survived, titanic$sex)
tab
#     man women
# no  694   123
# yes 175   324
# 막대차트
barplot(tab)
barplot(tab, col = rainbow(2))
titanic # 200개부터 생략됌 200개인이유
getOption("max.print") # 1000  <데이터의 원소최대치>
200*5
# 행 제한 풀기 <생략없이 전체보기>
options(max.print = 9999999)
titanic


# 2. 데이터 저장(출력)하기


# 1) 화면 출력

x=20
y=30
z= x+y
z # 50
cat(z) # 50
cat('z=',z) # z= 50 
print(z) # 50   <함수 내에서 출력>
print('z=',z)  # 문자열과 같이 사용할수없어서 오류
print(z**2) # 대신 수식은 사용가능

# 2) 파일 저장(출력)  <나중에 또 쓸수있게>
# read.table -> write.table : 구분자(공백, 특수문자)
# read.csv -> write.csv     : 구분자(콤마)
# read.xlsx -> write.xlsx   : 엑셀(패키지 필요)

# (1) wite.table() : 공백
setwd("C:/ITWILL/2_Rwork/output")  # 경로설정
write.table(titanic, "titanic.txt", row.names = FALSE)  # 파일이름과 저장할파일제목 quote생략해서  "" 로표시
write.table(titanic, "titanic2.txt", quote = FALSE, row.names = FALSE) # quote=FALSE로 "" 없앰
# (2) write.csv() : 콤마
head(titanic)
titanic_df <- titanic[-1]  # 맨앞에 x 칼럼 지우기
titanic_df
str(titanic_df)
write.csv(titanic_df, "titanic_df.csv", row.names = F, quote = F)
# (3) write.xlsx : 엑셀 파일 (패키지 필요)
search() # "package:xlsx" 이게 설치되어있는지 확인
write.xlsx(titanic, "titanic.xlsx", sheetName = "titanic", row.names = F)



