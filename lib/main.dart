// lib/main.dart
// QPLC Layer Tayabas - simple prototype (single-file)
// Paste this into lib/main.dart and run: flutter clean && flutter pub get && flutter run

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const QplcApp());
}

class QplcApp extends StatelessWidget {
  const QplcApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'QPLC Layer Tayabas - Logbook',
      theme: ThemeData(
        primarySwatch: Colors.green,
        brightness: Brightness.light,
      ),
      home: const LoginPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

// ---------- Simple in-memory data models (for prototype) ----------
class Staff {
  int id;
  String name;
  String position;
  Staff({required this.id, required this.name, this.position = ''});
}

class Batch {
  int id;
  String code;
  String status; // Active, Completed, Inactive
  int numberOfBirds;
  Batch({
    required this.id,
    required this.code,
    this.status = 'Active',
    this.numberOfBirds = 0,
  });
}

// Attendance Model
class Attendance {
  int id;
  int staffId;
  String staffName;
  DateTime date;
  TimeOfDay? timeIn;
  TimeOfDay? timeOut;
  String status; // Present, Absent, Late, Early Leave
  String? notes;
  
  Attendance({
    required this.id,
    required this.staffId,
    required this.staffName,
    required this.date,
    this.timeIn,
    this.timeOut,
    this.status = 'Absent',
    this.notes,
  });
}

// Minimal sample data
final List<Staff> sampleStaff = [
  Staff(id: 1, name: 'Juan Dela Cruz', position: 'Worker'),
  Staff(id: 2, name: 'Maria Santos', position: 'Supervisor'),
  Staff(id: 3, name: 'Pedro Rodriguez', position: 'Worker'),
];

final List<Batch> sampleBatches = [
  Batch(id: 1, code: 'BATCH-001', status: 'Active', numberOfBirds: 1200),
  Batch(id: 2, code: 'BATCH-002', status: 'Completed', numberOfBirds: 900),
];

// Attendance data
final List<Attendance> attendanceRecords = [
  Attendance(
    id: 1,
    staffId: 1,
    staffName: 'Juan Dela Cruz',
    date: DateTime.now(),
    timeIn: const TimeOfDay(hour: 7, minute: 30),
    timeOut: const TimeOfDay(hour: 17, minute: 0),
    status: 'Present',
  ),
  Attendance(
    id: 2,
    staffId: 2,
    staffName: 'Maria Santos',
    date: DateTime.now(),
    timeIn: const TimeOfDay(hour: 8, minute: 15),
    timeOut: null,
    status: 'Late',
  ),
  Attendance(
    id: 3,
    staffId: 3,
    staffName: 'Pedro Rodriguez',
    date: DateTime.now(),
    timeIn: null,
    timeOut: null,
    status: 'Absent',
  ),
];

// Simple "records" placeholders
final List<Map<String, dynamic>> sampleProduction = [
  {'date': DateTime.now(), 'batch': 'BATCH-001', 'eggs': 1100},
  {'date': DateTime.now().subtract(const Duration(days: 1)), 'batch': 'BATCH-001', 'eggs': 1050},
];

// ---------- Login page ----------
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _usernameCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  bool _loading = false;
  String? _error;

