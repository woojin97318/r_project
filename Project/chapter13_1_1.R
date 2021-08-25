# 2017년 전국 시도별 범죄발생횟수 지도시각화
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

korea <- read.csv('C:/R/Project/전국도별/전처리자료.csv') #csv file를 읽어온다

korea$id <- 0:16   #korea표의 열에 id열을 생성하여 각 시도별로 식별id값(0~16)을 넣어준다.
#korea 각 시도별 범죄횟수인 각 행들의 합을 korea_total열을 추가하여 값을 저장
korea$korea_total <- korea$살인기수 + korea$살인미수등 + korea$강도 + korea$강간 + korea$유사강간 + 
    korea$강제추행 + korea$기타강간강제추행등 + korea$방화 + korea$절도 + korea$상해 + korea$폭행 + 
    korea$체포감금 + korea$협박 + korea$약취유인 + korea$폭력행위등 + korea$공갈 + korea$손괴 + korea$직무유기 + 
    korea$직권남용 + korea$증수뢰 + korea$통화 + korea$문서인장 + korea$유가증권인지 + korea$사기 + korea$횡령 + 
    korea$배임 + korea$성풍속범죄 + korea$도박범죄 + korea$특별경제범죄 + korea$마약범죄 + korea$보건범죄 + 
    korea$환경범죄 + korea$교통범죄 + korea$노동범죄 + korea$안보범죄 + korea$선거범죄 + korea$병역범죄 + 
    korea$기타범죄
View(korea)

korea_map <- shapefile("C:/R/Project/전국도별/TL_SCCO_CTPRVN.shp")  #2017년 shape file을 로드
korea_map <- spTransform(korea_map, CRS("+proj=longlat"))  #위도, 경도 설정 / shp파일에는 설정되어있지 않기때문
korea_map <- fortify(korea_map) #fortify()함수: shp파일을 R에서 사용가능한 DataFrame으로 바꿔주는 함수
View(korea_map)

#merge함수로 DataFrame으로 변환된 shape file과 korea를 id값을 기준으로 병합한다.
korea_merge <- merge(korea_map, korea, by="id")
View(korea_merge)

korea_name <- read.csv('C:/R/Project/전국도별/시도별 좌표.csv')
korea_name <- merge(korea_name, korea, by="시도")
korea_name <- korea_name %>% select(시도, long, lat, korea_total)
View(korea_name)

options(scipen = 999)   #그래프에서 과학적 기호, scienrific notion, 공학 계산기 숫자가 안나오게 설정
# 지도데이터에 가공 데이터를 표시해준다
ggplot() + geom_polygon(data = korea_merge, aes(x=long, y=lat, group=group, fill=korea_total), color = "black") + 
    geom_text(data = korea_name, aes(x = long, y = lat, label = paste(시도, korea_total, sep = "\n")), size = 2.5) + 
    labs(fill="범죄발생수") + scale_fill_gradient(low = "white", high = "blue") + 
    theme_bw() + labs(title = "2017년도 전국 시도별 범죄 발생현황") + xlab("경도") + ylab("위도") + 
    theme(plot.title = element_text(face = "bold", size = 18, hjust = 0.5))
