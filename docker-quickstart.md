# 🐳 Docker Compose: PostgreSQL + PostGIS + pgAdmin

Este proyecto levanta un entorno SIG con PostgreSQL + PostGIS y pgAdmin usando Docker Compose.

---

## Comandos útiles

### Inicializar el entorno
```bash
docker-compose up -d
```
Levanta los contenedores en segundo plano.

---

### Ver estado de los servicios
```bash
docker ps
```
Muestra los contenedores en ejecución.

---

### Detener el entorno
```bash
docker-compose down
```
Apaga los contenedores, pero **no borra los datos** (porque están en volúmenes persistentes).

---

### Ver logs (opcional)
```bash
docker-compose logs -f
```
Muestra los logs en tiempo real.

---

### Entrar al contenedor de la base de datos
```bash
docker exec -it postgres_postgis bash
```

Una vez dentro, podés ejecutar `psql`:

```bash
psql -U gisuser -d gisdb
```

---

## Acceder a pgAdmin

- URL: [http://localhost:5050](http://localhost:5050)
- Email: `admin@example.com`
- Contraseña: `admin`

---

## Datos de conexión desde QGIS o pgAdmin

| Parámetro      | Valor           |
|----------------|-----------------|
| Host           | `db` (si estás dentro de otro contenedor) o `localhost` (desde tu máquina) |
| Puerto         | `5432`          |
| Usuario        | `gisuser`       |
| Contraseña     | `gispassword`   |
| Base de datos  | `gisdb`         |

---

## Eliminar TODO (contenedores, volúmenes, red)

 Esto borra datos permanentemente.

```bash
docker-compose down -v
```

---

##  Sugerencia

Si modificás `docker-compose.yml`, podés aplicar los cambios con:

```bash
docker-compose up -d --build
```

---
