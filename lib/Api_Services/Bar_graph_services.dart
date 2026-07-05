import 'package:dio/dio.dart';
import '../Api_Models/Bar_graph_model.dart';
import '../shared_prefrence/SharedPrefrenceMethods.dart';
import '../ulitity/NetworkManager.dart';

class BarGraphService {
  static final String baseUrl =
      "${NetworkManager().baseUrl}expenses/bar-graph";

  final Dio _dio = Dio();
  final SharedPreferenceMethods _pref = SharedPreferenceMethods();

  /// 📊 Get Bar Graph Data
  Future<BarGraphResponse?> getBarGraphData() async {
    try {
      String? token = await _pref.getToken();

      // 🔥 ADD THIS PART HERE
      if (token == null || token.isEmpty) {
        print("❌ TOKEN NULL");
        return null;
      }

      token = token.trim();   // ✅ IMPORTANT LINE

      print("🔐 BAR GRAPH TOKEN: $token");
      print("🌐 URL => $baseUrl");

      final response = await _dio.get(
        baseUrl,
        options: Options(
          headers: {
            "Authorization": "Bearer $token",
          },
        ),
      );

      print("📊 STATUS: ${response.statusCode}");
      print("📊 DATA: ${response.data}");

      if (response.statusCode == 200) {
        return BarGraphResponse.fromJson(response.data);
      }

    } on DioException catch (e) {
      print("❌ STATUS: ${e.response?.statusCode}");
      print("❌ RESPONSE: ${e.response?.data}");
    } catch (e) {
      print("❌ Unknown Error: $e");
    }

    return null;
  }
}
