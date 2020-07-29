# chap09_2_InFormal(2)


###########################################
# 단계2 - 연관어 분석(단어와 단어 사이 연관성 분석) 
#   - 시각화 : 연관어 네트워크 시각화,
###########################################


# 한글 처리를 위한 패키지 설치
Sys.setenv(JAVA_HOME='C:\\Program Files\\Java\\jre1.8.0_151')
library(rJava) # 아래와 같은 Error 발생 시 Sys.setenv()함수로 java 경로 지정
library(KoNLP) # rJava 라이브러리가 필요함


# 1.텍스트 파일 가져오기
#----------------------------------------------------
marketing <- file("C:/ITWILL/2_Rwork/Part-II/marketing.txt", encoding="UTF-8") 
marketing2 <- readLines(marketing) # 줄 단위 Test file 읽기

close(marketing)  # 기존에만든 파일지우기
head(marketing2) # 앞부분 6줄 보기 - 줄 단위 문장 확인 
str(marketing2)


# 2. 줄 단위 단어 추출
#----------------------------------------------------
# Map()함수 이용 줄 단위 단어 추출 
lword <- Map(extractNoun, marketing2) # Map(func, doc) 
length(lword) # [1] 472
class(lword) # list
lword[1] 

lword <- unique(lword) # 중복제거1(전체 대상)
length(lword) # [1] 353(119개 제거)

lword <- sapply(lword, unique) # 중복제거2(줄 단위 대상) 
length(lword) 

lword # 추출 단어 확인
# [[353]] -> key : doc num
# [1] ~ [180] -> value : word
lword[1] 
# [[1]] : key[[doc]] 
# [1] ~ [27] : value(word)


# 3. 전처리
#----------------------------------------------------
# 1) 한글 단어 길이 2음절~4글자(=음절) 필터링 함수
filter1 <- function(x){
  nchar(x) <= 4 && nchar(x) >= 2 && is.hangul(x)
}
# 2) Filter(f,x) -> filter1() 함수를 적용하여 x 벡터 단위 필터링 
filter2 <- function(x){
  Filter(filter1, x)
}
# is.hangul() : KoNLP 패키지 제공
# Filter(func, data) : base
# nchar() : base -> 문자 수 반환

# 3) 줄 단어 대상 필터링
lword_final <- sapply(lword, filter2)
lword_final # 추출 단어 확인(길이 1개 단어 삭제됨)


# 4. 트랜잭션 생성 : 연관분석 위해서 트랜잭션 변환 < 일단 생략 >
#----------------------------------------------------
# arules 패키지 설치
install.packages("arules")
library(arules) 
#--------------------
# arules 패키지 제공 기능
# - Adult,Groceries 데이터 셋
# - as(), apriori(), inspect()
#------------------- 

wordtran <- as(lword_final, "transactions") # 중복 word 있으면 error발생
wordtran 
# 353 transactions (rows) and 2423 items (columns)

# 트랜잭션 내용 보기 -> 각 트랜잭션의 단어 보기
inspect(wordtran)  


# 5.단어 간 연관규칙 산출
#----------------------------------------------------
# 지지도와 신뢰도를 적용하여 연관규칙 생성
# 형식) apriori(data, parameter = NULL, appearance = NULL, control = NULL)
tranrules <- apriori(wordtran, parameter=list(supp=0.25, conf=0.05)) # aprior : 규칙만들어줌
tranrules # set of 59 rules
inspect(tranrules) # 연관규칙 생성 결과
# supp : 지지도, conf : 신뢰도


# 6.연관어 시각화 
#----------------------------------------------------
# (1) 데이터 구조 변경 : 연관규칙 -> label 추출  
rules <- labels(tranrules, ruleSep=" ")  
rules

# 문자열로 묶인 연관단어를 행렬구조 변경 
rules <- sapply(rules, strsplit, " ",  USE.NAMES=F) 
rules

# list -> matrix 반환
rulemat <- do.call("rbind", rules)
rulemat

# (2) 연관어 시각화를 위한 igraph 패키지 설치
install.packages("igraph") # graph.edgelist(), plot.igraph(), closeness() 함수 제공
library(igraph)   

# (3) edgelist보기 - 연관단어를 정점 형태의 목록 제공 
ruleg <- graph.edgelist(rulemat[c(12:59),], directed=F) # [1,]~[11,] "{}" 제외
ruleg

# (4) edgelist 시각화
X11()
plot.igraph(ruleg, vertex.label=V(ruleg)$name,
            vertex.label.cex=1.2, vertex.label.color='black', 
            vertex.size=20, vertex.color='green', vertex.frame.color='blue')




