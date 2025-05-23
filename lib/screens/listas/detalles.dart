import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:goshopp/models/producto.dart';
import 'package:goshopp/models/tipoproducto.dart';
import 'package:goshopp/screens/listas/cada_producto.dart';
import 'package:goshopp/screens/auxiliar.dart';
import 'package:goshopp/services/imagenes.dart';
import 'package:goshopp/services/productos.dart';
import 'package:image_picker/image_picker.dart';

class ListaDetalles extends StatefulWidget {
  final String listaID;
  final String nombre;
  final String descripcion;
  final bool? isGrupal;
  final String? idGrupo;

  const ListaDetalles(this.listaID, this.nombre, this.descripcion,
      {super.key, this.isGrupal = false, this.idGrupo});

  @override
  State<ListaDetalles> createState() => _ListaDetallesState();
}

class _ListaDetallesState extends State<ListaDetalles> {
  final TextEditingController _nombreController = TextEditingController();
  TipoProducto _tipoProducto = TipoProducto.comida;
  final textRecognizer = TextRecognizer();
  File? imagen;
  List<String> textoObtenido = [];
  bool _cargando = false;

  @override
  Widget build(BuildContext context) {
    final User? usuario = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 0, 100, 190),
        title: Text(widget.nombre.toString()),
        centerTitle: true,
        titleTextStyle: const TextStyle(fontSize: 22),
        actions: [
          IconButton(
              splashRadius: 20,
              onPressed: () async {
                try {
                  final ImageSource? src =
                      await abrirModalObtenerImagen(context);
                  getTicket(src!);
                } catch (e) {
                  mostrarSnackBar(
                      "No se ha seleccionado ninguna imagen", "warn");
                }
              },
              icon: const Icon(Icons.qr_code_scanner_rounded))
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(25),
        child: Column(children: [
          // Descripción de la lista
          Text(
            widget.descripcion.toString(),
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color.fromARGB(255, 0, 100, 190),
            ),
          ),

          const SizedBox(height: 35),

          SizedBox(
            child: TextFormField(
              maxLength: 20,
              controller: _nombreController,
              style: const TextStyle(
                  fontSize: 20, color: Color.fromARGB(255, 0, 100, 190)),
              decoration: const InputDecoration(
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                  labelText: "Añadir nuevo producto",
                  labelStyle: TextStyle(
                      fontSize: 22, color: Color.fromARGB(255, 0, 100, 190)),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(5.0)),
                      borderSide: BorderSide(
                          color: Color.fromARGB(255, 0, 100, 190), width: 2)),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(5.0)),
                      borderSide: BorderSide(
                          color: Color.fromARGB(255, 0, 100, 190), width: 3))),
            ),
          ),

          const SizedBox(height: 10),

          // Botón que registra el nuevo producto en la lista
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            // Selector de tipo de producto
            TextButton(
              onPressed: () {},
              style: ButtonStyle(
                  foregroundColor: WidgetStateProperty.all(
                      const Color.fromARGB(255, 0, 100, 190)),
                  fixedSize:
                      WidgetStateProperty.all(const Size.fromHeight(20))),
              child: Row(
                children: [
                  Text("Tipo: ${getNombre(_tipoProducto)}"),
                  PopupMenuButton<TipoProducto>(
                      padding: const EdgeInsets.all(0),
                      icon: const Icon(Icons.expand_more),
                      iconSize: 22,
                      splashRadius: 20,
                      tooltip: "Seleccionar tipo de producto",
                      onSelected: (value) {
                        _tipoProducto = value;
                        setState(() {});
                      },
                      itemBuilder: ((context) => mostrarTiposProducto)),
                ],
              ),
            ),

            // Botón que registra el nuevo producto en la lista
            SizedBox(
                height: 40,
                width: 100,
                child: ElevatedButton(
                  onPressed: () async {
                    if (_nombreController.text.isEmpty) {
                      mostrarSnackBar(
                          'Debe rellenar todos los campos.', "error");
                    } else {
                      // Añadimos un nuevo producto con esos valores
                      Producto nuevoProducto = Producto(
                          "", _nombreController.text, -1, _tipoProducto, false);

                      _nombreController.text = "";

                      if (widget.isGrupal!) {
                        await addProductoGrupo(
                                nuevoProducto,
                                widget.listaID.toString(),
                                widget.idGrupo.toString())
                            .then((_) {
                          mostrarSnackBar(
                              "Producto añadido correctamente", "ok");
                          setState(() {});
                        });
                      } else {
                        await addProductoUsuario(nuevoProducto,
                                widget.listaID.toString(), usuario!.uid)
                            .then((_) {
                          mostrarSnackBar(
                              "Producto añadido correctamente", "ok");
                          setState(() {});
                        });
                      }
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 0, 40, 76),
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      side: const BorderSide(
                        color: Colors.white70,
                        width: 2,
                      ),
                    ),
                  ),
                  child: const Text('Añadir',
                      style: TextStyle(
                        fontSize: 18,
                      )),
                ))
          ]),

          const SizedBox(height: 25),

          const Text("Productos:",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 25,
                  color: Color.fromARGB(255, 0, 100, 190))),

          const SizedBox(height: 25),

          _cargando ? const CircularProgressIndicator() : Container(),

          // Mostramos todos los productos de la lista
          FutureBuilder(
              future: widget.isGrupal!
                  ? getProductosGrupo(
                      widget.idGrupo.toString(), widget.listaID.toString())
                  : getProductosUsuario(
                      usuario!.uid, widget.listaID.toString()),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  List<Widget> widgets = [];
                  for (var producto in snapshot.data!) {
                    final p = Producto(
                        producto.id!,
                        producto.nombre!,
                        producto.precio!,
                        producto.tipo!,
                        producto.estaComprado!);

                    widgets.add(CadaProductoWidget(
                        widget.listaID, widget.nombre, widget.descripcion, p,
                        isGrupal: widget.isGrupal,
                        idGrupo: widget.idGrupo.toString()));
                  }
                  return Expanded(
                      child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: widgets.length,
                        itemBuilder: (context, index) {
                          return widgets[index];
                        }),
                  ));
                } else {
                  return const CircularProgressIndicator();
                }
              })
        ]),
      ),
    );
  }

  // ================ Funciones auxiliares ================ //

  // Obtener el ticket de la compra mediante la fuente de origen seleccionada
  Future<void> getTicket(ImageSource src) async {
    try {
      final imagen = await ImagePicker().pickImage(source: src);

      if (imagen == null) return;

      setState(() {
        this.imagen = File(imagen.path);
      });

      obtenerTextoTicket(imagen);
    } catch (e) {
      mostrarSnackBar("Se produjo un error al seleccionar la imagen", "error");
    }
  }

  // Obtiene el texto de una imagen
  Future<void> obtenerTextoTicket(XFile imagen) async {
    final User? usuario = FirebaseAuth.instance.currentUser;

    setState(() {
      _cargando = true;
    });

    // Obtenemos el texto de la imagen
    final input = InputImage.fromFilePath(imagen.path);
    await textRecognizer.processImage(input).then((detectorTexto) {
      setState(() {
        textoObtenido = detectorTexto.text.split('\n');
        filtrarTextoObtenido();
      });
    });

    // Creamos productos y los añadimos a la lista marcándolos como comprados
    if (textoObtenido.isNotEmpty) {
      for (var i = 0; i < textoObtenido.length; i++) {
        String nombreProducto = textoObtenido[i].length > 20
            ? textoObtenido[i].substring(0, 1).toUpperCase() +
                textoObtenido[i].substring(1, 20).toLowerCase()
            : textoObtenido[i].substring(0, 1).toUpperCase() +
                textoObtenido[i].substring(1).toLowerCase();

        Producto nuevoProducto =
            Producto("", nombreProducto, -1, TipoProducto.comida, true);

        if (widget.isGrupal!) {
          await addProductoGrupo(nuevoProducto, widget.listaID.toString(),
              widget.idGrupo.toString());
        } else {
          await addProductoUsuario(
              nuevoProducto, widget.listaID.toString(), usuario!.uid);
        }
      }
    }

    setState(() {});
  }

  // Obtiene los elementos escaneados que se corresponden con productos
  filtrarTextoObtenido() {
    // Filtramos aquellas cadenas compuestas por numero + espacio + cadena
    RegExp regex = RegExp(r'^\s*\d{1,3}\s+.+');
    textoObtenido.removeWhere((element) => !regex.hasMatch(element));

    // Si encontramos elementos con la expresión regular, los formateamos
    if (textoObtenido.isNotEmpty) {
      // Eliminamos la cantidad y nos quedamos solo con el nombre
      textoObtenido = textoObtenido
          .map((elemento) => elemento.replaceAll(RegExp(r'^\d+\s+'), ''))
          .toList();
    }
    // Si no, informamos al usuario
    else {
      mostrarSnackBar("No ha sido posible encontrar productos.", "warn");
    }

    setState(() {
      _cargando = false;
    });
  }

  // Función que muestra los distintos tipo de producto seleccionables
  List<PopupMenuEntry<TipoProducto>> get mostrarTiposProducto {
    return <PopupMenuEntry<TipoProducto>>[
      const PopupMenuItem(
          value: TipoProducto.bricolaje, child: Text("Bricolaje")),
      const PopupMenuItem(value: TipoProducto.bebida, child: Text("Bebida")),
      const PopupMenuItem(value: TipoProducto.belleza, child: Text("Belleza")),
      const PopupMenuItem(value: TipoProducto.comida, child: Text("Comida")),
      const PopupMenuItem(value: TipoProducto.deporte, child: Text("Deporte")),
      const PopupMenuItem(
          value: TipoProducto.electrodomestico,
          child: Text("Electrodoméstico")),
      const PopupMenuItem(
          value: TipoProducto.medicamento, child: Text("Medicamento")),
      const PopupMenuItem(
          value: TipoProducto.mobiliario, child: Text("Mobiliario")),
      const PopupMenuItem(value: TipoProducto.ocio, child: Text("Ocio")),
      const PopupMenuItem(value: TipoProducto.ropa, child: Text("Ropa")),
      const PopupMenuItem(
          value: TipoProducto.tecnologia, child: Text("Tecnología"))
    ];
  }
}

// Función que devuelve el nombre del tipo de producto seleccionado
String getNombre(TipoProducto tipo) {
  var nombre = "";

  switch (tipo) {
    case TipoProducto.bebida:
      nombre = "Bebida";
      break;
    case TipoProducto.bricolaje:
      nombre = "Bricolaje";
      break;
    case TipoProducto.belleza:
      nombre = "Belleza";
      break;
    case TipoProducto.comida:
      nombre = "Comida";
      break;
    case TipoProducto.deporte:
      nombre = "Deporte";
      break;
    case TipoProducto.electrodomestico:
      nombre = "Electrodoméstico";
      break;
    case TipoProducto.medicamento:
      nombre = "Medicamento";
      break;
    case TipoProducto.mobiliario:
      nombre = "Mobiliario";
      break;
    case TipoProducto.ocio:
      nombre = "Ocio";
      break;
    case TipoProducto.ropa:
      nombre = "Ropa";
      break;
    case TipoProducto.tecnologia:
      nombre = "Tecnología";
      break;
  }

  return nombre;
}
