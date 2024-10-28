import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:usuario_inri/constants/constants.dart';


class ButtonPedir extends StatelessWidget {
  

  const ButtonPedir({super.key});

  @override
  Widget build(BuildContext context) {

    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Container(
              width: 300,
              height: screenHeight < 362? 50 : 59,
              decoration: BoxDecoration(
                  gradient: AppConstants.buttongradiente,
                  borderRadius: BorderRadius.circular(10),               
                  ),
              child: Container(
                width: 300,
                height: screenHeight < 362? 51 : 55,
                decoration: BoxDecoration(    
                border: Border.all(
                color: AppConstants.blur
                .withOpacity(0.9),
                width: 2.5
                ),              
                borderRadius: BorderRadius.circular(10),  
                gradient: LinearGradient(colors: 
                [
                 
                
                 
                 const Color.fromARGB(188, 126, 124, 250).withOpacity(0.5),
                 const Color.fromARGB(161, 47, 67, 247).withOpacity(0.09),
                 const Color.fromARGB(161, 47, 67, 247).withOpacity(0.09),
                
                 
                ],             
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter 
                )
                ),
                child: Row(
                  children: [
    
                    Container(
                      constraints: const BoxConstraints(maxHeight: 54, maxWidth: 95),                      
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.only( 
                          topLeft: Radius.circular(8),
                          bottomLeft: Radius.circular(8)),  
                        gradient: LinearGradient(colors: 
                        [
                       AppConstants.blur.withOpacity(0.5),
                      const Color.fromARGB(188, 126, 124, 250)
                      .withAlpha(2),
                        ],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight
    ,
                        )
                      ),
                    ),
                    
                    Expanded(
                      child: Center(
                      child: Text('Pedir Ahora',
                        style: GoogleFonts.roboto(
                            fontSize: screenWidth <= 348 ? 16 : 20,
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                            letterSpacing: 0.7
                            ),
                             
                      ),
                      ),
                    ),
                     Container(
                      constraints: const BoxConstraints(maxHeight: 54, maxWidth: 95),                     
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.only( 
                          topRight: Radius.circular(8),
                          bottomRight: Radius.circular(8)), 
                        gradient: LinearGradient(colors: 
                        [
                       const Color.fromARGB(188, 126, 124, 250)
                      .withAlpha(2),
                      AppConstants.blur.withOpacity(0.5),
                        ],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight
    ,
                        )
                      ),    
    
                     
                    ),
    
                  ],
                ),
                 
              ),
            );
  }
}