# Chap15_1_Regression Analysis

######################################################
# 회귀분석(Regression Analysis)
######################################################
# - 특정 변수(독립변수:설명변수)가 다른 변수(종속변수:반응변수)에 어떠한 영향을 미치는가 분석


###################################
## 1. 단순회귀분석 
###################################
# - 독립변수와 종속변수가 1개인 경우

# 단순선형회귀 모델 생성  
# 형식) lm(formula= y ~ x 변수, data) 

setwd("C:/ITWILL/2_Rwork/Part-IV")
product <- read.csv("product.csv", header=TRUE)
head(product) # 친밀도 적절성 만족도(등간척도 - 5점 척도)

str(product) # 'data.frame':  264 obs. of  3 variables:
y = product$제품_만족도 # 종속변수
x = product$제품_적절성 # 독립변수
df <- data.frame(x, y)
df

# 회귀모델 생성 
result.lm <- lm(formula=y ~ x, data=df)
result.lm # 회귀계수 
# Coefficients:
#       (Intercept)                x
# y절편 : 0.7789       기울기 : 0.7393 
# 회귀방정식 (y) = a.x + b (a:기울기, b:절편)
# y = 0.7393x + 0.7789

# 한번 확인해보기 <회귀방정식 : y 예측치>
head(df)
X <- 4  # 입력변수
Y <- 3  # 정답
a <- 0.7393
b <- 0.7789
y <- a*X + b
cat('y 의 예측치 =',y)  # y 의 예측치 = 3.7361
err <- y -Y # 오차(잔차)
cat('model error = ', err)  # model error =  0.7361

names(result.lm) # 12개의 컬럼
# [1] "coefficients" : 회귀계수
# [2] "residuals" : 오차(잔차)
# [5] "fitted.values" : 적합치(예측치) # x값이 같으면 예측치값도 다 똑같다.

# 컬럼검색 가능
result.lm$coefficients 
result.lm$residuals # [1] -0.73596305 위에 오류랑 거의 근사함
result.lm$fitted.values # [1] 3.735963 위에 예측치랑 거의 근사함

# 회귀모델 예측 
# predict(model, x)
predict(result.lm, data.frame(x=5) ) # 4.475239 
predict(result.lm, data.frame(x=6) ) # 5.214515 
# 있는지없는지확인해보기 
library(dplyr)
filter(df, df$x==5) # 10개있음
filter(df, df$x==6) # 없음

# (2) 선형회귀 분석 결과 보기
summary(result.lm) # x -> y
# F-statistic:   374 on 1 and 262 DF,  p-value: < 2.2e-16
# < 회귀모델 해석 순서 > 
# 1. F-statistic : p-value < 0.05 통계적으로 유의 하다. 
# 2. Adjusted R-squared(모델의설명력,예측력) : 0.5865 <1에 가까울수록 예측력이 좋다>
# 3. x의 유의성 검정 : t value(-1.96~+1.96)보다 크면 귀무가설 기각,
#                      Pr(p-value) < 0.05 귀무가설기각 대립가설채택

cor(df) # 0.7668527
r <- 0.7668527
r_squared <- r**2
r_squared # 0.5880631 은 모델의 설명력과 근사하다

# (3) 단순선형회귀 시각화
# x,y 산점도 그리기 
plot(formula=y ~ x, data=df, xlim=c(0,5), ylim=c(0,5))
# 회귀분석
result.lm <- lm(formula=y ~ x, data=df)
# 회귀선 
abline(result.lm, col='red')

result.lm$coefficients
# (Intercept)         x 
# 0.7788583   0.7392762 

y <- product$'제품_만족도'
x <- product$'제품_적절성'

# x 기울기 = Covxy / Sxx
Covxy = mean((x - mean(x))* (y - mean(y)))
Sxx = mean((x-mean(x))**2)
a <- Covxy / Sxx
a # 0.7392762

