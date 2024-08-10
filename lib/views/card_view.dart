import 'package:flutter/material.dart';

import 'package:usuario_inri/models/address.dart';
import 'package:usuario_inri/models/usuario.dart';
import 'package:intl/intl.dart';
import 'package:usuario_inri/responsive/responsive_ui.dart';


class CardView extends StatelessWidget {

  final OrderUser orderUser;
  final Usuario? usuario;
  
  const CardView({
  super.key,
  required this.orderUser,
  this.usuario
  });

  @override
  Widget build(BuildContext context) {    

    late ResponsiveUtil responsiveUtil = ResponsiveUtil(context);

    double responsiveTop = responsiveUtil.getResponsiveHeight(0.15);
    double responsiveHeight = responsiveUtil.getResponsiveHeight(0.12);
    double responsiveWidth = responsiveUtil.getResponsiveWidth(0.12); 

    double responsiveTopIconPerson = responsiveUtil.getResponsiveHeight(0.0005);   
    double responsiveHeightCard = responsiveUtil.getResponsiveHeight(0.29);
    
    return  Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        
        margin: EdgeInsets.only(top: responsiveTop, bottom: 50,  ),
        width: double.infinity,
        height: responsiveHeightCard,
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
              cupon: usuario?.cupon ?? [],
                           
            ),
             
            Align(
               alignment: Alignment(0.9, -1.0),
              child: Container(              
                margin: EdgeInsets.only(top: responsiveTopIconPerson, bottom: 12),                             
                height: responsiveHeight,
                width: responsiveWidth,
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
  final List<dynamic>? cupon;

  const _AddressDetails({
  required this.nombre,
  required this.email,
  required this.apellido,
  required this.vehiculo,
  required this.modelo,
  required this.patente,
  required this.order,
  this.cupon  
  
  }); 

  @override
  Widget build(BuildContext context) {

    final responsiveUtil = ResponsiveUtil(context);
    final responsiveFont = responsiveUtil.getResponsiveFontSize(31.0);
 

    final idCupon = cupon!.isNotEmpty ? cupon?.first : 0;
    final price   = cupon!.isNotEmpty ? cupon?.last  : 0;
   

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
                style: TextStyle( fontSize: responsiveFont, color: Colors.white),
                
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
               
              
              ),
            ),
            const SizedBox(height: 2),
            
            Align(
               alignment: Alignment(-0.9, 0),
              child: Text(
                apellidoCustom,
                style: TextStyle( fontSize: responsiveFont, color: Colors.white),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(height: 2), 
            Align(
              alignment: Alignment(-0.9, 0),
              child: Text(
                vehiculoCustom,
                style:  TextStyle( fontSize: responsiveFont, color: Colors.white),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(height: 2),            
           
            Align(
              alignment: Alignment(-0.9, 0),
              child: Text(
                orderCustom ,
                style: TextStyle( fontSize: responsiveFont, color: Colors.white),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(height: 2),
             Align(
              alignment: Alignment(-0.9, 0),
              child: Text(
                patenteCustom,
                style: TextStyle( fontSize: responsiveFont, color: Colors.white),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(height: 2),
            Align(
              alignment: Alignment(-0.9, 0),
              child: Text(
                idCupon is String ? idCuponCustom 
                  : '',
                style: TextStyle( fontSize: responsiveFont, color: Colors.white),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(height: 2),
             Align(
              alignment: Alignment(-0.9, 0),
              child: Text(
                price is int?
                'descuento: ${NumberFormat.currency(decimalDigits: 0).format(price)}'
                : '',               
                style: TextStyle( fontSize: responsiveFont, color: Colors.white),
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
