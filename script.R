#Identificación de comercios del rubro gastronómico dentro de los datos del RUS

## Activamos librerías
library(tidyverse)
library(rio)
library(sf)
library(tabulizer)
library(janitor)
## Importamos datos

### Generamos temp file y descargamos el zip de los datos del RUS
temp <- tempfile()

download.file("http://cdn.buenosaires.gob.ar/datosabiertos/datasets/relevamiento-usos-del-suelo/relevamiento-usos-del-suelo-2017-zip.zip",
              temp)

unzip(temp,overwrite = T)

RUS_df <- st_read("relevamiento-usos-suelo-2017.shp")

RUS_df$X4_DIG <- RUS_df$X4_DIG %>% as.character() %>% as.numeric()
RUS_df$X5_DIG <- RUS_df$X5_DIG %>% as.character() %>% as.numeric()

## Identificamos códigos de industrias de interés 
codes <- list()
codes$indumentaria <- c(51311:51315, 52331:52335,52339, 52341:52343)
codes$gastronomia <- c(55202, 55203, 55204, 55211, 55221)
codes$libreria <- c(51322, 52383, 52420, 51321, 52381)
codes$florerias <- c(52391)
codes$juguetes <- c(52393, 51392)
codes$joyas_y_relojes <- c(52372, 51342)
# codes$bijouterie <- c(52373)
codes$perfumeria <- c(52312)
# codes$decoracion <- c(52367)
codes$materiales_electricos <- c(51433, 52363)
codes$instrumentos_musicales <- c(51355, 52356)
codes$electrodomesticos <- c(51354, 52355)
codes$muebles <- c(51351, 51541, 51542, 52351, 52410)
codes$autos <- c(50100)
codes$motos <- c(50400)
codes$bicicletas <- c(51393, 52394)

## Generamos lista de salida
out_list <- map(codes,~RUS_df %>% 
                  filter(X5_DIG %in% .x) %>% 
                 nrow())


#hacemos lista para armar el xlsx detallado
RUS_extractor <- function(x){
  RUS_df %>% 
    st_drop_geometry() %>% 
    filter(X5_DIG %in% x) %>% 
    group_by(TIPO2_16) %>% 
    summarise(total = n()) %>% 
    adorn_totals()
} 


out_list_2 <- map(codes, RUS_extractor)


#armamos el xlsx

export(out_list_2, "rus_count.xlsx")





## Importamos datos del nomenclador
# Clanae_04 <- extract_tables('https://www.indec.gob.ar/ftp/cuadros/menusuperior/clasificadores/clanae_2004_19.pdf')
# 
# tables_vect <- map_lgl(Clanae_04, ~ ncol(.) == 2) %>% which()
# Clanae_04_df <- map_df(tables_vect, ~ pluck(Clanae_04, .) %>% data.frame() %>% set_names(c("code", "desc"))) %>% 
#   filter(code != "")  #pulir método para próxima iteración