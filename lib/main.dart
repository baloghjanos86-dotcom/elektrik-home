name: Android APK Keszites

on:
  push:
    branches: [ "main", "master" ]
  workflow_dispatch:

jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - name: Fajlok letoltese
        uses: actions/checkout@v4

      - name: Java beallitasa
        uses: actions/setup-java@v4
        with:
          distribution: 'zulu'
          java-version: '17'

      - name: Flutter telepitese
        uses: subosito/flutter-action@v2
        with:
          flutter-version: '3.24.0'
          channel: 'stable'

      - name: Elektrik-Home App Build
        run: |
          flutter create . --project-name elektrik_home --org hu.elektrikhome
          
          cat << 'EOF' > lib/main.dart
          import 'package:flutter/material.dart';
          import 'dart:math';

          // Globális fejlesztői kapcsoló (True = Minden prémium elérhető teszteléshez)
          bool isDeveloperMode = true; 

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
                  appBarTheme: AppBarTheme(
                    backgroundColor: Colors.amber[700],
                    foregroundColor: Colors.black87,
                    elevation: 2,
                  ),
                ),
                home: MainMenuScreen(),
              );
            }
          }

          class MainMenuScreen extends StatefulWidget {
            @override
            _MainMenuScreenState createState() => _MainMenuScreenState();
          }

          class _MainMenuScreenState extends State<MainMenuScreen> {
            @override
            Widget build(BuildContext context) {
              final List<MenuItemData> menuItems = [
                MenuItemData(
                  '1. Kisfeszültség (LV) - Lakossági & Ipari',
                  'Ohm-törvény, feszültségesés, lakossági hálózatok',
                  Icons.home,
                  Colors.blue,
                  TheoryMenuScreen(),
                ),
                MenuItemData(
                  '2. Villanyszerelő Képletgyűjtemény',
                  'Minden fontos szakmai és méretezési képlet',
                  Icons.functions,
                  Colors.teal,
                  FormulasMenuScreen(),
                ),
                MenuItemData(
                  '3. Interaktív Kalkulátorok',
                  'Áramerősség, keresztmetszet és feszültségesés',
                  Icons.calculate,
                  Colors.indigo,
                  CalculatorsScreen(),
                ),
                MenuItemData(
                  '4. Szabványok & Hivatkozások (MSZ / EN)',
                  'Elérhető hatályos szabványcsaládok és előírások',
                  Icons.menu_book,
                  Colors.brown,
                  StandardsScreen(),
                ),
                MenuItemData(
                  '5. Középfeszültség (MV) [PRÉMIUM]',
                  isDeveloperMode ? 'Transzformátorállomások (Fejlesztői Mód aktív)' : 'Transzformátorállomások, cellák, zárlati áramok',
                  Icons.electric_bolt,
                  Colors.deepOrange,
                  isDeveloperMode ? PlaceholderScreen(title: 'Középfeszültség (MV) Rendszerek [Fejlesztői Mód]') : LockedScreen(title: 'Középfeszültség (MV) Rendszerek'),
                ),
                MenuItemData(
                  '6. Magasfeszültség (HV) [PRÉMIUM]',
                  isDeveloperMode ? 'Távvezetékek (Fejlesztői Mód aktív)' : 'Távvezetékek, szabadvezetékek, FAM alapok',
                  Icons.electrical_services,
                  Colors.red,
                  isDeveloperMode ? PlaceholderScreen(title: 'Magasfeszültség (HV) & Távvezetékek [Fejlesztői Mód]') : LockedScreen(title: 'Magasfeszültség (HV) & Távvezetékek'),
                ),
                MenuItemData(
                  '7. Kapcsolási Rajzok & Szabványok',
                  'Váltó, csillár kapcsolók, színkódok',
                  Icons.lightbulb,
                  Colors.green,
                  PlaceholderScreen(title: 'Kapcsolási Rajzok és Szabványok'),
                ),
              ];

              return Scaffold(
                appBar: AppBar(
                  title: Text('Elektrik-Home Pro Expert', style: TextStyle(fontWeight: FontWeight.bold)),
                  centerTitle: true,
                  actions: [
                    IconButton(
                      icon: Icon(isDeveloperMode ? Icons.developer_mode : Icons.lock_open),
                      tooltip: 'Fejlesztői Mód Váltása',
                      onPressed: () {
                        setState(() {
                          isDeveloperMode = !isDeveloperMode;
                        });
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(isDeveloperMode ? '🔧 Fejlesztői Mód BEKAPCSOLVA' : '🔒 Fejlesztői Mód KIKAPCSOLVA'),
                            duration: Duration(seconds: 2),
                          ),
                        );
                      },
                    ),
                  ],
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
                          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          leading: CircleAvatar(
                            radius: 24,
                            backgroundColor: item.color.withOpacity(0.15),
                            child: Icon(item.icon, color: item.color, size: 28),
                          ),
                          title: Text(item.title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                          subtitle: Padding(
                            padding: EdgeInsets.only(top: 4.0),
                            child: Text(item.subtitle),
                          ),
                          trailing: Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey[600]),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => item.targetScreen),
                            );
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
            final Widget targetScreen;

            MenuItemData(this.title, this.subtitle, this.icon, this.color, this.targetScreen);
          }

          class TopicSection {
            final String title;
            final String subtitle;
            final List<String> bulletPoints;

            TopicSection(this.title, this.subtitle, this.bulletPoints);
          }

          // --- SZABVÁNYOK KÉPERNYŐ ---
          class StandardsScreen extends StatelessWidget {
            final List<TopicSection> standardsList = [
              TopicSection(
                'MSZ HD 60364 sorozat',
                'Kisfeszültségű villamos berendezések létesítése (A villanyszerelés alapköve)',
                [
                  'MSZ HD 60364-1: Alapelvek, általános jellemzők meghatározása, fogalommeghatározások.',
                  'MSZ HD 60364-4-41: Érintésvédelem (áramütés elleni védelem, alap- és hibavédelem, kiegészítő védelem FI-relével).',
                  'MSZ HD 60364-4-43: Túláramvédelem (vezetők védelme túlterhelés és zárlat ellen).',
                  'MSZ HD 60364-5-52: Kábelek és vezetékek kiválasztása és szerelése (terhelhetőség, feszültségesés).',
                  'MSZ HD 60364-6: Ellenőrzés (első vizsgálat és időszakos felülvizsgálat).',
                  'MSZ HD 60364-7 sorozat: Különleges berendezések vagy helyiségek (pl. fürdőszobák, uszodák, építkezések, napelemes rendszerek).',
                ],
              ),
              TopicSection(
                'MSZ EN 62305 sorozat',
                'Villámvédelem (Kockázatelemzés és fizikai védelem)',
                [
                  'MSZ EN 62305-1: Általános elvek (kockázatok, zónák).',
                  'MSZ EN 62305-2: Kockázatkezelés (gazdasági és személyi kockázatok számítása).',
                  'MSZ EN 62305-3: Épületek fizikai károsodása és életveszély (felfogók, levezetők, földelések, LPL osztályok).',
                  'MSZ EN 62305-4: Villamos és elektronikus rendszerek belső védelme (túlfeszültség-védelem, árnyékolás).',
                ],
              ),
              TopicSection(
                'MSZ EN 50110 sorozat',
                'Villamos berendezések üzemeltetése',
                [
                  'MSZ EN 50110-1: Európai szabvány az üzemeltetési biztonságról, feszültség alatti munkavégzésről, felelősségi körökről (Kiszakaszolás 5 arany szabálya).',
                ],
              ),
              TopicSection(
                'MSZ EN IEC 61439 sorozat',
                'Kisfeszültségű kapcsoló- és vezérlőberendezés-együttesek',
                [
                  'Elosztószekrények gyártási, tervezési, vizsgálati és tanúsítási szabványa (felváltotta a régi MSZ EN 60439-t).',
                ],
              ),
            ];

            @override
            Widget build(BuildContext context) {
              return Scaffold(
                appBar: AppBar(title: Text('Szabványok és Előírások')),
                body: ListView.builder(
                  padding: EdgeInsets.all(12),
                  itemCount: standardsList.length,
                  itemBuilder: (context, index) {
                    final std = standardsList[index];
                    return Card(
                      elevation: 2,
                      margin: EdgeInsets.symmetric(vertical: 6),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Colors.brown.withOpacity(0.15),
                          child: Icon(Icons.bookmark, color: Colors.brown),
                        ),
                        title: Text(std.title, style: TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Text(std.subtitle, maxLines: 2, overflow: TextOverflow.ellipsis),
                        trailing: Icon(Icons.arrow_forward_ios, size: 16),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => TopicDetailScreen(section: std, themeColor: Colors.brown)),
                          );
                        },
                      ),
                    );
                  },
                ),
              );
            }
          }

          class TheoryMenuScreen extends StatelessWidget {
            final List<TopicSection> chapters = [
              TopicSection(
                '1. Kisfeszültségű (LV) Alapok és Töltések',
                '0.4 kV alatti hálózatok és alapvető fizikai törvényszerűségek.',
                [
                  'Feszültségszintek: Kisfeszültség 1000 V AC-ig / 1500 V DC-ig terjed.',
                  'Elektromos töltés (Q) és áram (I): I = Q / t, mértékegysége Amper (A).',
                  'Ohm törvénye a gyakorlatban: U = I · R, védelem szempontjából kritikus értékek.',
                  'Kirchhoff törvények: Csomóponti és huroktörvény az elosztótáblák hibakereséséhez.',
                ],
              ),
              TopicSection(
                '2. Kisfeszültségű Elosztók és Védelmek',
                'Lakossági és kereskedelmi épületek elosztószekrényei.',
                [
                  'Kismegszakítók karakterisztikái: B (lakossági konnektorok, világítás), C (motorok, induktív terhelések), D (nagy indítóáramú transzformátorok).',
                  'Áram-védőkapcsoló (FI-relé / RCD): Érintésvédelem, lakossági szabvány szerint max 30 mA érzékenység.',
                  'Túlfeszültség-védelem (SPD): T1, T2, T3 fokozatok a villámvédelem és kapcsolási túlfeszültségek ellen.',
                ],
              ),
              TopicSection(
                '3. Vezeték- és Keresztmetszet-számítás LV-ben',
                'Hőmérsékleti tényezők, egyidejűség és feszültségesés.',
                [
                  'Megengedett tartós áram: Függ a fektetési módtól (falban, csőben, tálcán) és a szigetelés anyagától (PVC vs. XLPE).',
                  'Feszültségesési határok: Világításnál max. 1-3%, egyéb fogyasztóknál max. 3-5% a fogyasztói berendezés végpontjáig.',
                ],
              ),
            ];

            @override
            Widget build(BuildContext context) {
              return Scaffold(
                appBar: AppBar(title: Text('Kisfeszültség (LV) Rendszerek')),
                body: ListView.builder(
                  padding: EdgeInsets.all(12),
                  itemCount: chapters.length,
                  itemBuilder: (context, index) {
                    final ch = chapters[index];
                    return Card(
                      elevation: 2,
                      margin: EdgeInsets.symmetric(vertical: 6),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Colors.blue.withOpacity(0.15),
                          child: Text('${index + 1}.', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue)),
                        ),
                        title: Text(ch.title, style: TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Text(ch.subtitle, maxLines: 2, overflow: TextOverflow.ellipsis),
                        trailing: Icon(Icons.arrow_forward_ios, size: 16),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => TopicDetailScreen(section: ch, themeColor: Colors.blue)),
                          );
                        },
                      ),
                    );
                  },
                ),
              );
            }
          }

          class FormulasMenuScreen extends StatelessWidget {
            final List<TopicSection> formulaCategories = [
              TopicSection(
                '1. Alapvető egyenáramú és ohmikus képletek',
                'Tiszta ellenállásos körök összefüggései.',
                [
                  'Ohm törvénye: U = I · R',
                  'Teljesítmény: P = U · I = I² · R = U² / R',
                  'Elektromos munka: W = P · t',
                ],
              ),
              TopicSection(
                '2. Vezetékek ellenállása és feszültségesés',
                'Méretezéshez használt képletek.',
                [
                  'Vezeték ellenállása: R = ρ · (l / A) (Réz: 0,0175 Ω·mm²/m)',
                  'Egyfázisú feszültségesés: ΔU = (2 · l · I · ρ) / A',
                  'Háromfázisú feszültségesés: ΔU = (√3 · l · I · ρ · cosφ) / A',
                  'Százalékos esés: ε% = (ΔU / U_n) · 100',
                ],
              ),
              TopicSection(
                '3. Váltakozó áram és Háromfázisú rendszerek',
                'Ipari és hálózati teljesítmények.',
                [
                  'Hatásos teljesítmény: P = √3 · U_v · I · cosφ',
                  'Meddő teljesítmény: Q = √3 · U_v · I · sinφ',
                  'Látszólagos teljesítmény: S = √3 · U_v · I',
                ],
              ),
            ];

            @override
            Widget build(BuildContext context) {
              return Scaffold(
                appBar: AppBar(title: Text('Szakmai Képletgyűjtemény')),
                body: ListView.builder(
                  padding: EdgeInsets.all(12),
                  itemCount: formulaCategories.length,
                  itemBuilder: (context, index) {
                    final cat = formulaCategories[index];
                    return Card(
                      elevation: 2,
                      margin: EdgeInsets.symmetric(vertical: 6),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Colors.teal.withOpacity(0.15),
                          child: Icon(Icons.functions, color: Colors.teal),
                        ),
                        title: Text(cat.title, style: TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Text(cat.subtitle, maxLines: 2, overflow: TextOverflow.ellipsis),
                        trailing: Icon(Icons.arrow_forward_ios, size: 16),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => TopicDetailScreen(section: cat, themeColor: Colors.teal)),
                          );
                        },
                      ),
                    );
                  },
                ),
              );
            }
          }

          class TopicDetailScreen extends StatelessWidget {
            final TopicSection section;
            final Color themeColor;

            TopicDetailScreen({required this.section, required this.themeColor});

            @override
            Widget build(BuildContext context) {
              return Scaffold(
                appBar: AppBar(title: Text(section.title)),
                body: SingleChildScrollView(
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: themeColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: themeColor.withOpacity(0.3)),
                        ),
                        child: Text(
                          section.subtitle,
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87),
                        ),
                      ),
                      SizedBox(height: 16),
                      ...section.bulletPoints.map((point) => Card(
                        elevation: 1,
                        margin: EdgeInsets.symmetric(vertical: 6),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        child: Padding(
                          padding: EdgeInsets.all(14.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Icon(Icons.bolt, color: themeColor, size: 22),
                              SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  point,
                                  style: TextStyle(fontSize: 15, height: 1.4),
                                ),
                              ),
                            ],
                          ),
                        ),
                      )).toList(),
                    ],
                  ),
                ),
              );
            }
          }

          class CalculatorsScreen extends StatefulWidget {
            @override
            _CalculatorsScreenState createState() => _CalculatorsScreenState();
          }

          class _CalculatorsScreenState extends State<CalculatorsScreen> {
            final TextEditingController powerController = TextEditingController();
            final TextEditingController voltageController = TextEditingController(text: '230');
            String currentResult = 'Add meg az adatokat a számításhoz!';

            final TextEditingController lengthController = TextEditingController();
            final TextEditingController ampController = TextEditingController();
            final TextEditingController crossSectionController = TextEditingController(text: '2.5');
            bool isThreePhase = false;
            bool isCopper = true;
            String dropResult = 'Add meg a vezeték adatait!';

            void calculateCurrent() {
              double? power = double.tryParse(powerController.text.replaceAll(',', '.'));
              double? voltage = double.tryParse(voltageController.text.replaceAll(',', '.'));

              if (power != null && voltage != null && voltage > 0) {
                double current = power / voltage;
                String wire = current <= 13 ? '1,5 mm²' : (current <= 20 ? '2,5 mm²' : (current <= 25 ? '4,0 mm²' : '6,0+ mm²'));
                setState(() {
                  currentResult = 'Szükséges áramerősség (I): ${current.toStringAsFixed(2)} A\nAjánlott min. rézvezető: $wire';
                });
              } else {
                setState(() {
                  currentResult = 'Kérlek érvényes számokat adj meg!';
                });
              }
            }

            void calculateVoltageDrop() {
              double? l = double.tryParse(lengthController.text.replaceAll(',', '.'));
              double? i = double.tryParse(ampController.text.replaceAll(',', '.'));
              double? a = double.tryParse(crossSectionController.text.replaceAll(',', '.'));

              if (l != null && i != null && a != null && a > 0) {
                double rho = isCopper ? 0.0175 : 0.028;
                double un = isThreePhase ? 400.0 : 230.0;
                double deltaU = isThreePhase ? (sqrt(3) * l * i * rho) / a : (2 * l * i * rho) / a;
                double percent = (deltaU / un) * 100;

                setState(() {
                  dropResult = 'Feszültségesés (ΔU): ${deltaU.toStringAsFixed(2)} V\nSzázalékos esés (ε%): ${percent.toStringAsFixed(2)} %\n${percent <= 3.0 ? "✅ Megfelelő (< 3%)" : "⚠️ Túl magas feszültségesés (> 3%)!"}';
                });
              } else {
                setState(() {
                  dropResult = 'Kérlek minden mezőbe érvényes számot írj!';
                });
              }
            }

            @override
            Widget build(BuildContext context) {
              return Scaffold(
                appBar: AppBar(title: Text('Interaktív Kalkulátorok')),
                body: SingleChildScrollView(
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('1. Teljesítményből Áramerősség (I = P / U)', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blue[900])),
                      SizedBox(height: 10),
                      TextField(controller: powerController, keyboardType: TextInputType.number, decoration: InputDecoration(labelText: 'Teljesítmény (Watt, pl. 3600)', border: OutlineInputBorder(), filled: true, fillColor: Colors.white)),
                      SizedBox(height: 10),
                      TextField(controller: voltageController, keyboardType: TextInputType.number, decoration: InputDecoration(labelText: 'Feszültség (Volt, pl. 230)', border: OutlineInputBorder(), filled: true, fillColor: Colors.white)),
                      SizedBox(height: 12),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(minimumSize: Size(double.infinity, 48), backgroundColor: Colors.blue[700], foregroundColor: Colors.white),
                        onPressed: calculateCurrent,
                        child: Text('Áramerősség Számolása', style: TextStyle(fontSize: 16)),
                      ),
                      SizedBox(height: 12),
                      Container(
                        padding: EdgeInsets.all(14),
                        width: double.infinity,
                        decoration: BoxDecoration(color: Colors.blue[50], borderRadius: BorderRadius.circular(10), border: Border.all(color: Colors.blue.shade200)),
                        child: Text(currentResult, style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.blue[900])),
                      ),
                      SizedBox(height: 30),
                      Divider(thickness: 2),
                      SizedBox(height: 15),
                      Text('2. Feszültségesés Kalkulátor (ΔU és ε%)', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.teal[900])),
                      SizedBox(height: 10),
                      Row(
                        children: [
                          Expanded(child: ChoiceChip(label: Text('1 Fázis (230V)'), selected: !isThreePhase, onSelected: (val) => setState(() => isThreePhase = false))),
                          SizedBox(width: 8),
                          Expanded(child: ChoiceChip(label: Text('3 Fázis (400V)'), selected: isThreePhase, onSelected: (val) => setState(() => isThreePhase = true))),
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(child: ChoiceChip(label: Text('Réz (Cu)'), selected: isCopper, onSelected: (val) => setState(() => isCopper = true))),
                          SizedBox(width: 8),
                          Expanded(child: ChoiceChip(label: Text('Alumínium (Al)'), selected: !isCopper, onSelected: (val) => setState(() => isCopper = false))),
                        ],
                      ),
                      SizedBox(height: 10),
                      TextField(controller: lengthController, keyboardType: TextInputType.number, decoration: InputDecoration(labelText: 'Nyomvonal hossza (méter, pl. 25)', border: OutlineInputBorder(), filled: true, fillColor: Colors.white)),
                      SizedBox(height: 10),
                      TextField(controller: ampController, keyboardType: TextInputType.number, decoration: InputDecoration(labelText: 'Áramerősség (Amper, pl. 16)', border: OutlineInputBorder(), filled: true, fillColor: Colors.white)),
                      SizedBox(height: 10),
                      TextField(controller: crossSectionController, keyboardType: TextInputType.number, decoration: InputDecoration(labelText: 'Vezeték keresztmetszet (mm², pl. 2.5)', border: OutlineInputBorder(), filled: true, fillColor: Colors.white)),
                      SizedBox(height: 12),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(minimumSize: Size(double.infinity, 48), backgroundColor: Colors.teal[700], foregroundColor: Colors.white),
                        onPressed: calculateVoltageDrop,
                        child: Text('Feszültségesés Számolása', style: TextStyle(fontSize: 16)),
                      ),
                      SizedBox(height: 12),
                      Container(
                        padding: EdgeInsets.all(14),
                        width: double.infinity,
                        decoration: BoxDecoration(color: Colors.teal[50], borderRadius: BorderRadius.circular(10), border: Border.all(color: Colors.teal.shade200)),
                        child: Text(dropResult, style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.teal[900])),
                      ),
                    ],
                  ),
                ),
              );
            }
          }

          class LockedScreen extends StatelessWidget {
            final String title;
            LockedScreen({required this.title});

            @override
            Widget build(BuildContext context) {
              return Scaffold(
                appBar: AppBar(title: Text(title)),
                body: Padding(
                  padding: EdgeInsets.all(24.0),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.lock, size: 72, color: Colors.red[400]),
                        SizedBox(height: 20),
                        Text('Ez egy Prémium Szakmai Modul', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
                        SizedBox(height: 10),
                        Text('A(z) "$title" tartalom az ipari és nagytilalmi szabványokat, transzformátor és távvezeték méretezési kalkulátorokat tartalmazza.', textAlign: TextAlign.center, style: TextStyle(fontSize: 15, color: Colors.grey[700])),
                        SizedBox(height: 30),
                        ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(backgroundColor: Colors.red[700], foregroundColor: Colors.white, minimumSize: Size(double.infinity, 50)),
                          icon: Icon(Icons.star),
                          label: Text('Prémium Előfizetés Igénylése', style: TextStyle(fontSize: 16)),
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Google Play Billing integráció hamarosan érkezik!')),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }
          }

          class PlaceholderScreen extends StatelessWidget {
            final String title;
            PlaceholderScreen({required this.title});

            @override
            Widget build(BuildContext context) {
              return Scaffold(
                appBar: AppBar(title: Text(title)),
                body: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Center(
                    child: Text(
                      'A(z) "$title" modul tartalma sikeresen betöltve (Fejlesztői Mód aktív).',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 17, color: Colors.grey[700]),
                    ),
                  ),
                ),
              );
            }
          }
          EOF

          flutter pub get
          flutter build apk --release

      - name: Kész APK feltoltese
        uses: actions/upload-artifact@v4
        with:
          name: Elektrik-Home-Telepito
          path: build/app/outputs/flutter-apk/app-release.apk
