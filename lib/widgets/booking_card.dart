import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:usuario_inri/animation/dragable_card.dart';
import 'package:usuario_inri/blocs/blocs.dart';
import 'package:usuario_inri/constants/constants.dart';
import 'package:usuario_inri/service/message_service.dart';
import 'package:usuario_inri/widgets/btn_reusable.dart';
import 'package:usuario_inri/widgets/car.dart';
import 'package:usuario_inri/widgets/container_detail.dart';
import 'package:usuario_inri/widgets/presentation_container.dart';
import 'package:usuario_inri/widgets/widgets.dart';

class BookingCard extends StatefulWidget {
  const BookingCard({super.key});

  @override
  State<BookingCard> createState() => _BookingCardState();
}

class _BookingCardState extends State<BookingCard> {
  final MessageService messageService = MessageService();

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final isSmallScreen = screenHeight <= 780;

    final sectionSpacing = isSmallScreen ? 6.0 : 10.0;
    final horizontalPadding = screenWidth < 375 ? 15.0 : 20.0;

    final locationBloc = BlocProvider.of<LocationBloc>(context);

    return DraggableCard(
      startTopFactor: 0.53,
      dragPercent: 0.35,
      child: Container(
        constraints: const BoxConstraints(maxHeight: 550),
        decoration: _decorationContainerBookingCard(),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            // Fondo degradado inferior
            Positioned(
              top: 290,
              left: 0,
              right: 0,
              child: Container(
                height: 260,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppConstants.cardColor.withAlpha(2),
                      AppConstants.cardColor,
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.center,
                  ),
                ),
              ),
            ),

            const Positioned(
              top: -60,
              left: 0,
              right: 0,
              child: AbsorbPointer(
                absorbing: false,
                child: SizedBox(
                  height: 110,
                  child: CarImage(),
                ),
              ),
            ),

            // Título y cupón
            Positioned(
              top: 60,
              left: 20,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Detalle Viaje',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(width: screenWidth <= 370 ? 55 : 90),
                  const Row(
                    children: [
                      Icon(Icons.discount_rounded, color: Colors.white),
                      SizedBox(width: 10),
                      Text(
                        'Cupon',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(width: 5),
                      Text(
                        '\$ 250',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 17,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Contenido dinámico
            Positioned(
              top: sectionSpacing * 12.5,
              left: horizontalPadding,
              right: horizontalPadding,
              child: BlocBuilder<AddressBloc, AddressState>(
                builder: (context, stateAddress) {
                  final order = stateAddress.orderUser;
                  final idOrder = order?.id;
                  final idDriver = order?.idDriver;

                  // 🟢 Mostrar PresentationContainer SOLO si no hay orden
                  final isOrderMissing =
                      order == null || idOrder == null || idOrder.isEmpty;

                  if (isOrderMissing) {
                    return PresentationContainer();
                  }

                  // 🟡 Mostrar TimeLineAddress si hay orden pero no hay conductor
                  final isWaitingDriver = idOrder != null &&
                      idOrder.isNotEmpty &&
                      (idDriver == null || idDriver.isEmpty);

                  if (isWaitingDriver) {
                    return TimeLineAddress();
                  }

                  // ✅ Mostrar datos del conductor si está asignado
                  final isDriverAssigned =
                      idDriver != null && idDriver.isNotEmpty;

                  if (isDriverAssigned) {
                    return ContainerDetail();
                  }

                  return const SizedBox.shrink();
                },
              ),
            ),

            // Botón dinámico
            _buttonsPedirFinalizar(screenHeight, isSmallScreen, locationBloc),
          ],
        ),
      ),
    );
  }

  Positioned _buttonsPedirFinalizar(
      double screenHeight, bool isSmallScreen, LocationBloc locationBloc) {
    return Positioned(
      top: screenHeight * (isSmallScreen ? 0.365 : 0.375),
      left: 20,
      right: 20,
      child: BlocBuilder<AddressBloc, AddressState>(
        builder: (context, stateAddress) {
          // Botón "Pedir Ahora"
          if (stateAddress.orderUser?.id == null) {
            return ButtonReusable(
              text: 'Pedir Ahora',
              onPressed: () async {
                final myLocation = locationBloc.state.lastKnownLocation;
                if (myLocation == null) return;

                context
                    .read<AddressBloc>()
                    .add(CreateOrderUserEvent(myLocation));
                messageService.initPeriodicMessage();
              },
            );
          }

          // Botón "Finalizar"
          final order = stateAddress.orderUser;
          final idOrder = order?.id;
          final hasOrder = idOrder != null && idOrder.isNotEmpty;

          if (hasOrder) {
            return ButtonReusable(
              text: 'Finalizar',
              onPressed: () async {
                context.read<AddressBloc>().add(FinishOrderEvent());
                messageService.cancelPeriodicMessage();

                HydratedBloc.storage.write('AddressBloc', null);
              },
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }

  BoxDecoration _decorationContainerBookingCard() {
    return BoxDecoration(
      image: const DecorationImage(
        image: AssetImage('assets/background_image.png'),
        fit: BoxFit.cover,
        opacity: 0.8,
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
          offset: Offset(5, 0),
        ),
      ],
    );
  }
}
