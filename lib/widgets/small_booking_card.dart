import 'package:flutter/material.dart';
import 'package:usuario_inri/constants/constants.dart';
import 'package:usuario_inri/responsive/responsive_ui.dart';
import 'package:usuario_inri/widgets/button_pedir.dart';
import 'package:usuario_inri/widgets/presentation_container.dart';



class SmallBookingCard extends StatefulWidget {
  const SmallBookingCard({super.key});

  @override
  State<SmallBookingCard> createState() => _SmallBookingCardState();
}

class _SmallBookingCardState extends State<SmallBookingCard> {
  
  @override
  Widget build(BuildContext context) { 

    final screenWidth = MediaQuery.sizeOf(context).width; 
    final screenHeight = MediaQuery.sizeOf(context).height; 

    ResponsiveUtil responsiveUtil = ResponsiveUtil(context);
    double responsiveFontSize = responsiveUtil.getResponsiveFontSize(30);   
    double responsiveTop = responsiveUtil.getResponsiveHeight(0.51);

    return Positioned(
      top: responsiveTop,
      left: 0,
      right: 0,
      child: Container(
      constraints: const BoxConstraints(maxHeight: 450),
      decoration: BoxDecoration(
          image: const DecorationImage(
            image: AssetImage('assets/background_image.png'),
              fit: BoxFit.cover,                
              opacity: 0.8
            ),
          gradient: AppConstants.backgroundCard,            
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
          boxShadow: const [
            BoxShadow(
                color: Color.fromARGB(255, 192, 191, 191),
                blurRadius: 25,
                spreadRadius: 1.0,
                offset: Offset(5, 0)),
          ]
          ),
               
            
          child: Stack(children: [
        
          Positioned(
            top: 290,
            left: 0.0,
            right: 0.0,
            child: Container(
              width: double.infinity,
              height: 260,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                       
                      AppConstants.cardColor.withAlpha(2),
                      AppConstants.cardColor,
                       
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.center
                  )
              ),
            
              
            ),
          ), 
           Positioned(
            top: 57,
            left: 20,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [


                Text(
                  'Detalle Viaje',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: responsiveFontSize,
                      fontWeight: FontWeight.w600),
                ),
                SizedBox(width: screenWidth <=370 ? 55: 70),

                Row(
                  children: [

                    const Icon(
                      Icons.discount_rounded,
                      color: Colors.white,                     
                      ),
                    const SizedBox(width: 10),
                    Text(
                    'Cupon',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: responsiveFontSize,
                        fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(width: 5),
                  Text(
                    '\$ 250',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: responsiveFontSize,
                        fontWeight: FontWeight.w600),
                  ),

                  ] 
                ),
              ],
            ),
          ),
           
           Positioned(
            top: 91,
            left: 20,
            right: 20,
            child: Container(
              color: Colors.transparent,
              child: const PresentationContainer()
              //const ContainerDetail()
              //const TimeLineAddress()
              )),
        
              
           Positioned(
            top: 262,
            left: 20,
            right: 20,
            child: SizedBox(
              width: 300,
              height: screenHeight <=640 ? 45 : 59,
              child: const ButtonPedir())
          ),

          
        ]),  
      ),
      );
    
  }
}
