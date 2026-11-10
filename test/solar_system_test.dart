import 'package:flutter_test/flutter_test.dart';
import 'package:solarsize/appliance.dart';
import 'package:solarsize/solar_system.dart';

void main() {
  test('starter home with 5 sun hours and 8 backup hours', () {
    SolarSystem system = SolarSystem(getStarterList());
    // 3600 + 600 + 480 + 960 + 500 + 288
    expect(system.getDailyEnergy(), 6428);
    expect(system.getPanels(), 3);
    expect(system.getBatteries(), 2);
    expect(system.getInverter(), 3);
    expect(system.getCost(), 1750);
  });

  test('adding an air conditioner', () {
    List<Appliance> list = getStarterList();
    list.add(Appliance('Air conditioner', 1200, 6));
    SolarSystem system = SolarSystem(list);
    expect(system.getDailyEnergy(), 13628);
    expect(system.getPanels(), 7);
    expect(system.getBatteries(), 3);
    expect(system.getInverter(), 5);
    expect(system.getCost(), 2910);
  });

  test('more sun hours means fewer panels', () {
    SolarSystem system = SolarSystem(getStarterList());
    system.sunHours = 3;
    expect(system.getPanels(), 5);
    system.sunHours = 8;
    expect(system.getPanels(), 2);
  });

  test('no backup hours means no batteries', () {
    SolarSystem system = SolarSystem(getStarterList());
    system.backupHours = 0;
    expect(system.getBatteries(), 0);
  });

  test('without installation there is no extra 15%', () {
    SolarSystem system = SolarSystem(getStarterList());
    system.installation = false;
    // 3 x 90 + 2 x 450 + 350 = 1520
    expect(system.getCost(), 1520);
  });

  test('empty list', () {
    SolarSystem system = SolarSystem([]);
    expect(system.getPanels(), 0);
    expect(system.getBatteries(), 0);
    expect(system.getInverter(), 0);
    expect(system.getCost(), 0);
  });

  test('big load goes above the largest standard inverter', () {
    Appliance heater = Appliance('Heater', 1500, 1);
    heater.quantity = 8;
    // 12000 W x 1.25 / 0.8 = 18.75 kVA
    expect(SolarSystem([heater]).getInverter(), 19);
  });

  test('formatting', () {
    expect(formatNumber(1750), '1,750');
    expect(formatNumber(12000), '12,000');
    expect(formatNumber(950), '950');
    expect(formatHours(24), '24 h');
    expect(formatHours(0.5), '0.5 h');
    expect(Appliance('Fridge', 150, 24).toString(), '150 W · 24 h/day');
  });
}
