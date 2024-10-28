import 'package:flutter/material.dart';


class TimeLineAddress extends StatelessWidget {
  const TimeLineAddress({super.key});

  @override
  Widget build(BuildContext context) {
    
    final screenHeight = MediaQuery.sizeOf(context).height;

    return Container(
      constraints: const BoxConstraints(maxWidth: 300, maxHeight: 180),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,

        children: [
          Container(
            width: 372,
            height: screenHeight <= 640 ? 48 : 55,
            decoration: BoxDecoration(
                border: Border.all(
                    color: const Color.fromARGB(255, 156, 156, 156)
                        .withOpacity(0.9),
                    width: 1.6),
                color: const Color.fromARGB(255, 2, 2, 2),
                borderRadius: BorderRadius.circular(10)),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  child: Container(
                    constraints:
                        const BoxConstraints(maxWidth: 38, minHeight: 35),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      gradient: LinearGradient(
                          colors: [
                            const Color.fromARGB(188, 126, 124, 250)
                                .withOpacity(0.5),
                            const Color.fromARGB(188, 126, 124, 250),
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter),
                    ),
                    child: Icon(
                      Icons.check_circle,
                      color: const Color.fromARGB(255, 255, 254, 255),
                      size: screenHeight <= 641 ? 30 : 32,
                    ),
                  ),
                ),
                const SizedBox(width: 4),
                Align(
                  alignment: const Alignment(0.0, 0.5),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Container(
                      constraints:
                          const BoxConstraints(maxWidth: 280, maxHeight: 22),
                      color: Colors.transparent,
                      child: Text(
                        "Pedido exitoso",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: screenHeight <= 346 ? 10 : 16,
                            fontWeight: FontWeight.w400,
                            letterSpacing: 0.5),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
          const SizedBox(height: 7),
          Container(
            width: 372,
            height: screenHeight <= 640 ? 48: 55,
            decoration: BoxDecoration(
                border: Border.all(
                    color: const Color.fromARGB(255, 156, 156, 156)
                        .withOpacity(0.9),
                    width: 1.6),
                color: const Color.fromARGB(255, 2, 2, 2),
                borderRadius: BorderRadius.circular(10)),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  child: Container(
                    constraints:
                        const BoxConstraints(maxWidth: 38, minHeight: 35),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      gradient: LinearGradient(
                          colors: [
                            const Color.fromARGB(188, 126, 124, 250)
                                .withOpacity(0.5),
                            const Color.fromARGB(188, 126, 124, 250),
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter),
                    ),
                    child: Icon(
                      Icons.check_circle,
                      color: const Color.fromARGB(255, 255, 255, 255),
                      size: screenHeight <= 641 ? 30 : 32,
                    ),
                  ),
                ),
                const SizedBox(width: 4),
                Align(
                  alignment: const Alignment(0.0, 0.5),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Container(
                      constraints:
                          const BoxConstraints(maxWidth: 280, maxHeight: 22),
                      color: Colors.transparent,
                      child: Text(
                        "Buscando un Conductor",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: screenHeight <= 346 ? 10 : 16,
                            fontWeight: FontWeight.w400,
                            letterSpacing: 0.5),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
          const SizedBox(height: 7),
          Container(
            width: 372,
            height: screenHeight <= 640 ? 48 : 55,
            decoration: BoxDecoration(
                border: Border.all(
                    color: const Color.fromARGB(255, 156, 156, 156)
                        .withOpacity(0.9),
                    width: 1.6),
                color: const Color.fromARGB(255, 2, 2, 2),
                borderRadius: BorderRadius.circular(10)),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  child: Container(
                    constraints:
                        const BoxConstraints(maxWidth: 38, minHeight: 35),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      gradient: LinearGradient(
                          colors: [
                            const Color.fromARGB(188, 126, 124, 250)
                                .withOpacity(0.5),
                            const Color.fromARGB(188, 126, 124, 250),
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter),
                    ),
                    child: Icon(
                      Icons.check_circle,
                      color: const Color.fromARGB(255, 121, 122, 121),
                      size: screenHeight <= 641 ? 30 : 32,
                    ),
                  ),
                ),
                const SizedBox(width: 4),
                Align(
                  alignment: const Alignment(0.0, 0.5),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Container(
                      constraints:
                          const BoxConstraints(maxWidth: 280, maxHeight: 32),
                      color: Colors.transparent,
                      child: Text(
                        "Conductor encontrado",
                        style: TextStyle(
                            color: const Color.fromARGB(255, 156, 155, 155),
                            fontSize: screenHeight <= 346 ? 10 : 16,
                            fontWeight: FontWeight.w400,
                            letterSpacing: 0.5),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
