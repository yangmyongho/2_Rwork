# chap02_DataStructure

# 자료 구조의 유형(5)



# 1. vector 자료구조
# - 동일한 자료형을 갖는 1차원 배열구조 (linear구조)
# - 생성 함수 : c(), seq(), rep() 



#  1) c()


x <- c(1,3,5,7)
y <- c(3,5)
length(x) # 4
length(y) # 2

# 집합관련 함수 : base 패키지
union(x,y) # 1 3 5 7   <합집합>
setdiff(x,y) # 1 7     <차집합>
intersect(x,y) # 3 5   <교집합>

# 벡터 변수 유형
# 하나씩 타이핑해서 만들기엔 너무 길때에 (:사용)
num <- 1:5 # = c(1,2,3,4,5)
num
num <- c(-10:5)
num
num <- c(1,2,3,"4")   #<자료형이 같아야해서 전부 문자형으로 만듬>
num # "1" "2" "3" "4"

# 벡터 원소 이름 지정
names <- c("hong", "lee", "kang")
names # "hong" "lee"  "kang"
age <- c(35, 45, 55)
age # 35 45 55
names(age) <- names      #<이름만 지어준것일뿐 데이터가아니다>
age
mode(age) # "numeric"
mean(age) # 45
str(age)  # 객체의 자료구조 제공(확인)
# Named num [1:3] 35 45 55                              -> data
# - attr(*, "names")= chr [1:3] "hong" "lee" "kang"     -> label


# 2) seq() <나열>


help("seq")
num <- seq(1, 10, by=2)
num # 1 3 5 7 9
#from이 to 보다 작으면 by는 양수 / from이 to 보다 크면 by는 음수 
num2 <- seq(10, 1, by=-2)
num2 # 10  8  6  4  2


# 3) rep() <반복>


help(rep)
#time 과 each 반복되는 횟수는 같지만 색인이 다름
rep(1:3, times=3) # 1 2 3 1 2 3 1 2 3
rep(1:3, each=3) # 1 1 1 2 2 2 3 3 3


# 4) 색인(index : vector) : 저장 위치
# 형식) object[n]    <객체[]  항상 객체뒤에 []가 나온다>


a <- 1:50
a
# 1의 인덱스는 [1] , 2의 인덱스는 [2],...48의인덱스는 [48]
a[10] # 10
a[10:20] # 10~20
a[10:20, 30:35] #오류  <1차원에는 , 사용 불가능>
a[c(10:20,30:35)] # 10~20,30~35  <c함수로 묶어서 사용>

# 함수 이용
length(a) # 50  <길이= 원소 갯수>
a[10:length(a)] # 10~50
a[10:length(a)-5] # 5~45
a[10:(length(a)-5)] # 10~45
a[seq(2, length(a), by=2)] # 2부터 2씩 늘어나게 50까지

# 특정 원소 제외 (-)
a[-c(20:30)] #20~30제외한
a[-c(15,25,30:35)] # 15,25,30~35제외한

# 조건식 (boolean)
a[a>=10 & a<=30] # 10~30  < & 는 오라클의 and 와 같다>
a[a>=10 | a<=30] #1~50    < | 는 오라클의 or 와 같다>
a[!(a>=10)] # [1] 1 2 3 4 5 6 7 8 9    < ! = not >



# 2. matrix 자료 구조
# - 동일한 자료형을 갖는 2차원 배열구조
# - 생성 함수 : matrix(), rbind(), cbind()
# - 처리 함수 : apply(), 



# 1) matrix : 1차원 -> 2차원     < 행:r [r,], 열:c [,c] > 
m1 <- matrix(data=c(1:5)) # 행:5, 열:1  <속성값 생략가능>
m1
dim(m1) # [1] 5 1 = 5x1 <5행1열>
mode(m1) # [1] "numeric"  -자료형
class(m1) # [1] "matrix"  -자료구조

m2 <- matrix(data= c(1:9), nrow = 3, ncol = 3 , byrow = TRUE) #<byrow쓰면 행단위로>
m2 
dim(m2) # [1] 3 3


# 2) rbind <rowbind> 행단위 묶음
x <- 1:5
y <- 6:10
x
y
m3 <- rbind(x,y)  # <행벡터이름은 x,y 이고 행마다 벡터이름값이 들어감> 
m3
dim(m3) # [1] 2 5


# 3) cbind <colbind> 열단위 묶음
m4 <- cbind(x,y) # <열벡터이름은 x,y 이고 열마다 벡터이름값이 들어감> 
m4

