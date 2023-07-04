# GoShopp

Aplicación Android e iOS para gestionar listas de la compra de manera cooperativa. Proyecto de fin de grado desarrollado por Pablo Muñoz Castro para el grado en Ingeniería Informática en la Universidad de Granada.

## Descripción del proyecto

La aplicación se ha desarrollado utilizando el entorno [Flutter](https://flutter.dev/), mediante el lenguaje de programación [Dart](https://dart.dev/). Para la conexión con la base de datos se ha utilizado la plataforma Firebase proporcionada por [Google](https://firebase.google.com/?hl=es) y se ha utilizado el editor de código y compilador de [Visual Studio Code](https://code.visualstudio.com/).

Esta aplicación tiene como objetivo permitir al usuario crear múltiples listas de la compra, tanto individuales como cooperativas, para diferentes ocasiones y grupos, como una lista para la compra familiar o para una quedada con amigos. El objetivo en estas listas cooperativas es que cada uno de los miembros del grupo tenga acceso a ellas y pueda añadir y eliminar productos o marcarlos como comprados, de forma que cuando alguien vaya a hacer la compra, no falte nada por adquirir o pueda tener en cuenta qué productos ya se compraron.

La funcionalidad de GoShopp no se limita solo a la creación de listas individuales, sino que también se centra en la posibilidad de compartir las listas de la compra con grupos de allegados, como familiares, compañeros de piso o amigos, lo que facilita la colaboración y la coordinación de compras conjuntas. Para ello, también se implementará una funcionalidad de chat entre usuarios, permitiendo crear, borrar y participar en grupos, lo que permite la comunicación sin necesidad de salir de la aplicación.

Para resaltar la facilidad de uso del software desarrollado, también cuenta con una funcionalidad que permite a los usuarios escanear los tickets de la compra, detectando los productos anotados en ellos y añadiéndolos a la lista seleccionada de forma más eficiente que si se hiciera manualmente, utilizando inteligencia artificial para el reconocimiento de textos en imágenes, obtenidas tanto desde la galería como desde la cámara del dispositivo, pudiendo tomar una foto en el momento del escaneo.

## Pasos seguidos en la elaboración del proyecto

- Creación del proyecto Flutter [#2](https://github.com/pablo1mc315/TFG-GoShopp/pull/2).
- Aprendizaje de los conceptos básicos de Flutter [#3](https://github.com/pablo1mc315/TFG-GoShopp/pull/3).
- Creación de la estructura de datos e implementación de la autenticación de usuarios [#4](https://github.com/pablo1mc315/TFG-GoShopp/pull/4).
- Implementar visualización, creación, edición y borrado tanto de listas de la compra como de los productos de las mismas [#8](https://github.com/pablo1mc315/TFG-GoShopp/pull/8).
- Implementar visualización, creación, edición y borrado de grupos y listas cooperativas, así como la funcionalidad de chat entre usuarios de un mismo grupo [#15](https://github.com/pablo1mc315/TFG-GoShopp/pull/15).
- Implementar el escaneado de tickets de la compra, así como algunas otras funcionalidades adicionales [#23](https://github.com/pablo1mc315/TFG-GoShopp/pull/23).

## Instalación

Si desea probar la aplicación, puede descargarla en su dispositivo Android pulsando [aquí](https://drive.google.com/file/d/14tk2q-vphy2unUnq2HV-9yoi7i2yKWHi/view?usp=sharing). Asegúrese de entrar a Google Drive con una cuenta de Google corporativa de la Universidad de Granada. Basta con instalar el fichero .apk descargado para comenzar a utilizar GoShopp.

## Documentación

Toda la documentación del proyecto, así como las imágenes utilizadas en la misma y las capturas de pantalla de la interfaz de usuario final, se encuentra disponible en la carpeta [/docs](./docs).
