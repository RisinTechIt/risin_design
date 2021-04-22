import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';
import 'package:logger/logger.dart';

// There are common utils, to avoid repeating code in each projects
// 0. Constants
class CustomRestAuth {
  String baseUrl;
  String tokenType;
  Options options;
  Logger logger = Logger(
    filter: null, // Use the default LogFilter (-> only log in debug mode)
    printer: PrettyPrinter(
        methodCount: 2, // number of method calls to be displayed
        errorMethodCount: 8, // number of method calls if stacktrace is provided
        lineLength: 120, // width of the output
        colors: true, // Colorful log messages
        printEmojis: true, // Print an emoji for each log message
        printTime: true), // Use the PrettyPrinter to format and print log
    output: null, // Use the default LogOutput (-> send everything to console)
  );

  // constructor
  CustomRestAuth({
    @required this.baseUrl,
    this.tokenType = 'Token',
    this.options
  });

  Options getOption() {
    if (this.options == null ) {
      return Options();
    } else {
      return this.options;
    }
  }
  Future<void> setHeaderToken() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var _token = sharedPreferences.getString("token");
    if (_token != null) {
      this.logger.d("Token is: $_token");
      Options options = this.getOption();
      options.headers.addAll({"Authorization": "${this.tokenType} $_token"});
      this.options = options;
    } else {
      throw ("No token set in local storage!");
    }
  }

  Future<Response> authGet(path, [params]) async {
    try {
      await this.setHeaderToken();
      var response = await Dio().get(this.baseUrl + path,
          queryParameters: params, options: this.getOption());
      this.logger.d(response);
      return response;
    } catch (e) {
      this.logger.e(e);
      return Response(statusCode: 500, statusMessage: e.toString());
    }
  }

  Future<Response> authPost(path, body, [params]) async {
    try {
      await this.setHeaderToken();
      var response = await Dio().post(this.baseUrl + path,
          data: body, queryParameters: params, options: this.getOption());
      this.logger.d(response);
      return response;
    } catch (e) {
      this.logger.e(e);
      return e;
    }
  }

  Future<Response> authPut(path, body, [params = const {}]) async {
    try {
      await this.setHeaderToken();
      var response = await Dio().put(this.baseUrl + path,
          data: body, queryParameters: params, options: this.getOption());
      this.logger.d(response);
      return response;
    } catch (e) {
      this.logger.e(e);
      return e;
    }
  }

  Future<Response> authDelete(path, [params = const {}]) async {
    try {
      await this.setHeaderToken();
      var response = await Dio().delete(this.baseUrl + path, queryParameters: params, options: this.getOption());
      this.logger.d(response);
      return response;
    } catch (e) {
      this.logger.e(e);
      return e;
    }
  }
}
