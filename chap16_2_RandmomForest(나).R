# chap16_2_RandmomForest

##################################################
#randomForest
##################################################
# 결정트리(Decision tree)에서 파생된 모델 
# 랜덤포레스트는 앙상블 학습기법을 사용한 모델
# 앙상블 학습 : 새로운 데이터에 대해서 여러 개의 Tree로 학습한 다음, 
# 학습 결과들을 종합해서 예측하는 모델(PPT 참고)
# DT보다 성능 향상, 과적합 문제를 해결


# 랜덤포레스트 구성방법(2가지)
# 1. 결정 트리를 만들 때 데이터의 일부만을 복원 추출하여 트리 생성 
#  -> 데이터 일부만을 사용해 포레스트 구성 
# 2. 트리의 자식 노드를 나눌때 일부 변수만 적용하여 노드 분류
#  -> 변수 일부만을 사용해 포레스트 구성 
# [해설] 위 2가지 방법을 혼용하여 랜덤하게 Tree(학습데이터)를 구성한다.

# 새로운 데이터 예측 방법
# - 여러 개의 결정트리가 내놓은 예측 결과를 투표방식(voting) 방식으로 선택 


install.packages('randomForest')
library(randomForest) # randomForest()함수 제공 

data(iris)
str(iris)
# model
# 분류 tree : confusion matrix
# 회귀 tree : MSE, Cor


###########################
## 분류 tree
###########################

# 1. 랜덤 포레스트 모델 생성
# 형식) randomForest(y ~ x, data, ntree, mtry)
model = randomForest(Species~., data=iris)  # <생략하면 ntree=500, mtry=2 으로적용>  
model # 교차분할표까지 만들어서 성능비교까지해줌
# Type of random forest: classification <자동으로 타입을 판단해줌> 
# Number of trees: 500 <500개만듬>
# No. of variables tried at each split: 2
# OOB estimate of  error rate: 4.67% : 오차 


# 2. 파라미터 조정 300개의 Tree와 4개의 변수 적용 모델 생성 
model = randomForest(Species~., data=iris, 
                     ntree=300, mtry=4, na.action=na.omit )
model
# Number of trees: 300
# No. of variables tried at each split: 4

##########내가 생겼던 오류
# Error in na.fail.default(list(RainTomorrow = c(1L, 1L, 1L, 1L, 1L, 2L,  : 
# missing values in object
# 이 오류뜨는 이유 NA값이 있기때문에 na.action=na.omit 이걸로 NA값 지워줘야함 


# node 분할에 사용하는 x변수 갯수
p <- 14 # 변수의 갯수
mtry <- sqrt(p)
mtry # 범주형 : 3.741657(3~7)
mtry <- 1/3 * p
mtry # 연속형 : 4.666667(4~5)


# 3. 최적의 파리미터(ntree, mtry) 찾기
# - 최적의 분류모델 생성을 위한 파라미터 찾기

ntree <- c(400, 500, 600)
mtry <- c(2:4)

# 2개 vector이용 data frame 생성 
param <- data.frame(n=ntree, m=mtry)
param

for(i in param$n){ # 400,500,600
  cat('ntree = ', i, '\n')
  for(j in param$m){ # 2,3,4
    cat('mtry = ', j, '\n')
    model = randomForest(Species~., data=iris, 
                         ntree=i, mtry=j, 
                         na.action=na.omit )    
    print(model)
  }
}
# 결국 최적은 무엇인지??



# 4. 중요 변수 생성  
model3 = randomForest(Species ~ ., data=iris, 
                      ntree=500, mtry=2, 
                      importance = T,
                      na.action=na.omit )
model3 

model3$type # "classification"

class(model3) # "randomForest.formula" "randomForest" 

mode(model3) # list


importance(model3)
#                 setosa versicolor virginica MeanDecreaseAccuracy MeanDecreaseGini
# Sepal.Length  6.383642  9.2318553  9.199768            12.198699        10.560138
# Sepal.Width   5.060409  0.1158367  5.677032             5.615251         2.550543
# Petal.Length 22.932721 32.2146428 28.340732            33.945601        44.128068
# Petal.Width  20.902820 31.6763618 29.457088            32.038322        41.999785

# MeanDecreaseAccuracy : 분류정확도 개선에 기여하는 변수 <클수록 영향이크다.>
# MeanDecreaseGini : 노드불순도(불확실성) 개선에 기여하는 변수(=지니계수) <클수록 영향이 크다.>