  void _doLogin() async {
    FocusScope.of(context).unfocus();
    if (!_formKey.currentState!.validate()) return;
    setState(() {
      _loading = true;
      _error = null;
    });
    // Simple prototype auth: accept username 'admin' and password 'password'
    await Future.delayed(const Duration(milliseconds: 600));
    if (_usernameCtrl.text.trim() == 'admin' && _passwordCtrl.text == 'password') {
      if (!mounted) return;
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => const HomeShell()));
    } else {
      setState(() {
        _error = 'Invalid username or password (try admin / password)';
        _loading = false;
      });
    }
  }

  @override
  void dispose() {
    _usernameCtrl.dispose();
    _passwordCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final cardWidth = width > 600 ? 480.0 : double.infinity;
    return Scaffold(
      body: Center(
        child: Card(
          elevation: 8,
          child: SizedBox(
            width: cardWidth,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Form(
                key: _formKey,
                child: Column(mainAxisSize: MainAxisSize.min, children: [
                  const Text('QPLC Layer Tayabas', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  const Text('Digital Farming Logbook - Prototype', style: TextStyle(color: Colors.grey)),
                  const SizedBox(height: 18),
                  TextFormField(
                    controller: _usernameCtrl,
                    decoration: const InputDecoration(labelText: 'Username'),
                    validator: (v) => (v == null || v.trim().isEmpty) ? 'Enter username' : null,
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: _passwordCtrl,
                    decoration: const InputDecoration(labelText: 'Password'),
                    obscureText: true,
                    validator: (v) => (v == null || v.isEmpty) ? 'Enter password' : null,
                    onFieldSubmitted: (_) => _doLogin(),
                  ),
                  const SizedBox(height: 12),
                  if (_error != null) Text(_error!, style: const TextStyle(color: Colors.red)),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: _loading ? null : _doLogin,
                    child: _loading
                        ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2))
                        : const Text('Login'),
                  ),
                  const SizedBox(height: 8),
                  const Text('Test credentials: admin / password', style: TextStyle(color: Colors.grey, fontSize: 12)),
                ]),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ---------- Shell with sidebar / drawer + routing ----------
class HomeShell extends StatefulWidget {
  const HomeShell({super.key});
  @override
  State<HomeShell> createState() => _HomeShellState();
}

enum AppSection {
  dashboard,
  attendance,
  batches,
  production,
  feed,
  mortality,
  reports,
}

class _HomeShellState extends State<HomeShell> {
  AppSection _current = AppSection.dashboard;

  void _navigate(AppSection s) {
    setState(() => _current = s);
    if (kIsWeb) {
      // Optionally update URL
    }
  }

  Widget _buildBody() {
    switch (_current) {
      case AppSection.dashboard:
        return DashboardPage(onNavigate: (s) => _navigate(s));
      case AppSection.attendance:
        return const AttendanceListPage();
      case AppSection.batches:
        return const PlaceholderPage(title: 'Flock / Batch Records');
      case AppSection.production:
        return const PlaceholderPage(title: 'Daily Production');
      case AppSection.feed:
        return const PlaceholderPage(title: 'Feed Monitoring');
      case AppSection.mortality:
        return const PlaceholderPage(title: 'Mortality Records');
      case AppSection.reports:
        return const PlaceholderPage(title: 'Reports');
    }
  }

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.of(context).size.width >= 800;
    final side = NavigationRail(
      selectedIndex: AppSection.values.indexOf(_current),
      onDestinationSelected: (i) => _navigate(AppSection.values[i]),
      labelType: isWide ? NavigationRailLabelType.all : NavigationRailLabelType.selected,
      extended: isWide,
      leading: Column(
        children: [
          const SizedBox(height: 8),
          CircleAvatar(child: const Text('Q'), backgroundColor: Colors.green.shade700),
          const SizedBox(height: 8),
        ],
      ),
      destinations: const [
        NavigationRailDestination(icon: Icon(Icons.dashboard), label: Text('Dashboard')),
        NavigationRailDestination(icon: Icon(Icons.person), label: Text('Attendance')),
        NavigationRailDestination(icon: Icon(Icons.layers), label: Text('Batches')),
        NavigationRailDestination(icon: Icon(Icons.egg), label: Text('Production')),
        NavigationRailDestination(icon: Icon(Icons.fastfood), label: Text('Feed')),
        NavigationRailDestination(icon: Icon(Icons.warning), label: Text('Mortality')),
        NavigationRailDestination(icon: Icon(Icons.table_chart), label: Text('Reports')),
      ],
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('QPLC Layer Tayabas — Logbook'),
        actions: [
          IconButton(
            onPressed: () {
              // simple logout
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (_) => const LoginPage()),
                    (r) => false,
              );
            },
            icon: const Icon(Icons.logout),
            tooltip: 'Logout',
          )
        ],
      ),
      body: Row(
        children: [
          if (isWide) side,
          Expanded(child: _buildBody()),
        ],
      ),
      drawer: isWide
          ? null
          : Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
          const DrawerHeader(child: Text('QPLC Layer Tayabas')),
            ListTile(
                title: const Text('Dashboard'),
                leading: const Icon(Icons.dashboard),
                onTap: () {
                  Navigator.pop(context);
                  _navigate(AppSection.dashboard);
                }),
            ListTile(
                title: const Text('Attendance'),
                leading: const Icon(Icons.person),
                onTap: () {
                  Navigator.pop(context);
                  _navigate(AppSection.attendance);
                }),
            ListTile(
                title: const Text('Batches'),
                leading: const Icon(Icons.layers),
                onTap: () {
                  Navigator.pop(context);
                  _navigate(AppSection.batches);
                }),
            ListTile(
                title: const Text('Production'),
                leading: const Icon(Icons.egg),
                onTap: () {
                  Navigator.pop(context);
                  _navigate(AppSection.production);
                }),
            ListTile(
                title: const Text('Feed'),
                leading: const Icon(Icons.fastfood),
                onTap: () {
                  Navigator.pop(context);
                  _navigate(AppSection.feed);
                }),
            ListTile(
                title: const Text('Mortality'),
                leading: const Icon(Icons.warning),
                onTap: () {
                  Navigator.pop(context);
                  _navigate(AppSection.mortality);
                }),
            ListTile(
                title: const Text('Reports'),
                leading: const Icon(Icons.table_chart),
                onTap: () {
                  Navigator.pop(context);
                  _navigate(AppSection.reports);
                }),
          ],
        ),
      ),
    );
  }
}

