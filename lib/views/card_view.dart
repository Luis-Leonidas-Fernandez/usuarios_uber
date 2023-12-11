import 'package:flutter/material.dart';

import 'package:usuario_inri/models/address.dart';
import 'package:usuario_inri/models/usuario.dart';
import 'package:intl/intl.dart';


class CardView extends StatelessWidget {

  final OrderUser orderUser;
  final Usuario usuario;
  
  const CardView({
  Key? key,
  required this.orderUser,
  required this.usuario
  }) : super(key: key);

  @override
  Widget build(BuildContext context) { 
    

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        
        margin: const EdgeInsets.only(top: 110, bottom: 50,  ),
        width: double.infinity,
        height: 190,
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
              cupon: usuario.cupon?.first ?? {},
                           
            ),
            
            Align(
               alignment: Alignment(0.9, -1.0),
              child: Container(              
                margin: const EdgeInsets.only(top: 18, bottom: 12),                             
                height: 50,
                width: 63,
                color: Colors.transparent,
                child: Image.asset('assets/person.jpg'),
              ),
            ),
            Align(
               alignment: Alignment(1.0, -0.5),
              child: Container(              
                margin: const EdgeInsets.only(top: 105, bottom: 39), 
                          
                height: 68,
                width: 88,
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
  final Map<String, dynamic> cupon;

  const _AddressDetails({
  required this.nombre,
  required this.email,
  required this.apellido,
  required this.vehiculo,
  required this.modelo,
  required this.patente,
  required this.order,
  required this.cupon  
  
  }); 

  @override
  Widget build(BuildContext context) {

    final idCupon = cupon.entries.isNotEmpty ? cupon.values.first : 0;
    final price   = cupon.entries.isNotEmpty ? cupon.values.last :  0;
   

    final nombreCustom    = 'nombre: $nombre';
    final apellidoCustom  = 'apellido: $apellido ';    
    final vehiculoCustom  = 'vehiculo: $vehiculo';
  
    final patenteCustom   = 'patente: $patente';
    final orderCustom     = 'estado del pedido: $order';
    final idCuponCustom   = 'cupon N°: $idCupon';
 

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
                style: const TextStyle( fontSize: 18, color: Colors.white),
                
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
               
              
              ),
            ),
            const SizedBox(height: 3),
            
            Align(
               alignment: Alignment(-0.9, 0),
              child: Text(
                apellidoCustom,
                style: const TextStyle( fontSize: 18, color: Colors.white),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(height: 3), 
            Align(
              alignment: Alignment(-0.9, 0),
              child: Text(
                vehiculoCustom,
                style: const TextStyle( fontSize: 18, color: Colors.white),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(height: 3),            
           
            Align(
              alignment: Alignment(-0.9, 0),
              child: Text(
                orderCustom ,
                style: const TextStyle( fontSize: 18, color: Colors.white),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(height: 3),
             Align(
              alignment: Alignment(-0.9, 0),
              child: Text(
                patenteCustom,
                style: const TextStyle( fontSize: 18, color: Colors.white),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(height: 3),
            Align(
              alignment: Alignment(-0.9, 0),
              child: Text(
                idCupon is String ? idCuponCustom 
                  : '',
                style: const TextStyle( fontSize: 18, color: Colors.white),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(height: 3),
             Align(
              alignment: Alignment(-0.9, 0),
              child: Text(
                price is int?
                'descuento: ${NumberFormat.currency(decimalDigits: 0).format(price)}'
                : '',               
                style: const TextStyle( fontSize: 18, color: Colors.white),
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