model3$importance
#                  setosa   versicolor   virginica MeanDecreaseAccuracy MeanDecreaseGini
# Sepal.Length 0.03425316 0.0300553901 0.044025035          0.036625306        10.560138
# Sepal.Width  0.01151055 0.0002538802 0.009818946          0.007226584         2.550543
# Petal.Length 0.33980547 0.3008179671 0.301444292          0.311334319        44.128068
# Petal.Width  0.30784109 0.2987682262 0.267835693          0.288330278        41.999785
# d이거 왜다른지.. < 단위의 차이같다고하심 .. importance(model3) 이거를 주로 사용하라고하심>

varImpPlot(model3) # 중요한변수를 한눈에 볼수있게 해줌 

0.036757480+0.008062215+0.343461372+0.326534703


###########################
## 회귀 tree
###########################
library(MASS)
data("Boston")
str(Boston)
#crim : 도시 1인당 범죄율 
#zn : 25,000 평방피트를 초과하는 거주지역 비율
#indus : 비상업지역이 점유하고 있는 토지 비율  
#chas : 찰스강에 대한 더미변수(1:강의 경계 위치, 0:아닌 경우)
#nox : 10ppm 당 농축 일산화질소 
#rm : 주택 1가구당 평균 방의 개수 
#age : 1940년 이전에 건축된 소유주택 비율 
#dis : 5개 보스턴 직업센터까지의 접근성 지수  
#rad : 고속도로 접근성 지수 
#tax : 10,000 달러 당 재산세율 
#ptratio : 도시별 학생/교사 비율 
#black : 자치 도시별 흑인 비율 
#lstat : 하위계층 비율 
#medv(y) : 소유 주택가격 중앙값 (단위 : $1,000)

ntree <- 500
p <- 13 # y 변수를 제외한 x변수 갯수
mtry <- 1/3 * p
mtry # 4.333333 (4 or 5) <5로 선택>

boston_model <- randomForest(medv ~ ., data = Boston, 
                             ntree=500, mtry=5, 
                             importance=T)
boston_model
# Type of random forest: regression
#                     Number of trees: 500
# No. of variables tried at each split: 5
# Mean of squared residuals: 9.884753 <표준화를 안했기에 0~1사이로 안나옴>  <mse 값이랑 같음>
# % Var explained: 88.29  <88% 정도 예측> 
names(boston_model) # 18개의 이름들
importance(boston_model)
varImpPlot(boston_model) # rm,lstat 가 영향력이 큼 
boston_model$importance # 중요도 수치 < 왜 위에랑 다른지..?>

y_pred <- boston_model$predicted # 예측값
y_pred
y_true <- boston_model$y # 정답값
y_true
err <- y_true - y_pred
err
mse <- mean(err**2)
mse # 9.884753 <Mean of squared residuals 랑 같음>

# 표준화(x)
cor(y_true, y_pred) # 0.9417967 <1에 가까울수록 상관관계가 높다 정답이랑 비슷하다> 



#############################
## 분류 tree 
#############################

titanic <- read.csv(file.choose())
str(titanic)

titanic_df <- titanic[,c(-3,-8,-10,-12,-13,-14)]

titanic_df$survived <- factor(titanic_df$survived, levels = c("0","1"))

idx <- sample(nrow(titanic_df), 0.7*nrow(titanic_df))
tit_train <- titanic_df[idx,]
tit_test <- titanic_df[-idx,]

ntree <- 500
mtry <- round(sqrt(7))
mtry # 3
 
ran_model <- randomForest(survived ~ ., data = titanic_df, 
                          ntree=400, mtry=3, 
                          importance=T,
                          na.action = na.omit)
ran_model
varImpPlot(ran_model)

# 중요변수 : sex > pclass > age > fare ...


##############################
## entropy : 불확실성 척도 
##############################

# - tree model에서 중요 변수 선정 기준 < log의 밑을 2 로 한다. > 
# y의 중요도를 선정할때 사용한다. 앤트로피가 높을수록 불확실성이 높아진다. 

# 1. (동전의) x1 : 앞면 , x2 : 뒷면 -> 불확실성이 가장 높은 경우 (반반)
x1 = 0.5
x2 = 0.5
e1 <- (-x1 * log2(x1)) - (x2 * log2(x2)) # log의 밑을 2 로 두었다.
e1 # 1 

# 2. x1 = 0.9 , x2 = 0.1 일때
x1 = 0.9
x2 = 0.1
e2 <- -x1 * log2(x1) - x2 * log2(x2)
e2 # 0.4689956 
e2 <- -(x1 * log2(x1) + x2 * log2(x2)) # 위아래 결과 같다. 
e2 # 0.4689956


# 밑을 생략할경우 답이 다르게 나와서 쓸수없다. 
e <- exp(1)
e # 2.718282  < log 의 밑수는 e 로 되어있다.>
E <- (-x1 * log(x1)) - (x2 * log(x2))
E # 0.6931472














