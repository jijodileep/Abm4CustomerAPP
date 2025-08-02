import 'package:equatable/equatable.dart';

abstract class DashboardDealerState extends Equatable {
  const DashboardDealerState();

  @override
  List<Object> get props => [];
}

class DashboardInitial extends DashboardDealerState {
  const DashboardInitial();
}

class DashboardLoading extends DashboardDealerState {
  const DashboardLoading();
}

class DashboardLoaded extends DashboardDealerState {
  final Map<String, dynamic> dashboardData;

  const DashboardLoaded(this.dashboardData);

  @override
  List<Object> get props => [dashboardData];
}

class DashboardError extends DashboardDealerState {
  final String message;

  const DashboardError(this.message);

  @override
  List<Object> get props => [message];
}
