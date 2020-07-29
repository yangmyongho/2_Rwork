# chap14_Correlation_Analysis

##################################################
# chap14. 상관관계 분석(Correlation Analysis)
##################################################
# - 변수 간 관련성 분석 방법 
# - 관련함수 : cor(), cov(), cov2cor() 

product <- read.csv("C:/ITWILL/2_Rwork/Part-III/product.csv", header=TRUE)
head(product) # 친밀도 적절성 만족도(등간척도 - 5점 척도)

# 기술통계량
summary(product) # 요약통계량

sd(product$제품_친밀도); sd(product$제품_적절성); sd(product$제품_만족도)

# 변수 간의 상관관계 분석 
# 형식) cor(x,y, method) # x변수, y변수, method(pearson): 방법

# 1) 상관계수(coefficient of correlation) : 두 변량 X,Y 사이의 상관관계 정도를 나타내는 수치(계수)
cor(product$제품_친밀도, product$제품_적절성) # 0.4992086 -> 다소 높은 양의 상관관계
# 0.4992086

cor(product$제품_친밀도, product$제품_만족도) # 0.467145 -> 다소 높은 양의 상관관계
#  0.467145

cor(product$제품_적절성, product$제품_만족도)
# 0.7668527


# 전체 변수 간 상관계수 보기
cor(product, method="pearson") # 피어슨 상관계수 - default

# 방향성 있는 색생으로 표현 - 동일 색상으로 그룹화 표시 및 색의 농도 
install.packages("corrgram")   
library(corrgram)
corrgram(product) # 색상 적용 - 동일 색상으로 그룹화 표시
corrgram(product, upper.panel=panel.conf) # 수치(상관계수) 추가(위쪽)
corrgram(product, lower.panel=panel.conf) # 수치(상관계수) 추가(아래쪽)

# 차트에 곡선과 별표 추가
install.packages("PerformanceAnalytics") 
library(PerformanceAnalytics) 

# 상관성,p값(*),정규분포 시각화 - 모수 검정 조건 
chart.Correlation(product, histogram=, pch="+") 

# spearman : 서열척도 대상 상관계수

# 2) 공분산(covariance) : 두 변량 X,Y의 관계를 나타내는 양
cor(product) # 0.7668527
cov(product) # 0.5463331

cov2cor(cov(product)) # 공분산 행렬 -> 상관계수 행렬 변환

# 상관계수 vs 공분산 
# 공통점 : 두 확률변수의 관계를 나타내는 값
# 상관계수 : 두 변수의 관계를 크기(양)와 방향(-,+)을 제공 
# 공분산 : 두 변수의 관계를 크기(양) 제공 

x <- product$제품_적절성
y <- product$제품_만족도

Cov_xy <- mean((x - mean(x)) * (y - mean(y)))
Cov_xy # 0.5442637

r = Cov_xy / (sd(x) * sd(y))
r # 0.763948

# 공분산 : 크기 영향을 받는다.

score_iq <- read.csv(file.choose()) # score_iq.csv
head(score_iq)

cor(score_iq[-1])
# 0.88222034  0.8962647

cov(score_iq[-1])
# 51.3375391  7.1199105










