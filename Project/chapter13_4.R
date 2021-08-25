install.packages("ggplot2")
install.packages("dplyr")
library(ggplot2)
library(dplyr)

time_plot <- read.csv("C:/R/Project/2017_범죄 발생시간_전처리자료.csv")
time_plot <- time_plot[c(1:8),]
View(time_plot)

ggplot(time_plot, aes(x="", y=상대도수, fill=시간)) + geom_bar(width = 1, stat = "identity", color = "white") + 
    coord_polar("y") +  geom_text(aes(label = paste(시간, "시\n", round(상대도수*100, 1), "%")), position = position_stack(vjust = 0.5)) +
    theme_bw() + labs(title = "2017년도 범죄 발생시간 현황") + xlab("") + ylab("") + labs(fill="시간") + 
    theme(plot.title = element_text(face = "bold", size = 18, hjust = 0.5)) + theme_void()
