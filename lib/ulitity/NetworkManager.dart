import 'package:flutter/material.dart';

final class NetworkManager {
  NetworkManager._privateConstructor();

  static final NetworkManager _instance = NetworkManager._privateConstructor();

  factory NetworkManager() {
    return _instance;
  }
  String baseUrl = "https://expense-tracker-2k3t.onrender.com/api";
  bool isConnected = false;

  void updateConnectionStatus(bool status) {
    isConnected = status;
  }
}