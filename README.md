
<!-- IMPORTANT: do NOT edit README.Rmd! Edit index.Rmd instead,       -->

<!-- and generate README.Rmd using inst/extdata/code/create_README.sh -->

# <img src="img/logo_hemera.jpg" align="left" width="150px" /> <img src="img/Logo-UMAYOR.png" align="right" width="80px" />

# Práctica de Integración Mediada

Monitoreo Satelital de Kiwis con Sentinel-2 Agronomía UMayor 2019

## Reseña

La praćtica de integración mediada (PIM) es una actividad parte de la
malla de la carrera de Agronomía de la Universidad Mayor. En la PIM los
estudiantes deben demostrar su capacidad para resolver alguna
problemática relacionada a la agricultura.

En esta PIM se está realizando el monitoreo de kiwis utilizando imágenes
satelitales Sentinel-2 (A/B) además de drones. Para mas información
sobre Sentinel-2 pincha [acá](https://es.wikipedia.org/wiki/Sentinel-2)
o también
[acá](https://sentinel.esa.int/web/sentinel/missions/sentinel-2). El
objetivo de este estudio es encontrar una relación entre la radiación
reflejada por la vegetación en distintas longitudes de onda con
contenido de agua en la hoja y con calidad de kiwis en la cosecha.

Para el procesamiento de los datos se está trabajando con el software
[R](https://www.r-project.org/) en la IDE
[RStudio](https://www.rstudio.com/). El procesamiento de las imágenes
Sentinel-2 (descarga, corrección, transormación) se realiza con el
paquete [`sen2R`](https://github.com/ranghetti/sen2r) desarrollado por
Luigi Ranghetti and Lorenzo Busetto. Para el procesamiento y análisis de
los datos vectoriales ocupamos el paquete [`simple
feature`](https://github.com/r-spatial/sf)(Pebesma 2018a). Los datos
raster con el paquete
[`raster`](https://cran.r-project.org/web/packages/raster/index.html)(Hijmans
2019), esperando pronto evolucionar a
[STARS](https://cran.r-project.org/web/packages/RNetCDF/index.html)(Pebesma
2018b). El análisis de datos con todos los paquetes incluidos en
[tidyverse](https://www.tidyverse.org/)(Wickham 2017).

[Acá](/R) compartimos los script de procesamiento, análisis y descarga.
Los índices vegetacionales entre agosto 2018 a febrero 2019 los puedes
descarga en la carpeta [VIs](data/spatial/VIs). Pronto serán
actualizados.

Un ejemplo, series de imágenes de NDVI.

``` r
library(raster)
#> Loading required package: sp
list <- list.files('data/spatial/VIs/NDVI/',full.names=TRUE)
ndvi <- stack(list)
plot(ndvi)
```

![](README-unnamed-chunk-2-1.png)<!-- -->

Ranghetti, L. and Busetto, L. (2019). *sen2r: an R toolbox to find,
download and preprocess Sentinel-2 data*. R package version 1.0.0. DOI:
[10.5281/zenodo.1240384](https://dx.doi.org/10.5281/zenodo.1240384).
URL: <http://sen2r.ranghetti.info>.

<div id="refs" class="references">

<div id="ref-Hijmans2019">

Hijmans, Robert J. 2019. *Raster: Geographic Data Analysis and
Modeling*. <https://CRAN.R-project.org/package=raster>.

</div>

<div id="ref-Pebesma2018">

Pebesma, Edzer. 2018a. “Simple Features for R: Standardized Support for
Spatial Vector Data.” *The R Journal*.
<https://journal.r-project.org/archive/2018/RJ-2018-009/index.html>.

</div>

<div id="ref-Pebesma2018b">

———. 2018b. *Stars: Scalable, Spatiotemporal Tidy Arrays*.
<https://CRAN.R-project.org/package=stars>.

</div>

<div id="ref-Wickham2017">

Wickham, Hadley. 2017. *Tidyverse: Easily Install and Load the
’Tidyverse’*. <https://CRAN.R-project.org/package=tidyverse>.

</div>

</div>
