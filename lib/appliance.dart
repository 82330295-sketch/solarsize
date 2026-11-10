
class Appliance {
  String name;      // name of the device, like Fridge
  int watts;        // how much power it uses
  double hours;     // hours per day (double because it can be 0.5)
  int quantity = 1; // how many the user has, starts at 1

  Appliance(this.name, this.watts, this.hours);

  /* energy in one day (Wh) = watts x hours x quantity */
  double getDailyEnergy() {
    return watts * hours * quantity;
  }

  /* total power when all of them are on at the same time */
  int getTotalWatts() {
    return watts * quantity;
  }

  @override
  String toString() {
    // show 24 instead of 24.0, but keep 0.5
    String h = hours == hours.roundToDouble() ? hours.toInt().toString() : hours.toString();
    return '$watts W - $h h/day';
  }
}


List<Appliance> catalog = [
  Appliance('Fridge', 150, 24),
  Appliance('TV', 100, 6),
  Appliance('LED light', 10, 6),
  Appliance('Fan', 60, 8),
  Appliance('Washing machine', 500, 1),
  Appliance('Air conditioner', 1200, 6),
  Appliance('Laptop', 65, 6),
  Appliance('Microwave', 1000, 0.5),
  Appliance('Water heater', 1500, 2),
  Appliance('Wi-Fi router', 12, 24),
];