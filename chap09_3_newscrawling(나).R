# chap09_3_newscrawling

# https://media.daum.net/
# <a href="url"> 기사 내용 </a>

# 1. 관련 패키지 설치
install.packages("httr") # 원격 url 요청
library(httr)
install.packages("XML") # tag -> html 파싱
library(XML)

# 2. url 요청
url <- "https://media.daum.net"
url
web <- GET(url)
web # Status: 200

# 3. html 파싱(text -> html)
help("htmlTreeParse")
html <- htmlTreeParse(web, useInternalNodes = T, # Nodes 를 사용하겠다
                      trim = T, encoding = "UTF-8") # encoding : 문자열
html
root_node <- xmlRoot(html)

# 4.tag 자료수집 : "//tag명[@속성명='값']"
news <- xpathSApply(root_node, "//a[@class='link_txt']", xmlValue)
news # 59번째까지만 기사
news2 <- news[1:59]
news2

# 5. news 기사 전처리 
news_sent = gsub('[[\n\r\t]]', '', news2)         #이스케이프 제거
news_sent = gsub('[[:punct:]]', '', news_sent)  # 문장부호 제거
news_sent = gsub('[[:cntrl:]]', '', news_sent)    #특수문자 제거
news_sent = gsub('[a-z]', '', news_sent)          # 영문(소문자) 제거
news_sent = gsub('[A-Z]', '', news_sent)          # 영문(대문자) 제거
news_sent = gsub('\\s+', ' ', news_sent)          # 2개 이상 공백 제거 -> 공백을 띄어쓰기로 바꿔야지
                                                  # 안그러면 띄어쓰기없이 단어가 다 붙어버린다.
news_sent

# 6. file save
setwd("C:\\ITWILL\\2_Rwork\\output")
# 행 번호와 텍스트 저장 
write.csv(news_sent, 'news_data.csv', row.names = T, quote = F) # row.names 생략(T)가능 

news_data <- read.csv('news_data.csv')
head(news_data) 
colnames(news_data) <- c('no', 'news text')
head(news_data) 
news_text <- news_data$`news text`
news_text

# 7. 토픽분석 -> 단어구름 시각화 <1day 라서 양이 적음>
library(KoNLP)
library(tm)
library(wordcloud)
user_dic = data.frame(term=c("펜데믹","코로나19", "타다"), tag='ncn')
buildDictionary(ext_dic = 'sejong', user_dic = user_dic)
extractNoun("우리나라는 현재 코로나19 때문에 공황상태이다.")

exNouns <- function(x) { 
  paste(extractNoun(as.character(x)), collapse=" ")
}
news_nouns <- sapply(news_text, exNouns) 
news_nouns

# 전처리과정을 생략하는데 전부생략해서 오류

news_term <- TermDocumentMatrix(news_nouns, control=list(wordLengths=c(4,50)))


# 선생님꺼 보고 다시하기
x11() # 뷰어창띄우기













