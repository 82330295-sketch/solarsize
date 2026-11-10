import 'appliance.dart';

/* the numbers used in the calculation (rough estimates) */
const int panelWatts = 550;        // one solar panel
const double efficiency = 0.8;     // we lose about 20% (heat, dust, cables)
const int batteryWh = 2560;        // one battery = 2.56 kWh
const double usableBattery = 0.8;  // we only use 80% of the battery
const int panelPrice = 90;         // $
const int batteryPrice = 450;      // $
List<double> inverterSizes = [1, 1.5, 3, 5, 8, 10];          // kVA
List<int> inverterPrices = [150, 220, 350, 550, 800, 1000];  // $

class SolarSystem {
  List<Appliance> appliances;
  double sunHours = 5;       // sun hours in the area
  double backupHours = 8;    // battery hours needed at night
  bool installation = true;  // add 15% for installation

  SolarSystem(this.appliances);

  /* energy of all the appliances in one day (Wh) */
  double getDailyEnergy() {
    double total = 0;
    for (Appliance a in appliances) {
      total += a.getDailyEnergy();
    }
    return total;
  }

  /* power if everything is on at the same time (W) */
  int getTotalWatts() {
    int total = 0;
    for (Appliance a in appliances) {
      total += a.getTotalWatts();
    }
    return total;
  }

  /* one panel gives 550 x sun hours x 0.8 per day */
  int getPanels() {
    double onePanel = panelWatts * sunHours * efficiency;
    return (getDailyEnergy() / onePanel).ceil();
  }

  /* energy needed for the night hours, divided by what one battery gives */
  int getBatteries() {
    double nightEnergy = getDailyEnergy() / 24 * backupHours;
    return (nightEnergy / usableBattery / batteryWh).ceil();
  }

  /* index of the smallest inverter that is big enough */
  int getInverterIndex() {
    double kva = getTotalWatts() * 1.25 / 0.8 / 1000;
    for (int i = 0; i < inverterSizes.length; i++) {
      if (inverterSizes[i] >= kva) {
        return i;
      }
    }
    return inverterSizes.length - 1; // the biggest one
  }

  double getInverter() {
    return inverterSizes[getInverterIndex()];
  }

  /* price of everything, plus 15% if installation is checked, rounded to 10 */
  int getCost() {
    int parts = getPanels() * panelPrice +
        getBatteries() * batteryPrice +
        inverterPrices[getInverterIndex()];
    double extra = installation ? 1.15 : 1.0;
    return (parts * extra / 10).round() * 10;
  }
}