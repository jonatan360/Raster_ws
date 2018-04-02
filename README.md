# Taller raster

## Propósito

Comprender algunos aspectos fundamentales del paradigma de rasterización.

## Tareas

Emplee coordenadas baricéntricas para:

1. Rasterizar un triángulo;
2. Implementar un algoritmo de anti-aliasing para sus aristas; y,
3. Hacer shading sobre su superficie.

Implemente la función ```triangleRaster()``` del sketch adjunto para tal efecto, requiere la librería [frames](https://github.com/VisualComputing/framesjs/releases).

## Integrantes

Máximo 3.

Complete la tabla:

|   Integrante  | github nick |
|---------------|-------------|
| Lizzy Tengana | lizzyt10h   |
| Jonatan Parra | jonatan360  |

## Discusión

Describa los resultados obtenidos. Qué técnicas de anti-aliasing y shading se exploraron? Adjunte las referencias. Discuta las dificultades encontradas.


Usando la librería frames se realizo el raster del triangulo utilizando las coordenadas baricéntricas. 
Se implementó un algoritmo de antialiasing el cual divide un pixel en regiones a su vez se analizó que cada región para asignarle su respectivo color e intensidad. 

Se analizaron las siguientes técnicas:

Anti Aliasing:
    * UnderSampling
    * MSAA
    * Spatial AntiAliasing

Shading:
    * Analytical shading
    * Aspect-Based shading

     
Hubo dificultades al implementar las coordenadas baricentricas y para elegir el método mas adecuado de antialising.git


## Entrega

* Modo de entrega: [Fork](https://help.github.com/articles/fork-a-repo/) la plantilla en las cuentas de los integrantes (de las que se tomará una al azar).
* Plazo: 1/4/18 a las 24h.