# ADSP 시험 문제였던것
xy <- rbind(x,y)
# 다음 보기중에서 틀린 답항은?  정답 : 2번
# 1. xy[1,] 는 x 와 같다.
# 2. xy[,1] 은 y 와 같다.
# 3. dim(xy) 는 2x5 이다.
# 4. class(xy)는 matrix이다.
xy 
xy[1,] # [1] 1 2 3 4 5
xy[,1] # 1 6
dim(xy) # [1] 2 5
class(xy) # [1] "matrix"


# 4) 색인(index : matrix) 
# 형식) object[row,col]


m5 <- matrix(data= c(1:9), nrow = 3, ncol = 3 ) #<BYROW  생략하면 열단위>
m5
m5[2,3] # [1] 8 <특정 행열 선택>
# 특정 행/열 색인 
m5[1,] # [1] 1 4 7
m5[,1] # [1] 1 2 3
m5[1,2:3] # [1] 4 7
# box 선택
m5[2:3,1:3] # 행과 열에대한 범위 지정

#  -속성 (~을제외한 나머지)
m5[-2,] # 2행 제외
m5[,-3] # 3열 제외
m5[,-c(1,3)] # [1] 4 5 6  <2개이상제외>


# 5) 열(칼럼=변수=변인) 이름 지정


colnames(m5) <- c("one", "two", "three")
m5
m5[,"one"] # [1] 1 2 3 <열이름으로도 검색가능>
m5[,"one":"two"] # <오류> 
m5[, 1:2] # <가능>


# 6) broadcast 연산
# - 작은 차원 -> 큰차원 늘어나서 연산


x <- matrix(1:12, nrow = 4, ncol = 3, byrow = T)
x
dim(x) # [1] 4 3

# (1) scala(0) vs matrix(2) <scala가 행열구조에맞게변환한뒤 연산>
0.5*x

# (2) vactor(1) vs matrix(2) <vector가 행열구조에맞게변환한뒤 연산>
y <- 10:12
y # [1] 10 11 12
y+x

# (3) 동일한 모양 (shape)
x+x
x-x

# (4) 전치행렬 : 행->열 , 열->행
x
t(x)


# 7) 처리 함수 : apply()
help("apply") # apply(X, MARGIN(1/2), FUN, ...) < MARGIN(1=행/2=열) > <FUN=함수>
x
apply(x, 1, sum) # [1]  6 15 24 33 <행단위합계>
apply(x,2,mean) # [1] 5.5 6.5 7.5 <열단위평균>
apply(x,1,var) # [1] 1 1 1 1 <행단위분산>
apply(x,1,sd) # [1] 1 1 1 1 <행단위표준편차>



# 3. array 자료구조
# - 동일한 자료형을 작는 3차원 배열구조 
# - 생성 함수 : array()
# - 



# 1차원 -> 3차원
arr <- array(data=c(1:12), dim=c(3,2,2))
arr
dim(arr) # [1] 3 2 2  / 행 열 면

# 연습 붓꽃데이터
data()
data("iris3")
iris3
dim(iris3) # [1] 50  4  3
50*4*3 # 600 데이터갯수

# 색인 (index)
arr[,,1] # 1면의 데이터
arr[,,2] # 2면의 데이터
iris3[,,1] # 3면의 데이터 
iris3[10:20,1:2,1] # 10~20행,1~2열,1면의 데이터



# 4. data.frame
# - 열 단위 서로다른 자료형을 갖는 2차원(행렬) 배열구조
# - 생성 함수 : data.frame()
# - 처리 함수 : apply() -> 행렬 처리 



# 1) vector 이용
no <- 1:3
name <- c("홍길동", "이순신", "유관순")
pay <- c(250, 350, 200)

emp <- data.frame(NO=no, NAME=name, PAY=pay)
emp
dim(emp) # [1] 3 3
mode(emp) # [1] "list"  <2개이상의 자료형을 포함할 경우 list로 표현>
class(emp) # [1] "data.frame"

# 자료참조 : 칼럼 참조 or index 참조
# 형식) object$칼럼<칼럼참조> 
emp$PAY # [1] 250 350 200
pay <- emp$PAY #특정 칼럼 참조 -> vector
pay
mean(pay) # [1] 266.6667
sd(pay) # [1] 76.37626

# 형식) object[row,column]<index참조>
emp_row <- emp[c(1,3),] # < = emp[-2,] >
emp_row

