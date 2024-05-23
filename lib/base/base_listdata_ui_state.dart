//ignore_for_file: constant_identifier_names

class BaseListDataUiState<T> {
  /// Holds error is state is [State.ERROR]
  dynamic error;

  /// Holds data is state is [State.COMPLETED]
  T? data;

  /// Holds current [State]
  State? _state;

  BaseListDataUiState();

  /// Returns [BaseUiState] with [State.LOADING]
  BaseListDataUiState.loading() : _state = State.LOADING;

  /// Returns [BaseUiState] with [State.COMPLETED]
  BaseListDataUiState.completed({this.data}) : _state = State.COMPLETED;

  /// Returns [BaseListDataUiState] with [State.COMPLETED]
  BaseListDataUiState.loadingMore({this.data}) : _state = State.LOADINGMORE;

  /// Returns [BaseUiState] with [State.ERROR]
  BaseListDataUiState.error(this.error) : _state = State.ERROR;

  /// Returns true if the current [state] is [State.LOADING]
  bool isLoading() => _state == State.LOADING;

  /// Returns true if the current [state] is [State.LOADING]
  bool isLoadingMore() => _state == State.LOADINGMORE;

  /// Returns true if the current [state] is [State.COMPLETED]
  bool isCompleted() => _state == State.COMPLETED;

  /// Returns true if the current [state] is [State.ERROR]
  bool isError() => _state == null || _state == State.ERROR;

  @override
  String toString() {
    return 'State is $_state';
  }
}

/// UI States
enum State { LOADING, COMPLETED, ERROR, LOADINGMORE }
