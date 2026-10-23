
# muestreo.R — Parte B: población vs. muestra (RetailAndina).
#
# Población: data/clientes_400.csv (N = 400).
# Variable de interés: ingresos_mensuales.
#
# Ejecutar desde la raíz del repositorio:
# Rscript scripts/muestreo.R

# ---------------------------------------------------------------------------
# Función para mostrar resultados
# ---------------------------------------------------------------------------

reporte <- function(nombre, muestra, parametro) {

  if (is.null(muestra)) {
    cat(sprintf("[%s] pendiente de completar (TODO)\n", nombre))
    return(invisible(NULL))
  }

  n <- nrow(muestra)
  media <- mean(muestra$ingresos_mensuales)
  diferencia <- media - parametro
  composicion <- table(muestra$ciudad)

  cat(sprintf(
    "[%s] n=%d  media=%.2f USD  (parametro %.2f, diferencia %+.2f)\n",
    nombre, n, media, parametro, diferencia
  ))

  print(composicion)
  cat("\n")
}

# ---------------------------------------------------------------------------
# 1. Población y parámetro
# ---------------------------------------------------------------------------

poblacion <- read.csv(
  "data/clientes_400.csv",
  stringsAsFactors = FALSE
)

parametro <- mean(poblacion$ingresos_mensuales)

cat("--- POBLACION ---\n")
cat("Clientes:", nrow(poblacion), "\n")
cat("Columnas:", ncol(poblacion), "\n")
cat(sprintf("Media poblacional: %.2f USD\n", parametro))

cat("\nComposicion por ciudad:\n")
print(table(poblacion$ciudad))

# ---------------------------------------------------------------------------
# 2. Muestreo por conveniencia
# ---------------------------------------------------------------------------

# TODO 1: Seleccionar los primeros 20 clientes
muestra_conv <- head(poblacion, 20)

# ---------------------------------------------------------------------------
# 3. Muestreo aleatorio simple
# ---------------------------------------------------------------------------

# TODO 2: Seleccionar 20 clientes con semilla 1
set.seed(1)

muestra_aas <- poblacion[
  sample(nrow(poblacion), size = 20, replace = FALSE),
  ,
  drop = FALSE
]

# TODO 3: Repetir el sorteo con semillas 1 a 5
cat("\n--- MEDIAS DE CINCO SORTEOS ---\n")

medias_semillas <- numeric(5)

for (semilla in 1:5) {

  set.seed(semilla)

  muestra <- poblacion[
    sample(nrow(poblacion), size = 20, replace = FALSE),
    ,
    drop = FALSE
  ]

  medias_semillas[semilla] <- mean(
    muestra$ingresos_mensuales
  )

  cat(sprintf(
    "Semilla %d: %.2f USD\n",
    semilla,
    medias_semillas[semilla]
  ))
}

# ---------------------------------------------------------------------------
# 4. Muestreo estratificado proporcional
# ---------------------------------------------------------------------------

# TODO 4: Seleccionar el 5 % de cada ciudad
set.seed(1)

muestra_est <- poblacion |>
  dplyr::group_by(ciudad) |>
  dplyr::slice_sample(prop = 0.05) |>
  dplyr::ungroup()

# ---------------------------------------------------------------------------
# 5. Comparación final de los diseños
# ---------------------------------------------------------------------------

cat("\n--- COMPARACION DE DISEÑOS ---\n")

reporte("Conveniencia", muestra_conv, parametro)
reporte("Aleatorio simple", muestra_aas, parametro)
reporte("Estratificado", muestra_est, parametro)

resumen <- data.frame(
  diseno = c(
    "Conveniencia",
    "Aleatorio simple",
    "Estratificado"
  ),
  n = c(
    nrow(muestra_conv),
    nrow(muestra_aas),
    nrow(muestra_est)
  ),
  media_estimada = c(
    mean(muestra_conv$ingresos_mensuales),
    mean(muestra_aas$ingresos_mensuales),
    mean(muestra_est$ingresos_mensuales)
  )
)

resumen$diferencia <- resumen$media_estimada - parametro

cat("\n--- TABLA RESUMEN ---\n")
print(resumen, row.names = FALSE)

cat("\n--- COMPOSICION DE LA MUESTRA ESTRATIFICADA ---\n")
print(table(muestra_est$ciudad))
