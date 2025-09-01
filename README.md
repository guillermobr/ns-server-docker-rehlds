# Natural Selection Server con ReHLDS en Docker

Un servidor de Natural Selection containerizado usando ReHLDS, ENSL Plugin Package y AMX Mod X.

## Características

- **ReHLDS**: Versión mejorada del servidor HLDS para mejor rendimiento y estabilidad
- **Natural Selection v3.3b9**: La versión completa del juego NS
- **ENSL Plugin Package**: Plugins específicos para Natural Selection de la comunidad ENSL
- **AMX Mod X**: Sistema de plugins y administración del servidor
- **Debian Bullseye Slim**: Imagen base ligera para menor tamaño del contenedor

## Requisitos

- Docker
- Docker Compose

## Instalación y Uso

1. **Clonar el repositorio:**
   ```bash
   git clone https://github.com/tu-usuario/ns-server-docker-rehlds.git
   cd ns-server-docker-rehlds
   ```

2. **Construir y ejecutar el servidor:**
   ```bash
   docker-compose up --build
   ```

3. **Ejecutar en segundo plano:**
   ```bash
   docker-compose up -d --build
   ```

## Configuración

### Configuración de Administradores

Edita el archivo `overlay/addons/amxmodx/configs/users.ini` para agregar administradores:

```ini
; Ejemplo con SteamID
"STEAM_0:0:123456" "" "abcdefghijklmnopqrstu" "ce"

; Ejemplo con nombre y contraseña
"AdminName" "password123" "abcdefghijklmnopqrstu" ""
```

### Configuración de Plugins

Modifica `overlay/addons/amxmodx/configs/plugins.ini` para habilitar/deshabilitar plugins:

```ini
; Plugins básicos de administración
admin.amxx          ; base de administración (requerido)
admincmd.amxx       ; comandos básicos de admin
adminhelp.amxx      ; ayuda de comandos
```

### Configuración del Servidor

El archivo `overlay/server.cfg` puede ser editado para personalizar la configuración del servidor.

## Estructura del Proyecto

```
.
├── Dockerfile              # Definición del contenedor
├── docker-compose.yml      # Configuración de Docker Compose
├── start_server.sh         # Script de inicio del servidor
├── overlay/                # Configuraciones personalizadas
│   └── addons/
│       ├── metamod/
│       │   └── plugins.ini  # Configuración de plugins de Metamod
│       └── amxmodx/
│           └── configs/     # Configuraciones de AMX Mod X
└── README.md
```

## Puertos

- **27015/UDP**: Puerto principal del servidor NS
- **27015/TCP**: Puerto TCP del servidor

## Comandos Útiles

### Acceder al contenedor
```bash
docker exec -it ns_server bash
```

### Ver logs del servidor
```bash
docker-compose logs -f nsserver
```

### Reiniciar el servidor
```bash
docker-compose restart nsserver
```

### Detener el servidor
```bash
docker-compose down
```

## Troubleshooting

### El servidor no inicia
- Verifica que los puertos 27015 no estén en uso
- Revisa los logs con `docker-compose logs nsserver`

### Problemas de permisos
- Asegúrate de que los archivos en `overlay/` tengan los permisos correctos
- El usuario `steam` (UID 1000) debe poder leer los archivos

### Crash con libcurl
- El Dockerfile incluye `libcurl4:i386` para resolver dependencias de 32-bit

## Contribuir

1. Fork el proyecto
2. Crea una rama para tu feature (`git checkout -b feature/AmazingFeature`)
3. Commit tus cambios (`git commit -m 'Add some AmazingFeature'`)
4. Push a la rama (`git push origin feature/AmazingFeature`)
5. Abre un Pull Request

## Licencia

Este proyecto está bajo la Licencia MIT. Ver el archivo `LICENSE` para más detalles.

## Créditos

- [ReHLDS](https://github.com/rehlds/ReHLDS) - Servidor HLDS mejorado
- [ENSL](https://github.com/ENSL/NS) - Natural Selection v3.3b9
- [ENSL Plugin Package](https://github.com/ENSL/ensl-plugin) - Plugins específicos para NS
- [AMX Mod X for NS](https://github.com/pierow/amxmodx-ns) - Sistema de plugins
