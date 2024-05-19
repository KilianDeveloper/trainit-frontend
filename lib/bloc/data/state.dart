enum DataStatus { initial, success, error, loading }

extension DataStatusX on DataStatus {
  bool get isInitial => this == DataStatus.initial;
  bool get isSuccess => this == DataStatus.success;
  bool get isError => this == DataStatus.error;
  bool get isLoading => this == DataStatus.loading;
}

class DataState {
  DataState({
    this.status = DataStatus.initial,
    this.statusText,
  });

  final DataStatus status;
  final String? statusText;

  List<Object?> get props => [status];

  DataState copyWith({
    DataStatus? status,
    String? statusText,
  }) {
    return DataState(status: status ?? this.status, statusText: statusText);
  }
}
