# chap07_EDA_Preprocessing 

# 1. 탐색적 데이터 조회

# 실습 데이터 읽어오기
setwd("C:/ITWILL/2_Rwork/Part-II")
dataset <- read.csv("dataset.csv", header=TRUE) # 헤더가 있는 경우
# dataset.csv - 칼럼과 척도 관계 


# 1) 데이터 조회
# - 탐색적 데이터 분석을 위한 데이터 조회 

# (1) 데이터 셋 구조
names(dataset) # 변수명(컬럼)
attributes(dataset) # names(), class, row.names
str(dataset) # 데이터 구조보기
dim(dataset) # 차원보기 : 300 7
nrow(dataset) # 관측치 수 : 300
length(dataset) # 칼럼수 : 7 
length(dataset$resident) # 300

# (2) 데이터 셋 조회
# 전체 데이터 보기
dataset # print(dataset) 
View(dataset) # 뷰어창 출력

# 칼럼명 포함 간단 보기 
head(dataset)
head(dataset, 10) 
tail(dataset) 

# (3) 칼럼 조회 
# 형식) dataframe$칼럼명   
dataset$resident
length(dataset$age) # data 수-300개 

# 형식) dataframe["칼럼명"] 
dataset["gender"] 
dataset["price"]

# $ vs index
res <- dataset$resident # $
res2 <- dataset['resident'] # index
str(res) # int [1:300] - vector
str(res2) # 'data.frame': 
dim(res2) # 300   1 -> data.frame


# 형식) dataframe[색인] : 색인(index)으로 원소 위치 지정 
dataset[2] # 두번째 컬럼 : dataset['gender']
dataset[6] # 여섯번째 컬럼
dataset[3,] # 3번째 관찰치(행) 전체
dataset[,3] # 3번째 변수(열) 전체 : dataset$job
dataset[3] # 3번째 변수(열) 전체 : dataset['job']

# dataset에서 2개 이상 칼럼 조회
names(dataset)
dataset[c("job", "price")]
dataset[c("job":"price")] # error 
dataset[c(3:6)]
dataset[c(2,6)] 

dataset[c(1,2,3)] 
dataset[c(1:3)] 
dataset[c(2,4:6,3,1)] 
dataset[-c(2)] # dataset[c(1,3:7)] 


# 2. 결측치(NA) 발견과 처리
# 9999999 - NA

# 결측치 확인 
summary(dataset$price)

table(is.na(dataset$price)) # 특정 칼럼 
# FALSE  TRUE 
#   270    30

table(is.na(dataset)) # 전체 칼럼 
# FALSE  TRUE 
#  1982   118

# 1) 결측치 제거 
price2 <- na.omit(dataset$price) # 특정 칼럼 
length(price2) # 270

dataset2 <- na.omit(dataset) # 전체 칼럼 
dim(dataset2) # 209   7

# 특정 칼럼 기준 결측치 제거 -> subset 생성 
stock <- read.csv(file.choose()) # Part-I/stock.csv
str(stock)
# 'data.frame':	6706 obs. of  69 variables:
# Market.Cap : 시가총액 

library(dplyr)
stock_df <- stock %>% filter(!is.na(Market.Cap))
dim(stock_df) # 5028   69

stock_df2 <- subset(stock, !is.na(Market.Cap))
dim(stock_df2) # # 5028   69

# 2) 결측치 처리(0으로 대체)
x <- dataset$price
dataset$price2 <- ifelse(is.na(x), 0, x)

# 3) 결측치 처리(평균으로 대체)
dataset$price3 <- ifelse(is.na(x), mean(x, na.rm = T), x)

dim(dataset) # 300   9

head(dataset[c('price','price2','price3')],30)

# 4) 통계적 방법의 결측치 처리 
# ex) 1~4 : age 결측치 -> 각 학년별 평균으로 대체 
age <- round(runif(n=12, min=20, max =25))
age
grade <- rep(1:4, 3)
grade

age[5] <- NA
age[8] <- NA

DF <- data.frame(age, grade)
DF

# age 칼럼 대상 학년별 결측치 처리 -> age2 만들기 
n <- nrow(DF)
g1=0;g2=0;g3=0;g4=0 # 학년별 누적 
for(i in 1:n){ # i = index
   if(DF$grade[i]==1 & !is.na(DF$age[i])){
      g1 = g1 + DF$age[i]
   }else if(DF$grade[i]==2 & !is.na(DF$age[i])){
      g2 = g2 + DF$age[i]
   }else if(DF$grade[i]==3 & !is.na(DF$age[i])){
      g3 = g3 + DF$age[i]
   }else if(DF$grade[i]==4 & !is.na(DF$age[i])){
      g4 = g4 + DF$age[i]
   }
}

