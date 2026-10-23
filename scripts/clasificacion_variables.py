
# clasificacion_variables.py — Parte A: clasificación de las variables de clientes.csv.
#
# El archivo data/clientes.csv tiene 12 clientes y 7 variables (más el id).
# El objetivo: clasificar cada variable (numérica continua/discreta, categórica
# binaria/ordinal/nominal) y verificar la clasificación en código.
#
# Regla del capítulo 3: el dtype es una pista, no la clasificación — el criterio
# (¿tiene sentido la mitad del valor? ¿hay orden entre las categorías?) decide.
#
# Uso (desde la raíz del repositorio):  python scripts/clasificacion_variables.py

import pandas as pd

clientes = pd.read_csv("data/clientes.csv")

# ---------------------------------------------------------------------------
# 1. Estructura del archivo
# ---------------------------------------------------------------------------
print(f"Dimensiones: {clientes.shape[0]} filas × {clientes.shape[1]} columnas")
print()
print("Primeras filas:")
print(clientes.to_string(index=False))
print()

# ---------------------------------------------------------------------------
# 2. Tipos inferidos (dtype) — la pista que da el lenguaje
# ---------------------------------------------------------------------------
print("Tipos inferidos (dtype):")
print(clientes.dtypes)
print()

# TODO 1: Identificar las columnas numericas y de texto
columnas_numericas = clientes.select_dtypes(include="number").columns
columnas_texto = clientes.select_dtypes(include="object").columns

print("Columnas numericas:")
print(list(columnas_numericas))

print("Columnas de texto:")
print(list(columnas_texto))

print("Nota: satisfaccion llega como numero, pero es ordinal.")
print()

# ---------------------------------------------------------------------------
# 3. Valores únicos — ¿cuántas categorías hay y cuáles son?
# ---------------------------------------------------------------------------
# TODO 2: Mostrar valores unicos de cada columna
for columna in clientes.columns:
    valores = clientes[columna].unique()

    print(f"Variable: {columna}")
    print(f"Cantidad de valores unicos: {len(valores)}")
    print(f"Valores: {valores}")
    print()

print()

# ---------------------------------------------------------------------------
# 4. Declarar el orden de las variables ordinales
# ---------------------------------------------------------------------------
# Una ordinal se guarda como texto (o como número) y su orden natural se pierde:
# alfabéticamente "Posgrado" iría antes que "Primaria", que no tiene sentido.
#
# TODO 3: Convertir nivel_educacion en categoria ordenada
orden_educacion = [
    "Primaria",
    "Secundaria",
    "Universidad",
    "Posgrado"
]

tipo_educacion = pd.CategoricalDtype(
    categories=orden_educacion,
    ordered=True
)

clientes["nivel_educacion"] = clientes["nivel_educacion"].astype(
    tipo_educacion
)

print("Nivel de educacion ordenado:")
print(clientes["nivel_educacion"].dtype)

print("Nivel minimo:")
print(clientes["nivel_educacion"].min())

print()

# TODO 4: Convertir satisfaccion en categoria ordinal
orden_satisfaccion = [1, 2, 3, 4, 5]

tipo_satisfaccion = pd.CategoricalDtype(
    categories=orden_satisfaccion,
    ordered=True
)

clientes["satisfaccion"] = clientes["satisfaccion"].astype(
    tipo_satisfaccion
)

print("Satisfaccion ordenada:")
print(clientes["satisfaccion"].dtype)

print("Nivel minimo de satisfaccion:")
print(clientes["satisfaccion"].min())

# Prueba extra: escribir incorrectamente "Postgrado"
orden_incorrecto = [
    "Primaria",
    "Secundaria",
    "Universidad",
    "Postgrado"
]

tipo_incorrecto = pd.CategoricalDtype(
    categories=orden_incorrecto,
    ordered=True
)

educacion_incorrecta = pd.read_csv(
    "data/clientes.csv"
)["nivel_educacion"].astype(tipo_incorrecto)

print("\nPrueba de error con 'Postgrado':")
print("Valores faltantes:")
print(educacion_incorrecta.isna().sum())

print()

# ---------------------------------------------------------------------------
# 5. Resumen de la clasificación (para el informe)
# ---------------------------------------------------------------------------
# TODO 5: Completar la clasificacion de cada variable
clasificacion = {
    "cliente_id": "Categorica nominal (identificador)",
    "edad": "Numerica discreta (registrada en anos completos)",
    "numero_hijos": "Numerica discreta",
    "genero": "Categorica nominal",
    "nivel_educacion": "Categorica ordinal",
    "ciudad": "Categorica nominal",
    "ingresos_mensuales": "Numerica continua",
    "satisfaccion": "Categorica ordinal",
}

print("Resumen de la clasificación (para el informe):")
for variable, tipo in clasificacion.items():
    print(f"  {variable:20s} {tipo}")
