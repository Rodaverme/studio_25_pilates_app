# studio_25_pilates_app

# Studio 25 Pilates App

Aplicación móvil para los clientes de **Estudio 25 Pilates**, construida con Flutter. Permite explorar clases, reservar cupos, comprar planes, pagar con tarjeta, invitar acompañantes y recibir notificaciones push, todo conectado al backend del estudio.

## Características

- **Autenticación**: inicio de sesión, registro y recuperación de contraseña, con token guardado de forma segura (`flutter_secure_storage`) y renovación mediante un interceptor de Dio.
- **Inicio y estadísticas**: resumen de uso del plan y próximas clases.
- **Calendario y clases**: consulta de clases por ocurrencia, con detalle de instructor, sala y nivel.
- **Reservas**: verificación de disponibilidad, reserva de cupo y pantallas de éxito/error del pago.
- **Planes**: listado y compra de planes, con estado del plan activo.
- **Pagos**: tarjetas guardadas, alta de nueva tarjeta (`flutter_credit_card`), comercios/merchants y transacciones.
- **Invitados**: invitar a una persona a una clase mediante formulario de invitación.
- **Notificaciones push**: Firebase Cloud Messaging con manejo de mensajes en primer plano, segundo plano y al abrir la app.
- **Perfil**: mis datos, mis tarjetas, mis clases, mis reservas y mis pagos.
- **Idiomas**: español e inglés.

## Stack técnico

| Área | Tecnología |
| --- | --- |
| Framework | Flutter (Dart SDK `^3.8.1`) |
| Estado | `flutter_bloc` (Cubits y un Bloc para notificaciones) |
| Navegación | `go_router` (con redirección según autenticación) |
| Red | `dio` |
| Formularios | `formz` |
| Notificaciones | `firebase_core`, `firebase_messaging` |
| Almacenamiento seguro | `flutter_secure_storage` |
| UI | `animate_do`, `carousel_slider`, `smooth_page_indicator`, `vibration` |
| Localización | `flutter_localizations`, `flutter_localization`, `intl` |

## Arquitectura

El proyecto sigue una separación por capas inspirada en Clean Architecture:

```
lib/
├── config/            # Cliente Dio, router (go_router) y tema
├── domain/            # Entidades, contratos de datasources y repositorios
├── infrastructure/    # Implementaciones, modelos, mappers e inputs (formz)
└── presentation/      # Pantallas, vistas, widgets, cubits/blocs y servicios
```

Flujo de datos: `Vista → Cubit/Bloc → Repository → Datasource (Dio) → API`, y los modelos de la API se convierten a entidades de dominio mediante *mappers*.

## Rutas principales

| Ruta | Descripción |
| --- | --- |
| `/` | Login |
| `/register` | Registro |
| `/resetPassword` | Recuperar contraseña |
| `/Home` | Inicio |
| `/calendar` | Calendario de clases |
| `/class/:id` | Detalle de clase |
| `/reservation/:id` | Reserva y pago |
| `/plans` | Planes disponibles |
| `/invite/:id` | Invitar a una clase |
| `/notifications` | Notificaciones |
| `/perfil` | Perfil y sub-secciones (`/mis_tarjetas`, `/mis_classes`, `/mis_reservas`, `/mis_pagos`, `/mi_perfil`) |
| `/new_card` | Agregar tarjeta |

Las rutas privadas redirigen al login si no hay sesión activa.

## Backend

La app consume una API REST del estudio. La URL base se define en `lib/config/dio/dio_client.dart`. Los grupos de endpoints incluyen `/api/client/*` (login, registro, perfil, tarjetas, pagos, notificaciones), `/api/classes`, `/api/occurrences`, `/api/reservations`, `/api/plans`, `/api/payments`, `/api/guests`, `/api/instructors`, `/api/rooms` y `/api/class-levels`.

## Requisitos previos

- [Flutter SDK](https://docs.flutter.dev/get-started/install) compatible con Dart `^3.8.1`
- Android Studio / Xcode según la plataforma de destino
- Un proyecto de Firebase configurado (para notificaciones push)

## Puesta en marcha

```bash
# 1. Clonar el repositorio
git clone https://github.com/Rodaverme/studio_25_pilates_app.git
cd studio_25_pilates_app

# 2. Instalar dependencias
flutter pub get

# 3. Ejecutar
flutter run
```

### Configuración de Firebase

La app usa Firebase Cloud Messaging. Para usar tu propio proyecto:

1. Crea un proyecto en [Firebase Console](https://console.firebase.google.com/).
2. Registra las apps de Android/iOS.
3. Reemplaza `android/app/google-services.json` (y `GoogleService-Info.plist` en iOS).
4. Regenera `lib/firebase_options.dart` con `flutterfire configure`.

### Íconos y splash

```bash
dart run flutter_launcher_icons
dart run flutter_native_splash:create
```

## Identidad visual

- **Tipografía**: Sculpin (familia incluida en `assets/fonts/`).
- **Paleta**: piedra `#F5F3EB`, arena `#D9C9AE`, almendra `#896B5A` y café noir `#51382A`.

## Plataformas

Proyecto Flutter con soporte generado para Android, iOS, web, Windows, macOS y Linux. El enfoque principal es **Android/iOS**.

## Estado del proyecto

Versión `0.1.0`, en desarrollo activo.
