# chap_17_3_SVM

##################################################
#Support Vector Machine 
##################################################
# SVM 알고리즘 - 두 범주를 직선으로 분류(이진분류) 
# 선형분리 - 2개의 집합을 직선으로 분리(초평면 분리) 
# 초평면(Separating Hyperplane) : 2차원 이상 공간에서 평면 
# 가상의 직선을 중심으로 거리를 계산하여 직사각형 형태로 영역 확장
# -> 가장 가까운 점이 만날때 까지 영역  확장 

# 바이오인포매틱스의 유전자 데이터 분류 
# 용도 : 인간의 얼굴, 문자, 숫자 인식(이미지 데이터 패턴 인식) 
# 예) 스캐너로 스캔된 문서 이미지를 문자로 인식 


###############################################
####### e1071 패키지 
###############################################
# 관련 패키지(e1071, kernlab, klaR 등) 4개 중 e1071 가장 많이 사용함 

library(e1071)  

# 1. SVM 기본 개념 익히기 - Support Vector, Margin
df = data.frame(
  x1 = c(1,2,1,2,4,5,6),
  x2 = c(8,7,5,6,1,3,2),
  y=factor(c(1,1,1,1,0,0,0))
)

# 2. svm 모델 생성 : 비선형 SVM
# 형식) svm(y ~ x, data, type, kernel) 
?svm
model_svm = svm(y ~ ., data = df, na.action =na.omit)
model_svm

# default 속성 :  kernel="radial"
# kernel : 비선형(non linear) 관계를 선형적(linear)으로 변환하는 역할 
# kernel 종류 : linear, polynomial, radial, sigmoid <생략하면 radial 이 기본으로사용됌>
# cost = 1 : 오분류 조절속성 (값이 큰경우 -> 오분류 감소, 과적합 증가)
# gamma = 0.5 : 결정경계 모양 조절 속성 (값이 큰경우 -> 공간이 작아지고, 오분류 감소, 과적합 증가)
# gamma = if (is.vector(x)) 1 else 1 / ncol(x)

# svm 모델 시각화 
par(mfrow=c(1,1))
plot(df$x1, df$x2, col=df$y)  
X11()
plot(model_svm, df) # 분류 Factor levels에 의해서 2개 분류 

pred <- predict(model_svm, df)
pred
# 1 2 3 4 5 6 7 -> index
# 1 1 1 1 0 0 0 -> 예측치

# 3. kernel="linear" 변경 
model_svm2 = svm(y~., data=df,  kernel="linear")
model_svm2

# cost = 1 : 오분류 조절속성

summary(model_svm2)
pred2 <- predict(model_svm2, df)
pred2

############################
# iris 데이터 실습 
############################

# 1. 데이터셋 생성 
data(iris)
set.seed(415) # random 결과를 동일하게 지
idx = sample(1:nrow(iris), 0.7*nrow(iris))
training = iris[idx, ]
testing = iris[-idx, ]
training
testing
dim(training) # 105
dim(testing) # 45


# 2. 분류모델 생성 
model_svm = svm(Species ~ ., data = training) # na.action =na.omit <비선형>
summary(model_svm)
model_svm2 = svm(Species ~ ., data = training, kernel = 'linear') # <선형> 이 더 분류정확도가 높게나왔다.
summary(model_svm2)

# 3. 분류모델 성능 평가(testing set 적용 예측값 생성)  
pred <- predict(model_svm, testing)
pred2 <- predict(model_svm2, testing)
  
# 혼돈 matrix 작성 
table(testing$Species, pred)
# pred         setosa versicolor virginica
#   setosa         13          0         0
#   versicolor      0         17         3
#   virginica       0          0        12

table(testing$Species, pred2)
# pred2        setosa versicolor virginica
#   setosa         13          0         0
#   versicolor      0         16         1
#   virginica       0          1        14

# 분류정확도
42 / 45  # 0.93333333
43 / 45  # 0.95555556


###########################
## svm model tuning
###########################
# - 가장 최적으 ㅣ속성값을 찾아서 최적의 model 생성
params <- c(0.001, 0.01, 0.1, 1, 10, 100, 1000) # 범위 : 10^-3 ~ 10^3
length(params) # 7

tuning <- tune.svm(Species ~ ., data = training, gamma = params, cost = params)
tuning
# best parameters:
#   gamma cost
#    0.01 1000
# best performance: 0.02909091 

best_model <- svm(Species ~ ., data = training, gamma = 0.01, cost = 1000)
best_model
pred_best <- predict(best_model, testing)
table(testing$Species, pred_best)
#            setosa versicolor virginica
# setosa         13          0         0
# versicolor      0         16         1
# virginica       0          0        15
acc <- (13+16+15) / 45
acc # 0.9777778

##################################################
# Support Vector Machine 문제 : spamfiltering
##################################################
# 단계1. 실습 데이터 가져오기
load(file.choose()) # sms_data_total.RData
ls()

# 단계2. 데이터 탐색 
dim(train_sms) # train 데이터 4180  74
dim(test_sms) # test 데이터   1394  74
names(train_sms)
table(train_sms$type) # sms 메시지 유형 
table(test_sms$type)

# 단계3. 분류모델 생성 : 기본 파라미터 사용 
model_sms <- svm(type ~ ., data = train_sms) # h/s
model_sms
summary(model_sms)

# 단계4. 분류모델 평가
pred_sms <-predict(model_sms, test_sms) 
pred_sms

# 단계5. 분류정확도  
table(test_sms$type, pred_sms)
#       ham spam
# ham  1187    1
# spam  178   28
acc <- (1187 + 28) / length(test_sms$type)
acc # 0.8715925

# 단계6. 분류모델 수정 : linear kernel 방식 적용(radial과 linear 방식 비교) 
model_sms2 <- svm(type ~ ., data = train_sms, kernel = 'linear')
model_sms2

pred_sms2 <- predict(model_sms2, test_sms)
table(test_sms$type, pred_sms2)
#       ham spam
# ham  1170   18
# spam  112   94
acc2 <- (1170 + 94) / length(test_sms$type)
acc2 # 0.9067432


#######################################
### 스캔된 이미지 문자 인식 
#######################################
# 1. 파일 가져오기 
letterdata = read.csv(file.choose())	#letterdata.csv
str(letterdata) # 'data.frame':	20000 obs. of  17 variables:
# y : letter, x : 나머지 16

# 2. 데이터 셋 생성 
set.seed(415)
idx = sample(1:nrow(letterdata), 0.7*nrow(letterdata))
training_letter = letterdata[idx, ]
testing_letter  = letterdata[-idx, ]

# 3. NA 제거 
training_letter2 = na.omit(training_letter)
testing_letter2 = na.omit(testing_letter)

# 4. 분류모델 생성 
model_letter <- svm(letter~., data = training_letter2)

# 5. 분류모델 평가 
pred_letter <- predict(model_letter, testing_letter2)

# 혼돈 matrix 
table(pred_letter, testing_letter2$letter)

re <- (pred_letter == testing_letter2$letter)
table(re)
# FALSE  TRUE 
#   319  5681 
prop.table(table(re))
#      FALSE       TRUE 
# 0.05316667 0.94683333 



