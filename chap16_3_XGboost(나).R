# chap16_3_XGboost

# xgboost vs randomForest
# - xgboost : boosting 방식 
# - randomForest : bagging 방식 

# 1. package install
install.packages("xgboost")
library(xgboost)
#library(help="xgboost")


# 2. dataset load/search
data(agaricus.train)
data(agaricus.test)

train <- agaricus.train
test <- agaricus.test

# train 과 test 구조는 같지만 크기만 다름 6:1 비율정도
str(train)
# $ data : 6 slots [6513  126] 2차원(matrix)   -> x변수
# $ label : num [1:6513] : 1차원(vector)       -> y변수
train$data@Dim # 6513  126
# $ : key , @ : slot(member)
train$data
train$label
table(train$label)
#    0    1 
# 3373 3140

str(test)
# $ data : 6 slots [1611  126] 2차원(matrix)   -> x변수
# $ label : num [1:1611] : 1차원(vector)       -> y변수
test$data@Dim # 1611  126

# class -> object   < . vs @ >
# java,python : object.member
# R : object@member 


# 3. xgboost matrix 생성 : 객체 정보 확인  <list 구조이기때문에>
# xgb.Dmatrix(data = x, label = y)
dtrain <- xgb.DMatrix(data = train$data, label = train$label) # x:data, y:label
dtrain 
dim(dtrain) # 6513  126

?xgboost
#We will train decision tree model using the following parameters:
# •objective = "binary:logistic": we will train a binary classification model ;
# "binary:logistic" : y변수 이항 
# •max_depth = 2: the trees won't be deep, because our case is very simple ;
# tree 구조가 간단한 경우 : 2
# •nthread = 2: the number of cpu threads we are going to use;
# cpu 사용 수 : 2
# •nrounds = 2: there will be two passes on the data, the second one will enhance the model 
#               by further reducing the difference between ground truth and prediction.
# 실제값과 예측값의 차이를 줄이기 위한 반복학습 횟수 
# •eta = 1 : eta control the learning rate 
# 학습률을 제어하는 변수(생략하면: 0.3) 
# 숫자가 낮을 수록 모델의 복잡도가 높아지고, 컴퓨팅 파워가 더많이 소요
# 부스팅 과정을보다 일반화하여 오버 피팅을 방지하는 데 사용
# •verbose = 0 : no message
# 0이면 no message, 1이면 성능에 대한 정보 인쇄, 2이면 몇 가지 추가 정보 인쇄


# 4. model 생성 : xgboost matrix 객체 이용  
xgb_model <- xgboost(data = dtrain, max_depth = 2, eta = 1, nthread = 2, 
                     nrounds = 2, objective = "binary:logistic", verbose = 0)


# 5.  학습된 model의 변수(feature) 중요도/영향력 보기 
import <- xgb.importance(colnames(train$data), model = xgb_model)
import
#                    Feature        Gain      Cover  Frequency
# 1:               odor=none  0.67615471  0.4978746        0.4
# 2:         stalk-root=club  0.17135375  0.1920543        0.2
# 3:       stalk-root=rooted  0.12317236  0.1638750        0.2
# 4: spore-print-color=green  0.02931918  0.1461960        0.2
# Gain(지니계수) 가 클수록 영향력이 크다 

xgb.plot.importance(importance_matrix = import)

colnames(train$data)


# 6. 예측치
pred <- predict(xgb_model, test$data)
range(pred) # 0.01072847 0.92392391

y_pred <- ifelse(pred >= 0.5, 1, 0) # 예측치가 확률로 써있어서  0,1로 만들어줌 
y_true <- test$label # 정답값

tab <- table(y_true, y_pred)
tab
#           y_pred
# y_true    0    1
#      0  813   22
#      1   13  763
# 1) 분류정확도 : 1에 가까울수록 정확하다.
acc <- (tab[1,1]+tab[2,2]) / length(y_true)
acc # 0.9782744 

# 2) 평균오차 : 0에 가까울수록 정확하다.
# T/F -> 숫자 형변환 (1,0)
mean_err <- mean(as.numeric(pred >= 0.5) != y_true) 
mean_err # 0.02172564


# 7. model save & load

# 1) 저장하기
setwd("C:/ITWILL/2_Rwork/output")
xgb.save(xgb_model, 'xgboost.model') # (object, 'filename')
# TRUE

# 2) 리스트 지우기
# ls() : 모든 메모리를 보여줌 
ls()
# rm(list = ls()) : 모든 메모리 지움 
rm(list = ls())

# 3) 가져오기 model load(memory loading)
xgb_model2 <- xgb.load('xgboost.model')

pred2 <- predict(xgb_model2, test$data)
range(pred2) # 0.01072847 0.92392391



####################################
## iris dataset : y 이항분류
####################################
iris_df <- iris # iris 에 하면 손상되므로 복제본으로 해보기

# 1. y변수 -> binary
iris_df$Species <- ifelse(iris_df$Species == 'setosa', 0, 1)
str(iris_df) # species의 형태가 factor에서 num으로 변경됌 <이항분류에 적합한 0,1>
table(iris_df$Species)
#  0    1 
# 50  100

