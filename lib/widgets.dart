import 'package:flutter/material.dart';

import 'appliance.dart';
import 'solar_system.dart';

// colors used in the application
const Color night = Color(0xFF0E2433);
const Color sun = Color(0xFFF5A524);
const Color darkOrange = Color(0xFFA35C00);
const Color lightGrey = Color(0xFFF1F5F8);
const Color borderGrey = Color(0xFFD5DDE3);
const Color grey = Color(0xFF55636E);
const Color paleBlue = Color(0xFFC9D6E0);

class MySliderWidget extends StatefulWidget {
  /*
  class to represent a slider with a label, used for the sun hours, the backup
  hours and the hours per day of an appliance.
  It includes a callback method called updateValue, to return the new value to
  the page that uses it.
   */
  const MySliderWidget({
    required this.label,
    required this.icon,
    required this.value,
    required this.min,
    required this.max,
    required this.divisions,
    required this.updateValue,
    super.key,
  });
  final String label;
  final IconData icon;
  final double value;
  final double min;
  final double max;
  final int divisions;
  final Function(double) updateValue;

  @override
  State<MySliderWidget> createState() => _MySliderWidgetState();
}

class _MySliderWidgetState extends State<MySliderWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(widget.icon, size: 18.0, color: darkOrange),
            const SizedBox(width: 8.0),
            Text(
              widget.label,
              style: const TextStyle(fontWeight: FontWeight.w600, color: night),
            ),
            const Spacer(),
            Text(
              formatHours(widget.value),
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: darkOrange,
              ),
            ),
          ],
        ),
        Slider(
          value: widget.value,
          min: widget.min,
          max: widget.max,
          divisions: widget.divisions, // the slider moves in steps
          label: formatHours(widget.value),
          activeColor: sun,
          inactiveColor: borderGrey,
          onChanged: (val) {
            setState(() {
              widget.updateValue(
                val,
              ); // use widget to access widget fields from state class
            });
          },
        ),
      ],
    );
  }
}

class InstallationWidget extends StatefulWidget {
  /*
  class to represent a checkbox to add the installation cost (+15%) or not.
  It includes a callback method called updateInstallation, to return the new
  value to the home page.
   */
  const InstallationWidget({
    required this.installation,
    required this.updateInstallation,
    super.key,
  });
  final bool installation;
  final Function(bool) updateInstallation;

  @override
  State<InstallationWidget> createState() => _InstallationWidgetState();
}

class _InstallationWidgetState extends State<InstallationWidget> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Checkbox(
          value: widget.installation,
          activeColor: sun,
          checkColor: night,
          onChanged: (val) {
            setState(() {
              widget.updateInstallation(
                val as bool,
              ); // val is bool? so we cast it
            });
          },
        ),
        const Text(
          'Include installation (+15%)',
          style: TextStyle(fontWeight: FontWeight.w600, color: night),
        ),
      ],
    );
  }
}

class ApplianceTile extends StatelessWidget {
  /*
  class to represent one appliance in the list.
  It shows the name, the watts and hours, and - / + buttons for the quantity.
  Tapping the tile opens a sheet to change the hours per day.
   */
  const ApplianceTile({
    required this.appliance,
    required this.increase,
    required this.decrease,
    required this.updateHours,
    super.key,
  });
  final Appliance appliance;
  final Function(Appliance) increase;
  final Function(Appliance) decrease;
  final Function(Appliance, double) updateHours;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Material(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
          side: const BorderSide(color: borderGrey),
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(12.0),
          onTap: () {
            showHoursSheet(context, appliance, updateHours);
          },
          child: Padding(
            padding: const EdgeInsets.fromLTRB(14.0, 10.0, 10.0, 10.0),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        appliance.name,
                        style: const TextStyle(
                          fontSize: 15.0,
                          fontWeight: FontWeight.w600,
                          color: night,
                        ),
                      ),
                      const SizedBox(height: 2.0),
                      Text(
                        appliance.toString(),
                        style: const TextStyle(fontSize: 13.0, color: grey),
                      ),
                    ],
                  ),
                ),
                roundButton(Icons.remove, lightGrey, () => decrease(appliance)),
                SizedBox(
                  width: 36.0,
                  child: Text(
                    '${appliance.quantity}',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                roundButton(Icons.add, sun, () => increase(appliance)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // small round button used for - and +
  Widget roundButton(IconData icon, Color color, Function() onPressed) {
    return Material(
      color: color,
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onPressed,
        child: SizedBox(
          width: 36.0,
          height: 36.0,
          child: Icon(icon, size: 18.0, color: night),
        ),
      ),
    );
  }
}

void showHoursSheet(
  BuildContext context,
  Appliance appliance,
  Function(Appliance, double) updateHours,
) {
  /*
  opens a sheet from the bottom of the screen to change the hours per day of
  an appliance. StatefulBuilder lets the slider move inside the sheet.
   */
  double hours = appliance.hours;
  showModalBottomSheet(
    context: context,
    showDragHandle: true,
    backgroundColor: Colors.white,
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setSheetState) {
          return Padding(
            padding: const EdgeInsets.fromLTRB(24.0, 0.0, 24.0, 24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  appliance.name,
                  style: const TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                    color: night,
                  ),
                ),
                const SizedBox(height: 4.0),
                const Text(
                  'How many hours a day is it on?',
                  style: TextStyle(color: grey),
                ),
                const SizedBox(height: 16.0),
                MySliderWidget(
                  label: 'Hours per day',
                  icon: Icons.schedule,
                  value: hours,
                  min: 0.5,
                  max: 24,
                  divisions: 47, // steps of half an hour
                  updateValue: (val) {
                    setSheetState(() {
                      hours = val;
                    });
                  },
                ),
                const SizedBox(height: 8.0),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: () {
                      updateHours(
                        appliance,
                        hours,
                      ); // send the new hours to the home page
                      Navigator.pop(context); // close the sheet
                    },
                    style: FilledButton.styleFrom(
                      backgroundColor: night,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14.0),
                    ),
                    child: const Text('Save'),
                  ),
                ),
              ],
            ),
          );
        },
      );
    },
  );
}

