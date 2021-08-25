# 2017년도 강원도 시군별 범죄 발생현황 지도시각화
install.packages("ggmap")
install.packages("ggplot2")
install.packages("raster")
install.packages("rgeos")
install.packages("maptools")
install.packages("rgdal")
install.packages("dplyr")
library("ggmap")
library("ggplot2")
library("raster")
library("rgeos")
library("maptools")
library("rgdal")
library("dplyr")

gangwon <- read.csv("C:/R/Project/강원도시군/전처리자료.csv")
View(gangwon)

gangwon_map <- shapefile("C:/R/Project/강원도시군/TL_SCCO_SIG.shp") #지리 정보 데이터셋
gangwon_map <- spTransform(gangwon_map, CRSobj = CRS('+proj=longlat +ellps=WGS84 +datum=WGS84 +no_defs'))
gangwon_map <- fortify(gangwon_map, region = 'SIG_CD')
gangwon_map$id <- as.numeric(gangwon_map$id)
gangwon_map <- gangwon_map[gangwon_map$id >= 42110,]
gangwon_map <- gangwon_map[gangwon_map$id <= 42830,]
View(gangwon_map)

gangwon_merge <- merge(gangwon_map, gangwon, by='id')
View(gangwon_merge)

gangwon_name <- read.csv("C:/R/Project/강원도시군/강원도 시군구별 좌표.csv")
gangwon_name <- merge(gangwon_name, gangwon, by="시군구")
gangwon_name <- gangwon_name %>% select(시군구, long, lat, gangwon_total)
View(gangwon_name)

ggplot() + geom_polygon(data = gangwon_merge, aes(x=long, y=lat, group=group, fill = gangwon_total), color = "black") + 
    geom_text(data = gangwon_name, aes(x = long, y = lat, label = paste(시군구, gangwon_total, sep = "\n")), size = 4) + 
    scale_fill_gradient(low = "white", high = "red") + labs(fill="범죄발생수") + 
    theme_bw() + labs(title = "2017년도 강원도 시군구별 범죄 발생현황") + xlab("경도") + ylab("위도") + 
    theme(plot.title = element_text(face = "bold", size = 18, hjust = 0.5))
