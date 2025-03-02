import 'package:flutter/material.dart';
import '../services/calculations.dart';
import '../utils/helpers.dart';

class ShortCircuitCurrentCalculatorPage extends StatefulWidget {
  @override
  _ShortCircuitCurrentCalculatorPageState createState() => _ShortCircuitCurrentCalculatorPageState();
}

class _ShortCircuitCurrentCalculatorPageState extends State<ShortCircuitCurrentCalculatorPage> {
  final TextEditingController nominalVoltageController = TextEditingController(text: "10.5");
  final TextEditingController shortCircuitVoltageController = TextEditingController(text: "10.5");
  final TextEditingController shortCircuitPowerController = TextEditingController(text: "200");
  final TextEditingController transformerPowerController = TextEditingController(text: "6.3");

  ShortCircuitCurrentResult? result;

  void _calculate() {
    final double nominalVoltage = double.tryParse(nominalVoltageController.text) ?? 0.0;
    final double shortCircuitVoltage = double.tryParse(shortCircuitVoltageController.text) ?? 0.0;
    final double shortCircuitPower = double.tryParse(shortCircuitPowerController.text) ?? 0.0;
    final double transformerPower = double.tryParse(transformerPowerController.text) ?? 0.0;

    setState(() {
      result = calculateShortCircuitCurrent(
        nominalVoltage,
        shortCircuitVoltage,
        shortCircuitPower,
        transformerPower,
      );
    });
  }

  Widget buildTextField(TextEditingController controller, String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          labelText: label,
        ),
        keyboardType: TextInputType.number,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Введіть параметри для розрахунку струму короткого замикання:"),
          SizedBox(height: 16),
          buildTextField(nominalVoltageController, "Номінальна напруга"),
          buildTextField(shortCircuitVoltageController, "Напруга КЗ трансформатора"),
          buildTextField(shortCircuitPowerController, "Потужність короткого замикання"),
          buildTextField(transformerPowerController, "Номінальна потужність трансформатора"),
          SizedBox(height: 16),
          ElevatedButton(
            onPressed: _calculate,
            child: Text("Розрахувати"),
          ),
          SizedBox(height: 16),
          if (result != null) ...[
            Text("Загальний опір: ${result!.totalResistance.roundTo(2)} Ом"),
            Text("Початковий струм трифазного КЗ: ${result!.shortCircuitCurrent.roundTo(1)} А"),
          ]
        ],
      ),
    );
  }
}
