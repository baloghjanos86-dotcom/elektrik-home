import 'package:flutter/material.dart';
import 'dart:math';

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

// --- FŐMENÜ ---
class MainMenuScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final List<MenuItemData> menuItems = [
      MenuItemData(
        'Elméleti Alapok (1-6. fejezet)',
        'Töltés, áram, Ohm és Kirchhoff törvényei, AC/DC',
        Icons.menu_book,
        Colors.indigo,
        TheoryMenuScreen(),
      ),
      MenuItemData(
        'Villanyszerelő Képletgyűjtemény',
        'Minden fontos szakmai és méretezési képlet',
        Icons.functions,
        Colors.teal,
        FormulasMenuScreen(),
      ),
      MenuItemData(
        'Számológépek és Kalkulátorok',
        'Áramerősség, keresztmetszet és feszültségesés',
        Icons.calculate,
        Colors.blue,
        CalculatorsScreen(),
      ),
      MenuItemData(
        'Kapcsolási Rajzok',
        'Egypólusú, váltó, csillár kapcsolók',
        Icons.electrical_services,
        Colors.orange,
        PlaceholderScreen(title: 'Kapcsolási Rajzok'),
      ),
      MenuItemData(
        'Színkódok és Szabványok',
        'Fázis, nulla, védővezető jelölések',
        Icons.color_lens,
        Colors.green,
        PlaceholderScreen(title: 'Színkódok és Szabványok'),
      ),
      MenuItemData(
        'Prémium Tartalom (Zárolt)',
        'Exkluzív ipari projektek és méretezések',
        Icons.lock,
        Colors.red,
        PlaceholderScreen(title: 'Prémium Tartalom'),
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text('Elektrik-Home Szakmai Segédlet', style: TextStyle(fontWeight: FontWeight.bold)),
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

// --- ADATSTRUKTÚRA FEJEZETEKHEZ ---
class TopicSection {
  final String title;
  final String subtitle;
  final List<String> bulletPoints;

  TopicSection(this.title, this.subtitle, this.bulletPoints);
}

// --- 1. ELMÉLETI ALAPOK MENÜ (1-6. FEJEZET) ---
class TheoryMenuScreen extends StatelessWidget {
  final List<TopicSection> chapters = [
    TopicSection(
      '1. fejezet: Alapfogalmak és az elektromos töltés',
      'Minden elektromos jelenség alapja a töltés, amely az anyag egy alapvető tulajdonsága.',
      [
        'Elektromos töltés (Q): Jele Q, mértékegysége a Coulomb (C). Az elektronok negatív, a protonok pozitív töltésűek.',
        'Elemi töltés: Egyetlen elektron töltése (e ≈ -1,6 · 10⁻¹⁹ C).',
        'Coulomb-törvény: Két pontszerű töltés között ható erő egyenesen arányos a töltések nagyságával, és fordítottan arányos a köztük lévő távolság négyzetével.',
        'Elektromos tér: A töltések maguk körül elektromos mezőt hoznak létre, amely erőt fejt ki a többi töltésre.',
      ],
    ),
    TopicSection(
      '2. fejezet: Elektromos áram, feszültség és ellenállás',
      'Ez a három alapvető mennyiség határozza meg a villamos áramkörök működését.',
      [
        'Elektromos áram (I): A töltéshordozók (pl. szabad elektronok) egyirányú, rendezett mozgása.\n  • Képlete: I = Q / t (Áramerősség = Töltés / Idő)\n  • Mértékegysége: Amper (A)',
        'Elektromos feszültség (U): Két pont közötti potenciálkülönbség, amely az elektronokat mozgásra kényszeríti (a „meghajtó erő”).\n  • Mértékegysége: Volt (V)',
        'Elektromos ellenállás (R): Az anyagok azon tulajdonsága, amellyel akadályozzák az áram folyását. Függ az anyag fajtájától (fajlagos ellenállás: ρ), hosszától (l) és keresztmetszetétől (A).\n  • Képlete: R = ρ · (l / A)\n  • Mértékegysége: Ohm (Ω)',
      ],
    ),
    TopicSection(
      '3. fejezet: Alaptörvények az áramkörökben',
      'Az áramkörök méretezéséhez és megértéséhez szükséges legfontosabb szabályok.',
      [
        'Ohm törvénye: Egy vezető szakaszán átfolyó áram erőssége egyenesen arányos a vezető végein mérhető feszültséggel, és fordítottan arányos az ellenállással.\n  • Képlete: I = U / R  vagy  U = I · R',
        'Kirchhoff I. törvénye (Csomóponti törvény): Egy csomópontba befolyó áramok összege megegyezik az onnan kifolyó áramok összegével.',
        'Kirchhoff II. törvénye (Huroktörvény): Bármely zárt áramköri hurokban a feszültségek (forrásfeszültségek és feszültségesések) előjeles összege nulla.',
      ],
    ),
    TopicSection(
      '4. fejezet: Ellenállások kapcsolása',
      'Az alkatrészeket két alapvető módon kombinálhatjuk egy áramkörben:',
      [
        'SOROS KAPCSOLÁS (egymás után egy ágban):\n  • Áram: Minden ellenálláson ugyanaz az áram folyik át (I_össz = I₁ = I₂).\n  • Feszültség: A feszültségek összeadódnak (U_össz = U₁ + U₂).\n  • Eredő ellenállás: R_eredő = R₁ + R₂ + ...',
        'PÁRHUZAMOS KAPCSOLÁS (közös csomópontok):\n  • Áram: Az áramok megoszlanak, a részáramok összege adja a főág áramát (I_össz = I₁ + I₂).\n  • Feszültség: Minden ellenálláson ugyanakkora a feszültség (U_össz = U₁ = U₂).\n  • Eredő ellenállás: 1 / R_eredő = (1 / R₁) + (1 / R₂) + ...',
      ],
    ),
    TopicSection(
      '5. fejezet: Elektromos munka és teljesítmény',
      'Az elektromos áram energiát szállít, amit munkavégzésre használunk fel.',
      [
        'Elektromos teljesítmény (P): Az egységnyi idő alatt végzett munka.\n  • Képlete: P = U · I\n  • Mértékegysége: Watt (W)',
        'Elektromos munka (W): A teljesítmény és az idő szorzata.\n  • Képlete: W = P · t = U · I · t\n  • Mértékegysége: Joule (J) vagy a hétköznapokban a Kilowatthóra (kWh).',
      ],
    ),
    TopicSection(
      '6. fejezet: Egyenáram (DC) vs. Váltakozó áram (AC)',
      'Az áram két fő típusa a gyakorlatban:',
      [
        'Egyenáram (DC - Direct Current): A töltéshordozók állandóan egyazon irányba mozognak, az áram és feszültség értéke az időben állandó (pl. elemek, akkumulátorok).',
        'Váltakozó áram (AC - Alternating Current): Az áram iránya és nagysága periodikusan változik az időben. A hálózati áram (pl. az otthoni konnektorban) ilyen.',
        'Frekvencia (f): Másodpercenkénti rezgések száma. Európában ez 50 Hz (másodpercenként 50-szer vált irányt).',
      ],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Elméleti Alapok')),
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
                backgroundColor: Colors.indigo.withOpacity(0.15),
                child: Text('${index + 1}.', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.indigo)),
              ),
              title: Text(ch.title, style: TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text(ch.subtitle, maxLines: 2, overflow: TextOverflow.ellipsis),
              trailing: Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => TopicDetailScreen(section: ch, themeColor: Colors.indigo)),
                );
              },
            ),
          );
        },
      ),
    );
  }
}

