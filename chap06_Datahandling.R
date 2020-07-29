# chap06_Datahandling 

# 1. dplyr 패키지 

install.packages("dplyr")
library(dplyr)

library(help="dplyr")

# 1) 파이프 연산자 : %>% 
# 형식) df%>%func1()%>%func2()

iris %>% head() %>% filter(Sepal.Length >= 5.0)
# 150 관측치 > 6 관측치 > 3관측치 

install.packages("hflights")
library(hflights)

str(hflights)

# 2) tbl_df() : 콘솔 크기만큼 자료를 구성 
hflights_df <- tbl_df(hflights)
hflights_df

# 3) filter() : 행 추출 
# 형식) df %>% fillter(조건식)
names(iris)
iris %>% filter(Species == 'setosa') %>% head()
iris %>% filter(Sepal.Width > 3) %>% head()
iris_df <- iris %>% filter(Sepal.Width > 3)
str(iris_df)

# 형식) filter(df, 조건식) 
filter(iris, Sepal.Width > 3)
filter(hflights_df, Month == 1 & DayofMonth==1)
filter(hflights_df, Month == 1 | Month==2)

# 4) arrange() : 정렬 함수 
# 형식) df %>% arrage(칼럼명)
iris %>% arrange(Sepal.Width) %>% head() # 오름차순 
iris %>% arrange(desc(Sepal.Width)) %>% head() # 내림차순 

# 형식) arrage(df, 칼럼명) : 월(1~12) > 도착시간 
arrange(hflights_df,  Month, ArrTime) # 오름차순 

arrange(hflights_df,  desc(Month), ArrTime) # 내림차순 


# 5) select() : 열 추출 
# 형식) df %>% select()
names(iris)
iris %>% select(Sepal.Length, Petal.Length, Species) %>% head()

# 형식) select(df, col1, col2, ...)
select(hflights_df, DepTime, ArrTime, TailNum, AirTime)

select(hflights_df, Year:DayOfWeek)

# 문) Month 기준으로 내림차순 정렬하고, 
# Year, Month, AirTime 칼럼 선택하기 

select(arrange(hflights_df, desc(Month)), 
       Year, Month, AirTime)

# 6) mutate() : 파생변수 생성 
# 형식) df %>% mutate(변수 = 함수 or 수식)
iris %>% mutate(diff=Sepal.Length-Sepal.Width) %>% head()

# 형식) mutate(df, 변수 = 함수 or 수식)
select(mutate(hflights_df, 
       diff_delay = ArrDelay -  DepDelay),
       ArrDelay, DepDelay, diff_delay)# 출발지연 - 도착지연 

# 7) summarise() : 통계 구하기 
# 형식) df %>% summarise(변수 = 통계함수())
iris %>% summarise(col1_avg = mean(Sepal.Length),
                   col2_sd = sd(Sepal.Width))
#  col1_avg   col2_sd
#1 5.843333 0.4358663

# 형식) summarise(df, 변수 = 통계함수())
summarise(hflights_df, 
          delay_avg = mean(DepDelay, na.rm = T),
          delay_tot = sum(DepDelay, na.rm = T))
# 출발지연시간 평균/합계 
#       delay_avg delay_tot
#<dbl>     <int>
#  1      9.44   2121251

# 8) group_by(dataset, 집단변수) 
# 형식) df %>% group_by(집단변수)
names(iris)
table(iris$Species)
grp <- iris %>% group_by(Species)
grp

summarise(grp, mean(Sepal.Length))
#1 setosa                  5.01
#2 versicol~               5.94
#3 virginica               6.59

summarise(grp, sd(Sepal.Length))

# group_by() [실습]
install.packages("ggplot2")
library(ggplot2)

data("mtcars") # 자동차 연비 
head(mtcars)
str(mtcars)
table(mtcars$cyl) # 4  6  8
table(mtcars$gear) # 3  4  5 

# group : cyl
grp <- group_by(mtcars, cyl)
grp

# 각 cyl 집단별 연비 평균/표준편차 
summarise(grp, mpg_avg = mean(mpg),
               mpg_sd = sd(mpg))
# cyl mpg_avg mpg_sd
# <dbl>   <dbl>  <dbl>
#   1     4    26.7   4.51
# 2     6    19.7   1.45
# 3     8    15.1   2.56

# 각 gear 집단별 무게(wt) 평균/표준편차 
grp <- group_by(mtcars, gear)

summarise(grp, wt_avg = mean(wt),
               wt_sd = sd(wt))
#   gear wt_avg wt_sd
# <dbl>  <dbl> <dbl>
# 1     3   3.89 0.833
# 2     4   2.62 0.633
# 3     5   2.63 0.819

