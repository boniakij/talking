import 'package:equatable/equatable.dart';

class SignalingMessage extends Equatable {
  final String type;
  final dynamic data;
  final String? from;

  const SignalingMessage({required this.type, this.data, this.from});

  factory SignalingMessage.fromJson(Map<String, dynamic> json) {
    return SignalingMessage(
      type: json['type'],
      data: json['data'],
      from: json['from'],
    );
  }

  Map<String, dynamic> toJson() => {
    'type': type,
    'data': data,
    if (from != null) 'from': from,
  };

  @override
  List<Object?> get props => [type, data, from];
}
