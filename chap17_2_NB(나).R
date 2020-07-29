# chap17_2_NB(1)


##################################################
# Naive Bayes 알고리즘 
##################################################
# 조건부 확률 적용 예측 
# 비교적 성능 우수
# 베이즈 이론 적용
#  -> 조건부 확률 이용 
#  -> 스펨 메시지 분류에 우수함

# 조건부 확률 : 사건 A가 발생한 상태에서 사건 B가 발생할 확률 
# P(B|A) = P(A|B) * P(B) / P(A)
# ----------------------------------------------------------
# ex) 비아그라,정력 단어가 포함된 메시지가 스팸일 확률
# P(스팸|비아그라,정력)
# 사건 A : 비아그라, 정력 -> P(A) : 5/100(5%)
# 사건 B : 스팸 -> P(B) : 20/100(20%)
# P(A|B) : 스팸일때 비아그라, 정력일 경우 -> 4/20(20%) 

A <- 5/100
B <- 20/100
A.B <- 4/20
P <- A.B * B / A
P # 0.8


##################################################
# Naive Bayes 기본실습 : iris
##################################################

# 패키지 설치 
#install.packages('e1071')
library(e1071) # naiveBayes()함수 제공   

# 1. train과 test 데이터 셋 생성  
data(iris)
set.seed(415) # random 결과를 동일하게 지정
idx <- sample(1:nrow(iris), 0.7*nrow(iris)) # 7:3 비율 

train <- iris[idx, ]
test <- iris[-idx, ]
train; test
nrow(train) # 105

# 2. 분류모델 생성 : train data 이용    
# 형식) naiveBayes(train, class) - train : x변수, calss : y변수
model <- naiveBayes(train[-5], train$Species) 
model # 105개 학습 데이터를 이용하여 x변수(4개)를 y변수로 학습시킴  


# 3. 분류모델 평가 : test data 이용 
# 형식) predict(model, test, type='class')  
p <- predict(model, test) # test : y변수가 포함된 데이터 셋
p   

# 4. 분류모델 평가(예측결과 평가) 
tab <- table(p, test$Species) # 예측결과, 원형 test의 y변수   
tab
# p            setosa versicolor virginica
#   setosa         13          0         0
#   versicolor      0         16         3
#   virginica       0          1        12

# 분류 정확도
acc <- (tab[1,1]+tab[2,2]+tab[3,3]) / nrow(test)
acc  # 0.9111111



##################################################
# Naive Bayes 응용실습 : 기상데이터 분석
##################################################

# 1. 데이터 가져오기 
setwd("c:/ITWILL/2_Rwork/Part-IV")
weatherAUS <- read.csv('weatherAUS.csv')
weatherAUS <- weatherAUS[ ,c(-1,-2, -22, -23)] # 칼럼 제외 

# 2. 데이터 생성/전처리  
set.seed(415)
idx = sample(1:nrow(weatherAUS), 0.7*nrow(weatherAUS))
train_w = weatherAUS[idx, ]
test_w  = weatherAUS[-idx, ]

head(train_w)
head(test_w)
dim(train_w) # [1] 25816    20
dim(test_w) # [1] 11065    20


# 3. 분류모델(분류기) 생성 : train data 이용    
# 형식2) niveBayes(y변수 ~ x변수, data)  
model = naiveBayes(RainTomorrow ~ ., data = train_w)
model

# 4. 분류모델 평가(예측기) : test data 이용 
# 형식) predict(model, test, type='class')
p<- predict(model, test_w)
tab <- table(p, test_w$RainTomorrow)
tab
# p       No  Yes
#   No  7153  964
#   Yes 1137 1615

# 5. 분류정확도 
acc <- (tab[1,1]+tab[2,2]) / sum(tab)
acc # 0.7627197

tab[1,1] / sum(tab[1,]) # 0.7627197

tab[2,2] / sum(tab[2,]) # 