// ---------- Dashboard Page (summary cards + recent activities) ----------
class DashboardPage extends StatelessWidget {
  final void Function(AppSection) onNavigate;
  const DashboardPage({super.key, required this.onNavigate});

  int get totalStaff => sampleStaff.length;
  int get presentToday => attendanceRecords.where((a) => a.status == 'Present').length;
  int get activeBatches => sampleBatches.where((b) => b.status == 'Active').length;
  int get eggsToday => sampleProduction.fold<int>(0, (p, e) {
    final dt = e['date'] as DateTime;
    if (dt.day == DateTime.now().day && dt.month == DateTime.now().month && dt.year == DateTime.now().year) {
      return p + (e['eggs'] as int);
    }
    return p;
  });
  int get mortalityToday => 0; // sample
  double get feedUsedToday => 0; // sample

  @override
  Widget build(BuildContext context) {
    final cards = [
      _SummaryCard(title: 'Total Staff', value: '$totalStaff', color: Colors.green),
      _SummaryCard(title: 'Present Today', value: '$presentToday', color: Colors.blue),
      _SummaryCard(title: 'Active Batches', value: '$activeBatches', color: Colors.orange),
      _SummaryCard(title: 'Eggs Today', value: '$eggsToday', color: Colors.brown),
      _SummaryCard(title: 'Mortality Today', value: '$mortalityToday', color: Colors.red),
      _SummaryCard(title: 'Feed Used Today (kg)', value: '$feedUsedToday', color: Colors.teal),
    ];

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(children: [
        // Quick action buttons
        Row(
          children: [
            ElevatedButton.icon(
                onPressed: () => onNavigate(AppSection.attendance), icon: const Icon(Icons.person_add), label: const Text('Add Attendance')),
            const SizedBox(width: 8),
            ElevatedButton.icon(onPressed: () => onNavigate(AppSection.production), icon: const Icon(Icons.add), label: const Text('Add Production')),
            const Spacer(),
            const Text('Dashboard', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold))
          ],
        ),
        const SizedBox(height: 14),
        // summary grid
        LayoutBuilder(builder: (context, constraints) {
          final cols = constraints.maxWidth > 1000 ? 3 : (constraints.maxWidth > 600 ? 2 : 1);
          return GridView.count(
            crossAxisCount: cols,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            childAspectRatio: 3.2,
            children: cards,
          );
        }),
        const SizedBox(height: 18),
        Row(
          children: const [Text('Recent Activity', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold))],
        ),
        const SizedBox(height: 8),
        Expanded(
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: ListView.builder(
                itemCount: sampleProduction.length,
                itemBuilder: (ctx, i) {
                  final item = sampleProduction[i];
                  final dt = item['date'] as DateTime;
                  return ListTile(
                    leading: const Icon(Icons.egg),
                    title: Text('Production - ${item['batch']}'),
                    subtitle: Text('${item['eggs']} eggs • ${dt.toLocal().toString().split('.').first}'),
                    trailing: TextButton(onPressed: () {}, child: const Text('View')),
                  );
                },
              ),
            ),
          ),
        )
      ]),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  final String title;
  final String value;
  final Color color;
  const _SummaryCard({required this.title, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Row(children: [
          CircleAvatar(backgroundColor: color, child: Text(value, style: const TextStyle(color: Colors.white))),
          const SizedBox(width: 12),
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(title, style: const TextStyle(fontWeight: FontWeight.bold)), const SizedBox(height: 6), const SizedBox.shrink()]),
          const Spacer(),
          Text(value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        ]),
      ),
    );
  }
}

