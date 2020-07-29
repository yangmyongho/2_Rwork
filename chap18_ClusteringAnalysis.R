# chap18_ClusteringAnalysis

###################################################
# 군집분석(Clustering)
###################################################
# 고객DB   ->  알고리즘 -> 군집
# 알고리즘을 통해서(패턴으로) 근거리 모형으로 군집형성 - 규칙(rule)
# 변수에 의해서 그룹핑되다.
# 변수 적용 : 상품카테고리, 구매금액, 총거래금액

# 유사성 거리에 의한 유사객체를 묶어준다.
# 거리를 측정하여 집단의 이질성과 동질성을 평가하고, 이를 통해서 
# 군집을 형성한다..
# 유사성 거리 : 유클리드 거리
# y변수가 없는 데이터 마이닝 기법
# 예) 몸, 키 관점에서 묶음 -> 3개 군집 <- 3개 군집의 특징 요약
# 주요 알고리즘 : hierarchical, k-means

# 그룹화를 통한 예측(그룹 특성 차이 분석-고객집단 이해)

# 1. 유클리드 거리
# 유클리드 거리(Euclidean distance)는 두 점 사이의 거리를 계산하는 
# 방법으로 이 거리를 이용하여 유클리드 공간을 정의한다.

# (1) matrix 생성
x <- matrix(1:9, nrow=3, by=T) 
x

# (2) matrix 대상 유클리드 거리 생성 함수
# 형식) dist(x, method="euclidean") -> x : numeric matrix, data frame
dist <- dist(x, method="euclidean") # method 생략가능
dist

# (3) 유클리드 거리 계산 식
# 관측대상 p와 q의 대응하는 변량값의 차의 제곱의 합에 sqrt 적용
sqrt(sum((x[1,] - x[2,])**2)) # 5.196152
sqrt(sum((x[1,] - x[3,])**2)) # 10.3923


# 2. 계층적 군집분석(탐색적 분석)
# - 계층적 군집분석(Hierarchical Clustering)
# - 거리가 가장 가까운 대상부터 결합하여 나무모양의 
#   계층구조를 상향식(Bottom-up)으로 만들어가면서 군집을 형성 

# (1) 군집분석(Clustering)분석을 위한 패키지 설치
install.packages("cluster") # hclust() : 계층적 클러스터 함수 제공
library(cluster) # 일반적으로 3~10개 그룹핑이 적정

# (2) 데이터 셋 생성
r <- runif(15, min = 1, max = 50)
x <- matrix(r, nrow=5, by=T) 
x

# (3) matrix 대상 유클리드 거리 생성 함수
dist <- dist(x, method="euclidean") # method 생략가능
dist

# (4) 유클리드 거리 matrix를 이용한 클러스터링
hc <- hclust(dist) # 클러스터링 적용
hc
help(hclust)
plot(hc) # 클러스터 플로팅(Dendrogram) -> 1과2 군집(클러스터) 형성


#<실습> 중1학년 신체검사 결과 군집분석
#---------------------------------------------
body <- read.csv("c:/ITWILL/2_Rwork/Part-IV/bodycheck.csv")
names(body)
idist <- dist(body)
idist

hc <- hclust(idist)

plot(hc, hang=-1) # 음수값 제외


# 3개 그룹 선정, 선 색 지정
rect.hclust(hc, k=3, border="red") # 3개 그룹 선정, 선 색 지정

# 각 그룹별 서브셋 만들기
g1<- subset(body, 번호==15| 번호==1| 번호==4| 번호==8 | 번호==10)
g2<- subset(body, 번호==11| 번호==3| 번호==5| 번호==6 | 번호==14)
g3<- subset(body, 번호==2| 번호==9| 번호==7| 번호==12 | 번호==13)

# 각 그룹별 특징 분석 
summary(g1)# 신장 : 142~156, 안경유무(1)
summary(g2)# 신장 : 155~168, 안경유무(1, 2)
summary(g3)# 신장 : 154~169, 안경유무(2)


# 3. 계층형 군집분석에 그룹수 지정
# iris의 계층형군집결과에 그룹수를 지정하여 그룹수 만큼 
# 잘라서 iris의 1번째(Sepal.Length)와 3번째(Petal.Length) 변수를 
# 대상으로 클러스터별 변수의 평균 구하기 

# 1) 유클리드 거리 계산 
idist<- dist(iris[1:4]) # dist(iris[, -5])

