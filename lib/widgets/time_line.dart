import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:usuario_inri/blocs/blocs.dart';

import 'package:usuario_inri/service/addresses_service.dart';
import 'package:usuario_inri/service/storage_service.dart';

class HomeStepper extends StatelessWidget {
  const HomeStepper({super.key});

  @override
  Widget build(BuildContext context) {
    late AddressService addressService = AddressService();
    
    final addressBloc = BlocProvider.of<AddressBloc>(context);
    final storageService = StorageService.instance;

    return addressBloc.state.existOrder == false && addressBloc.state.isAccepted == true? 
    BlocBuilder<MapBloc, MapState>(
      builder: (context, state) {
        return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 50),
            child: Container(
              margin: const EdgeInsets.only(top: 230, bottom: 50),
              width: 300,
              height: 400,
              decoration: _cardBorders(),
              child: Stack(
                children: [
                  _AddressDetails(),
                  Align(
                    alignment: Alignment(-0.9, -0.35),
                    child: Container(
                      height: 40,
                      width: 40,
                      color: Colors.transparent,
                      child: Icon(
                        Icons.check_circle,
                        color: Colors.green,
                      ),
                    ),
                  ),
                  lineTime(),
                  Align(
                    alignment: Alignment(-0.9, 0),
                    child: Container(
                      height: 40,
                      width: 40,
                      color: Colors.transparent,
                      child: Icon(
                        Icons.check_circle,
                        color: Colors.green,
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment(-0.9, 0.35),
                    child: Container(
                      height: 40,
                      width: 40,
                      color: Colors.transparent,
                      child: Icon(
                        Icons.check_circle,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                  lineTimeTwo(),
                  Align(
                    alignment: Alignment(0, -1.0),
                    child: Container(
                      margin: const EdgeInsets.only(top: 18, bottom: 12),
                      height: 50,
                      width: 68,
                      color: Colors.transparent,
                      child: Image.asset('assets/person.jpg'),
                    ),
                  ),
                  Align(
                    alignment: Alignment(
                      -0.1,
                      0.8,
                    ),
                    child: MaterialButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        disabledColor: Colors.grey,
                        elevation: 0,
                        color: Colors.purple,
                        onPressed: () async {

                          // Eliminando viaje de base de datos
                          await addressService.finishTravel();
                          await storageService.deleteIdDriver();
                          await storageService.deleteIdOrder();                          

                          //addressBloc.add(OnIsDeclinedTravel());

                          //eliminar order de state
                          addressBloc.add(OnClearStateEvent());

                          
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 60, vertical: 12),
                          child: Text(
                            'CANCELAR',
                            style: const TextStyle(
                                color: Colors.white, fontSize: 18),
                          ),
                        )),
                  )
                ],
              ),
            ));
      },
    ): const SizedBox(); 
  }

  BoxDecoration _cardBorders() => BoxDecoration(
        color: Colors.grey[100],       
        border: Border.all(color: Colors.grey)
      );
}

class _AddressDetails extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    const procesado = 'Pedido exitoso';
    const buscando = 'Buscando un Conductor';
    const encontrado = 'Conductor encontrado';

    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: Container(
        width: double.infinity,
        height: 400,
        color: Colors.grey[100],
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Align(
              alignment: Alignment(-0.2, 1.0),
              child: Text(
                procesado,
                style: GoogleFonts.roboto(
                    color: Colors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.w700),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            SizedBox(height: 40),
            Align(
              alignment: Alignment(0.3, 0),
              child: Text(
                buscando,
                style: GoogleFonts.roboto(
                    color: Colors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.w700),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            SizedBox(height: 40),
            Align(
              alignment: Alignment(0.1, -0.9),
              child: Text(
                encontrado,
                style: GoogleFonts.roboto(
                    color: Colors.grey,
                    fontSize: 18,
                    fontWeight: FontWeight.w700),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Widget lineTime() {
  return Align(
    alignment: Alignment(-0.79, -0.18),
    child: Container(
      height: 25,
      width: 2,
      color: Color.fromARGB(255, 4, 158, 9),
    ),
  );
}

Widget lineTimeTwo() {
  return Align(
    alignment: Alignment(-0.79, 0.15),
    child: Container(
      height: 25,
      width: 2,
      color: Colors.grey,
    ),
  );
}

Widget buttonCancel() {
  return Align(
    alignment: Alignment(
      -0.1,
      0.8,
    ),
    child: MaterialButton(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        disabledColor: Colors.grey,
        elevation: 0,
        color: Colors.purple,
        onPressed: () async {},
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 12),
          child: Text(
            'CANCELAR',
            style: const TextStyle(color: Colors.white, fontSize: 18),
          ),
        )),
  );
}
