# PL1 - Informe de estadistica descriptiva
# Masa corporal de los pinguinos del archipielago Palmer segun el sexo
# Autor: Joselin Yasbel Olivares Soto
# Datos: https://www.kaggle.com/datasets/parulpandey/palmer-archipelago-antarctica-penguin-data


# Mostrar hasta 10 cifras (si no, la varianza sale como 648372.5 en vez de 648372.49)
options(digits = 10)


# 1. CARGA Y ORGANIZACION DE LOS DATOS

# Lectura del archivo de datos (esta en la carpeta del proyecto)
pinguinos = read.csv("penguins_PL1_es.csv")
str(pinguinos)

# Variable cuantitativa (masa corporal, en gramos) y variable cualitativa (sexo)
masa = pinguinos$masa_corporal_g
sexo = pinguinos$sexo

# Submuestras de cada grupo
masa.macho  = masa[sexo == "macho"]
masa.hembra = masa[sexo == "hembra"]

# Tamanio de la muestra completa y de cada grupo
length(masa)
table(sexo)

# 2. MUESTRAS (apartado 3.1)

# Valores ordenados de menor a mayor
sort(masa)
sort(masa.macho)
sort(masa.hembra)


# 3. MEDIDAS ESTADISTICAS (apartado 3.2, tabla 1)
# Primera linea: todos los pinguinos. Segunda linea: por sexo con tapply()

# Medidas de centralizacion
round(mean(masa), 2)
round(tapply(masa, sexo, mean), 2)

round(median(masa), 2)
round(tapply(masa, sexo, median), 2)

# Medidas de dispersion
min(masa)
tapply(masa, sexo, min)

max(masa)
tapply(masa, sexo, max)

max(masa) - min(masa)                                   # rango
tapply(masa, sexo, max) - tapply(masa, sexo, min)

round(var(masa), 2)                                     # varianza muestral
round(tapply(masa, sexo, var), 2)

round(sd(masa), 2)                                      # desviacion estandar
round(tapply(masa, sexo, sd), 2)

round(sd(masa) / mean(masa), 3)                         # coeficiente de variacion
round(tapply(masa, sexo, sd) / tapply(masa, sexo, mean), 3)

# Medidas de localizacion (type = 2: metodo explicado en teoria)
quantile(masa, c(0.25, 0.75), type = 2)                 # Q1 y Q3
tapply(masa, sexo, quantile, c(0.25, 0.75), type = 2)

IQR(masa, type = 2)                                     # rango intercuartilico
tapply(masa, sexo, IQR, type = 2)

# Valores atipicos: los que quedan fuera de [Q1 - 1.5*IQR, Q3 + 1.5*IQR]
# Se calcula para todos, machos y hembras cambiando x
x = masa                                                # luego x = masa.macho y x = masa.hembra
Q1 = as.double(quantile(x, 0.25, type = 2))
Q3 = as.double(quantile(x, 0.75, type = 2))
c(Q1 - 1.5 * IQR(x, type = 2), Q3 + 1.5 * IQR(x, type = 2))       # limites
length(x[x < Q1 - 1.5 * IQR(x, type = 2) | x > Q3 + 1.5 * IQR(x, type = 2)])  # n. de atipicos

x = masa.macho
Q1 = as.double(quantile(x, 0.25, type = 2))
Q3 = as.double(quantile(x, 0.75, type = 2))
c(Q1 - 1.5 * IQR(x, type = 2), Q3 + 1.5 * IQR(x, type = 2))
length(x[x < Q1 - 1.5 * IQR(x, type = 2) | x > Q3 + 1.5 * IQR(x, type = 2)])

x = masa.hembra
Q1 = as.double(quantile(x, 0.25, type = 2))
Q3 = as.double(quantile(x, 0.75, type = 2))
c(Q1 - 1.5 * IQR(x, type = 2), Q3 + 1.5 * IQR(x, type = 2))
length(x[x < Q1 - 1.5 * IQR(x, type = 2) | x > Q3 + 1.5 * IQR(x, type = 2)])

# Medidas de forma (paquete e1071, se instala solo si no esta instalado)
if (!require("e1071")) install.packages("e1071")
library(e1071)

round(skewness(masa, type = 3), 3)                      # coeficiente de asimetria
round(tapply(masa, sexo, skewness, type = 3), 3)

round(kurtosis(masa, type = 3), 3)                      # coeficiente de apuntamiento
round(tapply(masa, sexo, kurtosis, type = 3), 3)

# Numero de valores inferiores y superiores a la media
length(masa[masa < mean(masa)])
length(masa[masa > mean(masa)])
length(masa.macho[masa.macho < mean(masa.macho)])
length(masa.macho[masa.macho > mean(masa.macho)])
length(masa.hembra[masa.hembra < mean(masa.hembra)])
length(masa.hembra[masa.hembra > mean(masa.hembra)])


# 4. TABLAS DE CONTINGENCIA (apartado 3.3)
# f = frecuencias absolutas; h = frecuencias relativas (prop.table)