// ---------- ATTENDANCE CRUD PAGES ----------

// Attendance List Page
class AttendanceListPage extends StatefulWidget {
  const AttendanceListPage({super.key});

  @override
  State<AttendanceListPage> createState() => _AttendanceListPageState();
}

class _AttendanceListPageState extends State<AttendanceListPage> {
  DateTime _selectedDate = DateTime.now();
  String _filterStatus = 'All';

  List<Attendance> get _filteredAttendance {
    return attendanceRecords.where((a) {
      final isSameDate = a.date.year == _selectedDate.year &&
          a.date.month == _selectedDate.month &&
          a.date.day == _selectedDate.day;
      final matchesStatus = _filterStatus == 'All' || a.status == _filterStatus;
      return isSameDate && matchesStatus;
    }).toList();
  }

  void _deleteAttendance(int id) {
    setState(() {
      attendanceRecords.removeWhere((a) => a.id == id);
    });
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Attendance deleted')));
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Staff Attendance', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const AddAttendancePage()),
                  ).then((_) => setState(() {}));
                },
                icon: const Icon(Icons.add),
                label: const Text('Add Attendance'),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Filters
          Row(
            children: [
              Expanded(
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    child: Row(
                      children: [
                        const Icon(Icons.calendar_today, size: 20),
                        const SizedBox(width: 8),
                        Expanded(
                          child: InkWell(
                            onTap: () async {
                              final date = await showDatePicker(
                                context: context,
                                initialDate: _selectedDate,
                                firstDate: DateTime(2020),
                                lastDate: DateTime.now(),
                              );
                              if (date != null) {
                                setState(() => _selectedDate = date);
                              }
                            },
                            child: Text(
                              '${_selectedDate.year}-${_selectedDate.month.toString().padLeft(2, '0')}-${_selectedDate.day.toString().padLeft(2, '0')}',
                              style: const TextStyle(fontSize: 14),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              DropdownButton<String>(
                value: _filterStatus,
                items: ['All', 'Present', 'Absent', 'Late', 'Early Leave']
                    .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                    .toList(),
                onChanged: (v) {
                  if (v != null) {
                    setState(() => _filterStatus = v);
                  }
                },
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Attendance List
          Expanded(
            child: _filteredAttendance.isEmpty
                ? const Center(child: Text('No records found'))
                : ListView.builder(
                    itemCount: _filteredAttendance.length,
                    itemBuilder: (ctx, i) {
                      final record = _filteredAttendance[i];
                      final statusColor = record.status == 'Present'
                          ? Colors.green
                          : record.status == 'Absent'
                              ? Colors.red
                              : record.status == 'Late'
                                  ? Colors.orange
                                  : Colors.blue;

                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: statusColor,
                            child: Text(record.staffName[0], style: const TextStyle(color: Colors.white)),
                          ),
                          title: Text(record.staffName, style: const TextStyle(fontWeight: FontWeight.bold)),
                          subtitle: Text(
                            'In: ${record.timeIn?.format(ctx) ?? 'N/A'} | Out: ${record.timeOut?.format(ctx) ?? 'N/A'}',
                          ),
                          trailing: PopupMenuButton(
                            itemBuilder: (ctx) => [
                              PopupMenuItem(
                                child: const Text('Edit'),
                                onTap: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (_) => EditAttendancePage(attendance: record),
                                    ),
                                  ).then((_) => setState(() {}));
                                },
                              ),
                              PopupMenuItem(
                                child: const Text('Delete', style: TextStyle(color: Colors.red)),
                                onTap: () => _deleteAttendance(record.id),
                              ),
                            ],
                          ),
                          isThreeLine: true,
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

// Add Attendance Page
class AddAttendancePage extends StatefulWidget {
  const AddAttendancePage({super.key});

  @override
  State<AddAttendancePage> createState() => _AddAttendancePageState();
}

class _AddAttendancePageState extends State<AddAttendancePage> {
  final _formKey = GlobalKey<FormState>();
  int? _selectedStaffId;
  TimeOfDay? _timeIn;
  TimeOfDay? _timeOut;
  String _status = 'Present';
  final _notesCtrl = TextEditingController();

  void _saveAttendance() {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedStaffId == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please select a staff member')));
      return;
    }

    final staff = sampleStaff.firstWhere((s) => s.id == _selectedStaffId);
    final newAttendance = Attendance(
      id: attendanceRecords.length + 1,
      staffId: _selectedStaffId!,
      staffName: staff.name,
      date: DateTime.now(),
      timeIn: _timeIn,
      timeOut: _timeOut,
      status: _status,
      notes: _notesCtrl.text.isEmpty ? null : _notesCtrl.text,
    );

    attendanceRecords.add(newAttendance);
    Navigator.of(context).pop();
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Attendance added successfully')));
  }

  @override
  void dispose() {
    _notesCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Attendance')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // Staff Selection
              DropdownButtonFormField<int>(
                value: _selectedStaffId,
                decoration: const InputDecoration(labelText: 'Select Staff Member'),
                items: sampleStaff
                    .map((s) => DropdownMenuItem(value: s.id, child: Text(s.name)))
                    .toList(),
                onChanged: (v) => setState(() => _selectedStaffId = v),
                validator: (v) => v == null ? 'Select a staff member' : null,
              ),
              const SizedBox(height: 16),

              // Time In
              ListTile(
                title: const Text('Time In'),
                trailing: Text(_timeIn?.format(context) ?? 'Select'),
                onTap: () async {
                  final time = await showTimePicker(context: context, initialTime: TimeOfDay.now());
                  if (time != null) setState(() => _timeIn = time);
                },
              ),
              const SizedBox(height: 16),

              // Time Out
              ListTile(
                title: const Text('Time Out'),
                trailing: Text(_timeOut?.format(context) ?? 'Select'),
                onTap: () async {
                  final time = await showTimePicker(context: context, initialTime: TimeOfDay.now());
                  if (time != null) setState(() => _timeOut = time);
                },
              ),
              const SizedBox(height: 16),

              // Status
              DropdownButtonFormField<String>(
                value: _status,
                decoration: const InputDecoration(labelText: 'Status'),
                items: ['Present', 'Absent', 'Late', 'Early Leave']
                    .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                    .toList(),
                onChanged: (v) => setState(() => _status = v ?? 'Present'),
              ),
              const SizedBox(height: 16),

              // Notes
              TextFormField(
                controller: _notesCtrl,
                decoration: const InputDecoration(labelText: 'Notes'),
                maxLines: 3,
              ),
              const SizedBox(height: 24),

              // Save Button
              ElevatedButton(
                onPressed: _saveAttendance,
                child: const Text('Save Attendance'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Edit Attendance Page
class EditAttendancePage extends StatefulWidget {
  final Attendance attendance;
  const EditAttendancePage({super.key, required this.attendance});

  @override
  State<EditAttendancePage> createState() => _EditAttendancePageState();
}

class _EditAttendancePageState extends State<EditAttendancePage> {
  final _formKey = GlobalKey<FormState>();
  late TimeOfDay? _timeIn;
  late TimeOfDay? _timeOut;
  late String _status;
  late TextEditingController _notesCtrl;

  @override
  void initState() {
    super.initState();
    _timeIn = widget.attendance.timeIn;
    _timeOut = widget.attendance.timeOut;
    _status = widget.attendance.status;
    _notesCtrl = TextEditingController(text: widget.attendance.notes);
  }

  void _updateAttendance() {
    if (!_formKey.currentState!.validate()) return;

    final index = attendanceRecords.indexWhere((a) => a.id == widget.attendance.id);
    if (index != -1) {
      attendanceRecords[index].timeIn = _timeIn;
      attendanceRecords[index].timeOut = _timeOut;
      attendanceRecords[index].status = _status;
      attendanceRecords[index].notes = _notesCtrl.text.isEmpty ? null : _notesCtrl.text;
    }

    Navigator.of(context).pop();
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Attendance updated successfully')));
  }

  @override
  void dispose() {
    _notesCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Attendance')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // Staff Name (Read-only)
              TextFormField(
                initialValue: widget.attendance.staffName,
                enabled: false,
                decoration: const InputDecoration(labelText: 'Staff Member'),
              ),
              const SizedBox(height: 16),

              // Time In
              ListTile(
                title: const Text('Time In'),
                trailing: Text(_timeIn?.format(context) ?? 'Select'),
                onTap: () async {
                  final time = await showTimePicker(context: context, initialTime: _timeIn ?? TimeOfDay.now());
                  if (time != null) setState(() => _timeIn = time);
                },
              ),
              const SizedBox(height: 16),

              // Time Out
              ListTile(
                title: const Text('Time Out'),
                trailing: Text(_timeOut?.format(context) ?? 'Select'),
                onTap: () async {
                  final time = await showTimePicker(context: context, initialTime: _timeOut ?? TimeOfDay.now());
                  if (time != null) setState(() => _timeOut = time);
                },
              ),
              const SizedBox(height: 16),

              // Status
              DropdownButtonFormField<String>(
                value: _status,
                decoration: const InputDecoration(labelText: 'Status'),
                items: ['Present', 'Absent', 'Late', 'Early Leave']
                    .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                    .toList(),
                onChanged: (v) => setState(() => _status = v ?? 'Present'),
              ),
              const SizedBox(height: 16),

              // Notes
              TextFormField(
                controller: _notesCtrl,
                decoration: const InputDecoration(labelText: 'Notes'),
                maxLines: 3,
              ),
              const SizedBox(height: 24),

              // Update Button
              ElevatedButton(
                onPressed: _updateAttendance,
                child: const Text('Update Attendance'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ---------- Placeholder pages (for modules) ----------
class PlaceholderPage extends StatelessWidget {
  final String title;
  const PlaceholderPage({super.key, required this.title});
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        elevation: 6,
        margin: const EdgeInsets.all(24),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            Text(title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            const Text('Module UI placeholder — implement CRUD forms and lists here.'),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () => showDialog(context: context, builder: (_) => AlertDialog(title: const Text('Next step'), content: Text('Implement CRUD for $title'))),
              child: const Text('Plan CRUD'),
            ),
          ]),
        ),
      ),
    );
  }
}
