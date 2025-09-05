import 'package:flutter/material.dart';

class OrderPokemon extends StatefulWidget {
  const OrderPokemon({super.key});

  @override
  State<OrderPokemon> createState() => _OrderPokemonState();
}

class _OrderPokemonState extends State<OrderPokemon> {
  final List<String> types = [
    'Selecciona el orden',
    'Número menor',
    'Número mayor',
    'A-Z',
    'Z-A',
  ];

  String? selectedType;

  void _showTypeModal() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return SizedBox(
          height: 250,
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: types.map((type) {
              return TextButton(
                style: TextButton.styleFrom(
                  backgroundColor:
                      selectedType == type ? Colors.white : Color(0xff333333),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50),
                  ),
                ),
                onPressed: () {
                  setState(() => selectedType = type);
                  Navigator.pop(context);
                },
                child: Text(
                  type,
                  style: const TextStyle(color: Colors.white, fontSize: 16),
                ),
              );
            }).toList(),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      width: 170,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Color(0xff333333),
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50),
          ),
        ),
        onPressed: _showTypeModal,
        child: const Text('Seleccionar orden'),
      ),
    );
  }
}
