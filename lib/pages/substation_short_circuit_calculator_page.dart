import 'package:flutter/material.dart';
import '../services/calculations.dart';
import '../utils/helpers.dart';

class SubstationShortCircuitCalculatorPage extends StatefulWidget {
  @override
  _SubstationShortCircuitCalculatorPageState createState() =>
      _SubstationShortCircuitCalculatorPageState();
}

class _SubstationShortCircuitCalculatorPageState extends State<SubstationShortCircuitCalculatorPage> {
  final TextEditingController UkmaxController = TextEditingController(text: "11.1");
  final TextEditingController SnomController = TextEditingController(text: "6.3");
  final TextEditingController UvnController = TextEditingController(text: "115");
  final TextEditingController UnnController = TextEditingController(text: "11");
  final TextEditingController RcnController = TextEditingController(text: "10.65");
  final TextEditingController RcminController = TextEditingController(text: "34.88");
  final TextEditingController XcnController = TextEditingController(text: "24.02");
  final TextEditingController XcminController = TextEditingController(text: "65.68");

  SubstationShortCircuitCurrentResult? result;

  void _calculate() {
    final double Ukmax = double.tryParse(UkmaxController.text) ?? 0.0;
    final double Snom = double.tryParse(SnomController.text) ?? 0.0;
    final double Uvn = double.tryParse(UvnController.text) ?? 0.0;
    final double Unn = double.tryParse(UnnController.text) ?? 0.0;
    final double Rcn = double.tryParse(RcnController.text) ?? 0.0;
    final double Rcmin = double.tryParse(RcminController.text) ?? 0.0;
    final double Xcn = double.tryParse(XcnController.text) ?? 0.0;
    final double Xcmin = double.tryParse(XcminController.text) ?? 0.0;

    setState(() {
      result = calculateSubstationShortCircuitCurrents(
          Ukmax, Snom, Uvn, Unn, Rcn, Rcmin, Xcn, Xcmin);
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
          Text("Введіть параметри підстанції для розрахунку струму короткого замикання:"),
          SizedBox(height: 16),
          buildTextField(UkmaxController, "Максимальний імпеданс КЗ (%)"),
          buildTextField(SnomController, "Номінальна потужність трансформатора (MVA)"),
          buildTextField(UvnController, "Високовольтна напруга трансформатора (кВ)"),
          buildTextField(UnnController, "Низьковольтна напруга трансформатора (кВ)"),
          buildTextField(RcnController, "Опір мережі в нормальному режимі (Ом)"),
          buildTextField(RcminController, "Опір мережі в мінімальному режимі (Ом)"),
          buildTextField(XcnController, "Реактивний опір мережі в нормальному режимі (Ом)"),
          buildTextField(XcminController, "Реактивний опір мережі в мінімальному режимі (Ом)"),
          SizedBox(height: 16),
          ElevatedButton(
            onPressed: _calculate,
            child: Text("Розрахувати"),
          ),
          SizedBox(height: 16),
          if (result != null) ...[
            Text("Xt: ${result!.Xt.roundTo(2)} Ом"),
            Text("Xш в нормальному режимі приведений до 110кВ: ${result!.Xsh.roundTo(2)} Ом"),
            Text("Zш в нормальному режимі приведений до 110кВ: ${result!.Zsh.roundTo(2)} Ом"),
            Text("Xш в мінімальному режимі приведений до 110кВ: ${result!.Xshmin.roundTo(2)} Ом"),
            Text("Zш в мінімальному режимі приведений до 110кВ: ${result!.Zshmin.roundTo(2)} Ом"),
            Text("Струм трифазного КЗ в нормальному режимі приведений до 110кВ: ${result!.I3.roundTo(2)} А"),
            Text("Струм двофазного КЗ в нормальному режимі приведений до 110кВ: ${result!.I2.roundTo(2)} А"),
            Text("Струм трифазного КЗ в мінімальному режимі приведений до 110кВ: ${result!.I3shmin.roundTo(2)} А"),
            Text("Струм двофазного КЗ в мінімальному режимі приведений до 110кВ: ${result!.I2shmin.roundTo(2)} А"),
            Text("Коефіцієнт приведення: ${result!.kpr.roundTo(2)}"),
            Text("Rш в нормальному режимі приведений до 110кВ: ${result!.Rshn.roundTo(2)} Ом"),
            Text("Xш в нормальному режимі приведений до 110кВ: ${result!.Xshn.roundTo(2)} Ом"),
            Text("Zш в нормальному режимі приведений до 110кВ: ${result!.Zshn.roundTo(2)} Ом"),
            Text("Rш в мінімальному режимі: ${result!.Rshnmin.roundTo(2)} Ом"),
            Text("Xш в мінімальному режимі: ${result!.Xshnmin.roundTo(2)} Ом"),
            Text("Zш в мінімальному режимі: ${result!.Zshnmin.roundTo(2)} Ом"),
            Text("Струм трифазного КЗ в мінімальному режимі: ${result!.I3shnmin.roundTo(2)} А"),
            Text("Струм двофазного КЗ в мінімальному режимі: ${result!.I2shnmin.roundTo(2)} А"),
            Text("Релактанс відрізка: ${result!.Rl.roundTo(2)} Ом"),
            Text("Реактанс відрізка: ${result!.Xl.roundTo(2)} Ом"),
            Text("Ren в точці 10 в нормальному режимі: ${result!.Ren.roundTo(2)} Ом"),
            Text("Xen в точці 10 в нормальному режимі: ${result!.Xen.roundTo(2)} Ом"),
            Text("Zen в точці 10 в нормальному режимі: ${result!.Zen.roundTo(2)} Ом"),
            Text("Renmin в точці 10 в мінімальному режимі: ${result!.Renmin.roundTo(2)} Ом"),
            Text("Xenmin в точці 10 в мінімальному режимі: ${result!.Xenmin.roundTo(2)} Ом"),
            Text("Zenmin в точці 10 в мінімальному режимі: ${result!.Zenmin.roundTo(2)} Ом"),
            Text("Струм трифазного КЗ в точці 10 в нормальному режимі: ${result!.I3ln.roundTo(2)} А"),
            Text("Струм двофазного КЗ в точці 10 в нормальному режимі: ${result!.I2ln.roundTo(2)} А"),
            Text("Струм трифазного КЗ в точці 10 в мінімальному режимі: ${result!.I3lnmin.roundTo(2)} А"),
            Text("Струм двофазного КЗ в точці 10 в мінімальному режимі: ${result!.I2lnmin.roundTo(2)} А"),
          ]
        ],
      ),
    );
  }
}
