import 'package:equatable/equatable.dart';

abstract class DashboardDealerEvent extends Equatable {
  const DashboardDealerEvent();

  @override
  List<Object> get props => [];
}

class LoadDashboard extends DashboardDealerEvent {
  const LoadDashboard();
}

class RefreshDashboard extends DashboardDealerEvent {
  const RefreshDashboard();
}

class UpdateDashboardData extends DashboardDealerEvent {
  final Map<String, dynamic> data;

  const UpdateDashboardData(this.data);

  @override
  List<Object> get props => [data];
}