# Tabla 2: masa corporal en 6 intervalos de 600 g
L6 = seq(2700, 6300, by = 600)
masa.agrupada.6 = cut(masa, breaks = L6, right = FALSE, include.lowest = TRUE,
                      dig.lab = 4)  # dig.lab = 4: muestra 2700 en vez de 2.7e+03
addmargins(table(masa.agrupada.6, sexo))
round(addmargins(prop.table(table(masa.agrupada.6, sexo))), 2)

# Tabla 3: masa corporal en 3 categorias
# Ligero [2700, 3600)  Medio [3600, 4800)  Pesado [4800, 6300]
L3 = c(2700, 3600, 4800, 6300)
masa.agrupada.3 = cut(masa, breaks = L3, right = FALSE, include.lowest = TRUE,
                      labels = c("Ligero", "Medio", "Pesado"))
addmargins(table(masa.agrupada.3, sexo))
round(addmargins(prop.table(table(masa.agrupada.3, sexo))), 2)

# Tabla 4: frecuencias relativas condicionadas al sexo
# prop.table(..., 2) divide entre el total de cada columna (cada sexo),
# asi cada columna suma 1; addmargins(..., 1) anade solo esa suma
round(addmargins(prop.table(table(masa.agrupada.3, sexo), 2), 1), 2)


# 5. DIAGRAMAS (apartado 3.4)
# Para guardar un grafico: panel Plots > Export > Save as Image

# Figura 1: porcentaje de pinguinos por sexo
frec.sexo = table(sexo)
# table() ordena alfabeticamente: primero hembra y despues macho
porc.sexo = round(100 * prop.table(frec.sexo), 1)
etiq.sexo = paste0(c("Hembra ", "Macho "), format(porc.sexo, decimal.mark = ","), "%")
pie(frec.sexo, labels = etiq.sexo, col = c("coral", "steelblue"))

# Figura 2: histogramas (arriba) y diagramas de caja (abajo)
# Linea negra = mediana; linea roja discontinua = media
# mar reduce los margenes para que los 6 graficos quepan en el panel
par(mfrow = c(2, 3), mar = c(4, 4, 2, 1))

hist(masa, breaks = L6, main = "Masa corporal (todos)",
     xlab = "Masa corporal (g)", ylab = "Frecuencia", col = "lightblue")
abline(v = median(masa), lwd = 2)
abline(v = mean(masa), lwd = 2, lty = 2, col = "red")

hist(masa.macho, breaks = L6, main = "Masa corporal (machos)",
     xlab = "Masa corporal (g)", ylab = "Frecuencia", col = "lightblue")
abline(v = median(masa.macho), lwd = 2)
abline(v = mean(masa.macho), lwd = 2, lty = 2, col = "red")

hist(masa.hembra, breaks = L6, main = "Masa corporal (hembras)",
     xlab = "Masa corporal (g)", ylab = "Frecuencia", col = "lightblue")
abline(v = median(masa.hembra), lwd = 2)
abline(v = mean(masa.hembra), lwd = 2, lty = 2, col = "red")

boxplot(masa, horizontal = TRUE, col = "lightblue", xlab = "Masa corporal (g)")
abline(v = mean(masa), lwd = 2, lty = 2, col = "red")

boxplot(masa.macho, horizontal = TRUE, col = "lightblue", xlab = "Masa corporal (g)")
abline(v = mean(masa.macho), lwd = 2, lty = 2, col = "red")

boxplot(masa.hembra, horizontal = TRUE, col = "lightblue", xlab = "Masa corporal (g)")
abline(v = mean(masa.hembra), lwd = 2, lty = 2, col = "red")

# Figura 3: porcentaje de pinguinos en cada categoria de masa corporal
par(mfrow = c(1, 3), mar = c(1, 3, 3, 3))
colores3 = c("green3", "blue", "red")

f.todos = table(masa.agrupada.3)
pie(f.todos, labels = paste0(names(f.todos), " ", round(100 * prop.table(f.todos)), "%"),
    col = colores3, main = "Masa corporal - todos")

f.macho = table(masa.agrupada.3[sexo == "macho"])
pie(f.macho, labels = paste0(names(f.macho), " ", round(100 * prop.table(f.macho)), "%"),
    col = colores3, main = "Masa corporal - machos")

f.hembra = table(masa.agrupada.3[sexo == "hembra"])
pie(f.hembra, labels = paste0(names(f.hembra), " ", round(100 * prop.table(f.hembra)), "%"),
    col = colores3, main = "Masa corporal - hembras")

# Vuelve a un solo grafico por panel con los margenes normales
par(mfrow = c(1, 1), mar = c(5, 4, 4, 2))


# 6. DIAGRAMAS AVANZADOS (actividad extra, apartado 3.5)

# Paquete para el diagrama de violin (se instala solo si no esta instalado)
if (!require("vioplot")) install.packages("vioplot")
library(vioplot)

# Figura 4: diagrama de violin (forma de la distribucion + caja y mediana)
# Los titulos de los ejes se ponen con title() para que no se monten
# con los numeros (algunas versiones de vioplot los colocan mal)
vioplot(masa.macho, masa.hembra, names = c("Macho", "Hembra"),
        col = c("lightblue", "lightpink"))
