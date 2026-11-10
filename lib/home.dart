import 'package:flutter/material.dart';

import 'appliance.dart';
import 'solar_system.dart';
import 'widgets.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  // the solar system holds the appliances, the sun hours and the backup hours
  SolarSystem system = SolarSystem(getStarterList());

  /*
  callback functions. They are passed to the widgets so the widgets can send the
  new values back to the home page. setState rebuilds the page, so the results
  are calculated again every time a value changes.
   */
  void updateSunHours(double hours) {
    setState(() {
      system.sunHours = hours;
    });
  }

  void updateBackupHours(double hours) {
    setState(() {
      system.backupHours = hours;
    });
  }

  void updateInstallation(bool value) {
    setState(() {
      system.installation = value;
    });
  }

  void updateHours(Appliance appliance, double hours) {
    setState(() {
      appliance.hours = hours;
    });
  }

  void addAppliance(Appliance item) {
    setState(() {
      // if the appliance is already in the list, we add one more unit
      for (Appliance a in system.appliances) {
        if (a.name == item.name) {
          a.quantity++;
          return;
        }
      }
      // we add a copy, so the item in the catalog does not change
      system.appliances.add(Appliance(item.name, item.watts, item.hours));
    });
  }

  void increase(Appliance appliance) {
    setState(() {
      appliance.quantity++;
    });
  }

  void decrease(Appliance appliance) {
    if (appliance.quantity > 1) {
      setState(() {
        appliance.quantity--;
      });
    } else {
      removeAppliance(
        appliance,
      ); // quantity is 1, so we remove it from the list
    }
  }

  void removeAppliance(Appliance appliance) {
    int index = system.appliances.indexOf(appliance);
    setState(() {
      system.appliances.removeAt(index);
    });
    // show a message at the bottom with an undo button
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${appliance.name} removed'),
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () {
            setState(() {
              system.appliances.insert(index, appliance);
            });
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        // the title and the sun icon are in a row, next to each other
        title: const Row(
          children: [
            Text(
              'SolarSize',
              style: TextStyle(fontWeight: FontWeight.bold, color: night),
            ),
            SizedBox(width: 8.0),
            Icon(Icons.wb_sunny, color: sun),
          ],
        ),
      ),
      body: SafeArea(
        // the list scrolls and the results card stays at the bottom
        child: Column(
          children: [
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(16.0, 4.0, 16.0, 16.0),
                children: [
                  // zone 1: sun hours and backup hours
                  Container(
                    padding: const EdgeInsets.fromLTRB(16.0, 12.0, 16.0, 4.0),
                    decoration: BoxDecoration(
                      color: lightGrey,
                      borderRadius: BorderRadius.circular(16.0),
                    ),
                    child: Column(
                      children: [
                        MySliderWidget(
                          label: 'Sun hours',
                          icon: Icons.wb_sunny_outlined,
                          value: system.sunHours,
                          min: 3,
                          max: 8,
                          divisions: 10,
                          updateValue: updateSunHours,
                        ),
                        MySliderWidget(
                          label: 'Backup at night',
                          icon: Icons.nightlight_outlined,
                          value: system.backupHours,
                          min: 0,
                          max: 14,
                          divisions: 14,
                          updateValue: updateBackupHours,
                        ),
                        InstallationWidget(
                          installation: system.installation,
                          updateInstallation: updateInstallation,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20.0),
                  // zone 2: the list of appliances
                  Row(
                    children: [
                      const Text(
                        'Appliances',
                        style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                          color: night,
                        ),
                      ),
                      const Spacer(),
                      FilledButton.icon(
                        onPressed: () {
                          showAddSheet(context, addAppliance);
                        },
                        icon: const Icon(Icons.add, size: 18.0),
                        label: const Text('Add'),
                        style: FilledButton.styleFrom(
                          backgroundColor: sun,
                          foregroundColor: night,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8.0),
                  if (system.appliances.isEmpty)
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 32.0),
                      child: Text(
                        'No appliances yet.\nTap Add to choose what you use at home.',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: grey),
                      ),
                    ),
                  // one tile for each appliance in the list
                  for (Appliance a in system.appliances)
                    ApplianceTile(
                      key: ObjectKey(a),
                      appliance: a,
                      increase: increase,
                      decrease: decrease,
                      updateHours: updateHours,
                    ),
                ],
              ),
            ),
            // zone 3: the results
            ResultsCard(system: system),
          ],
        ),
      ),
    );
  }
}
