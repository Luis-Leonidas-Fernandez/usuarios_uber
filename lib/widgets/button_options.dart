import 'package:flutter/material.dart';

class ButtonOptions extends StatelessWidget {
  
  const ButtonOptions({
  super.key,
  required this.iconData,
  required this.buttonText,
  this.onTap 
  });

  final IconData iconData;
  final String buttonText;
  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Material(
        elevation: 8.0,
        borderRadius: BorderRadius.circular(12.0),
        child: InkWell(
          splashColor: Colors.indigo,
          onTap: onTap,
          child: Container(
            height: 50,
            width: 250,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.0)
            ),
            child: Row(
              children:  [               
                Container(
                 height: 50,
                 width: 40,
                 color: Colors.indigo,
                 child: Icon( iconData,
                 color: Colors.white,
            )
          ),
          Expanded(child: Text(
            buttonText,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 15,
              color: Colors.indigo,
              fontWeight: FontWeight.bold
            ),
          ))
         ],
        ),
      ),
    )
   )
  );
    
    
    
    
    
    
  }
}
/* ElevatedButton(
      onPressed: () {},
        style: ButtonStyle(
         overlayColor: MaterialStateProperty.all(Colors.indigo.withOpacity(0.2)),
         backgroundColor: Colors.
        ),
        child:  const Text('Tengo una Cuenta', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),)
    ); */

