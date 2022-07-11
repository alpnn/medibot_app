import 'package:flutter/material.dart';
import 'package:equatable/equatable.dart';

/*
        code range:
        100-199 authentication/authorization errors
        200-299 user errors
        300-399 patient errors
        400-499 dialogflow errors
        500-599 http side error
     */

class MedibotError extends Equatable {
  final int code;
  final String message;

  const MedibotError({Key? key, required this.code, required this.message});

  static const MedibotError unknown =
      MedibotError(code: 500, message: "unknown http side value");
  static const MedibotError connectionFailed =
      MedibotError(code: 501, message: "failed to connect to the server");
  static const MedibotError jsonParseFailed =
      MedibotError(code: 502, message: "failed to parse server response");

  @override
  List<Object?> get props => [code, message];
}
