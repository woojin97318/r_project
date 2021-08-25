install.packages("ggplot2")
install.packages("dplyr")
library(ggplot2)
library(dplyr)

gangwon_plot <- read.csv("C:/R/Project/강원도시군/전처리자료.csv")
gangwon_plot <- gangwon_plot %>% select(시군구, gangwon_total)  #시군구, gangwon_total 열 추출
gangwon_plot2 <- gangwon_plot %>% select(gangwon_total)
g <- colSums(gangwon_plot2)
gangwon_plot[19, ] <- c("합", g)
gangwon_plot$gangwon_total <- as.numeric(gangwon_plot$gangwon_total)
gangwon_plot$'상대도수' <- round(gangwon_plot$gangwon_total/g, 3)    #상대도수 열 추가 후 소수점 3자리까지 표현
gangwon_plot <- gangwon_plot[c(1:18),]
View(gangwon_plot)

ggplot(gangwon_plot, aes(x = reorder(시군구, -gangwon_total), y = gangwon_total)) + 
    geom_bar(stat = "identity", fill = "red", colour = "black") + 
    theme_bw() + labs(title = "2017년도 강원도 시군구별 범죄발생 현황") + xlab("시군구") + ylab("범죄발생수") + 
    theme(plot.title = element_text(face = "bold", size = 18, hjust = 0.5))

#pie차트 상대도수, 시군구를 라벨링하며 시각화
pie(gangwon_plot$상대도수, labels = paste(gangwon_plot$시군구, round(gangwon_plot$상대도수*100, 1), "%"))

#ggplot 원형그래프 시각화
ggplot(gangwon_plot, aes(x="", y=상대도수, fill=시군구)) + geom_bar(width = 1, stat = "identity", color = "white") + 
    coord_polar("y") + geom_text(aes(label = paste(round(상대도수*100, 1), "%")), position = position_stack(vjust = 0.5)) + 
    theme_bw() + labs(title = "2017년도 강원도 시군구별 범죄발생 현황") + xlab("") + ylab("") + labs(fill="시군구") + 
    theme(plot.title = element_text(face = "bold", size = 18, hjust = 0.5))

# 인구수 대비 범죄발생률 막대그래프 시각화
gangwon_people <- read.csv('C:/R/Project/강원도시군/2017_강원도 시군별 총 인구수.csv')
View(gangwon_people)

g_cbind <- cbind(gangwon_plot, gangwon_people)  #데이터프레임 열 기준으로 병합
g_cbind <- g_cbind[,-4]   #시군구 열이 중복이 되므로 4번째 "시군구"열 삭제
g_cbind$'범죄발생률' <- round(g_cbind$gangwon_total/g_cbind$인구수*100, 2)   # 상대도수 열 추가
g_cbind <- g_cbind %>% select(시군구, 범죄발생률)  #필요한 열 추출
View(g_cbind)

# stat='identity'는 y축의 높이를 데이터의 값으로 하는 bar그래프의 형태로 지정하는 것
ggplot(g_cbind, aes(x=reorder(시군구, -범죄발생률), y=범죄발생률)) + 
    geom_bar(stat = "identity", fill = "#ff0088", colour = "black") + 
    theme_bw() + labs(title = "2017년도 강원도 시군구별 인구수 대비 범죄발생률 현황") + 
    theme(plot.title = element_text(face = "bold", size = 18, hjust = 0.5)) + 
    xlab("시군구") + ylab("범죄 발생률(%)")
