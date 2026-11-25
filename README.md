# Clientes Web

Aplicación web de una sola pantalla para registrar clientes con cédula, nombre, dirección y teléfono. Los registros viven en memoria y se reinician al detener la aplicación. No utiliza base de datos.

## Requisitos
- Java 11 o superior
- Conexión a Internet la primera vez que uses `mvnw.cmd` (descarga Maven automáticamente)

## Ejecutar en Windows
Abre CMD en la carpeta del proyecto y ejecuta:

```bat
mvnw.cmd spring-boot:run
```

Luego abre http://localhost:8081. Para crear un paquete ejecutable usa `mvnw.cmd clean package` y después `java -jar target\clientes-web-1.0.0.jar`.

El lanzador guarda Maven en `%USERPROFILE%\.m2\wrapper`, de modo que no es necesario instalarlo en el PATH.

La cédula debe ser única entre los clientes registrados durante la sesión actual.

