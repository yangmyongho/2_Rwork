# chap15_2_Logistic_Regression

###############################################
# 15_2. 로지스틱 회귀분석(Logistic Regression) 
###############################################

# 목적 : 일반 회귀분석과 동일하게 종속변수와 독립변수 간의 관계를 나타내어 
# 향후 예측 모델을 생성하는데 있다.

# 차이점 : 종속변수가 범주형 데이터를 대상으로 하며 입력 데이터가 주어졌을 때
# 해당 데이터의결과가 특정 분류로 나눠지기 때문에 분류분석 방법으로 분류된다.
# 유형 : 이항형(종속변수가 2개 범주-Yes/No), 다항형(종속변수가 3개 이상 범주-iris 꽃 종류)
# 다항형 로지스틱 회귀분석 : nnet, rpart 패키지 이용 
# a : 0.6,  b:0.3,  c:0.1 -> a 분류 

# 분야 : 의료, 통신, 기타 데이터마이닝

# 선형회귀분석 vs 로지스틱 회귀분석 
# 1. 로지스틱 회귀분석 결과는 0과 1로 나타난다.(이항형)
# 2. 정규분포 대신에 이항분포를 따른다.
# 3. 로직스틱 모형 적용 : 변수[-무한대, +무한대] -> 변수[0,1]사이에 있도록 하는 모형 
#    -> 로짓변환 : 출력범위를 [0,1]로 조정
# 4. 종속변수가 2개 이상인 경우 더미변수(dummy variable)로 변환하여 0과 1를 갖도록한다.
#    예) 혈액형 AB인 경우 -> [1,0,0,0] AB(1) -> A,B,O(0)


# 단계1. 데이터 가져오기
weather = read.csv("C:/ITWILL/2_Rwork/Part-IV/weather.csv", stringsAsFactors = F) 
# stringsAsFactors = F 문자형을 변환안하고 그대로 문자형으로 가져오겠다.
dim(weather)  # 366  15
head(weather)
str(weather)

# chr 칼럼, Date, RainToday 칼럼 제거 
weather_df <- weather[, c(-1, -6, -8, -14)]
str(weather_df)

# RainTomorrow 칼럼 -> 로지스틱 회귀분석 결과(0,1)에 맞게 더미변수 생성      
weather_df$RainTomorrow[weather_df$RainTomorrow=='Yes'] <- 1
weather_df$RainTomorrow[weather_df$RainTomorrow=='No'] <- 0
weather_df$RainTomorrow <- as.numeric(weather_df$RainTomorrow)
head(weather_df)
# y 빈도수
table(weather_df$RainTomorrow)
#   0   1 
# 300  66 
prop.table(table(weather_df$RainTomorrow))
#         0         1 
# 0.8196721 0.1803279


#  단계2.  데이터 셈플링 <훈련셋,검정셋>
idx <- sample(1:nrow(weather_df), nrow(weather_df)*0.7)
train <- weather_df[idx, ]
test <- weather_df[-idx, ]
dim(train) # 256  11
dim(test) # 110  11


#  단계3.  로지스틱  회귀모델 생성 : 학습데이터 
weater_model <- glm(RainTomorrow ~ ., data = train, family = 'binomial') 
# family = 'binomial' : 이항이다.
weater_model 
summary(weater_model) 


# 단계4. 로지스틱  회귀모델 예측치 생성 : 검정데이터 
# newdata=test : 새로운 데이터 셋, type="response" : 0~1 확률값으로 예측<sig moid> 
pred <- predict(weater_model, newdata=test, type="response")  
pred 
range(pred, na.rm = T) # 0.0004994111 0.9905604668 
#                      <0에가까울수록 비가안올확률, 1에가까울수록 비가올 확률>
summary(pred)
str(pred)

# cut off = 0.5 로 잡았을 경우 < 0 ~ 1 사이에 기준이 필요하므로 > <보통 0.5로잡는다>
cpred <- ifelse(pred >= 0.5,1,0)
table(cpred)
#   0   1 
# 103   6 

y_true <- test$RainTomorrow
table(y_true) # 이게 정답이다 
#  0  1 
# 90 20 

# 교차분할표 
table(y_true, cpred) # y_true가 정답이므로 행 이 정답이다
#         cpred
# y_true   0  1
#       0 88  2
#       1 15  4

