import 'package:flutter/material.dart';

class CadaListaWidget extends StatelessWidget {
  final String? nombre;
  final String? descripcion;

  const CadaListaWidget(this.nombre, this.descripcion, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: SizedBox(
        height: 150,
        width: 350,
        child: ElevatedButton(
          onPressed: () {},
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.white,
            backgroundColor: const Color.fromARGB(255, 0, 40, 76),
            elevation: 5,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
          ),
          child: Column(
            children: [
              SizedBox(
                  height: 50,
                  child: Row(children: [
                    const Padding(
                      padding: EdgeInsets.only(right: 15),
                      child: Icon(
                        Icons.playlist_add_check_circle_outlined,
                        size: 30,
                      ),
                    ),
                    Text(nombre.toString(),
                        style: const TextStyle(
                          fontSize: 22,
                        ))
                  ])),
              SizedBox(
                  height: 85,
                  width: 350,
                  child: ElevatedButton(
                    onPressed: null,
                    style: const ButtonStyle(
                        backgroundColor: MaterialStatePropertyAll(
                            Color.fromARGB(255, 0, 100, 190)),
                        foregroundColor: MaterialStatePropertyAll(Colors.white),
                        side: MaterialStatePropertyAll(
                            BorderSide(width: 1, color: Colors.white))),
                    child: Text(descripcion.toString(),
                        style: const TextStyle(fontSize: 18)),
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
