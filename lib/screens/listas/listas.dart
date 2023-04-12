import 'package:flutter/material.dart';
import 'package:goshopp/models/producto.dart';
import 'package:goshopp/db/producto_db.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';

import '../../widgets/productowidget.dart';

class ListasPersonales extends StatefulWidget {
  ListasPersonales({super.key});

  final productoDB = ProductoDB();

  @override
  State<ListasPersonales> createState() => _ListasPersonalesState();
}

class _ListasPersonalesState extends State<ListasPersonales> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: <Widget>[
              _getListaPersonal(),
            ],
          )),
    );
  }

  Widget _getListaPersonal() {
    return Expanded(
        child: FirebaseAnimatedList(
      query: widget.productoDB.getProductos(),
      itemBuilder: (context, snapshot, animation, index) {
        final json = snapshot.value as Map<dynamic, dynamic>;
        final producto = Producto.fromJson(json);

        return ProductoWidget(
            producto.nombre,
            producto.precio,
            producto.cantidad,
            producto.medida,
            producto.tipo,
            producto.estaComprado);
      },
    ));
  }
}
