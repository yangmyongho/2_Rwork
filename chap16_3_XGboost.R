# chap16_3_XGboost

# xgboost vs randomForest
# - xgboost : boosting 방식 
# - randomForest : bagging 방식 

# 1. package install
install.packages("xgboost")
library(xgboost)
library(help="xgboost")

# 2. dataset load/search
data(agaricus.train)
data(agaricus.test)

train <- agaricus.train
test <- agaricus.test

str(train)
train$data@Dim # 6 slots(member)
# class -> object
# Java,Python : object.member
# R : object@member

# $ data : x변수 : [6513, 126] : 2차원(matrix)
# $ label : y변수 : num [1:6513] : 1차원(vector)
train$data[1,]
train$data
train$label
table(train$label)
#    0    1 
# 3373 3140

str(test)
# $ data : x변수 : [1611, 126] : 2차원(matrix)
# $ label : y변수 : num [1:1611] : 1차원(vector)

# 3. xgboost matrix 생성 : 객체 정보 확인  
#xgb.DMatrix(data = x, label = y)
dtrain <- xgb.DMatrix(data = train$data, label = train$label) # x:data, y:label
dtrain # dim: 6513 x 126

?xgboost
#We will train decision tree model using the following parameters:
# •objective = "binary:logistic": we will train a binary classification model ;
# "binary:logistic" : y변수 이항 
# •max_depth = 2: the trees won't be deep, because our case is very simple ;
# tree 구조가 간단한 경우 : 2
# •nthread = 2: the number of cpu threads we are going to use;
# cpu 사용 수 : 2
# •nrounds = 2: there will be two passes on the data, the second one will enhance the model by further reducing the difference between ground truth and prediction.
# 실제값과 예측값의 차이를 줄이기 위한 반복학습 횟수 
# •eta = 1 : eta control the learning rate 
# 학습률을 제어하는 변수(Default: 0.3) 
# 숫자가 낮을 수록 모델의 복잡도가 높아지고, 컴퓨팅 파워가 더많이 소요
# 부스팅 과정을보다 일반화하여 오버 피팅을 방지하는 데 사용
# •verbose = 0 : no message
# 0이면 no message, 1이면 성능에 대한 정보 인쇄, 2이면 몇 가지 추가 정보 인쇄

# 4. model 생성 : xgboost matrix 객체 이용  
xgb_model <- xgboost(data = dtrain, max_depth = 2, eta = 1, nthread = 2, nrounds = 2, objective = "binary:logistic", verbose = 0)

# 5.  학습된 model의 변수(feature) 중요도/영향력 보기 
import <- xgb.importance(colnames(train$data), model = xgb_model)
import
xgb.plot.importance(importance_matrix = import)

# 6. 예측치 
pred <- predict(xgb_model, test$data)
range(pred) # 0.01072847 0.92392391

y_pred <- ifelse(pred >= 0.5, 1, 0)
y_true <- test$label

table(y_true)

tab <- table(y_true, y_pred)
tab

# 7. model 평가 

# 1) 분류정확도 
acc <- (tab[1,1] + tab[2,2]) / length(y_true)
cat('분류정확도 =', acc)
# 분류정확도 = 0.9782744

# 2) 평균 오차
# T/F -> 숫자형 변환(1/0)
mean_err <- mean(as.numeric(pred >= 0.5) !=  y_true)
cat('평균 오차 =', mean_err)
# 평균 오차 = 0.02172564

# 8. model save & load

# 1) model file save
setwd("c:/ITWILL/2_Rwork/output")
xgb.save(xgb_model, 'xgboost.model') # (obj, 'file')
# [1] TRUE

rm(list = ls())


# 2) model load(memory loading)
xgb_model2 <- xgb.load('xgboost.model')

pred2 <- predict(xgb_model2, test$data)
range(pred2) # 0.01072847 0.92392391

##############################
## iris dataset : y 이항분류 
##############################

iris_df <- iris # 복제본 

# 1. y변수 -> binary(Species : num)
iris_df$Species <- ifelse(iris_df$Species == 'setosa', 0, 1)
str(iris_df)
table(iris_df$Species)

# 2. dataset 생성 
idx <- sample(nrow(iris_df), nrow(iris_df)*0.7)
train <- iris_df[idx, ]
test <- iris_df[-idx, ]

# x :matrix, y: vector
train_x <- as.matrix(train[, -5])
train_y <- train$Species
str(train_y)

# 3. DMatrix 생성 
dtrain <- xgb.DMatrix(data=train_x, label=train_y) # x:data, y:label
dtrain # dim: 6513 x 126

