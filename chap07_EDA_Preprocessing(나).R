# chap07_EDA_Preprocessing

# txt 붙여넣기



# 1. 탐색적 데이터 조회



# 실습 데이터 읽어오기
setwd("C:/ITWILL/2_Rwork/part-II")
dataset <- read.csv("dataset.csv", header=TRUE) # 헤더가 있는 경우
head(dataset)
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
length(dataset$resident) # 특정컬럼의행갯수:300

# (2) 데이터 셋 조회
# 전체 데이터 보기
dataset # print(dataset) 
View(dataset) # 뷰어창 출력 <filter기능>

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

# $ vs [] 
res1 <- dataset$resident # $
res1
str(res1) # int [1:300] vector
dim(res1) # NULL
res2 <- dataset['resident'] # [] index
res2
str(res2) # 'data.frame'
dim(res2) # 300   1

# 형식) dataframe[색인] : 색인(index)으로 원소 위치 지정 
dataset[2] # 두번째 컬럼 = dataset['gender']  <모양만다름 vector vs data.frame>
dataset[6] # 여섯번째 컬럼
dataset[3,] # 3번째 관찰치(행) 전체
dataset[,3] # 3번째 변수(열) 전체 = dataset$job
dataset[3] #  3번째 변수(열) 전체 = dataset['job']

# dataset에서 2개 이상 칼럼 조회
dataset[c("job", "price")]
dataset[c(2,6)] 
dataset[c(3:6)]
dataset[c("job":"price")] # error  < : 은 숫자만>

dataset[c(1,2,3)] # 두개 동일
dataset[c(1:3)]

dataset[c(2,4:6,3,1)] 
dataset[-c(2)] # = dataset[c(1,3:7)] 



# 2. 결측치(NA) 발견과 처리



# 결측치 확인
summary(dataset$price) # 마지막에 NA나옴
#    Min.    1st Qu.   Median   Mean    3rd Qu.   Max.      NA's 
# -457.200    4.425    5.400    8.752    6.300   675.000    30 
table(is.na(dataset$price)) # 특정 컬럼  <TRUE값이 NA 갯수>
# FALSE  TRUE 
# 270    30
table(is.na(dataset))  # 전체 컬럼   <TRUE값이 NA 갯수>
# FALSE  TRUE 
# 1982   118


# 1) 결측치 제거


# 특정 칼럼
length(dataset$price) # 300
price2 <- na.omit((dataset$price)) # 특정 칼럼
length(price2) # 270
dim(price2) # NULL
# 전체 칼럼
dataset2 <- na.omit(dataset)
length(dataset2) # 7
dim(dataset2) # 209 7

# 특정 칼럼 기준 결측치 제거 -> subset 생성
stock <- read.csv(file.choose()) # part-I/stock.scv
stock
str(stock) # 'data.frame':	6706 obs. of  69 variables:
dim(stock) # 6706   69
# Market.Cap : 시가총액
library(dplyr)
stock_df <- stock %>% filter(!is.na(Market.Cap))
stock_df
dim(stock_df) # 5028   69
# 위아래 동일
stock_df2 <- subset(stock, !is.na(Market.Cap))
dim(stock_df2) # 5028   69


# 2) 결측치 처리(0으로 대체)


x <- dataset$price
dataset$price2 <- ifelse(is.na(x), 0, x) #새로운 칼럼생성
dim(dataset) # 300   8


# 3) 결측치 처리(평균으로 대체)


dataset$price3 <- ifelse(is.na(x), mean(x, na.rm = T), x)
dim(dataset) # 300   9
# 결측치 처리 확인
head(dataset[c('price', 'price2', 'price3')],30)
# 28번째         NA        0.0     8.751481 확인


# 4) 통계적 방법의 결측치 처리


# ex) 1~4 : age 결측치 -> 각학년별 평균으로 대체
age <- round(runif(n = 12, min = 20, max = 25))
age
grade <- rep(1:4, 3)
grade
# 결측치 생성
age[5] <- NA
age[8] <- NA
DF <- data.frame(age, grade)
DF
# age 칼럼 대상 학년별 결측치 처리 -> age2 만들기
##############내가한풀이#################
is.na(age)
is.na(DF)
is.na(age,mean(),age)
age

ifelse(is.na(age), round(mean()), age)

#시작
num1 <- filter(DF, is.na(age))
num1

num1[1,]
num1[2,]

# numi <- select(num1[i,], grade)
select(num1[1,], grade) # 1
select(num1[2,], grade)


as.numeric(select(num1[1,], grade))

5*as.numeric(select(num1[1,], grade))


ifelse(is.na(age), round(mean(as.numeric(select(num1[1,], grade)))), age)



# 3. 이상치(outlier) 발견과 정제 
# -정상 범주에서 크게 벗어난 값



# 1) 범주형(집단) 변수


gender <- dataset$gender
gender
length(gender)

