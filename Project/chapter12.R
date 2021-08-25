install.packages("multilinguer")
library(multilinguer)
# install_jdk() OR multilinguer::install_jdk()
# install.packages(c("hash", "tau", "Sejong", "RSQLite", "devtools", "bit", "rex", "lazyeval", "htmlwidgets", "crosstalk", "promises", "later", "sessioninfo", "xopen", "bit64", "blob", "DBI", "memoise", "plogr", "covr", "DT", "rcmdcheck", "rversions"), type = "binary")
# install.packages("remotes")
# remotes::install_github('haven-jeon/KoNLP', upgrade = "never", INSTALL_opts=c("--no-multiarch"))
library(KoNLP)
library(wordcloud2)
useSejongDic()  # 세종사전 사용

# word_data 변수에 readLines()함수(파일을 행 단위로 읽는 기능)를 이용하여 대입
word_data <- readLines("C:/R/Project/a.txt")
word_data

# 다음 저장된 데이터에서 명사만 추출하여 new_word변수에 할당
# 명사만 분리할때는 extractNoun()함수를 사용한다.
# 행렬 형태의 word_data변수에서 모든 행에 함수를 적용하기 위해 sapply()함수를 같이 사용한다.
# sapply()함수는 형렬 구조의 데이터에서 모든 함수를 적용할 때 사용하는 함수로 sapply(데이터, 적용할 함수)형식으로 사용한다.
# USE.NAMES 열 이름을 나타내는 옵션이다. 여기서 F를 사용하여 열의 이름을 나타내지 않도록 한다.
new_word <- sapply(word_data, extractNoun, USE.NAMES = F)
new_word

# 실행 결과 단어가 제대로 추출되지 않았다.
# 이유는 해당 단어들이 세종사전에 등록되어 있지 않기 때문
# 이런 단어를 사용자 정의 사전에 별도로 추가한다.
add_word <- c("백두산", "남산", "철갑", "가을", "하늘", "달",
              "동해", "하느님", "삼천리", "화려강산", "공활", "바람", "구름",
              "밝은달")
buildDictionary(user_dic = data.frame(add_word, rep("ncn", length(add_word))), replace_usr_dic = T)

# 단어를 추가 후 정상으로 분류되는지 다시한번 명사 추출 실행
new_word <- sapply(word_data, extractNoun, USE.NAMES = F)
new_word
# 확인결과 백두산, 남산, 철갑, 가을, 하늘, 달 등 직접 사용자사전에 추가한 단어들이 정상적으로 추출됨

# 단어 처리된 데이터들을 더 편하게 처리하기 위해 행렬이 아닌 단어 뭉치 형태인 백터로 변환
# unlist()함수를 사용
undata <- unlist(new_word)
# 단어의 길이가 2 이상인 단어만 추출하여 undata 변수에 저장
undata2 <- Filter(function(x)(nchar(x)>=2), undata)
undata2

#rm(add_word, new_word, new_word2, undata, word_data)

# 사용 빈도에 따라 워드클라우드에서 크고 굵게 표시해야 하므로 단어의 사용 빈도 파악 필요
# table()함수를 사용해 항목과 빈도수를 확인하고 결과값을 저장
word_table <- table(undata2)
View(word_table)

# sort()함수를 이용하여 추s출한 단어를 빈도수 순으로 정렬
# 기본적으로 이 함수는 오름차순 정렬
# 빈도수가 높은 것부터 내림차순으로 정렬하기 위해 decreasing = T 옵션을 추가
bar = sort(word_table, decreasing = T)
h10 = head(bar, 10)
View(h10)
# 그래프 생성
barplot(h10, col = "skyblue", space = 0.4, main="애국가 명사 빈도수 Top10", ylab="빈도수", ylim=c(0,10))

# wordcloude2 package download
# install.packages("devtools")
# library(devtools)
# devtools::install_github("lchiffon/wordcloud2")
wordcloud2(word_table) # 내림차순으로 정리한 데이터를 wordcloude2패키지를 이용하여 실행
