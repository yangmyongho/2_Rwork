#############################
### 한글 감성분석 예 
### facebook_bigdata.txt
#############################

library(stringr)
library(plyr)

# 1. facebook_bigdata.txt 가져오기
facebook <- file(file.choose(), encoding="UTF-8")
facebook_data <- readLines(facebook) # 줄 단위 데이터 생성

head(facebook_data) # 앞부분 6줄 보기 - 줄 단위 문장 확인 
str(facebook_data) # chr [1:76]
facebook_data[1:5]


# 2. 전처리 + 형태소 생성
sentence = gsub('[[:punct:]]', '', facebook_data) #문장부호 제거
sentence = gsub('[[:cntrl:]]', '', sentence) #특수문자 제거
sentence = gsub('\\d+', '', sentence) # 숫자 제거
sentence = tolower(sentence) # 모두 소문자로 변경(단어가 모두 소문자 임)

word_list = str_split(sentence, '\\s+')# 공백 기준으로 단어 생성 -> \\s+ : 공백 정규식, +(1개 이상) 
words = unlist(word_list) # unlist() : list를 vector 객체로 구조변경
length(words) # 2488


# (1) 긍정어/부정어 영어 사전 가져오기 <R-script/chop09_한글 감성분석>
posDic <- readLines(file.choose(), encoding = 'UTF-8') # "pos_pol_word.txt"
negDic <- readLines(file.choose(), encoding = 'UTF-8') # "neg_pol_word.txt"
length(posDic) # 4882
length(negDic) # 9845


# (2) 긍정어/부정어 단어 추가 
posDic.final <-c(posDic, '지원')
negDic.final <-c(negDic, '불편한')
# 마지막에 단어 추가
length(posDic.final) # 4883 
length(negDic.final) # 9846


# (2) 감성분석을 위한 함수 정의
sentimental = function(words, posDic, negDic){
  
  scores = laply(words, function(words, posDic, negDic) {
    
   
    # 2) 단어 vs 사전 matching -> index(있음) / NA(없음)
    pos.matches = match(words, posDic) # words의 단어를 posDic에서 matching
    neg.matches = match(words, negDic)
    
    # 3) 사전에 등록된 단어 추출 
    pos.matches = !is.na(pos.matches) # NA 제거, 위치(숫자)만 추출
    neg.matches = !is.na(neg.matches)
    
    # 4) 긍정단어 합- 부정단어 합
    score = sum(pos.matches) - sum(neg.matches) # 긍정 - 부정    
    return(score) # 점수 반환
  }, posDic, negDic)
  
  scores.df = data.frame(score=scores, text=words)
  return(scores.df)
}

# 4) 감성 분석 : 두번째 변수(review) 전체 레코드 대상 감성분석
result<-sentimental(words, posDic.final, negDic.final)
result

names(result) # "score" "text" 
dim(result) # 2488   2
result$text
result$score # 

# score값을 대상으로 color 칼럼 추가
result$color[result$score >=1] <- "blue"
result$color[result$score ==0] <- "green"
result$color[result$score < 0] <- "red"


# 5) 단어의 긍정/부정 분석 

# (1) 감성분석 빈도수 
table(result$color)
# blue green   red 
# 51  2417    20 

# (2) score 칼럼 리코딩 
result$remark[result$score >=1] <- "긍정"
result$remark[result$score ==0] <- "중립"
result$remark[result$score < 0] <- "부정"

sentiment_result<- table(result$remark)
sentiment_result
#긍정 부정 중립 
# 51   20 2417

# (3) 제목, 색상, 원크기
pie(sentiment_result, main="감성분석 결과", 
    col=c("blue","red","green"), radius=0.8) # ->  1.2

