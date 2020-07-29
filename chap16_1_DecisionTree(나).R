# chap16_1_DecisionTree

install.packages('rpart')
library(rpart) # rpart() : 분류모델 생성 
install.packages("rpart.plot")
library(rpart.plot) # prp(), rpart.plot() : rpart 시각화
install.packages('rattle')
library('rattle') # fancyRpartPlot() : node 번호 시각화 


# 단계1. 실습데이터 생성 
data(iris)
set.seed(415)
idx = sample(1:nrow(iris), 0.7*nrow(iris))
train = iris[idx, ]
test = iris[-idx, ]
dim(train) # 105 5
dim(test) # 45  5
names(iris)

table(train$Species)

# 단계2. 분류모델 생성 
# rpart(y변수:범주형 ~ x변수:연속형 , data)
model = rpart(Species~., data=train) # iris의 꽃의 종류(Species) 분류 
model
# 1) root 105 68 setosa (0.35238095 0.31428571 0.33333333)  <시작노드>
# 2) Petal.Length< 2.45 37  0 setosa (1.00000000 0.00000000 0.00000000) * 
# 3) Petal.Length>=2.45 68 33 virginica (0.00000000 0.48529412 0.51470588)  
# 6) Petal.Width< 1.75 35  2 versicolor (0.00000000 0.94285714 0.05714286) *
# 7) Petal.Width>=1.75 33  0 virginica (0.00000000 0.00000000 1.00000000) *
# 우선 2) 으로 먼저 분류하고 나머지 3) 을 6) 과 7) 로 분류한다.
# 2) 밑으로 자식이 4),5) 가생겨야되는데 2)에서 끝나서 4),5) 없는듯?
# <*표시는 더이상 밑으로 내려가지않는다는뜻>
# x변수 분류해주는것 names() 4개인데 그중 3번4번 사용 해서 나온결과 y 

# 1) root 105 68 setosa (0.35238095 0.31428571 0.33333333)
# root node : 전체크기(105), 오분류(68)개, 주 label = setosa(37)  
# 분류비율 : setosa 35% , versicolor 31%, virginica 33% 
# 2) Petal.Length< 2.45 37  0 setosa (1.00000000 0.00000000 0.00000000) * 
# left node : 분류조건-> 분류대상(37개) 오분류(0개) 주 lable(37-0=37개) (각label별 비율)
# 3) Petal.Length>=2.45 68 33 virginica (0.00000000 0.48529412 0.51470588)
# right node : 분류조건-> 분류대상(68개) 오분류(33개) 주 lable(68-33=35개) (각label별 비율)

# 분류모델 시각화 - rpart.plot 패키지 제공 
prp(model) # 간단한 시각화   
rpart.plot(model) # rpart 모델 tree 출력
fancyRpartPlot(model) # node 번호 출력(rattle 패키지 제공)

##########################
## 가지치기(cp:cut prune)
##########################
# 트리의 가지치기 : 과적합 문제 해결법
# cp : 0 ~ 1, default = 0.05
# 0으로 갈수록 트리 커짐, 오류율 감소, 과적합 증가 
# < 이게 아마 6) 에서 더 안내려간이유? 과적합이 발생할까봐? > 
model$cptable
#          CP  nsplit   rel error      xerror        xstd
# 1 0.5147059       0  1.00000000  1.11764706  0.06737554
# 2 0.4558824       1  0.48529412  0.57352941  0.07281162
# 3 0.0100000       2  0.02941176  0.02941176  0.02059824  -> 가장 적은 오류율
# 3번에서 과적합 발생시 2번으로 조정 

# 단계3. 분류모델 평가  
pred1 <- predict(model, test) # 생략시 비율 예측 
pred2 <- predict(model, test, type="class") # type="class" : 분류 예측 <이해하기쉽다>

table(pred1)
# 0    0.0571428571428571    0.942857142857143                  1<1은 100% 예측> 
# 71                   19                   19                 26 

# 1) 분류모델로 분류된 y변수 보기 <예측>
table(pred2)
# setosa  versicolor  virginica 
#     13          19         13 

table(test$Species)
# 2) 분류모델 성능 평가  < 정답과예측비교 >
table(test$Species, pred2)
# pred2        setosa  versicolor  virginica
# setosa           13          0          0
# versicolor       0          16          1
# virginica        0           3         12

# 분류정확도
(13+16+12) / nrow(test) # 0.9111111  <91%>



##################################################
# Decision Tree 응용실습 : 암 진단 분류 분석
##################################################
# "wdbc_data.csv" : 유방암 진단결과 데이터 셋 분류

# 1. 데이터셋 가져오기 
wdbc <- read.csv('C:/ITWILL/2_Rwork/Part-IV/wdbc_data.csv', 
                 stringsAsFactors = FALSE) # factor형으로안한다고했으므로 이따 변환해줘야됌
str(wdbc)

# 2. 데이터 탐색 및 전처리 
wdbc <- wdbc[-1] # id 칼럼 제외(이상치) 
head(wdbc)
head(wdbc[, c('diagnosis')], 10) # 진단결과 : B -> '양성', M -> '악성'

