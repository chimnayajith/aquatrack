import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AquaTrack',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const WaterUsageTabs(),
    );
  }
}

class WaterUsageTabs extends StatefulWidget {
  const WaterUsageTabs({super.key});

  @override
  _WaterUsageTabsState createState() => _WaterUsageTabsState();
}

class _WaterUsageTabsState extends State<WaterUsageTabs> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _litersController = TextEditingController();
  double _priority = 1;

  List<Map<String, dynamic>> _registeredPeople = [];
  int _selectedIndex = 0;

  @override
  void dispose() {
    _nameController.dispose();
    _litersController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState?.validate() ?? false) {
      final String name = _nameController.text;
      final int liters = int.tryParse(_litersController.text) ?? 0;

      setState(() {
        _registeredPeople.add({
          'name': name,
          'liters': liters,
          'priority': _priority.toInt(),
        });
      });

      _nameController.clear();
      _litersController.clear();
      _priority = 1;

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Form Submitted'),
            content: Text(
              'Name: $name\nWater Usage: $liters liters\nPriority: ${_priority.toInt()}',
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

  String _getPriorityDescription(int priority) {
    switch (priority) {
      case 10:
        return 'Top Priority';
      case 9:
        return 'Very High Priority';
      case 8:
        return 'High Priority';
      case 7:
        return 'Above Average Priority';
      case 6:
        return 'Moderate Priority';
      case 5:
        return 'Below Average Priority';
      case 4:
        return 'Low Priority';
      case 3:
        return 'Very Low Priority';
      case 2:
        return 'Minimal Priority';
      case 1:
        return 'Lowest Priority';
      default:
        return '';
    }
  }

  Widget _getTabContent(int index) {
    switch (index) {
      case 0:
        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  Center(
                    child: Image.asset(
                      'lib/assets/aquatrack.png',
                      height: 120,
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'AquaTrack',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.blueAccent,
                      fontFamily: 'Pacifico',
                    ),
                  ),
                  const SizedBox(height: 40),
                  TextFormField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      labelText: 'Enter your name',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(12)),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your name';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: _litersController,
                    decoration: const InputDecoration(
                      labelText: 'Enter water usage in liters',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(12)),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter the amount of water used';
                      }
                      final int? liters = int.tryParse(value);
                      if (liters == null || liters <= 0) {
                        return 'Please enter a valid positive number for liters';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  Column(
                    children: [
                      const Text(
                        'Priority:',
                        style: TextStyle(fontSize: 18),
                      ),
                      Slider(
                        value: _priority,
                        min: 1,
                        max: 10,
                        divisions: 9,
                        label: _getPriorityDescription(_priority.toInt()),
                        onChanged: (double value) {
                          setState(() {
                            _priority = value;
                          });
                        },
                        activeColor: _getSliderColor(_priority.toInt()),
                      ),
                      Text(
                        _getPriorityDescription(_priority.toInt()),
                        style: const TextStyle(fontSize: 16),
                      ),
                    ],
                  ),

                  const SizedBox(height: 40),
                  ElevatedButton(
                    onPressed: _submitForm,
                    child: const Text('Submit'),
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.blueAccent,
                      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      case 1:
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: ListView.builder(
            itemCount: _registeredPeople.length,
            itemBuilder: (context, index) {
              final person = _registeredPeople[index];
              return Card(
                margin: const EdgeInsets.symmetric(vertical: 8.0),
                child: ListTile(
                  title: Text(person['name']),
                  subtitle: Text(
                    'Water Usage: ${person['liters']} liters\nPriority: ${person['priority']}',
                  ),
                ),
              );
            },
          ),
        );
      default:
        return const Center(child: Text('Unknown Tab'));
    }
  }
Color _getSliderColor(int priority) {
  if (priority <= 3) {
    return Colors.green; // Low priority
  } else if (priority <= 6) {
    return Colors.orange; // Medium priority
  } else {
    return Colors.red; // High priority
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(''),
      ),
      body: _getTabContent(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.add),
            label: 'Register',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: 'View Registered',
          ),
        ],
      ),
    );
  }
}