# 2) csv, text file, db table
setwd("c:/ITWILL/2_Rwork/Part-I")
getwd

emp_text <- read.table("emp.txt", header = T, sep = "")
# <header=제목이있다 , sep=어떻게 구분했는지>
emp_text
class(emp_text) # [1] "data.frame"

emp_csv <- read.csv("emp.csv")   # 콤마 구분자(생략가능)
emp_csv
class(emp_csv) # [1] "data.frame"



# [ 실습 ]
sid <- 1:3  # 이산형변수(정수단위) <실수형이올수없음>
score <- c(90,85,83)  # 연속형(소수점까지가능)
gender <- c('M','F','M')  # 문자형 <data.frame 으로변환되면 범주형으로 변함>

student <- data.frame(Sid=sid, Score=score, Gender=gender)
#<문자형 그대로 보내고싶을때 stringsAsFactors = F >
#student <- data.frame(Sid=sid, Score=score, Gender=gender,stringsAsFactors = F)
student

#자료 구조 보기
str(student) # 문자형 -> DF(요인형)
# 'data.frame':	3 obs. of  3 variables:
#   $ Sid   : int  1 2 3  <이산형>
# $ Score : num  90 85 83 <연속형>
# $ Gender: Factor w/ 2 levels "F","M": 2 1 2 <범주형>

# 특정 칼럼 -> vector
score <- student$Score
score
mean(score) # [1] 86
sum(score) # [1] 258
var(score) # [1] 13
# 표준편차(표본에대한)
sqrt(var(score)) # [1] 3.605551
sd(score) # [1] 3.605551

## 산포도 : 분산, 표준편차

# 모집단에 대한 분산, 표준편차 
# 분산 = sum(x-산술평균)^2 / n
# 표준편차 = sqrt(분산)

# 표본에 대한 분산, 표준편차   <- R 함수
# 분산 = sum(x-산술평균)^2 / n-1
# 표준편차 = sqrt(분산)

avg <- mean(score) # scala
diff <- (score - avg)^2 # (vector-scala)
VAR <- sum(diff) / (length(score)-1)
VAR # [1] 13

SD <- sqrt(VAR)
SD # [1] 3.605551




# 5. list 자료구조
# - key 와 value 한쌍으로 자료가 저장된다.
# - key는 중복 불가, value 중복 가능
# - key를 통해서 값(value)을 참조한다.
# - 다양한 자료형, 자료구조를 갖는 자료구조이다.
# - [key1=value1, key2=value2]



# 1) key 생략 : value만 입력(기본키 자동생성)
lst <- list('lee','이순신',35,'hong','홍길동',30)
lst
# 첫번째 원소 : key + value
# [[1]]         -> 기본키(default key)
# [1] "lee"     -> 값1(value)
# 두번째 원소 : key + value
# [[2]]         -> 기본키(default key)
# [1] "이순신"  -> 값2(value)

lst[1] # 첫번째 원소 index  [[1]] [1] "lee"  <key+value 한쌍> 
lst[6] # 마지막 원소 index  [[1]] [1] 30     로나온다.
# key -> value 참조
lst[[5]] # [1] "홍길동"


# 2) key=value


lst2 <- list(first=1:5, second=6:10)
lst2

# $first              -> key
# [1] 1 2 3 4 5       -> value

# $second             -> key
# [1]  6  7  8  9 10  -> value

# key -> value 참조 
lst2$first # [1] 1 2 3 4 5
lst2$second # [1]  6  7  8  9 10 
lst2$first[3] # [1] 3    <vector 로 접근>
lst2$second[2:4] # [1] 7 8 9

# data.frame($)  vs  list($)
# data.frame $ 칼럼명
# list $ 키명


# 3) 다양한 자료형  <하나의 객체에 다양한 자료형 가질수있다.>


lst3 <- list(name=c("홍길동","유관순"),
             age=c(35,25),
             gender=c('M','F'))
lst3
mean(lst3$age) # [1] 30


# 4) 다양한 자료구조(vector,matrix,array...) <하나의 객체에 다양한 자료구조 가질수있다.>
lst4 <- list(one=c('one', 'two', 'three'),
             two=matrix(1:9, nrow=3),
             three=array(1:12,c(2,3,2)))
lst4
# $one : 1차원
# $two : 2차원
# $three : 3차원


# 5) list 형변환 -> matrix
# 중첩리스트 
multi_list <- list(r1=list(1,2,3),
                   r2=list(10,20,30),
                   r3=list(100,200,300))