// --- 2. KÉPLETGYŰJTEMÉNY MENÜ (1-7. KATEGÓRIA) ---
class FormulasMenuScreen extends StatelessWidget {
  final List<TopicSection> formulaCategories = [
    TopicSection(
      '1. Alapvető egyenáramú és ohmikus képletek',
      'Az egyfázisú, tiszta ellenállásos (pl. fűtőtest, izzólámpa) váltakozó áramú körökben is ugyanezek érvényesek.',
      [
        'Ohm törvénye:  U = I · R',
        'Áramerősség kiszámítása:  I = U / R',
        'Ellenállás kiszámítása:  R = U / I',
        'Elektromos teljesítmény:  P = U · I',
        'Teljesítmény az ellenállás és áram függvényében:  P = I² · R',
        'Teljesítmény a feszültség és ellenállás függvényében:  P = U² / R',
        'Elektromos munka (fogyasztás):  W = P · t\n(Ha P wattban, t másodpercben van = Joule; ha P kilowattban és t órában van = kWh)',
      ],
    ),
    TopicSection(
      '2. Vezetékek ellenállása és méretezése',
      'A vezeték anyaga (fajlagos ellenállása), hossza és keresztmetszete határozza meg a hálózati veszteséget.',
      [
        'Vezeték ellenállása:  R = ρ · (l / A)',
        'ρ (rhó) - Fajlagos ellenállás:\n  • Réz esetén: 0,0175 Ω·mm²/m\n  • Alumínium esetén: 0,028 Ω·mm²/m',
        'l - A vezeték hossza méterben:\n  • Figyelem! Egyfázisú körnél oda-vissza hosszal (a távolság 2-szeresével) kell számolni!',
        'A - A vezeték keresztmetszete mm²-ben.',
        'Keresztmetszet kiszámítása ellenállásból:  A = ρ · (l / R)',
      ],
    ),
    TopicSection(
      '3. Feszültségesés kiszámítása (Méretezéshez)',
      'A feszültségesés mértéke a névleges feszültséghez képest általában 1% - 3% között lehet.',
      [
        'Egyfázisú (230 V) hálózat feszültségesése voltban:\n  ΔU = (2 · l · I · ρ) / A',
        'Háromfázisú (400 V) hálózat feszültségesése voltban:\n  ΔU = (√3 · l · I · ρ · cosφ) / A',
        'Feszültségesés százalékban:\n  ε% = (ΔU / U_n) · 100\n  (Ahol U_n a hálózati feszültség: 230 V vagy 400 V)',
      ],
    ),
    TopicSection(
      '4. Váltakozó áramú (AC) hálózatok és teljesítmények',
      'Tekercsek (induktív) és kondenzátorok (kapacitív) esetén megjelenik a fáziseltolódás (cosφ).',
      [
        'Látszólagos teljesítmény (S):  S = U · I  [VA - Volt-Amper]',
        'Hatásos teljesítmény (P):  P = U · I · cosφ  [W - Watt]',
        'Meddő teljesítmény (Q):  Q = U · I · sinφ  [var - Volt-Amper-reaktív]',
        'Teljesítmény-háromszög:  S = √(P² + Q²)',
        'Teljesítménytényező:  cosφ = P / S',
      ],
    ),
    TopicSection(
      '5. Háromfázisú hálózatok képletei',
      'A fázisfeszültség (U_f = 230 V) és a vonali feszültség (U_v = 4
