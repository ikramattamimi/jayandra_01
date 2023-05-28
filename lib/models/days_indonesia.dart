import 'package:jayandra_01/models/day_model.dart';

class DaysIndonesia {
  static List<DayModel> getDay() {
    List<DayModel> days = [];

    days.addAll([
      DayModel(id: 0, name: "Senin", isSelected: false),
      DayModel(id: 1, name: "Selasa", isSelected: false),
      DayModel(id: 2, name: "Rabu", isSelected: false),
      DayModel(id: 3, name: "Kamis", isSelected: false),
      DayModel(id: 4, name: "Jumat", isSelected: false),
      DayModel(id: 5, name: "Sabtu", isSelected: false),
      DayModel(id: 6, name: "Minggu", isSelected: false),
    ]);

    return days;
  }
}
