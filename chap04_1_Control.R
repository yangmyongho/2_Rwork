# chap04_1_Control 

# <실습> 산술연산자 
num1 <- 100 # 피연산자1
num2 <- 20  # 피연산자2
result <- num1 + num2 # 덧셈
result # 120
result <- num1 - num2 # 뺄셈
result # 80
result <- num1 * num2 # 곱셈
result # 2000
result <- num1 / num2 # 나눗셈
result # 5

result <- num1 %% num2 # 나머지 계산
result # 0

result <- num1^2 # 제곱 계산(num1 ** 2)
result # 10000
result <- num1^num2 # 100의 20승
result # 1e+40 -> 1 * 10의 40승과 동일한 결과


# <실습> 관계연산자 
# (1) 동등비교 
boolean <- num1 == num2 # 두 변수의 값이 같은지 비교
boolean # FALSE
boolean <- num1 != num2 # 두 변수의 값이 다른지 비교
boolean # TRUE

# (2) 크기비교 
boolean <- num1 > num2 # num1값이 큰지 비교
boolean # TRUE
boolean <- num1 >= num2 # num1값이 크거나 같은지 비교 
boolean # TRUE
boolean <- num1 < num2 # num2 이 큰지 비교
boolean # FALSE
boolean <- num1 <= num2 # num2 이 크거나 같은지 비교
boolean # FALSE

# <실습> 논리연산자(and, or, not, xor)
logical <- num1 >= 50 & num2 <=10 # 두 관계식이 같은지 판단 
logical # FALSE
logical <- num1 >= 50 | num2 <=10 # 두 관계식 중 하나라도 같은지 판단
logical # TRUE

logical <- num1 >= 50 # 관계식 판단
logical # TRUE
logical <- !(num1 >= 50) # 괄호 안의 관계식 판단 결과에 대한 부정
logical # FALSE

x <- TRUE; y <- FALSE
xor(x,y) # [1] TRUE
x <- TRUE; y <- TRUE
xor(x,y) # FALSE

c(T, T) & c(F, T)
c(T, T) & c(T, F)

c(T, F) && c(F, T) # FALSE
c(T, T) && c(T, F) # TRUE


##########################
### 1. 조건문 
##########################

# 1) if(조건식) - 조건식 : 산술,관계,논리연산자 
x <- 10
y <- 5
z <- x * y
z
if(z >= 20){
  cat('z는 20보다 크다.') # 실행문 
}

z <- 10

# 형식1) if(조건식){참}else{거짓}
if(z >= 20){
  cat('z는 20보다 크다.')
}else{
  cat('z는 20보다 작다.')
}

# 형식2) if(조건식1){참1}else if(조건식2){참2}else{거짓}
score <- scan() # 0~100
score # 85

# score -> grade(A, B, C, D, F)
grade <- ""
if(score >= 90){
   grade <- "A"
}else if(score >= 80){
   grade <- "B"
}else if(score >= 70){
  grade <- "C"
}else if(score >= 60){
  grade <- "D"
}else{
  grade <- "F"
}

cat('점수는', score, '이고, 등급은 ', grade)

# 문1) 키보드로 임의숫자를 입력받아서 짝수/홀수 판별하기
num <- scan() # 임의숫자를 입력

10%%2 # 0
7%%2 #  1

if(num %% 2 == 0){
   cat('짝수 이다.')
}else{
   cat("홀수 이다.")
}

# 문2) 주민번호를 이용하여 성별 판별하기 
library(stringr)
jumin <- "123456-4234567"

# 성별 추출하기 : str_sub(8,8)
gender <- str_sub(jumin, 8, 8)
gender # "4"

# 1 or 3 : 남자 
# 2 or 4 : 여자 
# other : 주민번호 양식 틀림 
if(gender == "1" | gender == "3"){
  cat('성별은 남자')
}else if(gender == "2" | gender == "4"){
  cat('성별은 여자')
}else{
  cat("주민번호 양식 틀림")
}
  

# 2) ifelse : if + else
# 형식)  ifelse(조건식, 참, 거짓) = 3항연산자 
# vector 입력 -> 처리 -> vector 출력 

score <- c(78, 85, 95, 45, 65)
grade <- ifelse(score >= 60, "합격", "실패") # 합격/실패 
grade # "합격" "합격" "합격" "실패" "합격"


excel <- read.csv(file.choose())#excel.csv
str(excel)

q5 <- excel$q5
length(q5) # 402
table(q5)
#1   2   3   4   5 (5점 척도)
#8  81 107 160  46 = 402

