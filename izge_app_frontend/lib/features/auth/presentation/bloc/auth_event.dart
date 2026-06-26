import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

class AuthCheckRequested extends AuthEvent {}

class AuthLoginRequested extends AuthEvent {
  final String? email;
  final String? phone;
  final String password;

  const AuthLoginRequested({
    this.email,
    this.phone,
    required this.password,
  });

  @override
  List<Object?> get props => [email, phone, password];
}

class AuthSignUpRequested extends AuthEvent {
  final String fullName;
  final String? email;
  final String? phone;
  final String password;
  final bool isParent;
  final String? childName;
  final String? childBirthDate;
  final String? childDiagnosis;

  const AuthSignUpRequested({
    required this.fullName,
    this.email,
    this.phone,
    required this.password,
    this.isParent = false,
    this.childName,
    this.childBirthDate,
    this.childDiagnosis,
  });

  @override
  List<Object?> get props => [
        fullName,
        email,
        phone,
        password,
        isParent,
        childName,
        childBirthDate,
        childDiagnosis,
      ];
}

class AuthGoogleSignInRequested extends AuthEvent {}

class AuthLogoutRequested extends AuthEvent {}
