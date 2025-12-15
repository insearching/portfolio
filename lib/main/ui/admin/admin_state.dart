import 'package:equatable/equatable.dart';

/// Authentication status
enum AuthStatus {
  initial,
  authenticating,
  authenticated,
  unauthenticated,
  authenticationFailed
}

/// Add operation status
enum AddOperationStatus { initial, loading, success, failure }

/// Admin BLoC state
class AdminState extends Equatable {
  const AdminState({
    this.authStatus = AuthStatus.initial,
    this.addOperationStatus = AddOperationStatus.initial,
    this.errorMessage,
    this.successMessage,
  });

  final AuthStatus authStatus;
  final AddOperationStatus addOperationStatus;
  final String? errorMessage;
  final String? successMessage;

  bool get isAuthenticated => authStatus == AuthStatus.authenticated;
  bool get isAuthenticating => authStatus == AuthStatus.authenticating;
  bool get isAddingItem => addOperationStatus == AddOperationStatus.loading;

  AdminState copyWith({
    AuthStatus? authStatus,
    AddOperationStatus? addOperationStatus,
    String? errorMessage,
    String? successMessage,
  }) {
    return AdminState(
      authStatus: authStatus ?? this.authStatus,
      addOperationStatus: addOperationStatus ?? this.addOperationStatus,
      errorMessage: errorMessage,
      successMessage: successMessage,
    );
  }

  @override
  List<Object?> get props => [
        authStatus,
        addOperationStatus,
        errorMessage,
        successMessage,
      ];
}