multi_list
# $r1
# $r1[[1]]
# [1] 1
# 
# $r1[[2]]
# [1] 2
# 
# $r1[[3]]
# [1] 3
# 
# 
# $r2
# $r2[[1]]
# [1] 10
# 
# $r2[[2]]
# [1] 20
# 
# $r2[[3]]
# [1] 30
# 
# 
# $r3
# $r3[[1]]
# [1] 100
# 
# $r3[[2]]
# [1] 200
# 
# $r3[[3]]
# [1] 300

# 복잡한 중첩리스트를 하나의 행으로 만들어서 간단한 리스트로 만든다.
mat <- do.call(rbind,multi_list)
mat
#    [,1] [,2] [,3]
# r1 1    2    3   
# r2 10   20   30  
# r3 100  200  300 


# 6) list 처리 함수
x <- list(1:10)  # key 생략 -> [[n]]
x # 하나의 key에 10개의 vector 
v <- unlist(x) # key 제거
v # [1]  1  2  3  4  5  6  7  8  9 10

a <- list(1:5)
b <- list(6:10)
a;b

# list객체에 함수 적용
lapply(c(a,b),max)  # list 반환
sapply(c(a,b),max)  # vector 반환



# 6. 서브셋(subset)
# - 특정 행 또는 열 선택 -> 새로운 dataset 생성



help("subset")
# subset(x, subset, select, drop = FALSE, ...)
x <- 1:5
y <- 6:10
letters
z <- letters[1:5]

df <- data.frame(x,y,z)
df


# 1) 조건식으로 subset 생성 : 행 기준
df2 <- subset(df, x>=2)
df2
str(df2)

# 2) select로 subset 생성 : 칼럼 기준
df3 <- subset(df, select=c(x,z))
df3

# 3) 조건식 & select 생성 : 행, 칼럼 모두 기준
df4 <- subset(df, x>=2 & x<=4, select=c(x,z))
df4

class(df2) # [1] "data.frame"
class(df3) # [1] "data.frame"
class(df4) # [1] "data.frame"

# 4) 특정 칼럼의 특정 값으로 subset 생성
df5 <- subset(df, z %in% c('a','c','e'))  # %in% 연산자
df5

#[실습] iris dataset 이용 subset 생성
iris
str(iris)   #str 데이터셋 구조보기
# 'data.frame':	150 obs. of  5 variables:
#   $ Sepal.Length: num  5.1 4.9 4.7 4.6 5 5.4 4.6 5 4.4 4.9 ...
# $ Sepal.Width : num  3.5 3 3.2 3.1 3.6 3.9 3.4 3.4 2.9 3.1 ...
# $ Petal.Length: num  1.4 1.4 1.3 1.5 1.4 1.7 1.4 1.5 1.4 1.5 ...
# $ Petal.Width : num  0.2 0.2 0.2 0.2 0.2 0.4 0.3 0.2 0.2 0.1 ...
# $ Species     : Factor w/ 3 levels "setosa","versicolor",..: 1 1 1 1 1 1 1 1 1 1 ...

iris_df = subset(iris, Sepal.Length >= mean(Sepal.Length),
                 select = c(Sepal.Length, Petal.Length, Species))
iris_df
str(iris_df)
# data.frame':	70 obs. of  3 variables



#7. 문자열 처리와 정규표현식
install.packages("stringr")
library(stringr)

string = "hong35lee45kang55유관순25이사도시45"
string
# [1] "hong35lee45kang55유관순25"
# 메타문자 : 패턴지정 특수 기호 

# [1] str_extract_all

# 1) 반복관련 메타문자 : [x] : x 1개, {n} : n개 연속 
str_extract_all(string, "[a-z]{3}") # 영문소문자 3개 연속
# [[1]]                     -> key
# [1] "hon" "lee" "kan"     -> value
str_extract_all(string, "[a-z]{3,}") # 영문소문자 3개 이상연속
# [[1]]                       -> key
# [1] "hong" "lee"  "kang"    -> value

name <- str_extract_all(string, "[가-힣]{3,}") #한글 3글자 이상
# list -> vector
name
# [[1]]
# [1] "유관순"   "이사도시"]
unlist(name)
# [1] "유관순"   "이사도시"

name <- str_extract_all(string, "[가-힣]{3,5}") # 한글 3~5글자 
name

