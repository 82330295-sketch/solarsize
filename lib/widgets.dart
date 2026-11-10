import 'package:flutter/material.dart';
import 'appliance.dart';
import 'solar_system.dart';

/* colors used in the app */
const Color sun = Color(0xFFF5A524);
const Color night = Color(0xFF0E2433);
const Color lightGrey = Color(0xFFF1F5F8);

/* a slider with a title, an icon and the value on the right */
class MySliderWidget extends StatefulWidget {
  final String title;
  final IconData icon;
  final double value;
  final double min;
  final double max;
  final int divisions;
  final Function(double) updateValue;

  const MySliderWidget({
    super.key,
    required this.title,
    required this.icon,
    required this.value,
    required this.min,
    required this.max,
    required this.divisions,
    required this.updateValue,
  });

  @override
  State<MySliderWidget> createState() => _MySliderWidgetState();
}

class _MySliderWidgetState extends State<MySliderWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Icon(widget.icon, color: sun),
            const SizedBox(width: 8.0),
            Text(widget.title,
                style: const TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold)),
            const Spacer(),
            Text('${widget.value} h',
                style: const TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold)),
          ],
        ),
        Slider(
          value: widget.value,
          min: widget.min,
          max: widget.max,
          divisions: widget.divisions,
          activeColor: sun,
          onChanged: (val) {
            setState(() {
              widget.updateValue(val);
            });
          },
        ),
      ],
    );
  }
}

/* checkbox to add the installation cost or not */
class InstallationWidget extends StatefulWidget {
  final bool value;
  final Function(bool) updateInstallation;

  const InstallationWidget(
      {super.key, required this.value, required this.updateInstallation});

  @override
  State<InstallationWidget> createState() => _InstallationWidgetState();
}

class _InstallationWidgetState extends State<InstallationWidget> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Checkbox(
          value: widget.value,
          activeColor: sun,
          onChanged: (val) {
            setState(() {
              widget.updateInstallation(val as bool);
            });
          },
        ),
        const Text('Include installation (+15%)',
            style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold)),
      ],
    );
  }
}

/* one appliance in the list, with - and + buttons */
class ApplianceTile extends StatelessWidget {
  final Appliance appliance;
  final Function(Appliance) increase;
  final Function(Appliance) decrease;
  final Function(Appliance) editHours;

  const ApplianceTile({
    super.key,
    required this.appliance,
    required this.increase,
    required this.decrease,
    required this.editHours,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(appliance.name,
            style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(appliance.toString()), // like: 150 W - 24 h/day
        onTap: () {
          editHours(appliance); // tap to change the hours per day
        },
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.remove_circle_outline),
              onPressed: () {
                decrease(appliance);
              },
            ),
            Text('${appliance.quantity}',
                style: const TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold)),
            IconButton(
              icon: const Icon(Icons.add_circle, color: sun),
              onPressed: () {
                increase(appliance);
              },
            ),
          ],
        ),
      ),
    );
  }
}

/* the dark card at the bottom with the results */
class ResultsCard extends StatelessWidget {
  final SolarSystem system;

  const ResultsCard({super.key, required this.system});

  /* one result: a big number and a small label under it */
  Widget result(String value, String label) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(value,
            style: const TextStyle(
                color: sun, fontSize: 28.0, fontWeight: FontWeight.bold)),
        Text(label, style: const TextStyle(color: Colors.white70)),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    String kwh = (system.getDailyEnergy() / 1000).toStringAsFixed(1);
    String kva = system.getInverter().toString().replaceAll('.0', ''); // 3.0 -> 3

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20.0),
      decoration: const BoxDecoration(
        color: night,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.0)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('YOUR SYSTEM - $kwh kWh per day',
              style: const TextStyle(color: Colors.white70, letterSpacing: 1.0)),
          const SizedBox(height: 16.0),
          Row(
            children: [
              Expanded(child: result('${system.getPanels()}', 'solar panels (550 W)')),
              Expanded(child: result('${system.getBatteries()}', 'batteries (2.56 kWh)')),
            ],
          ),
          const SizedBox(height: 12.0),
          Row(
            children: [
              Expanded(child: result('$kva kVA', 'inverter')),
              Expanded(child: result('\$${system.getCost()}', 'estimated cost')),
            ],
          ),
        ],
      ),
    );
  }
}

/* bottom sheet with the catalog, tap an appliance to add it */
void showAddSheet(BuildContext context, Function(Appliance) addAppliance) {
  showModalBottomSheet(
    context: context,
    builder: (context) {
      return ListView(
        children: [
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text('Add an appliance',
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold)),
          ),
          for (Appliance a in catalog)
            ListTile(
              title: Text(a.name),
              subtitle: Text(a.toString()),
              trailing: const Icon(Icons.add, color: sun),
              onTap: () {
                addAppliance(a);
                Navigator.pop(context); // close the sheet
              },
            ),
        ],
      );
    },
  );
}

/* dialog with a slider to change the hours per day of one appliance */
void showHoursDialog(BuildContext context, Appliance appliance,
    Function(Appliance, double) updateHours) {
  double hours = appliance.hours;
  showDialog(
    context: context,
    builder: (context) {
      // StatefulBuilder lets the slider move inside the dialog
      return StatefulBuilder(
        builder: (context, setDialogState) {
          return AlertDialog(
            title: Text('${appliance.name}: hours per day'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('$hours h',
                    style: const TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold)),
                Slider(
                  value: hours,
                  min: 0.5,
                  max: 24,
                  divisions: 47,
                  activeColor: sun,
                  onChanged: (val) {
                    setDialogState(() {
                      hours = val;
                    });
                  },
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Cancel'),
              ),
              FilledButton(
                onPressed: () {
                  updateHours(appliance, hours);
                  Navigator.pop(context);
                },
                child: const Text('Save'),
              ),
            ],
          );
        },
      );
    },
  );
}