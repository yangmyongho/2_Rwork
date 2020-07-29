# chap08_VisualizationAnalysis

#####################################
## Chapter08. 고급시각화 분석 
#####################################

# - lattice, latticeExtra, ggplot2, ggmap 패키지
##########################################
# 1. lattice 패키지
#########################################
# The Lattice Plotting System 
# 격자 형태의 그래픽(Trellis graphic) 생성 패키지
# 다차원 데이터를 사용할 경우, 한 번에 여러개의 plot 생성 가능
# 높은 밀도의 plot를 효과적으로 그려준다.

# lattice 패키지의 주요 함수
# xyplot(), barchart(), dotplot(),  cloud(), 
# histogram(), densityplot(), coplot()
###########################################
available.packages()
# install.packages("lattice")
library(lattice)
install.packages("mlmRev")
library(mlmRev)
data(Chem97)
str(Chem97)
###### Chem97 데이터 셋 설명 ##########
# - mlmRev 패키지에서 제공
# - 1997년 영국 2,280개 학교 31,022명을 대상으로 
#    A레벨(대학시험) 화학점수
# 'data.frame':  31022 obs. of  8 variables:
# score 변수 : A레벨 화학점수(0,2,4,6,8,10)
# gender 변수 : 성별
# gcsescore 변수 : 고등학교 재학중에 치루는 큰 시험
# GCSE : General Certificate of Secondary Education)



# 1) histogram(~x축, dataframe)
histogram(~gcsescore, data=Chem97) 
# gcsescore변수를 대상으로 백분율 적용 히스토그램
table(Chem97$score)

# score 변수를 조건으로 지정 
# | factor(집단변수) : 집단 수 만큼 격자 생성
histogram(~gcsescore | score, data=Chem97) # score 단위 
histogram(~gcsescore | factor(score), data=Chem97) # score 요인 단위
table(Chem97$score)
#   0    2    4    6    8   10 
# 3688 3627 4619 5739 6668 6681 


# 2) densityplot(~x축 | 조건, dataframe, groups=변수)
densityplot(~gcsescore | factor(score), data=Chem97, 
            groups = gender, plot.points=T, auto.key = T) 
# 밀도 점 : plot.points=F
# 범례: auto.key=T
# 성별 단위(그룹화)로 GCSE점수를 밀도로 플로팅    


# matrix -> data.table 변환
dft <- as.data.frame.table(VADeaths)
str(dft) # 'data.frame':  20 obs. of  3 variables:
class(dft) # "data.frame"

# 3.barchart(y~x | 조건, dataframe, layout)
barchart(Var1 ~ Freq | Var2, data=dft, layout=c(2,2))
# Var2변수 단위(그룹화)로 x축-Freq, y축-Var1으로 막대차트 플로팅
# layout 그래프 구조행렬

# x축 0부터 시작
barchart(Var1 ~ Freq | Var2, data=dft, layout=c(4,1), origin=0)


# 4.dotplot(y~x | 조건 , dataframe, layout)
dotplot(Var1 ~ Freq | Var2 , dft) 

# Var2변수 단위로 그룹화하여 점을 연결하여 플로팅  
dotplot(Var1 ~ Freq, data=dft, groups=Var2, type="o", 
        auto.key=list(space="right", points=T, lines=T)) 
# type="o" : 점 타입 -> 원형에 실선 통과 
# auto.key=list(배치위치, 점 추가, 선 추가) : 범례 

# 5.xyplot(y축~x축| 조건, dataframe or list)
library(datasets)
str(airquality) # datasets의 airqulity 테이터셋 로드
airquality # Ozone Solar.R Wind Temp Month(5~9) Day

# airquality의 Ozone(y),Wind(x) 산점도 플로팅
xyplot(Ozone ~ Wind, data=airquality) 
range(airquality$Ozone,na.rm=T)
# Month(5~9)변수 기준으로 플로팅
xyplot(Ozone ~ Wind | Month, data=airquality) # 2행3컬럼 
# default -> layout=c(3,2)
xyplot(Ozone ~ Wind | factor(Month), data=airquality, layout=c(5,1))
# 5컬럼으로 플로팅 - 컬럼 제목 : Month


head(quakes)
str(quakes) # 'data.frame':  1000 obs. of  5 variables:
# lat, long, depth, mag, stations
range(quakes$stations)
############## quakes 데이터셋 설명 #################
# R에서 제공하는 기존 데이터셋
# - 1964년 이후 피지(태평양) 근처에 발생한 지진 사건 
#lat:위도,long:경도,depth:깊이(km),mag:리히터규모,stations  
####################################################

