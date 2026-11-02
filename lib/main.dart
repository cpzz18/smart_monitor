import 'package:flutter/material.dart';

void main() => runApp(const SmartMonitorApp());

class _Palette {
  final Color bg, card, border, accent, accentSubtle, text, muted, green, greenBg, amber, amberBg;
  const _Palette({
    required this.bg, required this.card, required this.border, required this.accent,
    required this.accentSubtle, required this.text, required this.muted, required this.green,
    required this.greenBg, required this.amber, required this.amberBg,
  });

  static const light = _Palette(
    bg: Color(0xFFF7F8F9), card: Color(0xFFFFFFFF), border: Color(0xFFE5E7EB),
    accent: Color(0xFF0F766E), accentSubtle: Color(0xFFE6F4F2), text: Color(0xFF111827),
    muted: Color(0xFF6B7280), green: Color(0xFF059669), greenBg: Color(0xFFECFDF5),
    amber: Color(0xFFD97706), amberBg: Color(0xFFFEF3C7),
  );

  static const dark = _Palette(
    bg: Color(0xFF0F1115), card: Color(0xFF16191E), border: Color(0xFF262B33),
    accent: Color(0xFF2DD4BF), accentSubtle: Color(0xFF132D2B), text: Color(0xFFF3F4F6),
    muted: Color(0xFF9CA3AF), green: Color(0xFF34D399), greenBg: Color(0xFF064E3B),
    amber: Color(0xFFFBBF24), amberBg: Color(0xFF451A03),
  );

  static _Palette of(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark ? dark : light;
}

class SmartMonitorApp extends StatelessWidget {
  const SmartMonitorApp({super.key});

  ThemeData _theme(Brightness b) {
    final p = b == Brightness.dark ? _Palette.dark : _Palette.light;
    return ThemeData(
      useMaterial3: true,
      brightness: b,
      scaffoldBackgroundColor: p.bg,
      colorScheme: ColorScheme.fromSeed(seedColor: p.accent, brightness: b),
      cardTheme: CardThemeData(
        color: p.card,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: p.border),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Smart Monitor',
      theme: _theme(Brightness.light),
      darkTheme: _theme(Brightness.dark),
      themeMode: ThemeMode.system,
      home: const DashboardScreen(),
    );
  }
}

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final double _temp = 28.5;
  final double _humidity = 70.0;
  final bool _isConnected = true;
  bool _isLedOn = false;
  DateTime _lastUpdated = DateTime.now();

  void _toggleLed(bool val) => setState(() {
        _isLedOn = val;
        _lastUpdated = DateTime.now();
      });

  void _refresh() => setState(() => _lastUpdated = DateTime.now());