ages <- str_extract_all(string, "[0-9]{2}") 
# = ages <- str_extract_all(string, "[0-9]{1,}") 
# vector 로변경
ages_vec <- unlist(ages)
# 숫자형 변환
num_ages = as.numeric(ages_vec)
cat('나이 평균=',mean(num_ages)) # 나이 평균= 41 <cat 은 print처럼 출력하는 함수>

# 2) 단어와 숫자 관련 메타문자
# 단어 : \\w
# 숫자 : \\d

jumin <- "123456-1234567"
str_extract_all(jumin, "[0-9]{6}-[1-4]\\d{6}")
# "123456-1234567"  패턴과 일치된 경우

jumin <- "123456-5234567"
str_extract_all(jumin, "[0-9]{6}-[1-4]\\d{6}")
# character(0)      패턴과 일치되지 않은 경우

email <- "kp1234@naver.com"
str_extract_all(email, "[a-z]{3,}@[a-z]{3,}.[a-z]{2,}") # 이렇게 하면 영문자가 2글자여서 오류
str_extract_all(email, "[a-z]\\w{3,}@[a-z]{3,}.[a-z]{2,}") # "kp1234@naver.com"
str_extract_all(email, "\\w{3,}@[a-z]{3,}.[a-z]{2,}")      # "kp1234@naver.com"
str_extract_all(email, "\\d{3,}@[a-z]{3,}.[a-z]{2,}")      # "1234@naver.com"

email2 <- "kp1$234@naver.com"  # 중간에 특수문자가있을경우
str_extract_all(email2, "[a-z]\\w{3,}@[a-z]{3,}.[a-z]{2,}")  #특수문자때문에 오류

# 3) 접두어(^) / 접미어($) 메타문자

email3 <- "1kp1234@naver.com"
str_extract_all(email3, "[a-z]\\w{3,}@[a-z]{3,}.[a-z]{2,}") # 첫글자가 영문자인것부터인식
# [1] "kp1234@naver.com"
str_extract_all(email3, "^[a-z]\\w{3,}@[a-z]{3,}.[a-z]{2,}")
# 시작이 영문자가 아니여서 오류
str_extract_all(email3, "\\w{3,}@[a-z]{3,}.[a-z]{2,}")
# [1] "1kp1234@naver.com"
str_extract_all(email3, "[a-z]\\w{3,}@[a-z]{3,}.com$") # 끝이 com 으로 끝나는지확인

# 4) 특정 문자 제외 메타문자 
string
# [1] "hong35lee45kang55유관순25이사도시45"

# str_extract_all() 과 str_extract() 의 차이 : all은 패턴과일치하는전부 , 없으면 패턴과일칭하는 최초하나만

str_extract_all(string, "[^0-9]{3,}") # 숫자 제외, 나머지 반환
# [1] "hong"     "lee"      "kang"     "유관순"   "이사도시"

result <- str_extract_all(string, "[^0-9]{3,}")
result # [[1]] : 기본키
# 불용어 제거 : 숫자, 영문자, 특수문자
name <- str_extract_all(result[[1]], "[가-힣]{3,}")
unlist(name) # [1] "유관순"   "이사도시"

# [2] str_length_all : 문자열의 길이 반환
length(string)     # 1        길이
str_length(string) # 28       문자의 길이

# [3] str_locate / str_locate_all  : 위치찾기
str_locate(string, 'g')
#      start end
# [1,]     4   4
str_locate_all(string, 'g')
# [[1]]
#      start end
# [1,]     4   4
# [2,]    15  15

# [4] str_replace / str_replace_all  : 변경
str_replace_all(string, "[0-9]{2}","") # 두자리숫자를 제거하겠다
# "hongleekang유관순이사도시"
str_replace_all(string, "[0-9]{3}","") # 세자리숫자를제거하는데 3자리없어서 제거안됌
# "hong35lee45kang55유관순25이사도시45" 

# [5] str_sub  : 부분 문자열 
str_sub(string, start=3, end=5)  # "ng3"

# [6] str_split  : 문자열 분리(토큰)
string2 = "홍길동, 이순신, 강감찬, 유관순"
result <- str_split(string2, ",") # , 를기준으로 분리하겠다
result 
name <- unlist(result)
name # [1] "홍길동"  " 이순신" " 강감찬" " 유관순"

# [7] 문자열 결합(join) : 기본 함수 
paste(name, collapse = ",") # [1] "홍길동, 이순신, 강감찬, 유관순" 
paste(name, collapse = "")  # [1] "홍길동 이순신 강감찬 유관순"









