# 이상치 발견 : table(), 차트(pie)
table(gender)
# 0   1    2   5 
# 2  173  124  1 
pie(table(gender))

# 이상치 정제
dataset2 <- subset(dataset, gender == 1 | gender == 2) 
table(dataset2$gender)
#  1    2 
# 173  124 
pie(table(dataset2$gender))


# 2) 연속형 변수


price <- dataset$price
price
length(price)
summary(price)
dim(dataset) # 300   9

# 이상치 발견 : 차트(plot)
plot(price)

# 이상치 정제 : 2 ~ 10 정상 범주
dataset3 <- subset(dataset, price >= 2 & price <= 10)
dataset3$price
dim(dataset3) # 251   9
plot(dataset3$price) 
mean(dataset3$price) # 5.360558

# 예제)나이를 대상으로 해보기 dataset3 : age(20~69)
age <- dataset3$age
age
dataset4 <- subset(dataset3, age >= 20 & age <= 69)
dataset4
dim(dataset4) # 235   9


# 3) 이상치 발견이 어려운 경우
boxplot(dataset$price) # 이상치가 눈에 보임 < stats : 정상범주에서 상하위 0.3%>
par(mfrow=c(1,2))
boxplot(dataset$price)$stats # 하한값 2.1 ~ 상한값 7.9 까지 정상범위 < 선으로보이는걸 확대하면 상자임>
subset5 <- subset(dataset, price >= 2.1 & price <= 7.9) # 이상치정제
dim(subset5) # 251   9
boxplot(subset5$price)$stats # 위에 그래프를 확대한것
par(mfrow=c(1,2))

# 실습) 
library(ggplot2)
str(mpg) # 234 obs. of  11 variables
hwy <- mpg$hwy
length(hwy) # 234 
boxplot(hwy)$stats # 하한값:12 ~ 상한값:37 까지

# 정제 방법 1) 제거 
mpg_df <- subset(mpg, hwy >= 12 & hwy <= 37)
str(mpg_df) # 231 obs. of  11 variables
###내가하는연습 <점이 두개인데 3개가 사라졌다>
mpg_dsds <- subset(mpg, hwy < 12 | hwy > 37) 
mpg_dsds$hwy # 44 44 41   < 44가 두개여서 점이 두개로 보였음>

# 정제 방법 2) NA 처리
mpg$hwy2 <- ifelse(mpg$hwy < 12 | mpg$hwy > 37, NA, mpg$hwy)
mpg$hwy2
mpg <- as.data.frame(mpg)
mpg[c('hwy', 'hwy2')]



# 4. 코딩 변경 
# - 데이터 가독성, 척도 변경, 최초 코딩 내용 변경 



# 1) 데이터 가독성(1,2)


# 형식) dataset$새칼럼[조건식] <- "값"
dataset$gender2[dataset$gender==1] <- "남자"
dataset$gender2[dataset$gender==2] <- "여자"
dataset %>% head()

dataset2 %>% head()
dataset2$resident2[dataset2$resident==1] <- "1.서울특별시"
dataset2$resident2[dataset2$resident==2] <- "2.인천광역시"
dataset2$resident2[dataset2$resident==3] <- "3.대전광역시"
dataset2$resident2[dataset2$resident==4] <- "4.대구광역시"
dataset2$resident2[dataset2$resident==5] <- "5.시구군    "


# 2) 척도 변경 : 연속형 -> 범주형


dataset2 <- as.data.frame(dataset)
range(dataset2$age,na.rm = T) # 20 69 #여기 왜 NA 나오는지 해결
# 20 ~ 30 : 청년층, 31 ~ 55 : 중년층, 56 ~ : 장년층
dataset2$age2[dataset2$age <= 30] <- "청년층"
dataset2$age2[dataset2$age > 30 & dataset2$age <= 55] <- "중년층"
dataset2$age2[dataset2$age > 55] <- "장년층"
head(dataset2)


# 3) 역코딩 : 1->5, 5->1


table(dataset2$survey)
# 1   2   3   4   5 
# 17 117 124  36   6 
survey <- dataset$survey
survey
csurvey <- 6 - survey
csurvey
dataset2$survey <- csurvey
table(dataset2$survey) # 숫자 바뀌었는지 확인 
# 1   2   3   4   5 
# 6  36 124 117  17



# 5. 탐색적 분석을 위한 시각화 
# - 변수 간의 관계분석



setwd("C:/ITWILL/2_Rwork/Part-II")
new_data <- read.csv("new_data.csv")
new_data
dim(new_data) # 231  15
str(new_data)



# 1) 범주형(명목/서열) vs 범주형(명목/서열)
# - 방법 : 교차테이블, barplot, mosaicplot


# 거지주지역(5) vs 성별(2)
tab1 <-table(new_data$resident2, new_data$gender2)
tab1
barplot(tab1, beside = T, horiz = F,
        col = rainbow(5), main = "성별에 따른 거주지역 분표 형황",
        legend = row.names(tab1))
