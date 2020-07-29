# chap01_Basic

##########################
#패키지 설치 error 해결법
##########################
# 1. 최초 패키지 설치
# - Rstudio 관리자 권한으로 실행하기
# 2.기존 패키지 설치 
#  1) remove.packages('패키지')
#  2) rebooting
#  3) install.packages('패키지')
##################################
#주요 단축키
#############
# script 실행 : Ctrl + Enter
# save : Ctrl + S
# 자동완성 : Ctrl+Space bar
# 여러줄 주석처리하기 : 드래그 -> Ctrl + Shift + C  (토글)
##########################################################
# [] = 색인(index) : 저장 위치
# 더미변수 : 숫자에 의미가 없는 숫자형
# 껐다 키면 새로운 session으로 시작


# 수업내용
# 1. 패키지와 세션
# 2. 패키지 사용법
# 3. 변수와 자료형
# 4. 기본함수와 작업공간



# 1. 패키지와 세션



available.packages()
dim(available.packages())
# [1] 15297(패키지수<행>) 17(패키지정보<열>)
# [1] 15308    17 (하루만에 패키지수가 늘어났다.)
# 15250 행들을 생략합니다 그러면 58개만보임 이유: 58*17 = 986 이므로 최대치
getOption("max.print") # 1000  (현재 최대볼수있는 패키지수 1000개<행x열>)

# session
sessionInfo() #세션 정보 제공
# R 환경, OS 환경, 다국어(locale)정보, 기본7패키지, 
# 껐다 키면 초기화



# 2. 패키지 사용법 : package = function + dataset



#  1) 패키지 설치


# 기존버전 패키지를 현재 위치에 설치하는 방법
install.packages('https://cran.rstudio.com/bin/windows/contrib/3.2/xxx.zip', repos = NULL)
#이렇게 다운받고자하는 파일주소를 입력해도 다운가능
install.packages('stringr')
install.packages(stringr)  <오류>
# 패키지(1) + 의존성 패키지(3)      <()는결과갯수>
  
  
#  2)패키지 설치 경로
  
  
.libPaths()
# [1] "C:\Users\user\Documents\R\win-library\3.6"  - 확장 패키지
# [2] "C:/Program Files/R/R-3.6.2/library"         - 기본 30개 패키지


#  3) in memory : 패키지 -> upload


library(stringr) # = library('stringr')
library(help='stringr') # library사용 help 파일열기

# memory 로딩된 패키지 확인
search() #11개  (4,5,6,7,8,9,11 은 기본7패키지)

str_extract('홍길동35이순신45','[가-힣]{3}')
# [1] "홍길동"
str_extract_all('홍길동35이순신45','[가-힣]{3}')
# [1] "홍길동" "이순신"


#  4) 패키지 삭제


remove.packages('stringr')    # 물리적 삭제 가능
str_extract()  #남아있는경우 seission에 아직남아있어서,껐다키면 지워짐



# 3. 변수와 자료



# 1) 변수 : 메모리 이름


# 2) 변수 작성 규칙 및 특징


# - 첫자는 영문, 두번째는 숫자, 특수문자(_,.)
#   ex)score2020, score_2020, score.2020
# - 예약어, 함수명 변수로 사용 불가
# - 대소문자 구분
#   ex) Num=100, num=10 <서로다르게 저장>
# - 변수 선언시 type 선언 없음
#   ex) score = 90 (R)  vs  int score = 90 (C)
# - 가장 최근값으로 변경된다.
# - R의 모든 변수는 객체(object)

#할당 연산자( <- , = )
var1 <- 0   #var1 = 0
var1 <- 1   #var1 = 1  <가장최근값으로변경된다.>

var1
print(var1)   #<위아래같음 print생략가능>

var2 <- 10
var3 <- 20

var1; var2; var3;

# [1] 1
# [1] 10
# [1] 20


var3 <- c(10, 20, 30, 40, 50)

var3[5] # 50

#대소문자
NUM = 100
num = 200
print(NUM == num)  #관계식 -> T/F          < = , <- 서로같은의미>
# [1] FALSE

# object.member
member.id = 'hong'    # "hong"
member.name = "홍길동"
member.age = 35

member.id; member.name; member.age;

# scala(o차원) vs vector(1차원)
score <- 95                 #scala
scores <- c(85,75,95,100)   #vector
score      #[1] 95
scores     #[1]  85  75  95 100


# 3) 자료형(data type) : 숫자형, 문자형, 논리형  <p.15>


int <- 100
float<- 125.23
string <- "대한민국"
bool <- TRUE   # TRUE, T, FALSE, F

# mode자료형 반환 함수
mode(int)     #[1] "numeric"
mode(float)   #[1] "numeric"
mode(string)  #[1] "character"
mode(bool)    #[1] "logical"