# y 절편
b <- mean(y) - (a * mean(x))
b # 0.7788583


###################################
## 2. 다중회귀분석
###################################
# - 여러 개의 독립변수 -> 종속변수에 미치는 영향 분석
# 가설 : 음료수 제품의 적절성(x1)과 친밀도(x2)는 제품 만족도(y)에 정의 영향을 미친다.

product <- read.csv("product.csv", header=TRUE)
head(product) # 친밀도 적절성 만족도(등간척도 - 5점 척도)


#(1) 적절성 + 친밀도 -> 만족도  
y = product$'제품_만족도' # 종속변수
x1 = product$'제품_친밀도' # 독립변수1
x2 = product$'제품_적절성' # 독립변수2

df <- data.frame(x1, x2, y)
df

result.lm <- lm(formula=y ~ x1 + x2, data=df)
#result.lm <- lm(formula=y ~ ., data=df) # < . 을 사용하면 남아있는변수 모두 를 x값으로 여김 >

# 계수 확인 
result.lm
# (Intercept)       x1           x2  
# 0.66731      0.09593      0.68522     < y절편     x1기울기     x2기울기>
b <- 0.66731
a1 <- 0.09593
a2 <- 0.68522
head(df)
X1 <- 3
X2 <- 4
Y <- 3
# 다중 회귀방정식
y = (a1*X1 + a2*X2) + b
y # 3.69598
err <- Y -y
abs(err) # 0.69598
# 예측
predict(result.lm, data.frame(x1=3,x2=4) ) # 3.69598

# 분석결과 확인
summary(result.lm)
# 1. F-statistic : p-value: < 2.2e-16    <0.05이하이면 영향이있다.>
# 2. Adjusted R-squared :  0.5945        <1과 가까울수록 영향이 크다.>
# 3. x의 유의성 검정  <*개수가 많을수록 영향의 강도가 강하다.>
# x1  2.478   0.0138 *    -> 친밀도
# x2  15.684  < 2e-16 *** -> 적절성
# 친밀도와 적절성 모두 만족도에 유의하다. 
# 친밀도보다는 적절성이 더 만족도에 영향을 끼친다.

install.packages('car')  # 다중공선성 문제 확인
library(car)
Prestige # 102개 직업군 평판 dataset 
str(Prestige)
# $ education : 교육수준(x1) 
# $ income    : 수입(y)
# $ women     : 여성비율(x2)
# $ prestige  : 평판(x3)
# $ census    : 직업수
# $ type     : Factor w/ 3 levels "bc","prof","wc": 2 2 2 2 2 2 2 2 2 2 
row.names(Prestige) # 직업군이름 102개 

df <- Prestige[,c(1:4)]
str(df)

model <- lm(formula = income ~ ., data=df)
model
# (Intercept)    education        women     prestige  
# -253.8        177.2        -50.9        141.4 

# 교육수준과 수입은 정비례하다. 
# 여성의비율이 높아질수록 수입은 떨어진다.

summary(model)
# education       0.944    0.347       (상관 없음)  <0.05보다 크므로>
# women          -5.948 4.19e-08 ***   (음의 상관)
# prestige       4.729 7.58e-06 ***    (양의 상관)
# Adjusted R-squared:  0.6323 <설명력>
# t value도 -1.96과1.96사이이므로 귀무가설 채택 
# 따라서 교육수준과 수입은 큰 연관성이 없다.

res <- model$residuals # 잔차(오차) = 정답 - 예측치
res
summary(res)
mean(res) # 1.704083e-14
length(res) # 102

# MSE사용하려면 표준화 필수!!
# (1) MSE : 표준화 전 (x)
mse <- mean(res**2) # 평균제곱오차
cat('MSE = ',mse) # MSE =  6369159

# (2) 잔차 표준화 <scale>
res_scale <- scale(res)
summary(res_scale)
# mean =0 , sd = 1