# 5점 척도 -> 범주형 변수 
q5_re <- ifelse(q5 >= 3, "큰값", "작은값")
table(q5_re)
#작은값   큰값 
#  89    313

# NA -> 평균 대체 
x <- c(75,85,42,NA,85)
x_na <- ifelse(is.na(x), mean(x, na.rm = T), x)
x_na # 75.00 85.00 42.00 71.75 85.00

# NA -> 0 대체
x_na2 <- ifelse(is.na(x), 0, x)
x_na2 # 75 85 42  0 85


# 3) switch()
# 형식)  switch(비교 구문, 실행구문1, 실행구문2, 실행구문3) 
switch("pwd", age=105, name="홍길동", id="hong", pwd="1234")   
# name : "홍길동"
# pwd : "1234"

# 4) which 문 
# 조건식에 만족하는 위치 반환 

name <- c("kim","lee","choi","park") 
which(name=="choi") # 3

library(MASS) 
data("Boston")

str(Boston)
# 'data.frame':	506 obs. of  14 variables:
name <-  names(Boston)
name
length(name) # 14

# x(독립변수), y(종속변수) 선택 
y_col <- which(name == "medv") # 14
y_col

Y <- Boston[y_col] # y(종속변수)
head(Y)

X <- Boston[-y_col] # x(독립변수)
head(X)

# 문) iris 데이터셋을 대상으로 x변수(1~4칼럼), y변수(5칼럼)
name <- names(iris)

y_col <- which(name == "Species") # 14
y_col

Y <- iris[y_col] # y(종속변수)
head(Y)

X <- iris[-y_col] # x(독립변수)
head(X)


##########################
### 2. 반복문 
##########################

# 1) for(변수 in 열거형객체){실행문}

num <- 1:10 # 열거형객체 
num # 1  2  3  4  5  6  7  8  9 10

for(i in num){ # 10회 반복 
   cat('i=', i, '\n') # 실행문 
   print(i*2) # 줄바꿈 
}

# 홀수/짝수 출력 
for(i in num){ # 10회 반복
   if(i %% 2 != 0){
     cat('i=', i, '\n')
   }
}

for(i in num){ # 10회 반복
  if(i %% 2 == 0){ # 짝수 
    cat('i=', i, '\n')
  }else{ # 홀수
    next # skip
  }
}

# 문) 키보드로 5개 정수를 입력받아서 짝수/홀수 구분하기 
num <- scan() # 5개 정수 입력 
num

for(i in num){
  if(i %% 2 == 0){
    cat("짝수\n")
  }else{
    cat("홀수\n")
  }
}

num <- 1:100
num

# 문2) 1~100까지 홀수의 합과 짝수 합 출력하기 
even <- 0 # 짝수 합 
odd <- 0 # 홀수 합 
cnt <- 0 # 카운터 변수 

for(i in num){
  cnt = cnt + 1 # 카운터 변수 
  if(i %% 2 == 0){
     even = even + i # 짝수 누적변수 
  }else{
     odd = odd + i # 홀수 누적변수 
  }
}

cat('카운터 변수 =', cnt)
cat('짝수의 합 =', even, '홀수의 합=', odd)

kospi <- read.csv(file.choose()) # sam_kospi.csv
str(kospi)

# 칼럼 = 컬럼-칼럼 
kospi$diff <- kospi$High - kospi$Low
str(kospi)

row <- nrow(kospi)
# diff 평균 이상 '평균 이상', 아니면 '평균 미만'

diff_result = "" # 변수 초기화 

for(i in 1:row){ # 247회 반복 
  if (kospi$diff[i] >= mean(kospi$diff)){
    diff_result[i] = '평균 이상'
  }else{
    diff_result[i] = '평균 미만'
  }
}

# 칼럼 추가 
kospi$diff_result = diff_result
table(kospi$diff_result)
#평균 미만 평균 이상 
#    143       104


# 이중 for문 : 구구단 
for(i in 2:9){ # i : 단수
    cat('***', i, '단***\n')
  
  for(j in 1:9){  # j : 곱수 
      cat(i, '*', j, '=', (i*j), '\n')  
  } # inner for
  
  cat("\n")
} # outer for


# 2) while(조건식){실행문}
i = 0 # 초기화 
while(i < 5){
  cat('i = ', i, '\n')
  i = i + 1 # 카운터 
}

x <- c(2, 5, 8, 6, 9)
x # 각 변량 제곱
n <- length(x) # 5

i <- 0 # index 
y <- 0
while(i < n){
  i <- i + 1
  y[i] <- x[i]^2
}

x # 2 5 8 6 9
y # 4 25 64 36 81