# is.xxx : (NA=)결측치(null과비슷한의미) -> TRUE
is.numeric(int)        #[1] TRUE
is.character(string)   #[1] TRUE
is.logical(bool)       #[1] TRUE
is.numeric(string)     #[1] FALSE
 
datas <- c(84,85,62,NA,45)
datas   #[1] 84 85 62 NA 45

is.na(datas)   #[1] FALSE FALSE FALSE  TRUE FALSE
mode(datas) #[1] "numeric"


# 4) 자료형 변환 함수 <p.20>(as.xxx)


#  (1) 문자형 -> 숫자형 변환
x <- c(10, 20, 30, '40') # vector  (하나라도 문자면 전부 문자로저장)
x         # [1] "10" "20" "30" "40"
mode(x)   # "character"
x*2       #error  문자형이기때문

x <- as.numeric(x)
x         #[1] 10 20 30 40    <""사라짐>
x*2       #[1] 20 40 60 80
x**2      #[1]  100  400  900 1600
mode(x)   #[1] "numeric"
plot(x)    #그래프 생성  <순서는x축 , 값은y축>

#  (2) 요인형(factor)
# 범주형(집단형) 변수 생성
# 독립변수 (x변수 문자형) : 더미변수(1,2) 생성

gender <- c('남', '여', '남', '여', '여')
mode(gender)    #[1] "character"
class(gender)   #[1] "character"
plot(gender)    #오류 문자형이기때문
gender          #[1] "남" "여" "남" "여" "여"

#문자형 -> 요인형 형 변환      <leves순서는 ㄱㄴㄷ순서로>
fgender <- as.factor(gender)
mode(fgender)   #[1] "numeric"
plot(fgender)   
fgender         #[1] 남 여 남 여 여   Levels: 남 여
str(fgender)    #Factor w/ 2 levels "남","여": 1 2 1 2 2  <이때 12122는 더미변수라한다.>
                  #<더미변수에는 자료형이 숫자로표현되었지만 숫자의 의미는 없다.>
# mode  vs  class
mode(fgender)      #[1] "numeric"  -> 자료형 확인
class(fgender)     #[1] "factor"   -> 자료구조 확인

#숫자형 변수
x <- c(4, 2, 4, 2)
mode(x)         #[1] "numeric"
x               #[1] 4 2 4 2
#숫자형 -> 요인형
f <- as.factor(x)
f               #[1] 4 2 4 2    Levels: 2 4
mode(f) # numeric
class(f) # factor

#요인형 -> 숫자형       <숫자->요인->숫자로 하면 결과값이 요인형의 카테고리로 바뀐다.>
x2 <- as.numeric(f)
x2              #[1] 2 1 2 1

#요인형 -> 문자형
c <- as.character(f)
c               #[1] "4" "2" "4" "2"
mode(c) # character
class(c) # character

#문자형 -> 숫자형       <숫자->요인->문자->숫자로 하면 결과값 그대로>
x3 <- as.numeric(c)
x3              #[1] 4 2 4 2



# 4. 기본함수와 작업공간



# 1) 기본함수 : 7개 패키지에 속한 함수  <바로 사용하는 함수>


sessionInfo()  #attached base packages:
               #[1] stats     graphics  grDevices utils     datasets  methods   base  

#패키지 도움말
library(help='stats')

# 함수 도움말
help(sum)

x <- c(10,20,30,NA)
sum(x)               #[1] NA  <NA가 포함된연산은 결과가 NA로나옴>
sum(x,na.rm = TRUE)  #[1] 60  <NA값 TRUE로 변환>
sum(10,20,30,NA, na.rm = TRUE) #[1] 60
sum(1:5)             #[1] 15
sum(1,2,3,4,5)       #[1] 15

?mean  # mean(x, ...)             <R에서는 형식이 중요하다.>
mean(10,20,30,NA, na.rm = TRUE)   #[1] 10  <정확한 값이 아님>형식x
mean(x,na.rm = TRUE)              #[1] 20  <이게 정확한 값>형식o


# 2) 기본 데이터 셋


data()    #데이터 셋 확인 
data(Nile) # in memory
Nile
str(Nile) #  Time-Series [1:100] from 1871 to 1970: 
length(Nile) #[1] 100
mode(Nile) #[1] "numeric"
class(Nile) # ts
plot(Nile)
hist(Nile)


# 3) 작업공간


getwd() #[1] "C:/ITWILL/2_Rwork"
setwd("c:/itwill/2_rwork/part-i")
getwd() #[1] "c:/itwill/2_rwork/part-i"

emp <- read.csv("emp.csv", header = T)
emp


