# chap05_DataVisualization

# 차트 데이터 생성
chart_data <- c(305,450, 320, 460, 330, 480, 380, 520) # vector data

names(chart_data) <- c("2016 1분기","2017 1분기","2016 2분기","2017 2분기","2016 3분기","2017 3분기","2016 4분기","2017 4분기")
# names 이름지어주기
str(chart_data)
chart_data
max(chart_data) # 520 <이니까 그래프 최대값은 600정도?>
min(chart_data) # 305

 

# 1. 이산변수 시각화
# - 정수단위로 나누어지는 수(자녀수, 판매수)



# 1) 막대차트

# 세로막대차트
barplot(chart_data, ylim = c(0,600),
        main = "2016년 vs 2017년 판매현황",
        col = rainbow(8))
### 이거 최솟값 조절 어떻게 하는지
barplot(chart_data, ylim = c(300,600),
        main = "2016년 vs 2017년 판매현황",
        col = rainbow(4))
# 가로막대차트 (lim은 범위이므로 x축범위인지 y축범위인지 써야함)
barplot(chart_data, xlim = c(0,600), horiz = T,
        main = "2016년 vs 2017년 판매현황",
        col = rainbow(8))

# 1행 2열 구조
par(mfrow=c(1,2)) # 1행 2열 그래프 보기 barplot(VADeaths, beside=T,col=rainbow(5), main="미국 버지니아주 하위계층 사망비율") legend(19, 71, c("50-54","55-59","60-64","65-69","70-74"), cex=0.8, fill=rainbow(5))
VADeaths
str(VADeaths)
dim(VADeaths) # 5 4
max(VADeaths) # 71.1

# 행 열 이름 벡터 지정
row_names <- row.names(VADeaths) 
row_names
col_names <- colnames(VADeaths)
col_names
# beside=T , horiz=T
barplot(VADeaths, beside = T, horiz = T,
        main = "버지니아 사망비율",
        col=rainbow(5))
# beside=T , horiz=F < beside=T 이면 개별막대를 한막대로합친다.누적형,개별형>
barplot(VADeaths, beside = T, horiz = F,
        main = "버지니아 사망비율",
        col=rainbow(5))
# beside=F , horiz=F
par(mfrow=c(1,1))
barplot(VADeaths, beside = F, horiz = F,
        main = "버지니아 사망비율",
        col=rainbow(5))
# 범례추가 <범례좌표, 범례내용(행), fil 범례색깔, 
legend(x=4, y=200, 
       legend = row_names,
       fil = rainbow(5))


# 2)점 차트

dotchart(chart_data, 
         color=c("green","red"),                 # 점색깔 초,빨
         lcolor="black",                         # 선색깔 까망 
         pch=15:20,                              # 점모양 1=원,2=삼각형,3=십자가,4=x
         labels=names(chart_data), 
         xlab="매출액", 
         main="분기별 판매현황 점 차트 시각화", 
         cex=2.0)                                # 레이블 크기


# 3) 파이차트

pie(chart_data, 
    labels = names(chart_data), 
    border='blue', 
    col=rainbow(8), 
    cex=1.2) 
# 차트에 제목 추가
title("2014~2015년도 분기별 매출현황")

table(iris$Species) # 연습

pie(table(iris$Species),
    col = rainbow(3))
title("iris 꽃의 종류 빈도수")
# 위 아래 같음
pie(table(iris$Species),
    col = rainbow(3),
    main = "iris 꽃의 종류 빈도수")

# 내가한거...<뭔가 오류가있지만 별거아님..>
pie(chart_data, 
    labels = names(chart_data), 
    border='blue', 
    col=rainbow(8), 
    cex=1.2, 
    title("2014~2015년도 분기별 매출현황"))



# 2. 연속변수 시각화
# - 시간, 길이 등의 연속성을 갖는 변수


# 1) 상자 그래프 시각화
summary(VADeaths)  # 요약통계량
VADeaths
boxplot(VADeaths)
range(VADeaths[,1])
mean(VADeaths[,1])
# 사분위수 
quantile(VADeaths[,1])

# 2) 히스토그램 시각화 : 좌우 대칭성 확인 
range(iris$Sepal.Width) # 2.0 4.4
hist(iris$Sepal.Width, 
     xlab="iris$Sepal.Width",                 # x축이름
     col="mistyrose",                         # 색상
     main="iris 꽃받침 넓이 histogram",       # 그래프이름
     xlim=c(2.0, 4.5))                        # x축 범위
# 연습
par(mfrow=c(1,2)) 
# 빈도수그래프
hist(iris$Sepal.Width, 
     xlab="iris$Sepal.Width", 
     col="green", 
     # freq = T 생략
     main="iris 꽃받침 넓이 histogram", 
     xlim=c(2.0, 4.5))
