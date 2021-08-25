# 2017년도 서울 시군구별 5대 범죄 발생현황 지도시각화
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

seoul <- read.csv("C:/R/Project/서울시군구/전처리자료.csv") #시각화할 데이터셋
View(seoul)

seoul_map <- shapefile("C:/R/Project/서울시군구/TL_SCCO_SIG.shp") #지리 정보 데이터셋
# map을 spTransform() 함수를 이용하여 좌표계 변환 진행
seoul_map <- spTransform(seoul_map, CRSobj = CRS('+proj=longlat +ellps=WGS84 +datum=WGS84 +no_defs'))
#변환 전과 후의 형식 변화를 확인하고 싶다면 앞 뒤에 map@polygons[[1]]@Polygons[[1]]@coords %>% head(n = 10L)를
#실행하여 1-10행 좌표를 확인
seoul_map <- fortify(seoul_map, region = 'SIG_CD')  #region = ‘SIG_CD’ 옵션으로 인해 SIG_CD 컬럼이 id로 변환
#지리 정보 자료에는 대한민국 모든 구가 포함되어 있는데, id가 11740 이하가 서울시 구에 해당
#따라서 현재 문자형인 id 변수를 숫자로 변환한 후 11740 이하만 추출하여 seoul_map 변수를 생성
seoul_map$id <- as.numeric(seoul_map$id)
seoul_map <- seoul_map[seoul_map$id <= 11740,]
View(seoul_map)

#시각화할 자료(seoul)와 seoul_map에 id 변수가 존재 이를 key로 조인
seoul_merge <- merge(seoul_map, seoul, by='id')
View(seoul_merge)

#시도 이름을 쓰기 위한 seoul_name
seoul_name <- read.csv("C:/R/Project/서울시군구/서울 시군구별 좌표.csv")
seoul_name <- merge(seoul_name, seoul, by = "시군구")
seoul_name <- seoul_name %>% select(시군구, long, lat, seoul_total)
View(seoul_name)

# 서울 시군구별 범죄 발생현황 지도시각화
ggplot() + geom_polygon(data = seoul_merge, aes(x=long, y=lat, group=group, fill = seoul_total), color = "black") + 
    geom_text(data = seoul_name, aes(x = long, y = lat, label = paste(시군구, seoul_total, sep = "\n")), size = 4) + 
    scale_fill_gradient(low = "white", high = "green") + labs(fill="범죄발생수") + 
    theme_bw() + labs(title = "2017년도 서울 시군구별 5대 범죄 발생현황") + xlab("경도") + ylab("위도") + 
    theme(plot.title = element_text(face = "bold", size = 18, hjust = 0.5))