# 4. xgboost model 생성 
xgb_iris_model <- xgboost(data = dtrain, max_depth = 2, eta = 1, nthread = 2, nrounds = 2, objective = "binary:logistic", verbose = 0)
xgb_iris_model

# 5. 학습된 model의 변수(feature) 중요도/영향력 보기 
import <- xgb.importance(colnames(train_x), model = xgb_iris_model)
import # Petal.Length

xgb.plot.importance(importance_matrix = import)

# 6. 예측치
# x :matrix, y: vector
test_x <- as.matrix(test[, -5])
test_y <- test$Species

pred <- predict(xgb_iris_model, test_x)
range(pred) # 0.0617379 0.9488163

y_pred <- ifelse(pred >= 0.5, 1, 0)

tab <- table(test_y, y_pred)
acc <- (tab[1,1] + tab[2,2]) / length(test_y)

cat('분류정확도 =', acc*100, '%')


##############################
## iris dataset : y 다항분류 
##############################

?xgboost
# objective 속성 
# objective = 'reg:squarederror' : 연속형(default)
# objective = 'binary:logistic' : y 이항분류 
# objective = 'multi:softmax' : y 다항분류 
#  -> num_class = n
#  -> 첫번째 class = 0(number)

# 1. y변수 변경 
iris_df <- iris # 복제본 
table(iris_df$Species)
# 1. y변수 -> binary(Species : num)
iris_df$Species <- ifelse(iris_df$Species == 'setosa', 0, 
                      ifelse(iris_df$Species == 'versicolor', 1, 2))
str(iris_df)
table(iris_df$Species)
#  0  1  2 
# 50 50 50

# 2. data set 생성 
idx <- sample(nrow(iris_df), nrow(iris_df)*0.8)
train <- iris_df[idx, ]
test <- iris_df[-idx, ]

# 3. xgb.DMatrix 생성 

train_x <- as.matrix(train[-5]) # matrix
train_y <- train$Species # vector

dmtrix <- xgb.DMatrix(data = train_x, label = train_y)

# 4. xgboost model 생성 
xgb_iris_model2 <- xgboost(data = dmtrix, 
                           max_depth = 2, 
                           eta = 0.5, 
                           nthread = 2, 
                           nrounds = 2, 
                           objective = "multi:softmax",
                           num_class = 3,
                           verbose = 0)
xgb_iris_model2

# 5. prediction
test_x = as.matrix(test[-5]) # matrix 
test_y = test$Species # vector 

# softmax : 0~1 = sum(1)
pred <- predict(xgb_iris_model2, test_x)
range(pred) # class(0 ~ 2)
pred

# cut off 생략 
tab <- table(test_y, pred)
acc <- (tab[1,1]+tab[2,2]+tab[3,3]) / sum(tab)
cat('accuracy =', acc) # accuracy = 0.9333333

mean_err <- mean( pred != test_y )
cat('mean error=', mean_err) # mean error= 0.06666667

# 학습된 model의 변수(feature) 중요도/영향력 보기 
import <- xgb.importance(colnames(train_x), 
                       model = xgb_iris_model2)
import # Petal.Length
# 1: Petal.Length 0.8497497
# 2:  Petal.Width 0.1502503

xgb.plot.importance(importance_matrix = import)


##############################
## iris dataset : y 연속형 
##############################
# objective = 'reg:squarederror' : 연속형(default)


# 1. train/test 
idx <- sample(nrow(iris), nrow(iris)*0.7)
train <- iris[idx, ]
test <- iris[-idx, ]

# 2. xgboost model 생성 
# y : 1번 칼럼 
# x : 2~4번 칼럼 

train_x <- as.matrix(train[,-c(1,5)])
dim(train_x) # 105 3
train_y <- train$Sepal.Length

dmat <- xgb.DMatrix(data = train_x, label = train_y)

# 3. model 생성 
model <- xgboost(data=dmat, 
                 max_depth = 2, 
                 eta = 1, 
                 nthread = 2, 
                 nrounds = 3, 
                 verbose = 0)
model
# iter train_rmse
#  1   3.831950
#  2   2.724101

# 4. prediction
test_x <- as.matrix(test[,-c(1,5)])
test_y <- test$Sepal.Length

pred <- predict(model, test_x)
range(pred) # 4.874753 7.305714 : 숫자 예측 

# 5. model 평가 : MSE 
mse <- mean( (test_y - pred)**2 )
cat('MSE =', mse) # MSE = 0.11291


