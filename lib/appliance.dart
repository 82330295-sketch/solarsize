// class to represent a home appliance and calculate its energy
class Appliance {
  String name;
  int watts; // power of one unit
  double hours; // hours per day the appliance is turned on
  int quantity = 1; // number of units, default is 1

  // constructor takes name, watts and hours. quantity is changed later
  Appliance(this.name, this.watts, this.hours);

  // energy used in one day, in watt hours (Wh)
  double getDailyEnergy() {
    return watts * quantity * hours;
  }

  // power needed when all the units are on at the same time
  int getTotalWatts() {
    return watts * quantity;
  }

  // toString method used to display the details under the appliance name
  @override
  String toString() {
    return '${formatNumber(watts)} W · ${formatHours(hours)}/day';
  }
}

// a list of appliances the user can choose from when pressing Add.
// there is no database, the list is part of the code
List<Appliance> catalog = [
  Appliance('Air conditioner', 1200, 6),
  Appliance('Desktop computer', 200, 5),
  Appliance('Fan', 60, 8),
  Appliance('Freezer', 200, 24),
  Appliance('Fridge', 150, 24),
  Appliance('Iron', 1000, 0.5),
  Appliance('Laptop', 65, 6),
  Appliance('LED light', 10, 6),
  Appliance('Microwave', 1000, 0.5),
  Appliance('Phone charger', 10, 3),
  Appliance('TV', 100, 6),
  Appliance('Washing machine', 500, 1),
  Appliance('Water heater', 1500, 2),
  Appliance('Water pump', 750, 1),
  Appliance('Wi-Fi router', 12, 24),
];

// appliances of a small home, displayed when the application starts
List<Appliance> getStarterList() {
  Appliance lights = Appliance('LED light', 10, 6);
  lights.quantity = 8;
  Appliance fans = Appliance('Fan', 60, 8);
  fans.quantity = 2;

  return [
    Appliance('Fridge', 150, 24),
    Appliance('TV', 100, 6),
    lights,
    fans,
    Appliance('Washing machine', 500, 1),
    Appliance('Wi-Fi router', 12, 24),
  ];
}

// adds commas to big numbers, example: 1750 -> 1,750
String formatNumber(int number) {
  String digits = number.toString();
  String result = '';
  for (int i = 0; i < digits.length; i++) {
    if (i > 0 && (digits.length - i) % 3 == 0) {
      result += ',';
    }
    result += digits[i];
  }
  return result;
}

// example: 24.0 -> '24 h' and 0.5 -> '0.5 h'
String formatHours(double hours) {
  if (hours == hours.roundToDouble()) {
    return '${hours.toInt()} h';
  }
  return '${hours.toStringAsFixed(1)} h';
}