# (3) MSE 표준화 후 (o)
mse <- mean(res_scale**2) # 평균제곱오차
cat('MSE = ',mse) # MSE =  0.9901961 

# 제곱 : 부호 절대값, 패널티
# 평균 : 전체 오차에 대한 평균


###############################
## 3. x 변수선택
###############################

new_data <- Prestige[,c(1:5)]
dim(new_data) # 102 5 

model2 <- lm(income ~ ., data=new_data)
model2
summary(model2)

library(MASS)
step <- stepAIC(model2, direction = 'both') # AIC가 제일낮은값 찾기
step

model3 <- lm(income ~ women+prestige, data=new_data)
model3 # 똑같은 결과
summary(model3)
# Adjusted R-squared:  0.6327  <model2 는 Adjusted R-squared:  0.6289이였다.> 


###################################
# 4. 다중공선성(Multicolinearity)
###################################
# - 독립변수 간의 강한 상관관계로 인해서 회귀분석의 결과를 신뢰할 수 없는 현상
# - 생년월일과 나이를 독립변수로 갖는 경우
# - 해결방안 : 강한 상관관계를 갖는 독립변수 제거

# (1) 다중공선성 문제 확인
library(car)
fit <- lm(formula=Sepal.Length ~ Sepal.Width+Petal.Length+Petal.Width, data=iris)
vif(fit)
# Sepal.Width Petal.Length  Petal.Width 
# 1.270815    15.097572    14.234335
# Petal.Length 과 Petal.Width 숫자가 비슷해서 다중공선성 의심 

# root(VIF)가 2 이상인 것은 다중공선성 문제 의심
sqrt(vif(fit))>2  

# (2) iris 변수 간의 상관계수 구하기
cor(iris[,-5]) # 변수간의 상관계수 보기(Species 제외) 0.9628654 거의 1에 가깝다.
#x변수 들끼 계수값이 높을 수도 있다. -> 해당 변수 제거(모형 수정) <- Petal.Width

# (3) 학습데이터와 검정데이터 분류
nrow(iris) # 150
x <- sample(1:nrow(iris), 0.7*nrow(iris)) # sample (1:0.7) 전체중 70%만 추출 105개
train <- iris[x, ] # 학습데이터 추출 70%
test <- iris[-x, ] # 검정데이터 추출 30%
dim(train) # 105 5 -> model 학습용
dim(test) # 45 5  -> model 검정용
head(test)

# (4) model 생성 : Petal.Width 변수를 제거한 후 회귀분석 
iris_model <- lm(formula=Sepal.Length ~ Sepal.Width + Petal.Length, data=train)
iris_model
summary(iris_model)
# Adjusted R-squared:  0.8521
# Adjusted R-squared:  0.8435 이처럼 샘플 70% 뽑으므로 항상 결과가 조금씩 다르다

# (5) model 예측치 : test set
y_pred <- predict(iris_model, test)
y_pred # 예측값

y_true <- test$Sepal.Length # 실제 정답값

y_pred[1:10]
y_true[1:10]

range(y_true) # 4.5 ~ 6.9
range(y_pred) # 4.104659 ~ 6.970604

# (6) model 평가 : MSE , cor
# MSE : 반드시 표준화 한후에 가능 

Error <- y_true - y_pred
head(Error)
abs(Error)
mse <- mean(Error**2)
cat('MSE = ',mse) # MSE =  0.1165382 < 0에 가까울수록 평가가 좋다. >

# 상관계수 r : 표준화가안된경우도 가능 
r <- cor(y_true, y_pred)
cat('r=',r) # r= 0.8982964 < 1에 가까울수록 평가잘했다. >

# 시각화 평가
plot(y_true, col='blue', type = 'l', label= 'y true') # type 1이아니라 L이다
points(y_pred, col='red', type = 'l', label='y pred')
# 범례 추가
legend("topleft", legend = c('y true', 'y pred'),
       col=c('blue','red'), pch='-')
# 거의 비슷하게 생겼다.예측이 잘되었다.