# 목표변수(y변수)를 factor형으로 변환 
wdbc$diagnosis <- factor(wdbc$diagnosis, levels = c("B", "M")) # 0,1 더미변수생성
wdbc$diagnosis[1:10]
str(wdbc) # 보면 factor형으로 바뀌어짐

summary(wdbc) # 30개 모든변수가 범위가달라서 편향을가지고있으므로 정규화(0~1)시켜줘야한다. 

# 3. 정규화  : 서로 다른 특징을 갖는 칼럼값 균등하게 적용 
normalize <- function(x){ # 정규화를 위한 함수 정의 
  return ((x - min(x)) / (max(x) - min(x)))
}

# wdbc[2:31] : x변수에 해당한 칼럼 대상 정규화 수행 
wdbc_x <- as.data.frame(lapply(wdbc[2:31], normalize))
wdbc_x
summary(wdbc_x) # 0 ~ 1 사이 정규화 
class(wdbc_x) # [1] "data.frame"
nrow(wdbc_x) # [1] 569
dim(wdbc_x) # 569 30 

# 첫번째컬럼(diagnosis)빼고 정규화했으니까 다시 합쳐줘야함 
wdbc_df <- data.frame(wdbc$diagnosis, wdbc_x)
dim(wdbc_df) # 569  31
head(wdbc_df)

# 4. 훈련데이터와 검정데이터 생성 : 7 : 3 비율 
idx = sample(nrow(wdbc_df), 0.7*nrow(wdbc_df))
wdbc_train = wdbc_df[idx, ] # 훈련 데이터 
wdbc_test = wdbc_df[-idx, ] # 검정 데이터 
dim(wdbc_train) # 398 31 
dim(wdbc_test) # 171 31

# 5. rpart 분류모델 생성 
model <- rpart(wdbc.diagnosis ~ ., data = wdbc_train)
model
# 1) root 398 146 B (0.63316583 0.36683417)  
#   2) perimeter_worst< 0.2773544 247  11 B (0.95546559 0.04453441) *
#   3) perimeter_worst>=0.2773544 151  16 M (0.10596026 0.89403974)  
#     6) points_mean< 0.2371024 18   6 B (0.66666667 0.33333333) *
#     7) points_mean>=0.2371024 133   4 M (0.03007519 0.96992481) *

rpart.plot(model)


# 6. 분류모델 평가  
y_pred <- predict(model, wdbc_test, type = 'class')
y_true <- wdbc_test$wdbc.diagnosis

table(y_true, y_pred)
# y_pred
# y_true   B  M
#      B  99  6
#      M  14 52

# 분류정확도 88%
(99+52) / nrow(wdbc_test) # 0.8830409 

# 악성 예측 (재현율)
52 / (52+14) # 0.7878788 

#  양성 예측 (특이도)
99 / (99+6) # 0.9428571


# 비율로보기 
y_pred <- predict(model, wdbc_test)
head(y_pred)
#            B          M
# 3  0.95546559 0.04453441   양성일확률 95% 악성일경우 4%
# 5  0.95546559 0.04453441
# 9  0.95546559 0.04453441
# 11 0.03007519 0.96992481
# 21 0.95546559 0.04453441
# 23 0.95546559 0.04453441

# 보기쉽게 0,1 로 <y_pred[,1] = B 의미한다.>
y_pred <- ifelse(y_pred[,1] >= 0.5, 0, 1)
head(y_pred)
# 3  5  9 11 21 23 
# 0  0  0  1  0  0 
# 이걸 실제 정답이랑 비교해보면된다. 



################################
## 교차검정
################################

# 단계1 : k겹 교차검정을 위한 샘플링
install.packages("cvTools")
library(cvTools)

?cvFolds
# cvFolds(n, K = 5, R = 1, type = c("random", "consecutive", "interleaved"))
# n= 갯수 , K= 나눌수(몇그룹으로), R= 몇세트만들지

# K= 3 : d1=50, d2=50, d3=50
cross <- cvFolds(n=nrow(iris), K=3, R=1, type = "random")
cross # Fold(dataset)   Index(row)
str(cross)
# 150개 , 3묶음씩, 1세트, index숫자, 어디그룹인지 

# 기계학습 
# 두개를골라 훈련하고 남은하나로 검정해서 모든 set를 검정으로 해봄

# set1 
d1 <- cross$subsets[cross$which==1, 1] # [k, r]
d1
length(d1) # 50
# set2
d2 <- cross$subsets[cross$which==2, 1]
d2
length(d2) # 50
# set3
d3 <- cross$subsets[cross$which==3, 1]
d3
length(d3) # 50

