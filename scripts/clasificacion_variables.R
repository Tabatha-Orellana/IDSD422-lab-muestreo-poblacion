
# clasificacion_variables.R — Parte A: clasificación de las variables de clientes.csv.
#
# El archivo data/clientes.csv tiene 12 clientes y 7 variables (más el id).
# El objetivo: clasificar cada variable (numérica continua/discreta, categórica
# binaria/ordinal/nominal) y verificar la clasificación en código.
#
# Regla del capítulo 3: el tipo que infiere el lenguaje es una pista, no la
# clasificación — el criterio (¿tiene sentido la mitad del valor? ¿hay orden
# entre las categorías?) decide.
#
# Uso (desde la raíz del repositorio): Rscript scripts/clasificacion_variables.R

clientes <- read.csv("data/clientes.csv", stringsAsFactors = FALSE)

# ---------------------------------------------------------------------------
# 1. Estructura del archivo
# ---------------------------------------------------------------------------
cat(sprintf("Dimensiones: %d filas × %d columnas\n",
            nrow(clientes), ncol(clientes)))
print(clientes)

# ---------------------------------------------------------------------------
# 2. Tipos inferidos (str) — la pista que da el lenguaje
# ---------------------------------------------------------------------------
str(clientes)

# TODO 1: Identificar las columnas numericas y de texto
columnas_numericas <- names(clientes)[sapply(clientes, is.numeric)]
columnas_texto <- names(clientes)[sapply(clientes, is.character)]

cat("\nColumnas numericas:\n")
print(columnas_numericas)

cat("\nColumnas de texto:\n")
print(columnas_texto)

cat("\nNota: satisfaccion llega como numero, pero es ordinal.\n")

# ---------------------------------------------------------------------------
# 3. Valores únicos — ¿cuántas categorías hay y cuáles son?
# ---------------------------------------------------------------------------
# TODO 2: Mostrar los valores unicos de cada columna
for (columna in names(clientes)) {
  valores <- unique(clientes[[columna]])

  cat("\nVariable:", columna, "\n")
  cat("Cantidad de valores unicos:", length(valores), "\n")
  print(valores)
}

# ---------------------------------------------------------------------------
# 4. Declarar el orden de las variables ordinales
# ---------------------------------------------------------------------------
# TODO 3: Convertir nivel_educacion en factor ordenado
orden_educacion <- c(
  "Primaria",
  "Secundaria",
  "Universidad",
  "Posgrado"
)

clientes$nivel_educacion <- factor(
  clientes$nivel_educacion,
  levels = orden_educacion,
  ordered = TRUE
)

cat("\nNivel de educacion ordenado:\n")
print(levels(clientes$nivel_educacion))

cat("\nNivel minimo de educacion:\n")
print(min(clientes$nivel_educacion))

# TODO 4: Convertir satisfaccion en factor ordinal
clientes$satisfaccion <- factor(
  clientes$satisfaccion,
  levels = 1:5,
  ordered = TRUE
)

cat("\nSatisfaccion ordenada:\n")
print(levels(clientes$satisfaccion))

cat("\n¿Satisfaccion es ordinal?\n")
print(is.ordered(clientes$satisfaccion))

# Prueba extra: escribir "Postgrado" en lugar de "Posgrado"
orden_incorrecto <- c(
  "Primaria",
  "Secundaria",
  "Universidad",
  "Postgrado"
)

educacion_incorrecta <- factor(
  read.csv("data/clientes.csv")$nivel_educacion,
  levels = orden_incorrecto,
  ordered = TRUE
)

cat("\nPrueba con 'Postgrado' mal escrito:\n")
cat("Cantidad de valores faltantes:\n")
print(sum(is.na(educacion_incorrecta)))

# ---------------------------------------------------------------------------
# 5. Resumen de la clasificación (para el informe)
# ---------------------------------------------------------------------------
# TODO 5: Clasificar cada variable
clasificacion <- c(
  cliente_id         = "Categorica nominal (identificador)",
  edad               = "Numerica discreta (registrada en anos completos)",
  numero_hijos       = "Numerica discreta",
  genero             = "Categorica nominal",
  nivel_educacion    = "Categorica ordinal",
  ciudad             = "Categorica nominal",
  ingresos_mensuales = "Numerica continua",
  satisfaccion       = "Categorica ordinal"
)

cat("\nResumen de la clasificación (para el informe):\n")
for (variable in names(clasificacion)) {
  cat(sprintf("  %-18s %s\n",
              variable, clasificacion[[variable]]))
}
