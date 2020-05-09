#Identificación de comercios del rubro gastronómico dentro de los datos del RUS

## Activamos librerías
library(tidyverse)
library(rio)
library(sf)

## Importamos datos

### Generamos temp file y descargamos el zip de los datos del RUS
temp <- tempfile()

download.file("http://cdn.buenosaires.gob.ar/datosabiertos/datasets/relevamiento-usos-del-suelo/relevamiento-usos-del-suelo-2017-zip.zip",
              temp)

unzip(temp,overwrite = T)

RUS_df <- st_read("relevamiento-usos-suelo-2017.shp")

## Identificamos casos de indumentaria
Indumentaria <- RUS_df %>% 
  filter(X4_DIG %in% c(5131, 5233))

### separamos minorista de mayorista
Indumentaria$X4_DIG %>% as.character() %>% as.numeric() %>% table()
