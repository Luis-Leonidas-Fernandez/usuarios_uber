import 'package:flutter/material.dart';

import 'package:usuario_inri/models/address.dart';



class CardView extends StatelessWidget {

  final OrderUser orderUser;
  
  const CardView({
  Key? key,
  required this.orderUser
  }) : super(key: key);

  @override
  Widget build(BuildContext context) { 

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        
        margin: const EdgeInsets.only(top: 90, bottom: 50,  ),
        width: double.infinity,
        height: 173,
        decoration: _cardBorders(),
        child: Stack(
          
          children: [
            
             
            
            _AddressDetails(
              nombre: orderUser.nombre?? '',
              email: orderUser.email?? '',
              apellido: orderUser.apellido?? '',
              vehiculo: orderUser.vehiculo?? '',
              modelo: orderUser.modelo?? '',
              patente: orderUser.patente?? '',
              order: orderUser.order?? '',
                           
            ),
            
            Align(
               alignment: Alignment(0.9, -1.0),
              child: Container(              
                margin: const EdgeInsets.only(top: 18, bottom: 12), 
                //alignment: Alignment.bottomRight,             
                height: 50,
                width: 68,
                color: Colors.transparent,
                child: Image.asset('assets/person.jpg'),
              ),
            ),
            Align(
               alignment: Alignment(1.0, -1.0),
              child: Container(              
                margin: const EdgeInsets.only(top: 98, bottom: 28), 
                          
                height: 70,
                width: 98,
                color: Colors.transparent,
                child: Image.asset('assets/driver.png'),
              ),
            ),
            
            
          ],
        ),
      ),
    );
  }

  BoxDecoration _cardBorders() => BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(25),
    boxShadow: const [
      BoxShadow(
        color: Colors.black38,
        offset: Offset(0,10),
        blurRadius: 15
      )
    ]
  );
}

class _AddressDetails extends StatelessWidget {

  final String nombre;
  final String email;
  final String apellido; 
  final String vehiculo; 
  final String modelo; 
  final String patente;
  final String order; 

  const _AddressDetails({
  required this.nombre,
  required this.email,
  required this.apellido,
  required this.vehiculo,
  required this.modelo,
  required this.patente,
  required this.order  
  
  }); 

  @override
  Widget build(BuildContext context) {

    final nombreCustom   = 'nombre: $nombre';
    final apellidoCustom = 'apellido: $apellido ';    
    final vehiculoCustom = 'vehiculo: $vehiculo';
    final modeloCustom    = 'modelo: $modelo';
    final patenteCustom   = 'patente: $patente';
    final orderCustom     = 'estado del pedido: $order';

    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: Container(
        width: double.infinity,
        height: 400,
        color: Colors.indigo,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
              
          children: [


            
            Align(
              alignment: Alignment(-0.9, 0),
              child: Text(
                nombreCustom,
                style: const TextStyle( fontSize: 20, color: Colors.white),
                
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
               
              
              ),
            ),
            const SizedBox(height: 3),
            
            Align(
               alignment: Alignment(-0.9, 0),
              child: Text(
                apellidoCustom,
                style: const TextStyle( fontSize: 20, color: Colors.white),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(height: 9), 
            Align(
              alignment: Alignment(-0.9, 0),
              child: Text(
                vehiculoCustom,
                style: const TextStyle( fontSize: 20, color: Colors.white),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(height: 3), 
            Align(
              alignment: Alignment(-0.9, 0),
              child: Text(
                modeloCustom,
                style: const TextStyle( fontSize: 20, color: Colors.white),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(height: 3), 
            Align(
              alignment: Alignment(-0.9, 0),
              child: Text(
                patenteCustom,
                style: const TextStyle( fontSize: 20, color: Colors.white),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(height: 3),
            Align(
              alignment: Alignment(-0.9, 0),
              child: Text(
                orderCustom ,
                style: const TextStyle( fontSize: 20, color: Colors.white),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(height: 3),             
            
          ],
        ),     
      ),
    );
  }
}