# 성별(2) vs 거지주지역(5)
tab2 <-table(new_data$gender2,new_data$resident2)
tab2
barplot(tab2, beside = T, horiz = F,
        col = rainbow(2), main = "거주지역에 따른 성별 분표 형황",
        legend = row.names(tab2))
par(mfrow=c(1,2))
mosaicplot(tab1, col = rainbow(9)) # 사각형으로만든 막대그래프
mosaicplot(tab2, col = rainbow(8))

# 고급시각화 : 직업유형(범주형) vs 나이(범주형)
library(ggplot2) # chap08 에서 자세히 
#미적 객체 생성
obj <- ggplot(data = new_data, aes(x=job2, fill=age2))
# 막대차트 추가
obj + geom_bar()
# 막대차트 추가 : 밀도 1 기준 채우기
obj + geom_bar(position = "fill") # 비율보기
table(new_data$job2, new_data$age2, useNA = "ifany") # useNA = "ifany" : 결측치까지 확인 


# 2) 숫자형(비율/등간) vs 범주형(명목/서열)
# - 방법 : boxplot, 카테고리별 통계


install.packages("lattice") # chap08 에서 자세히
library(lattice) # 격자
# 나이(비율) vs 직업유형(명목)
densityplot( ~ age, groups = job2, data = new_data, auto.key = T) # auto.key = T : 범례
# groups = 집단변수 : 각 격자 내에 그룹 효과
# auto.key = T : 범례 추가


# 3) 숫자형(비율) vs 범주형(명목) vs 범주형(명목)
# | factor(집단변수) : 범주의 수 만큼 격자 생성
# groups = 집단변수 : 각 격자 내의 그룹 생성


# (1) 구매금액을 성별과 직급으로 분류
densityplot(~price | factor(gender2), 
            groups = position2, 
            data = new_data,
            auto.key = T)

# (2) 구매금액을 직급과 성별으로 분류
densityplot(~price | factor(position2), 
            groups = gender2, 
            data = new_data,
            auto.key = T)


# 4) 숫자형 vs 숫자형 or 숫자형 vs 숫자형 vs 범주형
# - 방법 : 상관계수, 산점도, 산점도 행렬
# 상관계수(cor)가 클수록 상관성이 크다(0.3이상) / 0에 가까울수록 상관성 x 


# (1) 숫자형(age) vs 숫자형(price)
cor(new_data$age, new_data$price) # NA
new_data2 <- na.omit(new_data) # NA값 제거
cor(new_data2$age, new_data2$price) # 0.0881251
plot(new_data2$age, new_data2$price) # 상관성 x

# (2) 숫자형 vs 숫자형 vs 범주(성별)
xyplot(price ~ age | factor(gender2),
       data = new_data)



# 6. 파생변수 생성
# - 기존 변수 -> 새로운 변수



# (1)사칙연산
# (2) 1:1 : 기존칼럼 -> 새로운 칼럼(1)
# (3) 1:n : 기존변수 -> 새로운 칼럼(n)


# 1) 1:1 : 기존칼럼 -> 새로운 칼럼(1)


# 더미변수 : 1,2 -> 1 / 3,4 -> 2
# 고객정보 테이블
user_data <- read.csv("user_data.csv")
str(user_data)
user_data$house_type2 <- ifelse(user_data$house_type==1 | user_data$house_type==2, 1, 2)
table(user_data$house_type2)


# 2) 1:n : 기존변수  -> 새로운 칼럼(n)


# 지불정보 테이블
pay_data <- read.csv("pay_data.csv")
str(pay_data)
names(pay_data)
# "user_id"(범주)  "product_type"(범주)  "pay_method"(범주)  "price"(비율)
library(reshape2)
# dcast(dataset, 행집단변수~열집단변수, func)
# long -> wide 
# 고객별 상품유형에 따른 구매금액 합계
product_price <- dcast(pay_data, user_id ~ product_type, sum)
product_price
dim(product_price) # 303 6
names(product_price) <- c("user_id", "식료품(1)", "생필품(2)", "의류(3)", "잡화(4)", "기타(5)")
product_price %>% head()


# 3) 파생변수 추가(join)


library(dplyr)
# 형식) left_join(df1, df2, by="column") 
user_pay_data <- left_join(user_data, product_price, by="user_id")
user_pay_data %>% head
dim(user_pay_data) # 400 11 


# 4) 사칙연산 : 총 구매금액


names(user_pay_data)
# user_pay_data[,7] or user_pay_data$'식료품(1)'
user_pay_data$tot_price <- user_pay_data[,7] + user_pay_data[,8] + user_pay_data[,9] + user_pay_data[,10] + user_pay_data[,11]
names(user_pay_data)
head(user_pay_data)












