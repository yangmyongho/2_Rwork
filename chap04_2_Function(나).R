# chap04_2_Function

# 1. 사용자 정의함수

# 형식) 
# 함수명 <- function([인수]){
#   실행문
#   실행문
#   [return 값]
# }

# 1) 매개변수 없는 함수
f1 <- function(){
  cat('f1 함수')
}
f1() # f1 함수    <함수 호출>

# 2) 매개변수 있는 함수
f2 <- function(x){   # <가인수=매개변수>
  x2 <- x^2
  cat('x2=',x2)
}
f2(9) # x2= 81   <실인수>

# 3) 리턴 있는 함수
f3 <- function(x,y){
  add <- x+y
  return(add)            # add 반환
}
f3(2,5)            # 7
# 함수 호출 -> 반환값 
add_re <- f3(2,5)  # 7
add_re             # 7

# avg <- tot / n
num <- 1:10
tot_func <- function(x){
  tot <- sum(x)
  return(tot)
}
tot_re <- tot_func(num)
avg <- tot_re / length(num)
avg # 5.5

# 문제1) calc 함수를 정의하기
# 100 + 20 = 120
# 100 - 20 = 80
# 100 * 20 = 2000
# 100 / 20 = 5

# 내가한풀이
calc <- function(x,y){
  cat(x,'+',y,'=',x+y,'\n')
  cat(x,'-',y,'=',x-y,'\n')
  cat(x,'*',y,'=',x*y,'\n')
  cat(x,'/',y,'=',x/y,'\n')
}
calc(100,20)
df <- calc(100,20)
df # NULL

# 선생님이 한 풀이
calc <- function(x,y){
  add <- x+y
  sub <- x-y
  mul <- x*y
  div <- x/y
  cat(x,'+',y,'=',add,'\n')
  cat(x,'-',y,'=',sub,'\n')
  cat(x,'*',y,'=',mul,'\n')
  cat(x,'/',y,'=',div,'\n')
  calc_df <- data.frame(add,sub,mul,div)   # return(add,sub,mul,div)
  return(calc_df)
}
calc(100,20)
df <- calc(100,20)
df
# add sub  mul div
# 1 120  80 2000   5

#오류 
calc <- function(x,y){
  add <- x+y
  sub <- x-y
  mul <- x*y
  div <- x/y
  cat(x,'+',y,'=',add,'\n')
  cat(x,'-',y,'=',sub,'\n')
  cat(x,'*',y,'=',mul,'\n')
  cat(x,'/',y,'=',div,'\n')
  return(add,sub,mul,div)   # 이거 오류<다중인자 반환 오류>
}
calc(x,y)


# 구구단의 단을 인수로 받아서 구구단 출력하기
gugu <- function(dan){
  cat('***',dan,'단 ***\n')
  for(i in 1:9){
    cat(dan,'*',i,'=',dan*i,'\n')
  }
}
gugu(3)
gugu(9)
gugu(10)
gugu(999999)


# switch를 응용
state <- function(fname, data){
  switch(fname,
         SUM = sum(data),
         AVG = mean(data),
         VAR = var(data),
         SD = sd(data))
}
data <- 1:10
state("SUM",data) # 55
state("AVG", data) # 5.5
state("VAR",data) # 9.166667
state("SD",data) # 3.02765


# 결측치(NA) 처리 함수
na <- function(x){
  # 1. NA 제거<na.omit>
  x1 <- na.omit(x)
  cat('x1=',x1,'\n')
  cat('x1평균=', mean(x1),'\n')
  
  # 2. NA -> 평균
  x2 <- ifelse(is.na(x), mean(x, na.rm = T), x)
  cat('x2=',x2,'\n')
  cat('x2평균=',mean(x2),'\n')
  
  # 3. NA -> 0
  x3 <- ifelse(is.na(x), 0, x)
  cat('x3=',x3,'\n')
  cat('x3평균=',mean(x3),'\n')
}
x <- c(10,5,NA,4.2,6.3,NA,7.5,8,10)
x # 10.0  5.0   NA  4.2  6.3   NA  7.5  8.0 10.0
length(x) ()
mean(x) # NA
mean(x, na.rm = T) # 7.285714

na(x)
# x1= 10 5 4.2 6.3 7.5 8 10 
# x1평균= 7.285714 
# x2= 10 5 7.285714 4.2 6.3 7.285714 7.5 8 10 
# x2평균= 7.285714 
# x3= 10 5 0 4.2 6.3 0 7.5 8 10 
# x3평균= 5.666667   


###################################
### 몬테카를로 시뮬레이션 
###################################
# 현실적으로 불가능한 문제의 해답을 얻기 위해서 난수의 확률분포를 이용하여 
# 모의시험으로 근사적 해를 구하는 기법

# 동전 앞/뒤 난수 확률분포 함수<동전함수>
coin <- function(n){
  r <- runif(n, min=0, max=1)
  #print(r) # n번 시행 
  
  result <- numeric()
  for (i in 1:n){
    if (r[i] <= 0.5)
      result[i] <- 0 # 앞면 
    else 
      result[i] <- 1 # 뒷면
  }
  return(result)
}
coin(10)

# 몬테카를로 시뮬레이션 
montaCoin <- function(n){
  cnt <- 0
  for(i in 1:n){
    cnt <- cnt + coin(1) # <동전 함수> 호출 
  }
  result <- cnt / n
  return(result)
}
montaCoin(5) # 0.6 / 0.4
montaCoin(50) # 0.58 / 0.54
montaCoin(99999) # 0.500715 / 0.499495
# 중심 극한 정리



