install.packages("ggplot2")
install.packages("dplyr")
library(ggplot2)
library(dplyr)

korea_plot <- read.csv('C:/R/Project/전국도별/전처리자료.csv')  #csv file 읽기
#시도별 총 범죄수를 합하여 korea_total열을 추가한 후 각 값들을 삽입
korea_plot$korea_total <- korea_plot$살인기수 + korea_plot$살인미수등 + korea_plot$강도 + korea_plot$강간 + 
    korea_plot$유사강간 + korea_plot$강제추행 + korea_plot$기타강간강제추행등 + korea_plot$방화 + 
    korea_plot$절도 + korea_plot$상해 + korea_plot$폭행 + korea_plot$체포감금 + korea_plot$협박 + 
    korea_plot$약취유인 + korea_plot$폭력행위등 + korea_plot$공갈 + korea_plot$손괴 + korea_plot$직무유기 + 
    korea_plot$직권남용 + korea_plot$증수뢰 + korea_plot$통화 + korea_plot$문서인장 + korea_plot$유가증권인지 + 
    korea_plot$사기 + korea_plot$횡령 + korea_plot$배임 + korea_plot$성풍속범죄 + korea_plot$도박범죄 + 
    korea_plot$특별경제범죄 + korea_plot$마약범죄 + korea_plot$보건범죄 + korea_plot$환경범죄 + 
    korea_plot$교통범죄 + korea_plot$노동범죄 + korea_plot$안보범죄 + korea_plot$선거범죄 + 
    korea_plot$병역범죄 + korea_plot$기타범죄

korea_plot <- korea_plot %>% select(시도, korea_total)  #시도, korea_total 열만 추출
korea_plot2 <- korea_plot %>% select(korea_total)    #korea_total 열만 추출하여 새로운 변수 선언
k <- colSums(korea_plot2) #korea_total열의 합을 구하여 변수 k에 대입
korea_plot[18, ] <- c("합", k)   #18번째 행 생성 후 "합"과 각 시도별 범죄수(korea_total)의 합을 대입
korea_plot$korea_total <- as.numeric(korea_plot$korea_total)  #korea_total변수의 값들을 숫자로 변환
korea_plot$'상대도수' <- round(korea_plot$korea_total/k, 3)   #새로운 열을 추가한 후 상대도수 계산 후 각 열에 대입
korea_plot <- korea_plot[c(1:17),]    #상대도수를 구하기 위했던 합 행(18행)을 제거
View(korea_plot)

#시도별 범죄발생수 ggplot 막대그래프 오름차순으로 시각화
ggplot(korea_plot, aes(x = reorder(시도, -korea_total), y = korea_total)) + 
    geom_bar(stat = "identity", fill = "blue", colour = "black") + 
    theme_bw() + labs(title = "2017년도 전국 시도별 범죄 발생현황") + xlab("시도") + ylab("범죄발생수") + 
    theme(plot.title = element_text(face = "bold", size = 18, hjust = 0.5))

#pie차트 각 시도의 상대도수를 표시하며 시각화
pie(korea_plot$상대도수, labels = paste(korea_plot$시도, round(korea_plot$상대도수*100, 1), "%"))

#시도별 범죄발생수 ggplot 원형그래프로 시각화
ggplot(korea_plot, aes(x="", y=상대도수, fill=시도)) + geom_bar(width = 1, stat = "identity", color = "white") + 
    coord_polar("y") + geom_text(aes(label = paste(round(상대도수*100, 1), "%")), position = position_stack(vjust = 0.5)) + 
    theme_bw() + labs(title = "2017년도 전국 시도별 범죄 발생현황") + xlab("") + ylab("") + labs(fill="시도") + 
    theme(plot.title = element_text(face = "bold", size = 18, hjust = 0.5))

# 각 시도별 인구수 대비 범죄발생률 ggplot의 막대그래프로 시각화
korea_people <- read.csv('C:/R/Project/전국도별/2017_전국 시도별 총 인구수.csv')
korea_people <- subset(korea_people, 연령별 == "계")    #연령별 열에서 "계"에 해당하는 행만 추출
korea_people <- korea_people %>% select(시도, 인구수)   #시도, 인구수 열 추출
korea_people <- korea_people[c(2:18),]  #전국을 제외한 나머지 시도별 행 추출
View(korea_people)

k_cbind <- cbind(korea_plot, korea_people)  #2개의 DataFrame을 단순히 열 기준으로 병합: cbine()
k_cbind <- k_cbind[,-4]   #시도 열이 중복이 되므로 4번째 "시도"열 삭제
k_cbind$'범죄발생률' <- round(k_cbind$korea_total/k_cbind$인구수*100, 2)   # 범죄발생률 열 추가
k_cbind <- k_cbind %>% select(시도, 범죄발생률)  #그래프에 필요한 열의 값만 추출
View(k_cbind)

# stat='identity'는 y축의 높이를 데이터의 값으로 하는 bar그래프의 형태로 지정하는 것
ggplot(k_cbind, aes(x=reorder(시도, -범죄발생률), y=범죄발생률)) + 
    geom_bar(stat = "identity", fill = "#00eeee", colour = "black") + 
    theme_bw() + labs(title = "2017년도 전국 시도별 인구수 대비 범죄 발생률 현황") + 
    theme(plot.title = element_text(face = "bold", size = 18, hjust = 0.5)) + 
    xlab("시도") + ylab("범죄 발생률(%)")