# 지진발생 위치(위도와 경도) 
xyplot(lat~long, data=quakes, pch="@") 
# 그래프를 변수에 저장 pch=점모양
tplot<-xyplot(lat~long, data=quakes, pch="*")
# 그래프에 제목 추가
tplot2<-update(tplot,
               main="1964년 이후 태평양에서 발생한 지진위치")
print(tplot2)

# depth 이산형 변수 리코딩
# 1. depth변수 범위
range(quakes$depth)# depth 범위
# 40 680

# 2. depth변수 리코딩
quakes$depth2[quakes$depth >=40 & quakes$depth <=150] <- 1
quakes$depth2[quakes$depth >=151 & quakes$depth <=250] <- 2
quakes$depth2[quakes$depth >=251 & quakes$depth <=350] <- 3
quakes$depth2[quakes$depth >=351 & quakes$depth <=450] <- 4
quakes$depth2[quakes$depth >=451 & quakes$depth <=550] <- 5
quakes$depth2[quakes$depth >=551 & quakes$depth <=680] <- 6

# 리코딩된 수심(depth2)변수을 조건으로 산점도 그래프 그리기
convert <- transform(quakes, depth2=factor(depth2)) # 자료형을 factor 형으로변경
xyplot(lat~long | depth2, data=convert)


# 동일한 패널에 2개의 y축에 값을 표현
# xyplot(y1+y2 ~ x | 조건, data, type, layout)

xyplot(Ozone + Solar.R ~ Wind | factor(Month), data=airquality,
       col=c("blue","red"),layout=c(5,1))

# 6.coplot()
# a조건 하에서 x에 대한 y 그래프를 그린다.
# 형식) coplot(y ~ x : a, data)
# two variantes of the conditioning plot
# http://dic1224.blog.me/80209537545

# 기본 coplot(y~x | a, data, overlap=0.5, number=6, row=2)
# number : 격자의 수
# overlap : 겹치는 구간(0.1~0.9:작을 수록  사이 간격이 적게 겹침)생략하면 0.5단위
# row : 패널 행수
# number : 6 , row : 2 이면 2행3열 
coplot(lat~long | depth, data=quakes) # 2행3열, 0.5, 사이간격 6
coplot(lat~long | depth, data=quakes, overlap=0.1) # 겹치는 구간 : 0.1
coplot(lat~long | depth, data=quakes, number=5, row=1) # 사이간격 5, 1행 5열
coplot(lat~long | depth, data=quakes, number=5, row=1, panel=panel.smooth)
coplot(lat~long | depth, data=quakes, number=5, row=1, 
       col='blue',bar.bg=c(num='green')) # 패널과 조건 막대 색 

# 7.cloud()
# 3차원(위도, 경도, 깊이) 산점도 그래프 플로팅
#lat:위도,long:경도,depth:깊이
cloud(depth ~ lat * long , data=quakes,
      zlim=rev(range(quakes$depth)), 
      xlab="경도", ylab="위도", zlab="깊이")

# 테두리 사이즈와 회전 속성을 추가하여 3차원 산점도 그래프 그리기
cloud(depth ~ lat * long , data=quakes,
      zlim=rev(range(quakes$depth)), 
      panel.aspect=0.9,
      screen=list(z=45,x=-25),
      xlab="경도", ylab="위도", zlab="깊이")

# depth ~ lat * long : depth(z축), lat(y축) * long(x축)
# zlim=rev(range(quakes$depth)) : z축값 범위 지정
# panel.aspect=0.9 : 테두리 사이즈
# screen=list(z=105,x=-70) : z,x축 회전
# xlab="Longitude", ylab="Latitude", zlab="Depth" : xyz축 이름



###########################################
# 2. ggplot2 패키지
###########################################
# ggplot2 그래픽 패키지
# 기하학적 객체들(점,선,막대 등)에 미적 특성(색상, 모양,크기)를 
# 맵핑하여 플로팅한다.
# 그래픽 생성 기능과 통계변환을 포함할 수 있다.
# ggplot2의 기본 함수 qplot()
# geoms(점,선 등) 속성, aes(크기,모양,색상) 속성 사용
# dataframe 데이터셋 이용(변환 필요)
###########################################


