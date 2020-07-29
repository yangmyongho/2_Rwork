# chap06_Datahandling 


# 1. dplyr
installed.packages("dplyr")
library(dplyr)
library(help='dplyr')



# 1) 파이프 연산자 : %>%


# 형식) df %>% func1() %>% func2()
iris %>% head()
# 위 아래 같음 ()안에 iris 를 넣는다는 의미
head(iris)

# 150 관측치 > 6 관측치 > 3 관측치
iris %>% head() %>% filter(Sepal.Length >= 5.0) 
# 위 아래 같음 순서대로연산
filter(head(iris), Sepal.Length >= 5.0)


# 2) tbl_df() : 콘솔 크기만큼 자료를 구성
# 콘솔에서 보여줄수있는만큼만 데이터를 자르는 함수


install.packages("hflights")
library(hflights)
str(hflights)

hflights_df <- tbl_df(hflights)
hflights_df
dim(hflights_df) # 227496     21 


# 3) filter() : 행 추출 <조건에 만족하는 행 추출>


# 형식) df %>% fillter(조건식)
names(iris)
str(iris) # 'data.frame':	150 obs. of  5 variables:
iris %>% filter(Species == 'setosa') %>% head() # iris에서 setosa종류중 대표 추출
iris %>% filter(Sepal.Width > 3) %>% head() # iris에서 Sepal.Width > 3 인 대표추출
iris_df <- iris %>% filter(Sepal.Width > 3)
str(iris_df) # 'data.frame':	67 obs. of  5 variables:

# 형식) filter(df, 조건식)
filter(iris, Sepal.Width > 3)
filter(hflights_df, Month == 1 & DayofMonth == 1) # A tibble: 552 x 21
filter(hflights_df, Month == 1 | Month == 2)     #  A tibble: 36,038 x 21


# 4) arrange() : 정렬 함수


# 형식) df %>% arrange(칼럼명)
iris %>% arrange(Sepal.Width) %>% head() # 오름차순
iris %>% arrange(desc(Sepal.Width)) %>% head() # 내림차순

# 형식) arrange(df, 칼럼명)   
arrange(hflights_df, Year, Month, ArrTime) # 오름차순 월(1~12) -> 오름차순 도착시간
arrange(hflights_df, Year, desc(Month), ArrTime) # 내림차순 월(1~12) -> 오름차순 도착시간


# 5) select() : 열 추출 <조건에 만족하는 열 추출>


# 형식) df %>% select()
names(iris)
iris %>% select(Sepal.Length, Petal.Length, Species) %>% head()

# 형식) select(df, col1, col2, ...)
select(hflights_df, DepTime, ArrTime, TailNum, AirTime)
select(hflights_df, Year:ArrTime) # 연속성 


# 문제1) Month 기준으로 내림차순 정렬하고, Year, Month, AirTime 칼럼 선택하기
hflights_df %>% arrange(desc(Month)) %>% select(Year, Month, AirTime)
# 위아래 동일
select(arrange(hflights_df, desc(Month)), Year, Month, AirTime)


# 6) mutate() : 파생변수 생성


# 형식) df %>% mutate(변수 = 함수 or 수식)
iris %>% mutate(diff = Sepal.Length - Sepal.Width) %>% head() # 첫번째 컬럼에서 두번째컬럼을 뺀값

# 형식) mutate(df, 변수 = 함수 or 수식)
select(mutate(hflights_df, 
              diff_delay = ArrDelay - DepDelay),  # 출발지연 - 도착지연
       ArrDelay, DepDelay, diff_delay)


# 7) summarise() : 통계 구하기


# 형식) df %>% summarise(변수 = 통계함수())
iris %>% summarise(col1_avg = mean(Sepal.Length), # 길이의 평균
                   col2_sd = sd(Sepal.Width))     # 넓이의 표준편차
# col1_avg   col2_sd
# 5.843333   0.4358663

# 형식) summarise(df, 변수 = 통계함수())
summarise(hflights_df, delay_avg = mean(DepDelay, na.rm = T),
         delay_tot = sum(DepDelay, na.rm = T))
# 출발지연시간 평균과 합계
#  delay_avg  delay_tot
#     <dbl>     <int>
#     9.44     2121251


# 8) group_by(dataset, 집단변수)


# 형식) df %>% group_by(집단변수)
names(iris)
table(iris$Species)
grp <- iris %>% group_by(Species)
grp
summarise(grp)
# Species   
# <fct>     
# 1 setosa    
# 2 versicolor
# 3 virginica
summarise(grp, mean(Sepal.Length))
# Species    `mean(Sepal.Length)`
# <fct>             <dbl>
# 1 setosa          5.01
# 2 versicolor      5.94
# 3 virginica       6.59

# group_by[실습]
install.packages("ggplot2")
library(ggplot2)

data("mtcars") # 자동차 연비
head(mtcars)
str(mtcars)
table(mtcars$cyl)  # 4 6 8 <집단변수>
table(mtcars$gear) # 3 4 5 <집단변수>

# 각 cyl 집단별 연비(mpg) 평균/표준편차
grp1 <- group_by(mtcars, cyl)  # group : cyl
grp1
summarise(grp1, mpg_avg = mean(mpg),
               mpg_sd = sd(mpg))
# 각 gear 집단별 무게(wt) 평균/표준편차
grp2 <- group_by(mtcars, gear)  # group : gear
summarise(grp2, wt_avg = mean(wt),
                wt_sd = sd(wt))
