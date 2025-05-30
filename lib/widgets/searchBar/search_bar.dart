import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:latlong2/latlong.dart';
import 'package:usuario_inri/blocs/location/location_bloc.dart';
import 'package:usuario_inri/blocs/searchBar/search_bar_bloc.dart';

class SearchBarWidget extends StatefulWidget {
  final Function(String, LatLng) onSearch;

  const SearchBarWidget({super.key, required this.onSearch});

  @override
  State<SearchBarWidget> createState() => _SearchBarWidgetState();
}

class _SearchBarWidgetState extends State<SearchBarWidget> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    final LatLng? userLocation =
        context.select((LocationBloc bloc) => bloc.state.lastKnownLocation);

    final fromText = userLocation != null
        ? '(${userLocation.latitude.toStringAsFixed(5)}, ${userLocation.longitude.toStringAsFixed(5)})'
        : 'Obteniendo ubicación...';

    return Positioned(
      top: 30,
      left: 50,
      right: 20,
      child: BlocBuilder<SearchBarBloc, SearchBarState>(
        builder: (context, state) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Material(
                elevation: 8,
                borderRadius: BorderRadius.circular(25),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white10,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Iconos + línea punteada
                      Column(
                        children: [
                          SizedBox(height: 8),
                          Icon(Icons.radio_button_checked,
                              size: 22, color: Colors.green),
                          SizedBox(height: 4),
                          CustomPaint(
                            painter: DottedLinePainter(),
                            size: const Size(1, 35),
                          ),
                          Icon(Icons.location_on_outlined,
                              size: 22, color: Colors.blue),
                        ],
                      ),
                      const SizedBox(width: 12),
                      // Campos de texto
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 8),
                            Text('Desde',
                                style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey.shade800,
                                    fontWeight: FontWeight.w600,
                                    letterSpacing: 0.5
                               )
                             ),
                            const SizedBox(height: 4),
                            Text(
                              fromText,
                              style: const TextStyle(fontSize: 16),
                            ),
                            const SizedBox(height: 12),
                            const Padding(
                              padding: EdgeInsets.only(left: 1, right: 10),
                              child: Divider(
                                  height: 1,
                                  thickness: 1,
                                  color: Color.fromARGB(255, 193, 191, 191)),
                            ),
                            const SizedBox(height: 8),
                            Text('Hacia',
                                style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey.shade800,
                                    fontWeight: FontWeight.w600,
                                    letterSpacing: 0.5)),
                            Row(
                              children: [
                                Expanded(
                                  child: TextField(
                                    controller: _controller,
                                    focusNode: _focusNode,
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      hintText: '¿A dónde vas?',
                                      hintStyle: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                      ),
                                      isDense: true,
                                      suffixIcon: _controller.text.isNotEmpty
                                          ? Transform.translate(
                                            offset: const Offset(0, -7),
                                            child: IconButton(
                                                icon: const Icon(Icons.clear,
                                                    size: 18,
                                                    color: Color.fromARGB(255, 139, 139, 139)),
                                                onPressed: () {
                                                  setState(() {
                                                    _controller.clear();
                                                  });
                                                  context
                                                      .read<SearchBarBloc>()
                                                      .add(
                                                          OnTextChangedEvent(''));
                                                },
                                              ),
                                          )
                                          : null,
                                    ),
                                    onChanged: (text) {
                                      context
                                          .read<SearchBarBloc>()
                                          .add(OnTextChangedEvent(text));
                                      setState(
                                          () {}); // importante para redibujar el icono
                                    },
                                  ),
                                ),
                                if (state.isLoading)
                                  const SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(
                                        strokeWidth: 2),
                                  ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // Mostrar sugerencias si hay texto y resultados
              if (_focusNode.hasFocus &&
                  _controller.text.isNotEmpty &&
                  state.suggestions.isNotEmpty) ...[
                const SizedBox(height: 8),
                _buildList(state.suggestions, true),
              ]

// Mostrar historial si el campo está vacío y hay historial
              else if (_focusNode.hasFocus &&
                  _controller.text.isEmpty &&
                  state.history.isNotEmpty) ...[
                const SizedBox(height: 8),
                _buildList(state.history, false),
              ]
            ],
          );
        },
      ),
    );
  }

  Widget _buildList(List<Map<String, dynamic>> items, bool isSuggestions) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(15),
      ),
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: items.length,
        itemBuilder: (_, index) {
          final item = items[index];
          final name = isSuggestions ? item['place_name'] : item['name'];
          final coords = isSuggestions
              ? LatLng(item['geometry']['coordinates'][1],
                  item['geometry']['coordinates'][0])
              : item['coords'];

          return ListTile(
            leading: Icon(isSuggestions ? Icons.location_on : Icons.history),
            title: Text(name),
            onTap: () {
              _controller.text = name;
              context.read<SearchBarBloc>().add(
                    OnSuggestionSelectedEvent(name: name, coords: coords),
                  );
              widget.onSearch(name, coords);
            },
          );
        },
      ),
    );
  }
}

// Línea punteada vertical entre los íconos
class DottedLinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.grey
      ..strokeWidth = 2;

    const dashHeight = 4;
    const dashSpace = 3;
    double startY = 0;

    while (startY < size.height) {
      canvas.drawLine(Offset(0, startY), Offset(0, startY + dashHeight), paint);
      startY += dashHeight + dashSpace;
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