# 각 학년별 나이 합계 
g1;g2;g3;g4
tab <- table(DF$grade)
age2 <- age
for(i in 1:n){
   if(is.na(DF$age[i]) & DF$grade[i]==1)
     age2[i] <- g1/2
   if(is.na(DF$age[i]) & DF$grade[i]==2)
     age2[i] <- g2/2
   if(is.na(DF$age[i]) & DF$grade[i]==3)
     age2[i] <- g3/2
   if(is.na(DF$age[i]) & DF$grade[i]==4)
     age2[i] <- g4/2
}
age2
DF$age2 <- round(age2)
DF

# 3. 이상치(outlier) 발견과 정제 
# - 정상 범주에서 크게 벗어난 값

# 1) 범주형(집단) 변수 
gender <- dataset$gender
gender

# 이상치 발견 : table(), 차트 
table(gender)
#0   1   2   5 
#2 173 124   1
pie(table(gender))

# 이상치 정제 
dataset <- subset(dataset, gender==1 | gender==2)

pie(table(dataset$gender))

# 2) 연속형 변수 
price <- dataset$price
length(price)
plot(price)
summary(price)

# 2~10 정상 범주 
dataset2 <- subset(dataset, price >=2 & price <= 10)
dim(dataset2) # 248 7
plot(dataset2$price)
boxplot(dataset2$price)

# dataset2 : age(20~69)
dataset2 <- subset(dataset2, age >= 20 & age <= 69)
boxplot(dataset2$age)

# 3) 이상치 발견이 어려운 경우 
boxplot(dataset$price)$stats
#  정상범주에서 상하위 0.3% 

re <- subset(dataset, price >= 2.1 & price <= 7.9)
boxplot(re$price)

# [실습]
library(ggplot2)
str(mpg) # 234

hwy <- mpg$hwy
length(hwy)

boxplot(hwy)$stats

# 정제 방법1) 제거 
mpg_df <- subset(mpg, hwy >= 12 & hwy <= 37)
boxplot(mpg_df$hwy)
dim(mpg_df) # 231  11

# 정제 방법2) NA 처리 
mpg$hwy2 <- ifelse(mpg$hwy < 12 | mpg$hwy > 37, NA, mpg$hwy)
mpg_df <- as.data.frame(mpg)

mpg_df[c('hwy', 'hwy2')]


# 4. 코딩 변경 
# - 데이터 가독성, 척도 변경, 최초 코딩 내용 변경 

# 1) 데이터 가독성(1,2)
# 형식) dataset$새칼럼[조건식] <- "값"
dataset$gender2[dataset$gender==1] <- "남자"
dataset$gender2[dataset$gender==2] <- "여자"

head(dataset)

head(dataset2)
dataset2$resident2[dataset2$resident==1]<- "1.서울특별시"
dataset2$resident2[dataset2$resident==2]<- "2.인천광역시"
dataset2$resident2[dataset2$resident==3]<- "3.대전광역시"
dataset2$resident2[dataset2$resident==4]<- "4.대구광역시"
dataset2$resident2[dataset2$resident==5]<- "5.시구군"

# 2) 척도 변경 : 연속형 -> 범주형 
range(dataset2$age) # 20 69
# 20~30 : 청년층, 31~55 : 중년층, 56~ : 장년층 
dataset2$age2[dataset2$age <= 30] <- "청년층"
dataset2$age2[dataset2$age > 30 & dataset2$age <=55] <- "중년층"
dataset2$age2[dataset2$age > 55] <- "장년층"
head(dataset2)

# 3) 역코딩 : 1->5, 5->1
table(dataset2$survey)
#  1  2  3  4  5 
# 15 91 93 27  6 

survey <- dataset2$survey
csurver <- 6 - survey # 역코딩 
dataset2$survey <- csurver

table(dataset2$survey)
#1  2  3  4  5 
#6 27 93 91 15 

# 5. 탐색적 분석을 위한 시각화 
# - 변수 간의 관계분석 

setwd("c:/ITWILL/2_Rwork/Part-II")

new_data <- read.csv("new_data.csv")
dim(new_data) # 231  15
str(new_data)

# 1) 범주형(명목/서열) vs 범주형(명목/서열) 
# - 방법 : 교차테이블, barplot, mosaicplot

# 거주지역(5) vs 성별(2) 
tab1 <- table(new_data$resident2, new_data$gender2)
tab1

tab2 <- table(new_data$gender2, new_data$resident2)
tab2

