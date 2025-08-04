import 'package:abm4_customerapp/features/Dashboard/Dealer/Bloc/dashboard_dealer_event.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:abm4_customerapp/features/Dashboard/Dealer/Bloc/dashboard_dealer_state.dart';

class DashboardBloc extends Bloc<DashboardDealerEvent, DashboardDealerState> {
  DashboardBloc() : super(DashboardInitial()) {
    // Add event handlers here
  }
}
