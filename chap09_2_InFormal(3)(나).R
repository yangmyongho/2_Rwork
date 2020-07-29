# chap09_2_InFormal(3)


#############################################
# 단계3 - 감성 분석(단어의 긍정/부정 분석) 
#  - 시각화 : 파랑/빨강 -> 불만고객 시각화
#############################################

# 1. 데이터 가져오기() 
setwd("C:/ITWILL/2_Rwork/Part-II")

data<-read.csv("reviews.csv") 
head(data,2)
str(data)
dim(data)


# 2. 단어 사전에 단어추가

# 긍정어/부정어 영어 사전 가져오기
posDic <- readLines("posDic.txt") # 긍정어
negDic <- readLines("negDic.txt") # 부정어
length(posDic) # 2006
length(negDic) # 4783


# 긍정어/부정어 단어 추가 
posDic.final <-c(posDic, 'victor') # 성공자
negDic.final <-c(negDic, 'vanquished') # 실패자


# 3. 감성 분석 함수 정의-sentimental

# (1) 문자열 처리를 위한 패키지 로딩 
library(plyr) # laply()함수 제공
library(stringr) # str_split()함수 제공
# laply() : list에 apply
a <- list(a=1:5)
a # key : value
# 형식) laply(data,func) # a->x자리, 10->y자리, 20->z자리
laply(a, function(x,y,z){
       return(x+y+z) 
},10,20)
#  1  2  3  4  5    -> list
# 31 32 33 34 35    -> return값

# (2) 감성분석을 위한 함수 정의
sentimental = function(sentences, posDic, negDic){
  
  scores = laply(sentences, function(sentence, posDic, negDic) {
    # 문장 전처리 : gsub('패턴', '교체', 문장)
    #             = gsub('어떤형식을', '어떻게바꿀건지, 어디문장에서)
    sentence = gsub('[[:punct:]]', '', sentence) #문장부호 제거
    sentence = gsub('[[:cntrl:]]', '', sentence) #특수문자 제거
    sentence = gsub('\\d+', '', sentence) # 숫자 제거
    
    sentence = tolower(sentence) # 모두 소문자로 변경(단어가 모두 소문자 임)
    # 문장 -> 단어
    word.list = str_split(sentence, '\\s+') # 공백 기준으로 단어 생성 -> \\s+ : 공백 정규식, +(1개 이상) 
    words = unlist(word.list) # unlist() : list를 vector 객체로 구조변경
    # 단어 와 사전 매칭(긍정,부정) : 긍정인지부정인지 판별
    pos.matches = match(words, posDic) # words의 단어를 posDic에서 matching
    neg.matches = match(words, negDic)
    # 매칭된 단어 추출(NA제거)
    pos.matches = !is.na(pos.matches) # NA 제거, 위치(숫자)만 추출 : 연산이가능해짐
    neg.matches = !is.na(neg.matches)
    # 최종점수 = 긍정단어점수 - 부정단어점수 
    score = sum(pos.matches) - sum(neg.matches) # 긍정 - 부정    
    return(score) # score 리턴 -> scores
  }, posDic, negDic) # inner function
  
  scores.df = data.frame(score=scores, text=sentences)
  return(scores.df)
} # outer function

# 4. 감성 분석 : 두번째 변수(review) 전체 레코드 대상 감성분석
result<-sentimental(data[,2], posDic.final, negDic.final) # data[,2]를 sentence자리에 입력
result # data.frame형식
names(result) # "score" "text" 
dim(result) # 100   2
result$text
result$score # 100 줄 단위로 긍정어/부정어 사전을 적용한 점수 합계

# score값을 대상으로 color 칼럼 추가
result$color[result$score >=1] <- "blue"
result$color[result$score ==0] <- "green"
result$color[result$score < 0] <- "red"

# 감성분석 결과 차트보기
plot(result$score, col=result$color) # 산포도 색생 적용
barplot(result$score, col=result$color, main ="감성분석 결과화면") # 막대차트


# 5. 단어의 긍정/부정 분석 <긍정과부정 전체를 한눈에볼수있게>

# (1) 감성분석 빈도수 
table(result$color)

# (2) score 칼럼 리코딩 
result$remark[result$score >=1] <- "긍정"
result$remark[result$score ==0] <- "중립"
result$remark[result$score < 0] <- "부정"

sentiment_result<- table(result$remark)
sentiment_result

# (3) 제목, 색상, 원크기
pie(sentiment_result, main="감성분석 결과", 
    col=c("blue","red","green"), radius=0.8) # ->  1.2

names(result) # "score"  "text"   "color"  "remark"

str(result)