void showAddSheet(BuildContext context, Function(Appliance) addAppliance) {
  // opens the list of appliances (the catalog) from the bottom of the screen
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    backgroundColor: Colors.white,
    builder: (context) {
      return AddApplianceWidget(addAppliance: addAppliance);
    },
  );
}

class AddApplianceWidget extends StatefulWidget {
  /*
  class to represent the catalog of appliances with a search field.
  It includes a callback method called addAppliance, to return the selected
  appliance to the home page.
   */
  const AddApplianceWidget({required this.addAppliance, super.key});
  final Function(Appliance) addAppliance;

  @override
  State<AddApplianceWidget> createState() => _AddApplianceWidgetState();
}

class _AddApplianceWidgetState extends State<AddApplianceWidget> {
  String _search = '';

  @override
  Widget build(BuildContext context) {
    // only keep the appliances that contain the search text
    List<Appliance> items = catalog
        .where((a) => a.name.toLowerCase().contains(_search.toLowerCase()))
        .toList();

    return Padding(
      // moves the sheet up when the keyboard is open
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.7,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.0),
              child: Text(
                'Add an appliance',
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                  color: night,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20.0, 12.0, 20.0, 8.0),
              child: TextField(
                onChanged: (text) {
                  setState(() {
                    _search = text.trim();
                  });
                },
                decoration: InputDecoration(
                  hintText: 'Search appliances',
                  prefixIcon: const Icon(Icons.search),
                  isDense: true,
                  filled: true,
                  fillColor: lightGrey,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
            Expanded(
              child: items.isEmpty
                  ? const Center(
                      child: Text(
                        'Nothing found',
                        style: TextStyle(color: grey),
                      ),
                    )
                  : ListView.builder(
                      itemCount: items.length,
                      itemBuilder: (context, index) {
                        Appliance item = items[index];
                        return ListTile(
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 20.0,
                          ),
                          title: Text(
                            item.name,
                            style: const TextStyle(fontWeight: FontWeight.w600),
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                '${formatNumber(item.watts)} W',
                                style: const TextStyle(color: grey),
                              ),
                              const SizedBox(width: 12.0),
                              const Icon(Icons.add_circle, color: sun),
                            ],
                          ),
                          onTap: () {
                            widget.addAppliance(
                              item,
                            ); // send the appliance to the home page
                            Navigator.pop(context); // close the sheet
                          },
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class ResultsCard extends StatelessWidget {
  /*
  class to represent the results at the bottom of the screen.
  It calls the methods of the SolarSystem class every time the page is rebuilt.
   */
  const ResultsCard({required this.system, super.key});
  final SolarSystem system;

  @override
  Widget build(BuildContext context) {
    double kWh = system.getDailyEnergy() / 1000;
    double kva = system.getInverter();
    int cost = system.getCost();

    // 3.0 -> '3 kVA' and 1.5 -> '1.5 kVA'
    String inverterText = kva == kva.roundToDouble()
        ? '${kva.toInt()} kVA'
        : '$kva kVA';
    String costText = cost == 0 ? '\$0' : '≈ \$${formatNumber(cost)}';

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.fromLTRB(12.0, 0.0, 12.0, 12.0),
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: night,
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'YOUR SYSTEM  ·  ${kWh.toStringAsFixed(1)} kWh per day',
            style: const TextStyle(
              color: paleBlue,
              fontSize: 12.0,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.8,
            ),
          ),
          const SizedBox(height: 12.0),
          Row(
            children: [
              Expanded(
                child: result('${system.getPanels()}', 'solar panels (550 W)'),
              ),
              Expanded(
                child: result(
                  '${system.getBatteries()}',
                  'batteries (2.56 kWh)',
                ),
              ),
            ],
          ),
          const SizedBox(height: 12.0),
          Row(
            children: [
              Expanded(child: result(inverterText, 'inverter')),
              Expanded(child: result(costText, 'estimated cost')),
            ],
          ),
        ],
      ),
    );
  }

  // one result: a big number with a small label under it
  Widget result(String value, String label) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          value,
          style: const TextStyle(
            color: sun,
            fontSize: 24.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(label, style: const TextStyle(color: paleBlue, fontSize: 12.0)),
      ],
    );
  }
}