# 단계 5 : 모델 평가
# 88  4  정분류 (맞춘거)
# 15  2  오분류 (틀린거)

# 1) 정분류 : 분류정확도
# 평균 
acc <- (88+4) / nrow(test)  # 분류정확도
acc # 0.8363636    < 약 84% 정도 일치 (비올지말지) >

no <- 88 / (88 + 2) # 비안올 예측
no # 0.9777778     <약 97% 정도 > 
yes <- 4 / (15+4)  # 비올 예측
yes # 0.2105263    < 약 21% 정도 > 
# 따라서 비안올 예측은 94%로 예측력이 높지만 비안올예측은 매우낮다.

# 매번달라지니까 테이블로 만들기
tab <- table(y_true, cpred)
tab
acc <- (tab[1,1]+tab[2,2]) / nrow(test) # 정분류정확도
acc # 0.8181818

# 2) 오분류 
no_acc <- (tab[1,2]+tab[2,1]) / nrow(test) # 오분류정확도
no_acc # 0.1636364

# 3) 특이도 : 관측치(NO) -> NO
tab[1,1] / (tab[1,1]+tab[1,2]) # 0.9651163

# 4) 민감도 = 재현율 : 관측치(YES) -> YES
recall <- tab[2,2] / (tab[2,1]+tab[2,2]) 
recall # 0.5769231

# 5) 정확률 : 예측치(yes) -> yes 
precision <- tab[2,2] / (tab[1,2]+tab[2,2])
precision # 0.6818182


# 6) F1_score : 불균형 비율 
F1_score = 2*((recall * precision) / (recall + precision))
F1_score # 0.5221519
# 종합적으로 이데이터는 0.5221519% 만큼 효과가 있다.


### ROC Curve를 이용한 모형평가(분류정확도)  ####
# Receiver Operating Characteristic

install.packages("ROCR")
library(ROCR)

# ROCR 패키지 제공 함수 : prediction() -> performance
pr <- prediction(pred, test$RainTomorrow)
pr
prf <- performance(pr, measure = "tpr", x.measure = "fpr")
plot(prf)
# 그래프를 정사각형으로 봤을때 빈공간이 오류인 부분 
# 따라서 사각형의범위가 클수록 오차범위가 적은것


###################################
## 다항형 로지스틱 회귀분석 : nnet
###################################
install.packages("nnet")
library(nnet)

set.seed(123) # 시드값을 같게 하면 매번 같은 결과가 나온다.
idx <- sample(nrow(iris), nrow(iris)*0.7)
idx
train <- iris[idx,]
train
test <- iris[-idx,]
test

# 활성함수 
# 이항 : sigmoid function : 0~1 확률값
# 다항 : softmax function : 0~1 확률값 (sum=1)
# y1=0.1 y2=0.1 y3=0.8
names(iris)
model <- multinom(Species ~ ., data=train)
# stopped after 100 iterations <100번 반복실행> 
# 10번 시행할때마다 오차가 줄어듬 
# 최초 오차(115.354290)에서 100번째 오차(0.015915)로 줄어듬 
names(model)
model$fitted.values
range(model$fitted.values) # 2.911725e-108  1.000000e+00 <0~1사이>
rowSums(model$fitted.values)# 모든값 : 1
str(model$fitted.values)
# num [1:105, 1:3] -> matrix
model$fitted.values[1,] # 가장 높은게 setosa 로 예측 
#       setosa    versicolor     virginica 
# 1.000000e+00  1.927298e-12  1.895157e-91 
1.000000e+00 + 1.927298e-12 + 1.895157e-91  # 1
train[1,] # setosa 
# 예측값이 정답과 동일하다

# 예측치 
y_pred <- predict(model, test)
y_pred # 랜덤하게 선정된 45개 예측
# 정답과 비교 
y_true <- test$Species
y_true
# 교차분할표(confusion matrix)
tab <- table(y_true , y_pred)
tab
# y_true       setosa versicolor virginica
# setosa         14          0         0
# versicolor      0         17         1
# virginica       0          0        13
# 전체 45개중에 1개 빼고  예측이 다 맞음
acc <- (tab[1,1] + tab[2,2] + tab[3,3]) / nrow(test)
acc # 0.9777778
44 / 45 # 0.9777778





