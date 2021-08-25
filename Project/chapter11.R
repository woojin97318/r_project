install.packages("ggplot2")
install.packages("dplyr") #데이터프레임 조작 패키지
library(ggplot2)
library(dplyr)

graph1 <- data.frame(height = c(160, 175, 189, 177, 170), weight = c(70, 75, 82, 77, 65))
plot(graph1$height, graph1$weight)

graph3 <- as.data.frame(ggplot2::diamonds)
View(graph3)
ggplot(data = graph3, aes(x = color)) + geom_bar()
ggplot(data = graph3, aes(x = carat, y = price)) + geom_point()
ggplot(data = graph3, aes(x = carat, y = price)) + geom_point() + xlim(1, 3) + ylim(5000, 15000)

graph4 <- as.data.frame(ggplot2::mpg)
View(graph4)
ggplot(data = graph4, aes(x = drv, y = cty)) + geom_boxplot()

graph5 <- mtcars
View(graph5)
ggplot(data = graph5, aes(x = wt, y = mpg)) + geom_line()

graph6 <- as.data.frame(undata2)
View(graph6)
ggplot(data = graph6, aes(x = undata2)) + geom_bar() + ylim(0, 8)

graph7 <- as.data.frame(h10)

ab = rename(graph7, A = undata2, B = Freq)
View(ab)
plot(ab$A, ab$B)
qplot(data = ab, x = A, y = B, geom)

ggplot(data = ab, aes(x = A)) + geom_
hist(ab$B)