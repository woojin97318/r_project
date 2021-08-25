install.packages("ggplot2")
install.packages("dplyr")
library(ggplot2)
library(dplyr)

seoul_plot <- read.csv("C:/R/Project/서울시군구/전처리자료.csv")

seoul_plot <- seoul_plot %>% select(시군구, seoul_total)  #시군구, 합계 열 추출 프레임 생성
seoul_plot2 <- seoul_plot %>% select(seoul_total)
s <- colSums(seoul_plot2)
seoul_plot[26, ] <- c("합", s)
seoul_plot$seoul_total <- as.numeric(seoul_plot$seoul_total)
seoul_plot$'상대도수' <- round(seoul_plot$seoul_total/s, 3)    #상대도수 열 추가 후 소수점 3자리까지 표현
seoul_plot <- seoul_plot[c(1:25),]
View(seoul_plot)

ggplot(seoul_plot, aes(x = reorder(시군구, -seoul_total), y = seoul_total)) + 
    geom_bar(stat = "identity", fill = "green", colour = "black") + 
    theme_bw() + labs(title = "2017년도 전국 시군구별 범죄 발생현황") + xlab("시군구") + ylab("범죄발생수") + 
    theme(plot.title = element_text(face = "bold", size = 18, hjust = 0.5))

#pie차트 상대도수, 시군구를 라벨링하며 시각화
pie(seoul_plot$상대도수, labels = paste(seoul_plot$시군구, round(seoul_plot$상대도수*100, 1), "%"))

#ggplot 원형그래프 시각화
ggplot(seoul_plot, aes(x="", y=상대도수, fill=시군구)) + geom_bar(width = 1, stat = "identity", color = "white") + 
    coord_polar("y") + geom_text(aes(label = paste0(round(상대도수*100, 1), "%")), position = position_stack(vjust = 0.5)) + 
    theme_bw() + labs(title = "2017년도 전국 시군구별 5대 범죄 발생현황") + xlab("") + ylab("") + labs(fill="시군구") + 
    theme(plot.title = element_text(face = "bold", size = 18, hjust = 0.5))

# 인구수 대비 범죄발생률 막대그래프 시각화
seoul_people <- read.csv('C:/R/Project/서울시군구/2017_서울 시군구별 총 인구수.csv')
View(seoul_people)

s_cbind <- cbind(seoul, seoul_people)  #데이터프레임 열 기준으로 병합
s_cbind <- s_cbind[,-4]   #시군구 열이 중복이 되므로 4번째 "시군구"열 삭제
s_cbind$'범죄발생률' <- round(s_cbind$seoul_total/s_cbind$인구수*100, 2)   # 상대도수 열 추가
s_cbind <- s_cbind %>% select(시군구, 범죄발생률)  #필요한 열 추출
View(s_cbind)

# stat='identity'는 y축의 높이를 데이터의 값으로 하는 bar그래프의 형태로 지정하는 것
ggplot(s_cbind, aes(x=reorder(시군구, -범죄발생률), y=범죄발생률)) + 
    geom_bar(stat = "identity", fill = "#99ff00", colour = "black") + 
    theme_bw() + labs(title = "2017년도 서울 시군구별 인구수 대비 범죄발생률 현황") + 
    theme(plot.title = element_text(face = "bold", size = 18, hjust = 0.5)) + 
    xlab("시군구") + ylab("범죄 발생률(%)")
