import 'appliance.dart';

/*
values used in the calculation. They are average values and can be changed here
if the prices or the equipment change.
 */
const int panelWatts = 550; // power of one solar panel
const double efficiency = 0.8; // panels lose about 20% (heat, dust and wires)
const int batteryWh = 2560; // one lithium battery: 25.6 V x 100 Ah
const double batteryUse = 0.8; // only 80% of a battery should be used
const int panelPrice = 90;
const int batteryPrice = 450;
// standard inverter sizes in kVA, and the price of each size in the same order
const List<double> inverterSizes = [1, 1.5, 3, 5, 8, 10];
const List<int> inverterPrices = [150, 220, 350, 550, 800, 1000];

// class to represent the solar system of a home and calculate its parts
class SolarSystem {
  List<Appliance> appliances;
  double sunHours = 5; // sun hours in the area, default 5 hours
  double backupHours = 8; // battery hours needed at night, default 8 hours
  bool installation = true; // add the installation cost (+15%), default is true

  SolarSystem(this.appliances);

  // total energy of all the appliances in one day (Wh)
  double getDailyEnergy() {
    double total = 0;
    for (Appliance a in appliances) {
      total += a.getDailyEnergy();
    }
    return total;
  }

  int getPanels() {
    /*
    one panel gives (550 x sun hours x 0.8) Wh in one day
    number of panels = daily energy / energy of one panel, rounded up
     */
    double energy = getDailyEnergy();
    if (energy == 0) {
      return 0;
    }
    double onePanel = panelWatts * sunHours * efficiency;
    return (energy / onePanel).ceil();
  }

  int getBatteries() {
    /*
    energy needed at night = average energy per hour x backup hours
    we divide by 0.8 because only 80% of the battery is used
    number of batteries = night energy / energy of one battery, rounded up
     */
    double energy = getDailyEnergy();
    if (energy == 0 || backupHours == 0) {
      return 0;
    }
    double nightEnergy = energy / 24 * backupHours;
    return (nightEnergy / batteryUse / batteryWh).ceil();
  }

  double getInverter() {
    /*
    the inverter must handle all the appliances on at the same time
    kVA = total watts x 1.25 (safety margin) / 0.8 (power factor) / 1000
    then we take the next standard size
     */
    int watts = 0;
    for (Appliance a in appliances) {
      watts += a.getTotalWatts();
    }
    if (watts == 0) {
      return 0;
    }
    double kva = watts * 1.25 / 0.8 / 1000;
    for (double size in inverterSizes) {
      if (kva <= size) {
        return size;
      }
    }
    return kva.ceilToDouble(); // bigger than the largest standard size
  }

  int getCost() {
    /*
    cost = panels + batteries + inverter
    if installation is selected we add 15% for the wires and the installation
    The result is rounded to the nearest 10 dollars
     */
    double kva = getInverter();
    if (kva == 0) {
      return 0;
    }
    int inverterPrice;
    int index = inverterSizes.indexOf(kva);
    if (index != -1) {
      inverterPrice = inverterPrices[index];
    } else {
      inverterPrice = (kva * 100).round(); // not a standard size
    }
    int parts =
        getPanels() * panelPrice +
        getBatteries() * batteryPrice +
        inverterPrice;
    // 15% only if installation is selected
    double extra = installation ? 1.15 : 1.0;
    double total = parts * extra;
    return (total / 10).round() * 10;
  }
}
