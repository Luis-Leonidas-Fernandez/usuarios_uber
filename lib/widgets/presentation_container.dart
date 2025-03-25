import 'package:flutter/material.dart';

class PresentationContainer extends StatelessWidget {
  const PresentationContainer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: const DecorationImage(
            image: AssetImage('assets/background_image.png'),
              fit: BoxFit.cover,                
              opacity: 0.8
            ),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: const Color.fromARGB(255, 156, 156, 156)
                .withValues(),
                width: 1.6 
        ),
        gradient: LinearGradient(colors: [
          const Color.fromARGB(188, 126, 124, 250).withValues(),
          const Color.fromARGB(188, 126, 124, 250),
               
          
        ], begin: Alignment.topCenter, end: Alignment.bottomCenter),
      ),
      width: 372,
      height: 145,
      child: const Padding(
         padding: EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(height: 20),
            
            Align(
              alignment: Alignment(-1.0, 0.0),
              child: Text(
                "30% OFF",
                style: TextStyle(
                    color: Colors.yellowAccent,
                    letterSpacing: 0.5,
                    fontSize: 25,
                    fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(height: 5),
            Align(
              alignment: Alignment(-0.5, 0.0),
              child: Text(
                "Descubre descuentos semanales y viaja con tranquilidad",
                style: TextStyle(
                    color: Colors.white,
                    letterSpacing: 0.5,
                    fontSize: 16,
                    fontWeight: FontWeight.w400),
              ),
            )
          ],
        ),
      ),
    );
  }
}