# 2) 계층형 군집분석(클러스터링)
hc <- hclust(idist)
hc
plot(hc, hang=-1)
rect.hclust(hc, k=3, border="red") # 3개 그룹수 

# 3) 그룹수 만들기 : cutree()함수 -> 지정된 그룹수 만큼 자르기
# 형식) cutree(계층형군집결과, k=그룹수) -> 그룹수 만큼 자름
ghc<- cutree(hc, k=3) # stats 패키지 제공

ghc #  150개(그룹을 의미하는 숫자(1~3) 출력)

# 4) iris에서 ghc 컬럼 추가
iris$ghc <- ghc
table(iris$ghc) # ghc 빈도수
head(iris,60) # ghc 칼럼 확인 

# 5) 그룹별 요약통계량 구하기
g1 <- subset(iris, ghc==1)
summary(g1[1:4]) # Mean   :5.006

g2 <- subset(iris, ghc==2)
summary(g2[1:4]) # Mean   :6.546 

g3 <- subset(iris, ghc==3)
summary(g3[1:4]) # Mean   :5.532


# 4. 비계층적 군집분석(확인적 분석)
# - 군집 수를 알고 있는 경우 이용하는 군집분석 방법

# 군집분석 종류 : 계층적 군집분석(탐색적), 비계층적 군집분석(확인적) 

# 1) data set 준비 
library(ggplot2)
data(diamonds)

nrow(diamonds) # [1] 53940
t <- sample(nrow(diamonds),1000) # 1000개 셈플링 

test <- diamonds[t, ] # 1000개 표본 추출
dim(test) # [1] 1000 10

head(test) # 검정 데이터
mydia <- test[c("price","carat", "depth", "table")] # 4개 칼럼만 선정
head(mydia)

# 2) 계층적 군집분석(탐색적 분석)
result <- hclust(dist(mydia), method="average") # 평균거리 이용 
result

# [작성] 군집 방법(Cluster method) 
# method = "complete" : 완전결합기준(최대거리 이용) <- default(생략 시)
# method = "single" : 단순결합기준(최소거리 이용) 
# method = "average" : 평균결합기준(평균거리 이용) 

plot(result, hang=-1) # hang : -1 이하 값 제거

# 3) 비계층적 군집분석(확인적 분석) - kmeans()함수 이용
# - 확인적 군집분석 : 군집의 수를 알고 있는 경우
result2 <- kmeans(mydia, 3)
result2 
# K-means clustering with 3 clusters of sizes 302, 95, 603 - 클러스터별 군집수 
# Cluster means: 클러스터별 칼럼의 평균 

names(result2) # cluster 칼럼 확인 
result2$cluster # 각 케이스에 대한 소속 군집수(1,2,3)
table(result2$cluster)

result2$centers

# 4) 원형데이터에 군집수 추가
mydia$cluster <- result2$cluster
head(mydia) # cluster 칼럼 확인 


# 5) 변수 간의 상관성 보기 
plot(mydia[,-5])
cor(mydia[,-5], method="pearson") # 상관계수 보기 
# 반응변수 : price <- 설명변수 : carat(양의 영향) > table(양의 영향) > depth(음의 영향)

library(corrgram) # 상관성 시각화 
corrgram(mydia[,-5]) # 색상 적용 - 동일 색상으로 그룹화 표시
corrgram(mydia[,-5], upper.panel=panel.conf) # 수치(상관계수) 추가(위쪽)


# 6) 비계층적 군집시각화
plot(mydia$carat, mydia$price)
plot(mydia$carat, mydia$price, col=mydia$cluster)
# mydia$cluster 변수로 색상 지정(1,2,3)

# 중심점 표시 추가
result2$centers # Cluster means 값을 갖는 컬럼 

# 각 그룹의 중심점에 포인트 추가 
points(result2$centers[,c("carat", "price")], col=c(3,1,2), pch=8, cex=5)
# names(result2) -> centers 칼럼 확인 
# col : color, pch : 중심점 문자, cex : 중심점 문자 크기
# pch(plotting character), cex(character expansion)


##########################
### 군집수 결정방법 
##########################

install.packages("NbClust")
library(NbClust)
data("iris")

iris_max <- as.matrix(iris[-5]) # 150x4
dim(iris_max) # 150   4

?NbClust
#devAskNewPage(ask=TRUE)
nc <- NbClust(iris_max, distance = "euclidean", min.nc = 2, max.nc = 15,
        method =  "complete")

nc

names(nc)

table(nc$Best.nc[1,])
# 0  2  3  7 15  -> 클러스터 수 
# 2  9 11  3  1