# 2. dataset 생성 
idx <- sample(nrow(iris_df), 0.7 * nrow(iris_df))
train <- iris_df[idx,]
test <- iris_df[-idx,]
dim(train) # 105  5
dim(test) # 45  5
# x : matrix , y : vector
train_x <- as.matrix(train[,-5])
train_y <- train$Species
dim(train_x) # 105  4
str(train_y) # num [1:105]

# 3. DMatrix 생성 
dtrain <- xgb.DMatrix(data = train_x, label = train_y)
dtrain # dim: 105 x 4  info: label 

# 4. xgboost model 생성
xgb_iris_model <- xgboost(data = dtrain, max_depth = 2,  eta = 1, nthread = 2, 
                          nrounds = 2, objective = "binary:logistic", verbose = 0)
xgb_iris_model

# 5. 학습된 model의 변수(feature) 중요도/영향력 보기
import <- xgb.importance(colnames(train_x), model = xgb_iris_model)
import 

xgb.plot.importance(importance_matrix = import)

# 6. 예측치 
# x : matrix , y : vector
test_x <- as.matrix(test[,-5])
test_y <- test$Species

pred <- predict(xgb_iris_model, test_x)
range(pred) # 0.06118078 0.94868654

y_pred <- ifelse(pred >= 0.5, 1, 0)

tab <- table(test_y, y_pred)
tab
#         y_pred
# test_y  0   1
#      0 16   0
#      1  0  29

# 분류정확도 100% 
acc <- (tab[1,1]+tab[2,2]) / length(test_y)
acc # 1



####################################
## iris dataset : y 다항분류
####################################
# objective 속성
# objective = 'reg:squarederror' : 연속형(default)
# objective = 'binary:logistic' : y 이항분류 
# objective = 'multi:softmax' : y 다항분류
# -> num_class = n <써줘야함>
# -> 첫번째 class = 0(number)

########### 다항분류 차이점 #########################
# objective = "multi:softmax", num_class = 3
# 다항에서는 y변수 값으로 나눠지기때문에 cuttoff 생략 
#####################################################

iris_df <- iris # 복제
table(iris_df$Species) 

# 1. y변수 -> binary (Species : num)
iris_df$Species <- ifelse(iris_df$Species == 'setosa', 0, 
                          ifelse(iris_df$Species == 'versicolor', 1, 2))
str(iris_df) # Species : num
table(iris_df$Species)
#  0  1  2 
# 50 50 50

# 2. data set 생성 
idx <- sample(nrow(iris_df), 0.7 * nrow(iris_df))
train <- iris_df[idx,]
test <- iris_df[-idx,]

# 3. xgb.DMatrix 생성
train_x <- as.matrix(train[-5]) # matrix
train_y <- train$Species # vector

dmtrix <- xgb.DMatrix(data = train_x, label = train_y)

# 4. xgboost model 생성
xgb_iris_model2 <- xgboost(data = dmtrix, max_depth = 2, eta = 0.5, nthread = 2,
                           nrounds = 2, objective = "multi:softmax", num_class = 3, 
                           verbose = 0)
xgb_iris_model2

# 5. prediction
test_x <- as.matrix(test[-5])
test_y <- test$Species
# softmax : 0~1 = sum(1)
pred <- predict(xgb_iris_model2, test_x)
range(pred) # 0 ~ 2 
# 다항에서는 y변수 값으로 나눠지기때문에 cuttoff 생략 
tab <- table(test_y, pred)
tab
#            pred
#  test_y   0   1  2
#       0  13   0  0
#       1   0  20  1
#       2   0   2  9
acc <- (13+20+9) / length(test_y)
acc # 0.9333333
ACC <- mean(pred == test_y)
ACC # 0.9333333
mean_err <- mean(pred != test_y)
mean_err # 0.06666667

# 학습된 model의 변수 
import <- xgb.importance(colnames(train_x), model = xgb_iris_model2)
import

xgb.plot.importance(importance_matrix = import)



####################################
## iris dataset : y 연속형
####################################
# objective = 'reg:squarederror' : 연속형(default)
# y : 1번 칼럼
# x : 2~4번 칼럼 

iris_df <- iris[-5] 

idx <- sample(nrow(iris_df), 0.7 * nrow(iris_df))
train <- iris_df[idx,]
test <- iris_df[-idx,]

train_x <- as.matrix(train[-1])
train_y <- train$Sepal.Length

dmatrix <- xgb.DMatrix(data = train_x, label = train_y)

xgb_iris_model3 <- xgboost(data = dmatrix , eta = 0.5, nrounds = 2, nthread = 2, max_depth = 2,
                           verbose = 0, objective = "reg:squarederror")
xgb_iris_model3

test_x <- as.matrix(test[-1])
test_y <- test$Sepal.Length

pred <- predict(xgb_iris_model3, test_x)
pred

pred2 <- round(pred, digits = 1)
range(pred2) # 3.9  5.0

# table(test_y, pred2)
err <- test_y - pred2
err
mse <- mean(err**2)
mse # 1.869333

cor(test_y, pred2) # 0.8628495

# 
err <- test_y - pred
err
mse <- mean(err**2)
mse # 1.906612

cor(test_y, pred) # 0.8620895







