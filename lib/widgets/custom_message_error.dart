import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:usuario_inri/blocs/blocs.dart';

class CustomSnackBarContentError extends StatelessWidget {
  const CustomSnackBarContentError({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MapBloc, MapState>(
      builder: (context, state) {
        return Stack(
          clipBehavior: Clip.none,
           children: [
          Container(
            padding: const EdgeInsets.all(16),
            height: 100,
            decoration: BoxDecoration(
              color: const Color(0xFFC72C41),
              borderRadius: BorderRadius.all(Radius.circular(20)),
            ),
            child: Row(children: const [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Lo sentimos!',
                        style: TextStyle(fontSize: 18, color: Colors.white)),
                    Spacer(),
                    Text(
                      "Usted esta fuera del area de covertura, pronto estaremos disponibles en su zona",
                      style: TextStyle(fontSize: 14, color: Colors.white),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ]),
          ),
        ]);
      },
    );
  }
}

