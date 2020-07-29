# chap01_Basic

# 수업내용 
# 1. 패키지와 세션 
# 2. 패키지 사용법 
# 3. 변수와 자료형 
# 4. 기본함수와 작업공간 
  
# 1. 패키지와 세션
dim(available.packages())
# [1] 15297(패키지 수)    17(패키지 정보)

# session
sessionInfo() # 세션 정보 제공 
# R 환경, OS 환경, 다국어(locale)정보, 기본 7 패키지    

# 주요 단축키 
# script 실행 : Ctrl + Enter
# save : Ctrl + S
# 자동완성 : Ctrl + Space bar
# 여러줄 주석 : Ctrl + Shift + C(토글)
# a <- 10
# b <- 20
# c <- a + b
# print(c)

# 2. 패키지 사용법 : package = function + dataset

# 1) 패키지 설치 
install.packages('stringr')
install.packages(stringr) # error 
# 패키지(1) + 의존성 패키지(3) 

# 2) 패키지 설치 경로 
.libPaths()
#[1] "C:/Users/user/Documents/R/win-library/3.6" - 확장 패키지 
#[2] "C:/Program Files/R/R-3.6.2/library" - 기본 30개 패키지 

# 3) in memory : 패키지 -> upload
library(stringr) # library('stringr')

str_extract('홍길동35이순신45', '[가-힣]{3}')
# [1] "홍길동"
str_extract_all('홍길동35이순신45', '[가-힣]{3}')
# [[1]] [1] "홍길동" "이순신"

# 4) 패키지 삭제 
remove.packages('stringr') # 물리적 삭제 가능 

#############################
## 패키지 설치 Error 해결법 
#############################

# 1. 최초 패키지 설치 
# - RStudio 관리자 모드 실행 

# 2. 기존 패키지 설치 
# 1) remove.packages('패키지') 
# 2) rebooting
# 3) install.packages('패키지')


# 3. 변수와 자료형 

# 1) 변수 : 메모리 이름 

# 2) 변수 작성 규칙 및 특징  
# - 첫자는 영문, 두번째는 숫자, 특수문자(_, .)
#   ex) score2020, score_2020, score.2020
# - 예약어, 함수명 사용 불가 
# - 대소문자 구분 
#   ex) NUM=100, num=10 
# - 변수 선언시 type 선언 없음 
# - score = 90(R) vs int score = 90(c)
# - 가장 최근값으로 변경됨
# - R의 모든 변수는 객체(object)

var1 <- 0 # var1 = 0
var1 <- 1
var1
print(var1)

var2 <- 10
var3 <- 20

var1; var2; var3
# [1] 1 
# [1] 10
# [1] 20

# 색인(index) : 저장 위치 
var3 <- c(10, 20, 30, 40, 50)
var3 # [1] 10 20 30 40 50
var3[5] # 50

# 대소문자
NUM = 100
num = 200
print(NUM == num) # 관계식 -> T/F
# [1] FALSE

# object.member
member.id = 'hong' # "hong" 
member.name = "홍길동"
member.age = 35 

member.id; member.age

# scala(0) vs vector(1)
score <- 95 # scala
scores <- c(85,75,95,100) # vector 
score #  95
scores # [1]  85  75  95 100


# 3) 자료형(data type) : p.15 숫자형,문자형,논리형 

int <- 100
float <- 125.23
string <- "대한민국"
bool <- TRUE # TRUE, T, FALSE, F

# mode : 자료형 반환 함수  
mode(int) # "numeric"
mode(float) # "numeric"
mode(string) # "character"
mode(bool) # "logical"

# is.xxxx
is.numeric(int) # TRUE
is.character(string) # TRUE
is.logical(bool) #  TRUE
is.numeric(string) # FALSE

datas <- c(84,85,62,NA,45)
datas # 84 85 62 NA 45

is.na(datas) # 결측치 -> TRUE
# FALSE FALSE FALSE  TRUE FALSE


# 4) 자료형변환 함수 : p.20

# (1) 문자형 -> 숫자형 변환 
x <- c(10, 20, 30, '40') # vector
x # [1] "10" "20" "30" "40"
mode(x) # "numeric" -> "character"
x*2 # Error 

x <- as.numeric(x)
x*2 # 숫치 연산 
x**2
x
plot(x) # 그래프 생성 

# (2) 요인형(factor)
# 범주형 변수(집단변수) 생성 

gender <- c('남', '여', '남', '여', '여')
mode(gender) # "character"
plot(gender) # Error 
gender # "남" "여" "남" "여" "여"

# 문자형 -> 요인형 변환 
fgender <- as.factor(gender)
mode(fgender) # "numeric"
plot(fgender)

fgender
# [1] 남 여 남 여 여
# Levels: 남 여
str(fgender)
# Factor w/ 2 levels "남","여": 1 2 1 2 2
# 더미변수 : 숫자에 의미가 없는 숫자형 

# mode vs class
mode(fgender) # "numeric" -> 자료형 확인 
class(fgender) # "factor" -> 자료구조 확인 

###########################
# factor 형변환 고려사항 
###########################
# 숫자형 변수 
x <- c(4,2,4,2)
mode(x) # "numeric"

# 숫자형 -> 요인형 
f <- as.factor(x)
f # Levels: 2 4 -> 2 1 2 1

# 요인형 -> 문자형 
c <- as.character(f)

# 문자형 -> 숫자형 
x2 <- as.numeric(c)
x2 # 2 1 2 1 -> 4 2 4 2


# 4. 기본함수와 작업공간

# 1) 기본함수 : 7개 패키지에 속한 함수 
sessionInfo() #attached base packages:

# 패키지 도움말 
library(help='stats')

# 함수 도움말 
help(sum) # sum(..., na.rm = FALSE)
x <- c(10,20,30,NA)
sum(x, na.rm = TRUE) # 60
sum(10,20,30,NA, na.rm = TRUE) # 60
sum(1:5) # 15
sum(1, 2, 3, 4, 5) # 15

?mean # mean(x, ...)
mean(10,20,30,NA, na.rm = TRUE) # 10
mean(x, na.rm = TRUE) # 20

# 2) 기본 데이터셋 
data() # 데이터셋 확인 
data(Nile) # in memory 

Nile
length(Nile) # 100
mode(Nile) # "numeric"
plot(Nile)
hist(Nile)

# 3) 작업공간
getwd() # "C:/ITWILL/2_Rwork"
setwd("c:/itwill/2_rwork/part-i")
getwd() # "c:/itwill/2_rwork/part-i"

emp <- read.csv("emp.csv", header = T)
emp





