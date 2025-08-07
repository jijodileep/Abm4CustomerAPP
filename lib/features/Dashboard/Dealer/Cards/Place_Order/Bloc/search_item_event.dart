import 'package:equatable/equatable.dart';

abstract class SearchItemEvent extends Equatable {
  const SearchItemEvent();

  @override
  List<Object> get props => [];
}

class SearchItemRequested extends SearchItemEvent {
  final String searchQuery;

  const SearchItemRequested({required this.searchQuery});

  @override
  List<Object> get props => [searchQuery];
}

class SearchItemCleared extends SearchItemEvent {
  const SearchItemCleared();
}