  @override
  Widget build(BuildContext context) {
    final p = _Palette.of(context);

    return Scaffold(
      backgroundColor: p.bg,
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600),
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildHeader(p),
                  const SizedBox(height: 20),
                  _buildHeroTempCard(p),
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      Expanded(child: _buildHumidityCard(p)),
                      const SizedBox(width: 14),
                      Expanded(child: _buildLedCard(p)),
                    ],
                  ),
                  const SizedBox(height: 24),
                  _buildFooter(p),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(_Palette p) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('SMART MONITOR',
                style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, letterSpacing: 1.2, color: p.accent)),
            const SizedBox(height: 4),
            Text('Dashboard Lingkungan',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700, letterSpacing: -0.3, color: p.text)),
          ],
        ),
        InkWell(
          onTap: _refresh,
          borderRadius: BorderRadius.circular(20),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: _isConnected ? p.greenBg : p.card,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: _isConnected ? p.green.withValues(alpha: 0.3) : p.border),
            ),
            child: Row(
              children: [
                Container(width: 7, height: 7, decoration: BoxDecoration(shape: BoxShape.circle, color: _isConnected ? p.green : p.muted)),
                const SizedBox(width: 7),
                Text(_isConnected ? 'Terhubung' : 'Terputus',
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: _isConnected ? p.green : p.muted)),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHeroTempCard(_Palette p) {
    final status = _temp < 22 ? 'Sejuk' : (_temp <= 29 ? 'Optimal' : 'Hangat');
    final ratio = ((_temp - 15) / 25).clamp(0.0, 1.0);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    _iconBox(Icons.device_thermostat_rounded, p.accent, p.accentSubtle),
                    const SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _cardLabel('SUHU RUANGAN', p.muted),
                        Text('DHT22 / Termal', style: TextStyle(fontSize: 12, color: p.muted)),
                      ],
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
                  decoration: BoxDecoration(color: p.accentSubtle, borderRadius: BorderRadius.circular(6)),
                  child: Text(status, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: p.accent)),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                Text(
                  _temp.toStringAsFixed(1),
                  style: TextStyle(
                    fontSize: 48, fontWeight: FontWeight.w300, letterSpacing: -1.0,
                    fontFeatures: const [FontFeature.tabularFigures()], color: p.text,
                  ),
                ),
                const SizedBox(width: 6),
                Text('°C', style: TextStyle(fontSize: 20, color: p.muted)),
              ],
            ),
            const SizedBox(height: 16),
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: ratio, minHeight: 5, backgroundColor: p.border,
                valueColor: AlwaysStoppedAnimation<Color>(p.accent),
              ),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Sejuk (15°C)', style: TextStyle(fontSize: 11, color: p.muted)),
                Text('Hangat (40°C)', style: TextStyle(fontSize: 11, color: p.muted)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHumidityCard(_Palette p) {
    final status = _humidity < 50 ? 'Kering' : (_humidity <= 70 ? 'Nyaman' : 'Lembap');

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _iconBox(Icons.water_drop_outlined, p.accent, p.accentSubtle),
                Text(status, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: p.accent)),
              ],
            ),
            const SizedBox(height: 16),
            _cardLabel('KELEMBAPAN', p.muted),
            const SizedBox(height: 4),
            Row(
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                Text(
                  _humidity.toStringAsFixed(0),
                  style: TextStyle(
                    fontSize: 32, fontWeight: FontWeight.w400, letterSpacing: -0.5,
                    fontFeatures: const [FontFeature.tabularFigures()], color: p.text,
                  ),
                ),
                const SizedBox(width: 4),
                Text('%', style: TextStyle(fontSize: 16, color: p.muted)),
              ],
            ),
            const SizedBox(height: 10),
            Text('Ideal: 50% - 70%', style: TextStyle(fontSize: 11, color: p.muted)),
          ],
        ),
      ),
    );
  }

  Widget _buildLedCard(_Palette p) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _iconBox(
                  _isLedOn ? Icons.lightbulb_rounded : Icons.lightbulb_outline_rounded,
                  _isLedOn ? p.amber : p.muted,
                  _isLedOn ? p.amberBg : p.bg,
                ),
                Semantics(
                  label: 'Saklar Lampu LED',
                  child: Transform.scale(
                    scale: 0.82,
                    alignment: Alignment.centerRight,
                    child: Switch(
                      value: _isLedOn,
                      onChanged: _toggleLed,
                      activeThumbColor: p.accent,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _cardLabel('LAMPU LED', p.muted),
            const SizedBox(height: 4),
            Text(
              _isLedOn ? 'Menyala' : 'Mati',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: _isLedOn ? p.text : p.muted),
            ),
            const SizedBox(height: 10),
            Text(
              _isLedOn ? 'Aktif (Pin GPIO 2)' : 'Siap dikontrol',
              style: TextStyle(fontSize: 11, color: p.muted),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFooter(_Palette p) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final time = '${twoDigits(_lastUpdated.hour)}:${twoDigits(_lastUpdated.minute)}:${twoDigits(_lastUpdated.second)}';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: p.card,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: p.border),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(Icons.memory_rounded, size: 16, color: p.muted),
              const SizedBox(width: 8),
              Text('Node: ESP32-WROOM', style: TextStyle(fontSize: 12, fontFamily: 'monospace', color: p.text)),
            ],
          ),
          Row(
            children: [
              Icon(Icons.schedule_rounded, size: 14, color: p.muted),
              const SizedBox(width: 6),
              Text('Sync: $time',
                  style: TextStyle(fontSize: 11, fontFeatures: const [FontFeature.tabularFigures()], color: p.muted)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _iconBox(IconData icon, Color fg, Color bg) => Container(
        width: 36, height: 36,
        decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(8)),
        child: Icon(icon, size: 18, color: fg),
      );

  Widget _cardLabel(String text, Color color) => Text(
        text,
        style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, letterSpacing: 0.8, color: color),
      );
}