# 두 집단변수 -> 그룹화 
grp2 <- group_by(mtcars, cyl, gear) # cyl:1차, gear:2차 

summarise(grp2, mpg_avg = mean(mpg), 
          mpg_sd = sd(mpg))

# 형식) group_by(dataset, 집단변수)

# 예제) 각 항공기별 비행편수가 40편 이상이고,
# 평균 비행거리가 2,000마일 이상인 경우의
# 평균 도착지연시간을 확인하시오. 

# 1) 항공기별 그룹화 
str(hflights_df)

planes <- group_by(hflights_df, TailNum) # 항공기 일련번호 
planes

# 2) 항공기별 요약 통계 : 비행편수, 평균 비행거리, 평균 도착지연시간 
planes_state <- summarise(planes, count = n(),
          dist_avg = mean(Distance, na.rm = T),
          delay_avg = mean(ArrDelay, na.rm = T))

planes_state

# 3) 항공기별 요약 통계 필터링 
filter(planes_state, count >= 40 & dist_avg >= 2000)


# 2. reshape2
install.packages("reshape2")
library(reshape2)

# 1) dcast() : long -> wide

data <- read.csv(file.choose()) # Part-II/data.csv
data
dim(data) # 22  3

# Date : 구매일자(col) 
# ID : 고객 구분자(row)
# Buy : 구매수량 
names(data)

# 형식) dcast(dataset, row ~ col, func)
wide <- dcast(data, Customer_ID ~ Date, sum)
wide

library(ggplot2)
data(mpg) # 자동차 연비 
str(mpg)

mpg

mpg_df <- as.data.frame(mpg)
mpg_df
str(mpg_df)

mpg_df <- select(mpg_df, c(cyl, drv, hwy))
head(mpg_df)  

# 교차셀에 hwy 합계 
tab <- dcast(mpg, cyl ~ drv, sum)
tab <- dcast(mpg_df, cyl ~ drv, sum)  
tab  
  
# 교차셀에 hwy 출현 건수 
tab2 <- dcast(mpg_df, cyl ~ drv, length)
tab2  

# 교차분할표 
#table(행집단변수, 열집단변수)
table(mpg_df$cyl, mpg_df$drv)
  
unique(mpg_df$cyl)# 4 6 8 5
unique(mpg_df$drv)# "f" "4" "r"

  
# 2) melt() : wide -> long
wide
long <- melt(wide, id="Customer_ID")
long
# Customer_ID : 기준 칼럼 
# variable : 전체 열이름 
# value : 교차셀의 값 

names(long) <- c("User_ID", "Date", "Buy")
long


# example
data("smiths")
smiths

# wide -> long
long <- melt(smiths, id='subject')
long

long2 <- melt(smiths, id=1:2)
long2


# long -> wide
wide <- dcast(long, subject ~ ...) # 나머지 칼럼 
wide

# 3. acast(datasete, 행~열~면)
data("airquality")
str(airquality)

table(airquality$Month)
#  5  6  7  8  9 -> 월
# 31 30 31 31 30 -> 일
table(airquality$Day)
dim(airquality) # 153   6

# wide -> long
air_melt <- melt(airquality, id=c("Month", "Day"), na.rm = T)
air_melt
dim(air_melt) # 568   4
table(air_melt$variable)

# [일, 월, variable] -> [행, 열, 면]
# acast(dataset, Day ~ Month ~ variable)
air_arr3d <- acast(air_melt, Day ~ Month ~  variable) # [31,5,4]
dim(air_arr3d) # 31  5  4

# 오존 data
air_arr3d[,,1]
# 태양열 data 
air_arr3d[,,2]

###### 추가내용 #######
# 4. URL 만들기 : http://www.naver.com?name='홍길동' 

# 1) base url 만들기 
baseUrl <- "http://www.sbus.or.kr/2018/lost/lost_02.htm"

# 2) page query 추가 
# http://www.sbus.or.kr/2018/lost/lost_02.htm?Page=1
no <- 1:5
library(stringr)
page <- str_c('?Page=', no)
page # "?Page=1" "?Page=2" "?Page=3" "?Page=4" "?Page=5"

# outer(X(1), Y(n), func)
page_url <- outer(baseUrl, page, str_c)
page_url
dim(page_url) # 1 5

# reshape : 2d -> 1d 
page_url <- sort(as.vector(page_url)) 
page_url


# 3) sear query 추가 
# http://www.sbus.or.kr/2018/lost/lost_02.htm?Page=1&sear=2
no <- 1:3
sear <- str_c("&sear=", no)
sear # "&sear=1" "&sear=2" "&sear=3"

final_url <- outer(page_url, sear, str_c) # matrix
final_url <- sort(as.vector(final_url))
final_url