# 두 집단변수 -> 그룹화
grp3 <- group_by(mtcars, cyl, gear) # cyl : 1차 , gear : 2차
summarise(grp3, mpg_avg = mean(mpg),
                mpg_sd = sd(mpg))

# 형식) group_by(dataset, 집단변수)

# 예제) 각 항공기별 비행편수가 40편 이상이고, 평균 비행거리가 
#        2,000마일 이상인경우의 평균 도착지연시간을 확인하라.

# (1) 항공기별 그룹화
planes <- group_by(hflights_df, TailNum) # 항공기 일련번호 < 그룹갯수 3320대>
planes
# (2) 항공기별 요약 통계 : 비행편수, 평균 비행거리, 평균 도착지연시간
planes_st <- summarise(planes, count = n(),
                               dist_avg = mean(Distance, na.rm = T),
                               delay_avg = mean(ArrDelay, na.rm = T))
planes_st
# (3) 비행기별 요약 통계 필터링
filter(planes_st, count >= 40 & dist_avg >= 2000)



# 2. reshape2
install.packages("reshape2")
library(reshape2)



# 1) dcast() : long -> wide


# 형식) dcast(dataset, row ~ col, func)
data <- read.csv(file.choose()) # part-II/data.csv
data  # Date : 구매일자(col) / ID : 고객 구분자(row) / Buy : 구매수량
wide <- dcast(data, Customer_ID ~ Date, sum)
wide

library(ggplot2)
data(mpg) # 자동차 연비
str(mpg)
mpg # 이형식이 불편하면 데이터프레임으로 형변환시켜주기
mpg_df <- as.data.frame(mpg)
mpg_df 
str(mpg_df)

mpg_df <- select(mpg_df, c(cyl, drv, hwy))
head(mpg_df)
# 교차셀에 hwy 합계
tab <- dcast(mpg_df, cyl ~ drv, sum)
tab
# 교차셀에 hwy 출현 건수
tab2 <- dcast(mpg_df, cyl ~ drv, length)
tab2
# 교차분할표 < dcast.length 과 같은결과>
# table(행집단변수, 열집단변수)
table(mpg_df$cyl, mpg_df$drv)

unique(mpg_df$cyl) # 4 6 8 5
unique(mpg_df$drv) # "f" "4" "r" 


# 2) melt() : wide -> long


long <- melt(wide, id = "Customer_ID")
long # long으로 변환하고 갯수가늘어남! 다시보기
# Customer_ID : 기준 칼럼 / variable : 열이름 / value : 교차셀의 값
names(long) <- c("user_ID", "Date", "Buy")
long
########다시 long -> wide 로
dcast(long, user_ID ~ Date)


# 예제)
data("smiths")
smiths
# wide -> long
long1 <- melt(smiths, id = 'subject') # 기준을 1열만
long1
dim(long1) # 8 3
long2 <- melt(smiths, id = 1:2)  # 기준을 1열과2열로 
long2
dim(long2) # 6 4

# long -> wide
wide1 <- dcast(long1, subject ~ ...)  # subject를 행, ...을 열 <...은 나머지컬럼을 의미>
wide1


# 3) acast : 삼차원만들기


# 형식) (dataset, 행 ~ 열 ~ 면) -> [행, 열, 면]
data("airquality")
str(airquality)
head(airquality)
airquality$Month
airquality$Day
table(airquality$Month)
# 5  6  7  8  9 
# 31 30 31 31 30 
table(airquality$Day)
dim(airquality) # 153 6

# wide -> long
air_melt <- melt(airquality, id=c("Month","Day"), na.rm = T)
air_melt
dim(air_melt) #568 4 
table(air_melt$variable)
# Ozone  Solar.R    Wind    Temp 
#  116      146     153     153 

# [일, 월, variable] -> [행, 열, 면]
#  acast(dataset, Day ~ Month ~ variable)
air_arr3d <- acast(air_melt, Day ~ Month ~ variable) # [31행, 5열, 4면]
dim(air_arr3d) # 31 5 4 
air_arr3d[,,1] # Ozone dataset
air_arr3d[,,2] # 태양열 dataset



##########추가내용##########
# 3. URL 만들기 : http://www.naver.com?name='홍길동'

# 1) base url 만들기
baseurl <- "http://www.sbus.or.kr/2018/lost/lost_02.htm"

# 2) page query 추가
# http://www.sbus.or.kr/2018/lost/lost_02.htm?Page=1
no <- 1:5
library(stringr)
page <- str_c('?page=', no)
page # "?page=1" "?page=2" "?page=3" "?page=4" "?page=5"
# outer(x(1), y(n), func) :  일 대 다 형식
page_url <- outer(baseurl, page, str_c)
page_url
dim(page_url) # 1 5 
# reshape < as.vector : 2d -> 1d >
page_url2 <- sort(as.vector(page_url)) # sort : 오름차순 정렬
page_url2

# 3) sear query 추가
# http://www.sbus.or.kr/2018/lost/lost_02.htm?Page=1&sear=2
no <- 1:3
sear <- str_c("&sear=", no)
sear  # "&sear=1" "&sear=2" "&sear=3"
# outer
final_url <- outer(page_url, sear, str_c)
final_url <- sort(as.vector(final_url))
final_url


help(str_c)












































































































