##########################################
##  5. 선형회귀분석 잔차검정과 모형진단
##########################################

# 1. 변수 모델링                        : x,y 변수 선정 
# 2. 회귀모델 생성                      : lm()
# 3. 모형의 잔차검정                    : 
#   1) 잔차의 등분산성 검정
#   2) 잔차의 정규성 검정 
#   3) 잔차의 독립성(자기상관) 검정 
# 4. 다중공선성 검사                    : 
# 5. 회귀모델 생성/ 평가 


names(iris)

# 1. 변수 모델링 : y:Sepal.Length <- x:Sepal.Width,Petal.Length,Petal.Width
formula = Sepal.Length ~ Sepal.Width + Petal.Length + Petal.Width


# 2. 회귀모델 생성 
model <- lm(formula = formula,  data=iris)
model
names(model)


# 3. 모형의 잔차검정 <1번과2번주로사용>
plot(model)
#Hit <Return> to see next plot: 잔차 vs 적합값 -> 패턴없이 무작위 분포(포물선 분포 좋지않은 적합) 
#                               등분산선 검정 
#Hit <Return> to see next plot: Normal Q-Q -> 정규분포 : 대각선이면 잔차의 정규성 
#                               정규성 검정 
#Hit <Return> to see next plot: 척도 vs 위치 -> 중심을 기준으로 고루 분포 
#Hit <Return> to see next plot: 잔차 vs 지렛대값 -> 중심을 기준으로 고루 분포 

# (1) 등분산성 검정 
plot(model, which = 1) 
# x축 : 적합치 , y축 : 오차   < 골고루 분포되어있다. >
methods('plot') # plot()에서 제공되는 객체 보기 

# (2) 잔차 정규성 검정
plot(model, which = 2) # 그림으로도 정규분포 확인가능 
attributes(model) # coefficients(계수), residuals(잔차), fitted.values(적합값)
res <- residuals(model) # 잔차 추출 
res <- model$residuals # 똑같은 잔차 추출
shapiro.test(res) # 정규성 검정 - p-value = 0.9349 >= 0.05
# 귀무가설 : 정규성과 차이가 없다.

# 정규성 시각화  
hist(res, freq = F) 
qqnorm(res)

# (3) 잔차의 독립성(자기상관 검정 : Durbin-Watson) 
install.packages('lmtest')
library(lmtest) # 자기상관 진단 패키지 설치 
dwtest(model) # 더빈 왓슨 값
# DW = 2.0604, p-value = 0.6013  < DW가 2~4 사이면 귀무가설 채택열 > 자기상관이없다는 뜻
# p-value > 0.05 똑같이 귀무가설 채택 <잔차들간에 상관이없다는 뜻> = 독립적이다


# 4. 다중공선성 검사 
library(car)
sqrt(vif(model)) > 2 # TRUE  <다중공선성 의심>

# 5. 모델 생성/평가 
formula = Sepal.Length ~ Sepal.Width + Petal.Length 
model <- lm(formula = formula,  data=iris)
summary(model) # 모델 평가

###############################
## 6. 범주형 변수 사용
###############################

# - 범주형 변수 -> 더미변수 생성 
# ex) (gender)  ->  (0,1) 
# - 범주형 변수 기울기 영향 없음(절편에만 영향 미침)
# - 범주형 변수의 범주수가 n개이면 더미변수의 수는 : n-1 
# ex)  혈액형(AB, A, B, O) -> 3개 변수 
#         x1  x2  x3
#      A  1   0   0  
#      B  0   1   0   
#      O  0   0   1  
#     AB  0   0   0   <base,기준>
# Factor : 범주형 -> 더미변수 <factor형은 더미변수가 자동으로 만들어진다.>

