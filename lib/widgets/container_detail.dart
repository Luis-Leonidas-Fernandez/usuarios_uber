import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:usuario_inri/blocs/blocs.dart';


class ContainerDetail extends StatelessWidget {


  const ContainerDetail({super.key });

  @override
  Widget build(BuildContext context) {

    final screenHeight = MediaQuery.of(context).size.height;   
 

    return BlocBuilder<AddressBloc, AddressState>(
      builder: (context, stateAddress) {         
      

        return Column(
        children: [
      
          Container(
            
            width: 372,
            height: screenHeight <=640 ? 50 : 55,
            decoration: BoxDecoration(
                border: Border.all(
                color: const Color.fromARGB(255, 156, 156, 156)
                  .withOpacity(0.9),
                  width: 1.6              
                ),
                color: const Color.fromARGB(255, 2, 2, 2),
                borderRadius: BorderRadius.circular(10)),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      child: Container( 
                        constraints: const BoxConstraints(maxWidth: 38, minHeight: 36),  
                        decoration: BoxDecoration(   
                  borderRadius: BorderRadius.circular(8),  
                  gradient: LinearGradient(
                  colors: 
                  [                                  
                   const Color.fromARGB(188, 126, 124, 250).withOpacity(0.5),
                   const  Color.fromARGB(188, 126, 124, 250),  
                  ],             
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter 
                  ),
                        
                        
                      ),
                      child: Icon(
                          Icons.person,
                          color: Colors.white,
                          size: screenHeight <= 380 ? 18 : 32,
                          ),
                     ),
                    ),
                    const SizedBox(width: 4),
      
                    Align(
                      alignment: const Alignment(0.0, 0.5),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: Container(
                          constraints: const BoxConstraints(maxWidth: 280, maxHeight: 22),                      
                          color: Colors.transparent,
                          child: Text(
                            stateAddress.orderUser?.nombre ?? "",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: screenHeight <= 346 ? 10 : 16,
                              fontWeight: FontWeight.w400,
                              letterSpacing: 0.5
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
          ),
          SizedBox(height: screenHeight <= 641? 6 : 10),
      
          Container(          
            width: 372,
            height: screenHeight <=640 ? 50 : 55,
            decoration: BoxDecoration(
                border: Border.all(
                color: const Color.fromARGB(255, 156, 156, 156)
                  .withOpacity(0.9),
                  width: 1.6              
                ),
                color: const Color.fromARGB(255, 2, 2, 2),
                borderRadius: BorderRadius.circular(10)),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      child: Container(                      
                        width: 38,
                        height: 36,
                        decoration: BoxDecoration(   
                  borderRadius: BorderRadius.circular(8),  
                  gradient: LinearGradient(
                  colors: 
                  [                                  
                   const Color.fromARGB(188, 126, 124, 250).withOpacity(0.5),
                   const  Color.fromARGB(188, 126, 124, 250),  
                  ],             
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter 
                  ),
                        
                        
                      ),
                      child: const Icon(
                          Icons.local_taxi,
                          color: Colors.white,
                          size: 32,
                          ),
                     ),
                    ),
                    SizedBox(width: screenHeight <= 347 ? 2 : 4),
          
                    Align(
                      alignment: const Alignment(0.0, 0.5),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: Container(
                        constraints: const BoxConstraints(maxWidth: 280, maxHeight: 22),  
                        child: Text(
                        "${stateAddress.orderUser?.patente} ${stateAddress.orderUser?.patente}",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: screenHeight <= 346 ? 10 : 16,
                          fontWeight: FontWeight.w400,
                          letterSpacing: 0.5
                        ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
          ),
          SizedBox(height: screenHeight <= 641? 6 : 10),
          Container(
            width: 372,  
            height:screenHeight <=640 ? 50 : 55,                   
            decoration: BoxDecoration(
                border: Border.all(
                color: const Color.fromARGB(255, 156, 156, 156)
                  .withOpacity(0.9),
                  width: 1.6              
                ),
                color: const Color.fromARGB(255, 2, 2, 2),
                borderRadius: BorderRadius.circular(10)),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                      child: Container(                      
                        width: 38,
                        height: 36,
                        decoration: BoxDecoration(   
                  borderRadius: BorderRadius.circular(8),  
                  gradient: LinearGradient(
                  colors: 
                  [                                  
                   const Color.fromARGB(188, 126, 124, 250).withOpacity(0.5),
                   const  Color.fromARGB(188, 126, 124, 250),  
                  ],             
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter 
                  ),
                        
                        
                      ),
                      child: const Icon(
                          Icons.location_pin,
                          color: Colors.white,
                          size: 32,
                          ),
                     ),
                    ),
                    const SizedBox(width: 4),
      
                    Align(
                      alignment: const Alignment(0.0, 0.5),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Container(
                          constraints: const BoxConstraints(maxWidth: 280, maxHeight: 22),                        
                          color: Colors.transparent,
                          child: Text(
                            stateAddress.orderUser?.estado == false? "" : stateAddress.orderUser?.estado,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: screenHeight <= 346 ? 10 : 16,
                              fontWeight: FontWeight.w400,
                              letterSpacing: 0.5
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
          ),
      
        ],
      );
      }
     
    );
  }
}
