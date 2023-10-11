# Aplicación de Medición de Objetos con Flutter y IA

Esta es una aplicación desarrollada en Flutter como parte de un proyecto integrador para la Universidad Central del Ecuador. La aplicación utiliza inteligencia artificial para medir objetos (rosas) a través de la cámara de tu dispositivo móvil y se integra con un API REST para proporcionar datos adicionales y funcionalidades.

## Funcionalidades Principales

- **Medición de Objetos:** Utiliza la cámara de tu dispositivo para medir objetos en tiempo real. Simplemente apunta la cámara al objeto y obtén medidas precisas.

- **Inteligencia Artificial:** La aplicación utiliza modelos de aprendizaje automático para calcular las dimensiones de los objetos. La precisión puede variar según el modelo utilizado.

- **Integración de API REST:** La aplicación se conecta a un servidor a través de un API REST para acceder a información adicional sobre los objetos medidos, como descripciones, precios y más.

- **Historial de Mediciones:** Guarda un historial de las mediciones realizadas para su posterior consulta o comparación.

## Requisitos de Instalación

- Flutter SDK: Asegúrate de tener Flutter instalado. Puedes obtenerlo [aquí](https://flutter.dev/docs/get-started/install).

- Dispositivo Móvil o Emulador: La aplicación utiliza la cámara del dispositivo, por lo que necesitas un dispositivo móvil o un emulador con cámara habilitada.

- API REST: Configura la URL del API REST en el archivo `lib/api.dart` antes de compilar la aplicación.

## Cómo Usar

1. Clona este repositorio en tu máquina local.

2. Abre una terminal en la carpeta del proyecto y ejecuta `flutter pub get` para instalar las dependencias.

3. Configura la URL del API REST en el archivo `lib/api.dart`.

4. Ejecuta la aplicación en tu dispositivo o emulador mediante `flutter run`.

## Contribuciones

Si deseas contribuir a este proyecto, no dudes en abrir un *issue* o enviar una solicitud de extracción (*pull request*).