barplot(tab1, beside = T, horiz = T,
        col=rainbow(5), 
        main = "성별에 따른 거주지역 분포 현황",
        legend = row.names(tab1))

barplot(tab2, beside = T, horiz = T,
        col=rainbow(2), 
        main = "거주지역에 따른 성별에 분포 현황",
        legend = row.names(tab2))

# 정사각형 기준 
mosaicplot(tab1, col=rainbow(5),
           main = "성별에 따른 거주지역 분포 현황")

# 고급시각화 : 직업유형(범주형) vs 나이(범주형)
library(ggplot2) # chap08

# 미적 객체 생성 
obj <- ggplot(data = new_data, aes(x=job2, fill=age2))
# 막대차트 추가 
obj  + geom_bar()

# 막대차트 추가 : 밀도 1기준 채우기 
obj  + geom_bar(position = "fill")

table(new_data$job2, new_data$age2, useNA = "ifany")

# 2) 숫자형(비율/등간) vs 범주형(명목/서열) 
# - 방법 : boxplot, 카테고리별 통계 

install.packages("lattice") # chap08
library(lattice) # 격자 


# 나이(비율) vs 직업유형(명목)
densityplot( ~ age, groups = job2, 
             data = new_data,
             auto.key = T)

# groups = 집단변수 : 각 격자 내에 그룹 효과 
# auto.key = T : 범례 추가 

# 3) 숫자형(비율) vs 범주형(명목) vs 범주형(명목)

# (1) 구매금액을 성별과 직급으로 분류 
densityplot(~ price | factor(gender2),
            groups = position2, 
            data = new_data,
            auto.key = T)

# | factor(집단변수) : 범주의 수 만큼 격자 생성 
# groups = 집단변수 : 각 격자 내의 그룹 생성 

# (2) 구매금액을 직급과 성별로 분류 
densityplot(~ price | factor(position2),
            groups = gender2, 
            data = new_data,
            auto.key = T)

# 4) 숫자형 vs 숫자형 or 숫자형 vs 숫자형 vs 범주형 
# - 방법 : 상관계수, 산점도, 산점도 행렬 

# (1) 숫자형(age) vs 숫자형(price) 
cor(new_data$age, new_data$price) # NA

new_data2 <- na.omit(new_data)
cor(new_data2$age, new_data2$price)
# 0.0881251 : +-0.3~0.4 이상
plot(new_data2$age, new_data2$price)


# (2) 숫자형 vs 숫자형 vs 범주형(성별) 
xyplot(price ~ age | factor(gender2), 
       data = new_data)

# 6) 파생변수 생성 
# - 기존 변수 -> 새로운 변수 
# 1. 사칙연산 
# 2. 1:1 : 기존칼럼 -> 새로운 칼럼(1) 
# 3. 1:n : 기준변수 -> 새로운 칼럼(n)

# 고객정보 테이블 
user_data <- read.csv("user_data.csv")
str(user_data)

# 1) 1:1 : 기존칼럼 -> 새로운 칼럼(1)
# 더미변수 : 1,2 -> 1, 3,4 -> 2
tmp <- ifelse(user_data$house_type==1 | user_data$house_type==2, 1, 2)
user_data$house_type2 <- tmp
table(user_data$house_type2)
# 1   2 
#79 321 

# 2)  1:n : 기준변수 -> 새로운 칼럼(n)
# 지불정보 테이블 
pay_data <- read.csv("pay_data.csv")
str(pay_data)
names(pay_data)
# "user_id" "product_type" "pay_method" "price"(비율)

library(reshape2)
# dcase(dataset, 행집단변수~열집단변수, func)
# long -> wide

# 고객별 상품유형에 따른 구매금액 합계 
product_price <- dcast(pay_data, 
                       user_id ~ product_type, sum)
product_price
dim(product_price) # 303   6

names(product_price) <- c("user_id", "식료품(1)","생필폼(2)",
                          "의류(3)", "잡화(4)", "기타(5)")
head(product_price)

# 3) 파생변수 추가(join) 
library(dplyr)

# 형식) left_join(df1, df2, by='column')
user_pay_data <- left_join(user_data, product_price, by="user_id")
dim(user_pay_data) # 400  11
head(user_pay_data)


# 4) 사칙연산 : 총구매금액 
names(user_pay_data)
#user_pay_data$`식료품(1)` or user_pay_data[,7]
tot_price <- user_pay_data$`식료품(1)`+user_pay_data[,8]+user_pay_data[,9]+user_pay_data[,10]+user_pay_data[,11]
user_pay_data$tot_price <- tot_price
dim(user_pay_data)
str(user_pay_data)
head(user_pay_data)




