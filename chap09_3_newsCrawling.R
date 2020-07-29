# chap09_3_newsCrawling

# https://media.daum.net/
# <a href="url"> 기사 내용 </a>

# 1. 패키지 설치 
install.packages('httr') # 원격 url 요청 
library(httr)
install.packages('XML') # tag -> html 파싱 
library(XML)

# 2. url 요청 
url <- "https://media.daum.net"
web <- GET(url)
web # Status: 200


# 3. html 파싱(text -> html) 
#help("htmlTreeParse")
html <- htmlTreeParse(web, 
                      useInternalNodes = T, 
                      trim=T, encoding ="utf-8")
root_node <- xmlRoot(html)


# 4. tag 자료수집 : "//tag[@속성='값']"
news <- xpathSApply(root_node, "//a[@class='link_txt']", xmlValue)
news

news2 <- news[1:59]
news2


# 5. news 전처리 
news_sent = gsub('[\n\r\t]', '', news2) # 이스케이프 제거 
news_sent = gsub('[[:punct:]]', '', news_sent) #문장부호 제거
news_sent = gsub('[[:cntrl:]]', '', news_sent) #특수문자 제거
news_sent = gsub('[a-z]', '', news_sent) # 영문 제거 
news_sent = gsub('[A-Z]', '', news_sent) # 영문 제거 
news_sent = gsub('\\s+', ' ', news_sent) # 2개 이상 공백 제거 

news_sent


# 6. file save
setwd("c:/ITWILL/2_Rwork/output")
# 행 번호과 텍스트 저장 
write.csv(news_sent, 'news_data.csv', row.names = T, quote = F)

news_data <- read.csv('news_data.csv')
head(news_data)

colnames(news_data) <- c('no', 'news_text')
head(news_data)

news_text <- news_data$news_text
news_text

# 7. 토픽분석 -> 단어구름 시각화(1day) 
library(KoNLP)
library(tm)
library(wordcloud)

# [1] 신규단어 
user_dic = data.frame(term=c("펜데믹","코로나19","타다"), 
                      tag='ncn')
buildDictionary(ext_dic = 'sejong', user_dic = user_dic)
# 370968 words dictionary was built.

extractNoun("우리나라는 현재 코로나19 때문에 공황상태이다.")

                  
## [2] 단어추출 사용자 함수 정의
# (1) 사용자 정의 함수 실행 순서 : 문장 -> 문자형 -> 명사 추출 -> 공백 합침 
exNouns <- function(x) { 
  paste(extractNoun(as.character(x)), collapse=" ")
}

# (2) exNouns 함수 이용 단어 추출 
# 형식) sapply(vector, 함수) -> 문장에서 단어 추출 
news_nouns <- sapply(news_text, exNouns) 
news_nouns


## 5. 데이터 전처리   
# (1) 말뭉치(코퍼스:Corpus) 생성 : 텍스트를 처리할 수 있는 자료의 집합 
myCorpus <- Corpus(VectorSource(news_nouns))  # 벡터 소스 생성 -> 코퍼스 생성 
myCorpus

inspect(myCorpus[1]) # corpus 내용 보기 
inspect(myCorpus[2])

# (2) 전처리 생략 

## 6. 단어 선별(단어 길이 2개 이상)
# (1) 단어길이 2개 이상(한글 1개 2byte) 단어 선별 -> matrix 변경
myCorpusPrepro_term <- TermDocumentMatrix(myCorpus, 
                           control=list(wordLengths=c(4,16))) # 2절~8절 
# TermDocumentMatrix : [Term, Doc]
myCorpusPrepro_term
# <<TermDocumentMatrix (terms: 230, documents: 59)>>
#   Non-/sparse entries: 279/13291
# Sparsity           : 98%
# Maximal term length: 7
# Weighting          : term frequency (tf)

# (2) Corpus -> 평서문 변환 : matrix -> data.frame 변경
myTerm_df <- as.data.frame(as.matrix(myCorpusPrepro_term)) 
str(myTerm_df)

## 7. 단어 빈도수 구하기
# (1) 단어 빈도수 내림차순 정렬
wordResult <- sort(rowSums(myTerm_df), decreasing=TRUE) 
wordResult[1:10]

w_name <- names(wordResult)
w_name
w_name[1:10] # 단어이름 
wordResult[1:10] # 출현빈도 


## 8. 단어구름에 디자인 적용(빈도수, 색상, 랜덤, 회전 등)
# (1) 단어 이름 생성 -> 빈도수의 이름
myName <- names(wordResult) # 단어이름 추출  

# (2) 단어이름과 빈도수로 data.frame 생성
word.df <- data.frame(word=myName, freq=wordResult) 
head(word.df)
str(word.df) # word, freq 변수

# (3) 단어 색상과 글꼴 지정
pal <- brewer.pal(12,"Paired") # 12가지 색상 pal <- brewer.pal(9,"Set1") # Set1~ Set3
# 폰트 설정세팅 : "맑은 고딕", "서울남산체 B"
windowsFonts(malgun=windowsFont("맑은 고딕"))  #windows

# (4) 단어 구름 시각화 - 별도의 창에 색상, 빈도수, 글꼴, 회전 등의 속성을 적용하여 
wordcloud(word.df$word, word.df$freq, 
          scale=c(5,1), min.freq=2, random.order=F, 
          rot.per=.1, colors=pal, family="malgun")

x11()










