import 'package:equatable/equatable.dart';
import 'dealer.dart';

class DealerLoginRequest extends Equatable {
  final String mobileNumberOrId;
  final String password;

  const DealerLoginRequest({
    required this.mobileNumberOrId,
    required this.password,
  });

  Map<String, dynamic> toJson() {
    return {'mobileNumber': mobileNumberOrId, 'password': password};
  }

  @override
  List<Object?> get props => [mobileNumberOrId, password];
}

class DealerLoginResponse extends Equatable {
  final bool success;
  final String? token;
  final Dealer? dealer;
  final String? message;
  final String? error;

  const DealerLoginResponse({
    required this.success,
    this.token,
    this.dealer,
    this.message,
    this.error,
  });

  factory DealerLoginResponse.fromJson(Map<String, dynamic> json) {
    return DealerLoginResponse(
      success: json['success'] as bool? ?? false,
      token: json['data'] != null ? json['data']['token'] as String? : null,
      dealer: json['data'] != null && json['data']['data'] != null
          ? Dealer.fromJson(json['data']['data'])
          : null,
      message: json['message'] as String?,
      error: json['success'] == false
          ? json['message'] as String?
          : json['error'] as String?,
    );
  }

  factory DealerLoginResponse.success({
    required String token,
    required Dealer dealer,
    String? message,
  }) {
    return DealerLoginResponse(
      success: true,
      token: token,
      dealer: dealer,
      message: message,
    );
  }

  factory DealerLoginResponse.failure({required String error}) {
    return DealerLoginResponse(success: false, error: error);
  }

  @override
  List<Object?> get props => [success, token, dealer, message, error];
}

class DealerForgotPasswordRequest extends Equatable {
  final String mobileNumberOrId;

  const DealerForgotPasswordRequest({required this.mobileNumberOrId});

  Map<String, dynamic> toJson() {
    return {'mobile_number_or_id': mobileNumberOrId, 'user_type': 'dealer'};
  }

  @override
  List<Object?> get props => [mobileNumberOrId];
}