# 의료비 예측 : insurance.csv
insurance <- read.csv(file.choose())
str(insurance)
# 'data.frame':	1338 obs. of  7 variables:
# $ age     : 나이 :int  19 18 28 33 32 31 46 37 37 60 ...
# $ sex     : 성별 :Factor w/ 2 levels "female","male": 1 2 2 2 2 1 1 1 2 1 ...
# $ bmi     : 비만도지수 : num  27.9 33.8 33 22.7 28.9 ...
# $ children: 자녀수 : int  0 1 3 0 0 0 1 3 2 0 ...
# $ smoker  : 흡연유무 : Factor w/ 2 levels "no","yes": 2 1 1 1 1 1 1 1 1 1 ...
# $ region  : 지역 : Factor w/ 4 levels "northeast","northwest",..: 4 3 3 2 2 3 3 2 1 2 ...
# $ charges : 의료비(y) : num  16885 1726 4449 21984 3867 ...

# 범주형 변수 : sex(2), smoker(2), region(4)
# 기준(base) : level1(base)=0, level2=1, level3=2, level4=3

# 회귀모델 생성
insurance2 <- insurance[,-c(5:6)] # 흡연유무, 지역 제외<성별만 해보려고>
head(insurance2)

ins_model <- lm(charges ~ ., data=insurance2)
ins_model
# (Intercept)        age      sexmale          bmi     children  
#     -7460.0      241.3       1321.7        326.8        533.2  

# sexmale 1321.7 <해석 : 남자가 여자보다 1321.7원 더 비싸다.>
# female = 0 , male = 1 이므로 male 이 더미변수 
# female 이 기준(base)이므로 0으로 되서 결과값이 보이지않는다. <y절편에 들어가있다?> 
# [해석] 여성에 비해서 남성의 의료비 증가(1321.7)
# y = ax + b
y_male = 1321.7 * 1 + (-7460.0)
y_female = 1321.7 * 0 + (-7460.0)
y_male # -6138.3
y_female # -7460

# 기준 바꾸기
x <- c('male', 'female')
insurance2$sex <- factor(insurance2$sex, levels = x)
insurance2$sex
# levels : male(base) = 0 , female = 1 
ins_model <- lm(charges ~ ., data=insurance2)
ins_model
# (Intercept)       age    sexfemale          bmi     children  
#     -6138.2     241.3      -1321.7        326.8        533.2 
# sexfemale -1321.7 <해석 : 여자가 남자보다 1321.7원 더 싸다.>
# female = 1 , male = 0 이므로 female 이 더미변수 
# [해석] 여성이 남성에 비해서 의료비 절감(-1321.7)

male <- subset(insurance2, sex == 'male')
female <- subset(insurance2, sex == 'female')
mean(male$charges)   # 13956.75
mean(female$charges) # 12569.58
13956.75 - 12569.58 # 1387.17


# dummy 변수 vs 절편  <단순> <범주형 1개>
insurance3 <- insurance[,-6]
head(insurance3)
# 단순선형회귀분석 < 기준(base)의 평균이 y절편이 된다.> 
ins_model2 <- lm(charges ~ smoker, data=insurance3)
ins_model2
# (Intercept)    smokeryes  
#       8434        23616
# base : smokerno = 0 , smokeryes = 1
# [해석] 흡연자가 비흡연자에 비해 의료비가 증가한다. (23616)

no <- subset(insurance3, smoker=='no')
yes <- subset(insurance3, smoker=='yes')
mean(no$charges)  # 8434.268
mean(yes$charges) # 32050.23
32050.23 - 8434.268 # 23615.96


# 4개 범주 -> 3개 더미변수 생성  <범주형 1개>
insurance4 <- insurance
ins_model3 <- lm(charges ~ region, data=insurance4)
ins_model3
# (Intercept)  regionnorthwest  regionsoutheast  regionsouthwest  
#     13406.4           -988.8           1329.0          -1059.4 
# regionnoreast : 기준(base) = 0 <절편으로 표현됌> 
# regionnorthwest =x1 , regionsoutheast = x2 , regionsouthwest = x3