title(xlab = "Sexo", ylab = "Masa corporal (g)")

# Figura 5: curvas de densidad de ambos grupos superpuestas
d.macho  = density(masa.macho)
d.hembra = density(masa.hembra)
plot(d.macho, col = "steelblue", lwd = 3, main = "",
     xlab = "Masa corporal (g)", ylab = "Densidad",
     xlim = range(d.macho$x, d.hembra$x), ylim = range(d.macho$y, d.hembra$y))
lines(d.hembra, col = "coral", lwd = 3)
legend("topright", c("Macho", "Hembra"), col = c("steelblue", "coral"), lwd = 3, bty = "n")

# Figura 6: diagramas Q-Q. Cuanto mas cerca de la recta roja, mas "normal"
par(mfrow = c(1, 2), mar = c(4, 4, 2, 1))
qqnorm(masa.macho, main = "Q-Q plot (machos)", col = "steelblue", pch = 19,
       xlab = "Cuantiles teóricos (normal)", ylab = "Cuantiles muestrales (g)")
qqline(masa.macho, col = "red", lwd = 2)
qqnorm(masa.hembra, main = "Q-Q plot (hembras)", col = "coral", pch = 19,
       xlab = "Cuantiles teóricos (normal)", ylab = "Cuantiles muestrales (g)")
qqline(masa.hembra, col = "red", lwd = 2)
par(mfrow = c(1, 1), mar = c(5, 4, 4, 2))

# Prueba de normalidad de Shapiro-Wilk: si p-valor < 0,05 no es normal
shapiro.test(masa.macho)
shapiro.test(masa.hembra)

# Figura 7: funcion de distribucion empirica (ECDF)
# Proporcion de pinguinos con masa <= x; la mediana es donde cruza el 50%
plot(ecdf(masa.macho), col = "steelblue", lwd = 2, pch = NA, main = "",
     xlab = "Masa corporal (g)", ylab = "Probabilidad acumulada")
lines(ecdf(masa.hembra), col = "coral", lwd = 2, pch = NA)
abline(h = 0.5, lty = 3, col = "gray40")
legend("bottomright", c("Macho", "Hembra"), col = c("steelblue", "coral"), lwd = 2, bty = "n")

# Figura 8: comparacion directa de machos y hembras (practica 3, apartado 7)
# Izquierda: barras agrupadas por categoria. Derecha: cajas una al lado de otra
sexo.f = factor(sexo, levels = c("macho", "hembra"), labels = c("Macho", "Hembra"))
par(mfrow = c(1, 2), mar = c(4, 4, 2, 1))
# ylim llega hasta 120 para dejar hueco arriba a la leyenda (la barra mas alta es 94)
barplot(table(sexo.f, masa.agrupada.3), beside = TRUE, col = c("steelblue", "coral"),
        ylim = c(0, 120), cex.names = 0.85, legend.text = TRUE, args.legend = list(x = "topright", bty = "n"),
        xlab = "Categoría de masa corporal", ylab = "Número de pingüinos")
boxplot(masa ~ sexo.f, col = c("steelblue", "coral"),
        xlab = "Sexo", ylab = "Masa corporal (g)")
par(mfrow = c(1, 1), mar = c(5, 4, 4, 2))

# Figura 9: histogramas con la curva normal superpuesta (practica 2, apartado 2.4)
# freq = FALSE dibuja densidades para poder comparar con la curva normal
par(mfrow = c(1, 2), mar = c(4, 4, 2, 1))
hist(masa.macho, breaks = L6, freq = FALSE, col = "lightblue", main = "Machos",
     xlab = "Masa corporal (g)", ylab = "Densidad")
curve(dnorm(x, mean(masa.macho), sd(masa.macho)), add = TRUE, col = "red", lwd = 2)
hist(masa.hembra, breaks = L6, freq = FALSE, col = "lightpink", main = "Hembras",
     xlab = "Masa corporal (g)", ylab = "Densidad")
curve(dnorm(x, mean(masa.hembra), sd(masa.hembra)), add = TRUE, col = "red", lwd = 2)
par(mfrow = c(1, 1), mar = c(5, 4, 4, 2))

# Figura 10: diagrama de caja interactivo (actividad extra)
# Aparece en el panel "Viewer" de RStudio (al lado de "Plots"). Al pasar
# el raton por cada punto se ve la masa, la especie y la isla de ese
# pinguino; tambien permite hacer zoom y ocultar un grupo en la leyenda
if (!require("plotly")) install.packages("plotly")
library(plotly)

fig10 = plot_ly(x = sexo.f, y = masa, color = sexo.f, colors = c("steelblue", "coral"),
                type = "box", boxpoints = "all", jitter = 0.4, pointpos = 0,
                text = paste("Especie:", pinguinos$especie, "<br>Isla:", pinguinos$isla),
                hoverinfo = "y+text")
fig10 = layout(fig10, xaxis = list(title = "Sexo"), yaxis = list(title = "Masa corporal (g)"))
fig10