# 2. R의 주요 내장함수 

# 1) 기술통계함수 

vec <- 1:10          
min(vec)                   # 최소값
max(vec)                   # 최대값
range(vec)                  # 범위
mean(vec)                   # 평균
median(vec)                # 중위수 <5번째+6번째 /2>
sum(vec)                   # 합계
prod(vec)                  # 데이터의 곱 < ! (팩토리얼)이랑은 조금 다름 > 
1*2*3*4*5*6*7*8*9*10
summary(vec)               # 요약통계량 <1stQu. : 25퍼샌트값 3-> 75퍼센트값>

rnorm(10) # mean=0 , sd=1
mean(rnorm(10))
sd(rnorm(10))      # 표준편차 구하기
factorial(5) # 팩토리얼=120
factorial(vec) # 1  2  6  24  120  720  5040  40320  362880  3628800
sqrt(49) # 루트

install.packages('RSADBE')
library(RSADBE)
library(help="RSADBE")
data(Bug_Metrics_Software)
str(Bug_Metrics_Software)

Bug_Metrics_Software

# 소프트웨어 발표전 버그 수
Bug_Metrics_Software[,,1]  # Before
# 행 단위 합계 : 소프트웨어 별 버그 수 합계
rowSums(Bug_Metrics_Software[,,1])
# 행 단위 평균 : 소프트웨어 별 버그 수 평균
rowMeans(Bug_Metrics_Software[,,1])
# 열 단위 합계 : 버그 별 버그 수 합계 
colSums(Bug_Metrics_Software[,,1])
# 열 단위 평균 : 버그 별 버그 수 평균
colMeans(Bug_Metrics_Software[,,1])
# 소프트웨어 발표후 버그 수
Bug_Metrics_Software[,,2]  # After

# before - after 의 결과값으로 3번째 면을만들어보려고함
# [,,3] = before - after
bug <- Bug_Metrics_Software # 이름이길어서
bug.new <- array(bug, dim = c(5,5,3)) # 면추가
bug.new
dim(bug.new) # 5 5 3
bug.new[,,3] = bug[,,1] - bug[,,2]
bug.new

# 2) 반올림 관련 함수 
x <- c(1.5, 2.5, -1.3, 2.5)
mean(x) # 1.3
round(mean(x)) # 1.3 (반올림) -> 1
ceiling(mean(x)) # 1.3보다 큰 정수 -> 2 
floor(mean(x)) # 1.3보다 작은 정수 -> 1


# 3) 난수 생성과 확률분포

# (1) 정규분포를 따르는 난수 - 연속확률분포(실수형) 
# 형식) rnorm(n, mean=0, sd=1)
n <- 1000
r <- rnorm(n,mean = 0,sd=1) # < 표준정규분포형식> 
r
mean(r) # -0.0007945121  <0과 근사한값>
sd(r) # 0.9804295        <1과 근사한값>
hist(r) # 히스토그램 시각화 <좌우 대칭성>

# (2) 균등분포를 따르는 난수 - 연속확률분포(실수형)
# 형식) runif(n, min=, max=)
runif(n) # 최대최소 생략하면 0~1로 자동으로됌
r2 <- runif(n, min = 10, max = 100)
r2
hist(r2) # <값들이 거의 균등>

# (3) 이항분포를 따르는 난수 - 이산확률분포(정수형)
# 형식) rbinom(n, size = , prob = )
n <- 10 
r3 <- rbinom(n, size =1, prob =0.5 )
r3 # 0 1 1 0 0 0 0 1 1 1
hist(r3)

set.seed(123) # <항상 같은결과로만들어줌> seed값이 같으면 항상 동일한 난수
n <- 10
r3 <- rbinom(n, size =1, prob =0.5 )  # 확률 1/2
r3 # 0 1 0 1 1 0 1 1 1 0
hist(r3)

r3 <- rbinom(n, size =1, prob =0.25)  # 확률을 1/4 
r3 # 1 0 0 0 0 1 0 0 0 1

# (4) sample
# x : 모집단 , size : 샘플링 갯수 , replace : 복원추출유무(생략하면 비복원 = f) , prob : 확률
x <- c(10:20)
sample(x,5)
sample(10:20, 5) # 18 12 17 11 16
sample(c(10:20,50:100),10)  # 10~20과 50~100 사이가 모집단

# 홀드아웃방식
# train(70%)/test(30%) 데이터셋
dim(iris) # 150(행)   5(열)
idx <- sample(nrow(iris), nrow(iris)*0.7) # <랜덤>
idx # 행번호
range(idx) # 1 149 / 2 150 
length(idx) # 105
train <- iris[idx,]  # 학습용
test <- iris[-idx,]  # 검증용
dim(train) # 105 5
dim(test)  # 45  5


# 4) 행렬연산 내장함수 
x <- matrix(1:9, nrow = 3, byrow = T) # 행3개 행우선
x
dim(x) # 3 3
y <- matrix(1:3, nrow = 3)
y
dim(y) # 3 1
x;y

# 두 행렬의 곱 x %*% y  
# 전제조건 1. x,y 모두 행렬 
#          2. x(열) = y(행) 일치 : 수일치
#          3. 결과  x(행)y(열)
z <- x %*% y
z
dim(z) # 3 1