#install.packages("ggplot2") # 패키지 설치
library(ggplot2)
library(help='ggplot2')
data(mpg) # 데이터 셋 가져오기
str(mpg) # map 데이터 셋 구조 보기
head(mpg) # map 데이터 셋 내용 보기 
summary(mpg) # 요약 통계량
table(mpg$drv) # 구동방식 빈도수 
################ mpg 데이터셋 #################
# ggplot2에서 제공하는 데이터셋
# 'data.frame':	234 obs. of  11 variables:
# 주요 변수 : displ:엔진크기, cyl : 실린더수,
#      drv(구동방식) ->사륜구동(4), 전륜구동(f), 후륜구동(r)
#      hwy : 고속도로주행마일수 , cty : 도시주행마일수
###################################################


# 1. gplot()함수
help(qplot)

# (1) 1개 변수 대상 기본 - x축 기준 도수분포도
qplot(hwy, data=mpg) 

#  fill 옵션 : hwy 변수를 대상으로 drv변수에 색 채우기 
qplot(hwy, data=mpg, fill=drv) # fill 옵션 적용

# binwidth 옵션 : 도수 폭 지정 속성
qplot(hwy, data=mpg, fill=drv, binwidth=2) # binwidth 옵션 적용 

# facets 옵션 : drv변수 값으로 열단위/행단위 패널 생성
qplot(hwy, data=mpg, fill=drv, facets=.~ drv, binwidth=2) # 열 단위 패널 생성
qplot(hwy, data=mpg, fill=drv, facets=drv~., binwidth=2) # 행 단위 패널 생성


# (2) 2변수 대상 기본 - 속이 꽉찬 점 모양과 점의 크기는 1를 갖는 산점도 그래프
qplot(displ, hwy, data=mpg)# mpg 데이터셋의 displ과 hwy변수 이용

# displ, hwy 변수 대상으로 drv변수값으로 색상 적용 산점도 그래프
qplot(displ, hwy, data=mpg, color=drv)


# (3) 색상, 크기, 모양 적용
### ggplot2 패키지 제공 데이터 셋
head(mtcars)
str(mtcars) # ggplot2에서 제공하는 데이터 셋
#주요 변수 
# mpg(연비), cyl(실린더 수), displ(엔진크기), hp(마력), wt(중량), 
# qsec(1/4마일 소요시간), am(변속기:0=오토,1=수동), gear(앞쪽 기어 수), carb(카뷰레터 수) 

# num(동일색 농도) vs factor(집단별 색상)
qplot(wt, mpg, data=mtcars, color=carb) # 한가지색 농도차이
qplot(wt, mpg, data=mtcars, color=factor(carb)) # 색상 적용
qplot(wt, mpg, data=mtcars, size=qsec, color=factor(carb)) # 크기 적용
qplot(wt, mpg, data=mtcars, size=qsec, color=factor(carb), shape=factor(cyl))#모양 적용 
mtcars$qsec


# (4) geom 속성  
### ggplot2 패키지 제공 데이터 셋
head(diamonds) 
str(diamonds)
# 주요 변수 
# price : 다이아몬드 가격($326~$18,823), carat :다이아몬드 무게 (0.2~5.01), 
# cut : 컷의 품질(Fair,Good,Very Good, Premium Ideal),
# color : 색상(J:가장나쁨 ~ D:가장좋음), 
# clarity : 선명도(I1:가장나쁨, SI1, SI1, VS1, VS2, VVS1, VVS2, IF:가장좋음), 
# x: 길이, y : 폭


# geom 속성 : 차트 유형, clarity변수 대상 cut변수로 색 채우기
qplot(clarity, data=diamonds, fill=cut, geom="bar") #geom="bar" : 막대차트 

# qplot(wt, mpg, data=mtcars, size=qsec) # geom="point" : 산점도
qplot(wt, mpg, data=mtcars, size=qsec, geom="point")
# cyl 변수의 요인으로 point 크기 적용, carb 변수의 요인으로 포인트 색 적용
qplot(wt, mpg, data=mtcars, size=factor(cyl), color=factor(carb), geom="point")
# qsec변수로 포인트 크기 적용, cyl 변수의 요인으로 point 모양 적용
qplot(wt, mpg, data=mtcars, size=qsec, color=factor(carb), shape=factor(cyl), geom="point")

# geom="line"
qplot(mpg, wt, data=mtcars, color=factor(cyl), geom="line")

# geom="smooth"
qplot(wt, mpg, data=mtcars, geom=c("point", "smooth"))

qplot(wt, mpg, data=mtcars, geom=c("point", "line"))


# 2. ggplot()함수

# (1) aes(x,y,color) 옵션 
# aes(x,y,color) 속성 = aesthetics : 미학
p<-ggplot(diamonds, aes(x=carat, y=price, color=cut))
p+geom_point()  # point 추가

