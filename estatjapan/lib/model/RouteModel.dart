import 'jsonModel/Class.dart';
import 'jsonModel/ImmigrationStatisticsRoot.dart';

class RouteModel {
  final Class selectedCLASS;
  Class? selectedMonth;
  ImmigrationStatisticsRoot? rootModel;
  late ImmigrationStatisticsRoot loadedDatarootModel;
  RouteModel({required this.selectedCLASS, this.rootModel});
}