# 밀도그래프
hist(iris$Sepal.Width, 
     xlab="iris$Sepal.Width", 
     col="mistyrose",
     freq = F, 
     main="iris 꽃받침 넓이 histogram", 
     xlim=c(2.0, 4.5)) 
# 밀도분포 곡선(1)
par(mfrow=c(1,1))
hist(iris$Sepal.Width, 
     xlab="iris$Sepal.Width", 
     col="mistyrose",
     freq = F, 
     main="iris 꽃받침 넓이 histogram", 
     xlim=c(2.0, 4.5)) 
# 밀도분포 곡선(2)
lines(density(iris$Sepal.Width),col="red")

# 정규분포 <좌우대칭>
n <- 10000
x <- rnorm(n, mean = 0, sd = 1)
hist(x, freq = F)
lines(density(x),col="red")


# 3) 산점도 시각화

x <- runif(n=15, min = 1, max = 100) # 균등분포 난수
x
plot(x) # x값만적을경우 : x값이 y축으로가고 x축은 index(순서?)가 들어간다.
y <- runif(n=15, min = 5, max = 20)
y
plot(x,y) # x는x축으로 y는y축으로 간다
plot(y~x) # 이렇게 해도 결과는 같다<x,y 위치바꾸기> 포뮬라
# col 속성 : 범주형
head(iris,10)
plot(iris$Sepal.Length,iris$Petal.Length, # 둘다 연속형
     col = iris$Species) # 색으로 범주구분

# 산점도 유형 <만능차트 라고불림>
price<- runif(10, min=1, max=100) # 1~100사이 10개 난수 발생 
price #price <-c(1:10) 
par(mfrow=c(2,2)) # 2행 2열 차트 그리기 
plot(price, type="l") # 유형 : 실선 
plot(price, type="o") # 유형 : 원형과 실선(원형 통과) 
plot(price, type="h") # 직선 
plot(price, type="s") # 꺾은선
# type=o , pch = 점모양
plot(price, type="o", pch=5) # 빈 사각형 
plot(price, type="o", pch=15)# 채워진 마름모 
plot(price, type="o", pch=20, col="blue") #color 지정 
plot(price, type="o", pch=20, col="orange", cex= 3) #character expension(확대) cex: 점크기

# 만능함수<만능차트>
methods(plot) # plot이 사용할수있는 방법들

# plot.ts : 시계열 자료
WWWusage
plot(WWWusage) # 추세선 
# plot.lm* : 회귀모델
install.packages("UsingR") # galton 사용하려고 설치한 패키지
library(UsingR) 
library(help = "UsingR") # galton이 대문자와소문자 가있어서 뭐가 usingr에서 쓰는건지 확인하려고
data("galton")
str(galton)
# 유전학자 갈톤 : 회귀 용어 제안 
model <- lm(child ~ parent, data = galton)
plot(model) # 4가지차트


# 4) 산점도 행렬 : 변수 간의 비교 <대각선 기준 대칭성>
pairs(iris[-5]) # 5번째 칼럼은 범주형이므로
head(iris) # 대각선 기준 대칭성

# 꽃의 종별 산점도 행렬
table(iris$Species) # 꽃의 종류 3가지
pairs(iris[iris$Species == 'setosa', 1:4]) # 세토사 꽃으로만 실행
pairs(iris[iris$Species == 'virginica', 1:4]) # 버지니아 꽃으로만 실행


# 5) 차트 파일 저장
setwd("C:/ITWILL/2_Rwork/output")

jpeg("iris.jpg", width=720, height=480) # 픽셀 지정 가능 
plot(iris$Sepal.Length, iris$Petal.Length, col=iris$Species) 
title(main="iris 데이터 테이블 산포도 차트") 
dev.off() # 장치 종료



#########################
### 3차원 산점도 
#########################
install.packages('scatterplot3d')
library(scatterplot3d)

# 꽃의 종류별 분류 
iris_setosa = iris[iris$Species == 'setosa',]
iris_versicolor = iris[iris$Species == 'versicolor',]
iris_virginica = iris[iris$Species == 'virginica',]

# scatterplot3d(밑변, 오른쪽변, 왼쪽변, type='n') # type='n' : 기본 산점도 제외 
d3 <- scatterplot3d(iris$Petal.Length, iris$Sepal.Length, iris$Sepal.Width, type='n')
str(d3)

d3$points3d(iris_setosa$Petal.Length, iris_setosa$Sepal.Length,
            iris_setosa$Sepal.Width, bg='orange', pch=21)

d3$points3d(iris_versicolor$Petal.Length, iris_versicolor$Sepal.Length,
            iris_versicolor$Sepal.Width, bg='blue', pch=23)

d3$points3d(iris_virginica$Petal.Length, iris_virginica$Sepal.Length,
            iris_virginica$Sepal.Width, bg='green', pch=25)












