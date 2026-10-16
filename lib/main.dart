import 'package:flutter/material.dart';

void main() => runApp(VillanyszereloApp());

class VillanyszereloApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Elektrik-Home Pro',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.amber,
        scaffoldBackgroundColor: Colors.grey[100],
      ),
      home: MainMenuScreen(),
    );
  }
}

class MainMenuScreen extends StatelessWidget {
  final List<MenuItemData> menuItems = [
    MenuItemData('Számítások és Képletek', 'Ohm-törvény, teljesítmény, keresztmetszet', Icons.calculate, Colors.blue),
    MenuItemData('Kapcsolási Rajzok', 'Egypólusú, váltó, csillár kapcsolók', Icons.electrical_services, Colors.orange),
    MenuItemData('Színkódok és Szabványok', 'Fázis, nulla, védővezető jelölések', Icons.color_lens, Colors.green),
    MenuItemData('Gyakorlati Tippek', 'Szerelési fogások, hibakeresés', Icons.lightbulb, Colors.purple),
    MenuItemData('Prémium Tartalom (Zárolt)', 'Exkluzív ipari projektek és méretezések', Icons.lock, Colors.red),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Elektrik-Home Szakmai Segédlet'),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.all(12.0),
        child: ListView.builder(
          itemCount: menuItems.length,
          itemBuilder: (context, index) {
            final item = menuItems[index];
            return Card(
              elevation: 3,
              margin: EdgeInsets.symmetric(vertical: 8),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: item.color.withOpacity(0.2),
                  child: Icon(item.icon, color: item.color),
                ),
                title: Text(item.title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                subtitle: Text(item.subtitle),
                trailing: Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () {
                  if (item.title.contains('Számítások')) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => CalculationsScreen()),
                    );
                  } else {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => DetailScreen(title: item.title)),
                    );
                  }
                },
              ),
            );
          },
        ),
      ),
    );
  }
}

class MenuItemData {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;

  MenuItemData(this.title, this.subtitle, this.icon, this.color);
}

class CalculationsScreen extends StatefulWidget {
  @override
  _CalculationsScreenState createState() => _CalculationsScreenState();
}

class _CalculationsScreenState extends State<CalculationsScreen> {
  final TextEditingController powerController = TextEditingController();
  final TextEditingController voltageController = TextEditingController(text: '230');
  String resultText = 'Add meg az adatokat a számításhoz!';

  void calculateCurrent() {
    double? power = double.tryParse(powerController.text);
    double? voltage = double.tryParse(voltageController.text);

    if (power != null && voltage != null && voltage > 0) {
      double current = power / voltage;
      setState(() {
        resultText = 'Szükséges áramerősség (I): ${current.toStringAsFixed(2)} A\n'
            'Ajánlott minimális rézvezető: ${current <= 13 ? '1.5 mm²' : (current <= 20 ? '2.5 mm²' : '4.0 mm²')}';
      });
    } else {
      setState(() {
        resultText = 'Kérlek érvényes számokat adj meg!';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Számítások és Képletek')),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('1. Teljesítményből Áramerősség Kalkulátor (I = P / U)',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blue[800])),
            SizedBox(height: 10),
            TextField(
              controller: powerController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Teljesítmény (Watt, pl. 3600)',
                border: OutlineInputBorder(),
                filled: true,
                fillColor: Colors.white,
              ),
            ),
            SizedBox(height: 10),
            TextField(
              controller: voltageController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Feszültség (Volt, pl. 230)',
                border: OutlineInputBorder(),
                filled: true,
                fillColor: Colors.white,
              ),
            ),
            SizedBox(height: 15),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 50),
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
              ),
              onPressed: calculateCurrent,
              child: Text('Számolás', style: TextStyle(fontSize: 16)),
            ),
            SizedBox(height: 20),
            Container(
              padding: EdgeInsets.all(16),
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.blue[50],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.blue.withOpacity(0.3)),
              ),
              child: Text(
                resultText,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.blue[900]),
              ),
            ),
            SizedBox(height: 30),
            Divider(),
            SizedBox(height: 10),
            Text('2. Elméleti háttér (Ohm-törvény)',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blue[800])),
            SizedBox(height: 8),
            Text('• Feszültség (U) = Áramerősség (I) × Ellenállás (R)\n'
                '• Teljesítmény (P) = Feszültség (U) × Áramerősség (I)\n\n'
                'Itt jeleníthetjük meg majd a te további képleteidet, képeidet és magyarázataidat is.'),
          ],
        ),
      ),
    );
  }
}

class DetailScreen extends StatelessWidget {
  final String title;
  DetailScreen({required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Itt jelennek meg majd a(z) "$title" részletes leírásai és képei!',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
          ],
        ),
      ),
    );
  }
}
