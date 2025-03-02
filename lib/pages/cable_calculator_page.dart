import 'package:flutter/material.dart';
import '../services/calculations.dart';
import '../utils/helpers.dart';

class CableCalculatorPage extends StatefulWidget {
  @override
  _CableCalculatorPageState createState() => _CableCalculatorPageState();
}

class _CableCalculatorPageState extends State<CableCalculatorPage> {
  final TextEditingController nominalVoltageController = TextEditingController(text: "10");
  final TextEditingController calculatedLoadController = TextEditingController(text: "1300");
  final TextEditingController shortCircuitCurrentController = TextEditingController(text: "2500");
  final TextEditingController shortCircuitDurationController = TextEditingController(text: "2.5");
  final TextEditingController operatingDurationController = TextEditingController(text: "4000");

  CableSelectionResult? result;

  void _calculate() {
    final double voltage = double.tryParse(nominalVoltageController.text) ?? 0.0;
    final double load = double.tryParse(calculatedLoadController.text) ?? 0.0;
    final double scCurrent = double.tryParse(shortCircuitCurrentController.text) ?? 0.0;
    final double scDuration = double.tryParse(shortCircuitDurationController.text) ?? 0.0;
    final int opDuration = int.tryParse(operatingDurationController.text) ?? 0;

    setState(() {
      result = calculateCableSelection(voltage, load, scCurrent, scDuration, opDuration);
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
          Text("Введіть параметри для вибору кабелю:"),
          SizedBox(height: 16),
          buildTextField(nominalVoltageController, "Номінальна напруга"),
          buildTextField(calculatedLoadController, "Розрахункове навантаження"),
          buildTextField(shortCircuitCurrentController, "Струм короткого замикання"),
          buildTextField(shortCircuitDurationController, "Час дії струму КЗ"),
          buildTextField(operatingDurationController, "Розрахункова тривалість роботи"),
          SizedBox(height: 16),
          ElevatedButton(
            onPressed: _calculate,
            child: Text("Розрахувати"),
          ),
          SizedBox(height: 16),
          if (result != null) ...[
            Text("Розрахунковий струм для нормального режима: ${result!.requiredCurrentCapacity.roundTo(1)} А"),
            Text("Розрахунковий струм для післяаварійного режима: ${result!.emergencyCurrentCapacity.roundTo(1)} А"),
            Text("Економічний переріз кабелю: ${result!.crossSectionArea.roundTo(1)} мм²"),
            Text("Переріз кабелю за термічною стійкістю: ${result!.thermalStability.roundTo(1)} мм²"),
          ]
        ],
      ),
    );
  }
}
