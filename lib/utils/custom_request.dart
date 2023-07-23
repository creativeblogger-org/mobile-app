import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_spinkit/flutter_spinkit.dart';

void customRequest(
  BuildContext context,
  Function(bool value) setConnecting,
  Uri url,
  Object? body,
  Map<String, String>? headers,
  Function onNoConnection,
  Function onUnauthorized,
  Function(String token) onSuccess,
  Function(String error) onServerError,
) {}