# (2) geom_line() 레이어 추가 
p+geom_line() # line 추가

# (3) geom_point()함수  레이어 추가
p<- ggplot(mtcars, aes(mpg,wt,color=factor(cyl)))
p+geom_point()  # point 추가

# (4) geom_step() 레이어 추가
p+geom_step()  # step 추가

# (5) geom_bar() 레이어 추가
p<- ggplot(diamonds, aes(clarity))
p+geom_bar(aes(fill=cut), position="fill")  # bar 추가
# position="fill" : 밀도 1기준 꽉찬 막대차트

library(UsingR)
data("galton")
head(galton)

p <- ggplot(data = galton, aes(x=parent, y=child))
p + geom_count() + geom_smooth(method = "lm") # 방법 회귀모형으로



# 3. ggsave()함수 
# save image of plot on disk 
#geom_point()함수 - 결과 동일 
p<-ggplot(diamonds, aes(carat, price, color=cut))
p+geom_point()  # point 추가
ggsave(file="C:/ITWILL/2_Rwork/output/diamond_price.pdf") # 가장 최근 그래프 저장
ggsave(file="C:/ITWILL/2_Rwork/output/diamond_price.jpg", dpi=72) # 해상도 : dpi

# 변수에 저장된 그래프 저장 
p<- ggplot(diamonds, aes(clarity))
p<- p+geom_bar(aes(fill=cut), position="fill")  # bar 추가
ggsave(file="C:/ITWILL/2_Rwork/output/bar.png", plot=p, width=10, height=5)



##########################################
# 3. ggmap 패키지
##########################################
#공간시각화
# 공간 시각화는 지도를 기반으로 하기 때문에 
# 표현방법 : 레이어 형태로 추가하여 시각화
# 영역 : 데이터에 따른 색상과 크기 표현
##########################################         


# 지도 관련 패키지 설치
install.packages("ggmap")
library(ggmap) # get_stamenmap()
library(ggplot2) # geom_point(), geom_text(), ggsave()

# ge <- geocode('seoul') # 인증 key 필요 해서 수업에선 뺀다

# 서울 : 위도(left), 경도(bottom) : 126.97797  37.56654  -> google 지도에서 검색 
# 서울 중심 좌표 : 위도 중심 좌우(126.8 ~ 127.2), 경도 중심 하상(37.38~37.6) 
seoul <- c(left = 126.77, bottom = 37.40, 
           right = 127.17, top = 37.70)
map <- get_stamenmap(seoul, zoom=12,  maptype='terrain')#'toner-2011')
ggmap(map) # maptype : terrain, watercolor
map1 <- get_stamenmap(seoul, zoom=12,  maptype='watercolor')
ggmap(map1)

# 대구 중심 남쪽 대륙 지도 좌표 : 35.829355, 128.570088
# 대구 위도와 경도 기준으로 남한 대륙 지도  
daegu <- c(left = 123.4423013, bottom = 32.8528306, 
           right = 131.601445, top = 38.8714354)

map2 <- get_stamenmap(daegu, zoom=8,  maptype='terrain')
ggmap(map2)

# [단계1] dataset 가져오기
pop <- read.csv(file.choose()) # 2019.1.인구수
str(pop)
library(stringr)
head(pop)
reigon <- pop$지역명
lon <- pop$LON
lat <- pop$LAT
# 문자열 -> 숫자형
tot_pop <- as.numeric(str_replace_all(pop$'총인구수', ",",""))
tot_pop  
df <- data.frame(reigon, lon, lat, tot_pop)
df

# [단계2] 지도정보 생성
daegu <- c(left = 123.4423013, bottom = 32.8528306, 
           right = 131.601445, top = 38.8714354)
map3 <- get_stamenmap(daegu, zoom=7,  maptype='watercolor')

# [단계3] 레이어1 : 정적 지도 시각화
layer1 <- ggmap(map3)

# [단계4] 레이어2 : 각 지역별 포인트 추가
layer2 <- layer1 + geom_point(data= df, aes(x=lon, y=lat, 
                                   color=factor(tot_pop), 
                                   size=factor(tot_pop)))
layer2

# [단계5] 레이어3 : 각 지역별 포인트 옆에 지명 추가
layer3 <- layer2 + geom_text(data = df, aes(x=lon+0.01, 
                                            y=lat+0.08,
                                            label=reigon),
                             size = 3)
layer3                                            
# [단계6] 지도이미지 file save
ggsave("pop201901.png", scale = 1, width = 10.24, height = 7.68)