# 일일히 하지않고 한번에 가능하게 
K <- 1:3
R <-1
# 반복 하게 만드는 for문 안에거부터 반복하고 밖에거 반복 
for(r in R){ # set = 열 index
  for(k in K){ # k겹 = 행 index
    idx <- cross$subsets[cross$which==k, r]
    cat('K=',k,'\n')
    print(idx)
  }
}
# K= 1 
# [1]  89 149 147  44 121  88  27 131  98  64  87  83   5 140  96  58 120  85
# [19] 139  42  28  30  39  20  46  32 128 123  80  62  71 105  34  92  29  86
# [37]  15   8  41 126 138  49  26  23  47  24  72 127  70  10
# K= 2 
# [1] 129 117 106  51  60  31  25  95  11 111 142  35  67   2  48 141  37   4
# [19] 110  93  97  59 115  55  78  19 148   7  74 102  66 135  12  16  53 101
# [37] 133 108  63 109  82 116  52 122 136 132   6 107  68  14
# K= 3 
# [1]  65 119  75   3  22 113 150 103  56 146 114  54 104  13  33  45 134  69
# [19] 112   1  17 130  21  40  38  90  91 124  73  76  50 137 144 145  84  99
# [37]  43  79  81 118  36 100  61 143  77  18  94 125  57   9


# R을 2까지 해보기
K <- 1:3 # k겹
R <-1:2  # set
# 반복 하게 만드는 for문 안에거부터 반복하고 밖에거 반복 
for(r in R){ # set = 열 index
  cat('R=',r,'\n')
  for(k in K){ # k겹 = 행 index
    idx <- cross$subsets[cross$which==k, r]
    cat('K=',k,'\n')
    print(idx)
  }
}
# 오류 위에서 R 을 1로 만들었기때문 


# 다시 해보기 
cross <- cvFolds(n=nrow(iris), K=3, R=2, type = "random")
K <- 1:3 # k겹
R <-1:2  # set
# 반복 하게 만드는 for문 안에거부터 반복하고 밖에거 반복 
for(r in R){ # set = 열 index (2회전)
  cat('R=',r,'\n')
  for(k in K){ # k겹 = 행 index (3회전)
    idx <- cross$subsets[cross$which==k, r]
    cat('K=',k,'\n')
    print(idx)
  }
}
# R= 1 
# K= 1 
# [1]  96  49  42  65  81  99  59 125  62 105 112  17 126 135  11  84  98 138
# [19]  86  14 119 104  91  97  88  76  54 149 143  68 103  75 111  64 134  93
# [37]  69  94 145  66  20   7  34  70 147 146 110 132  60 113
# K= 2 
# [1] 127  39  43  46 117 129  67  56   8   6 102  90 131 122  41  89 121  16
# [19]  52   2  44  78 144 150  21 141 107   1  82   3 115 133 140 124  31 109
# [37]  27  18  73 100 148  47  57 108  72  85 106   4  83 142
# K= 3 
# [1]  40  28 136 137  12  26  74 116  36  29 120  79  23  55  80  32 128  24
# [19]  61  58  22  48 114  10  37 118  30   5  25  45  51 130  50  87  33  92
# [37]  95  19  63  77  71  38  53 139 123  13   9 101  15  35
# R= 2 
# K= 1 
# [1]  37   3 149 111  59  48 124 135 107  47   5  58  34  98   4  40  55 123
# [19]  28  42  94  85 147  79 101 118 112 128 100 105  50  20  71  97 145  26
# [37]  77   7 143 106  74 126 122   9  63 120  35 127   6  81
# K= 2 
# [1]  57  80 136  88  33  30   8  24  27  69   1  72  70  75 140 102 119  73
# [19] 104 116 132  64  62  38  32  83  51  12  29  78 110 114  14  36  11 141
# [37] 130  92  96 142  46  45 117 129  21  16 148 138  87  66
# K= 3 
# [1]  52 103 150  15 125  44  61  13  93  90  10  18  22  56  76  54  25 108
# [19] 131  19  86  67  43  95  65  31  68 144  60  39  89 115  49  82 134   2
# [37]  99 113 109  84 139  91  41  23 146 121 137  17  53 133



# 이제 확인했으니까 학습을 위해 다시 원래대로 해서 쭉 해보기 
cross <- cvFolds(n=nrow(iris), K=3, R=1, type = "random") 
K <- 1:3 # k겹
R <-1    # set
ACC <- numeric()
cnt <- 1

# for문으로 완성하기 
for(r in R){ # set = 열 index
  cat('R=',r,'\n')
  for(k in K){ # k겹 = 행 index
    idx <- cross$subsets[cross$which==k, r]
    # cat('K=',k,'\n')
    # print(idx)
    test <- iris[idx,] # 검정용(50)
    train <- iris[-idx,] # 훈련용(100)
    model <- rpart(Species~ ., data = train) # 모델링 
    pred <- predict(model, test, type = 'class') # 예측치
    tab <- table(test$Species, pred) # 교차분할표생성 
    ACC[cnt] <- (tab[1,1]+tab[2,2]+tab[3,3]) / sum(tab)
    cnt <- cnt + 1 # 카운터
  }
}

ACC # 0.96 0.98 0.94
mean(ACC) # 0.96





