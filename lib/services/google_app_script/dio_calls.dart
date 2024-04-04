import 'package:dio/dio.dart';
import 'package:facebook_results/services/google_app_script/json_constants.dart';
import 'package:facebook_results/services/google_app_script/local_properties.dart';
import 'dart:developer' as devtools show log;

final dio = Dio();

const baseUrl = 'https://script.google.com/macros/s/$deploymentId/exec';

Future<Map<String, dynamic>> getRequest({
  required Map<String, String> queryParams,
}) async {
  Uri uri = Uri.parse(baseUrl).replace(queryParameters: queryParams);

  try {
    Response response = await dio.getUri(uri);
    checkingResponse(response);
    return response.data;
  } catch (error) {
    devtools.log('Error: $error');
    rethrow;
  }
}

Future<Map<String, dynamic>> postRequest({
  required Map<String, dynamic> data,
}) async {
  try {
    final response = await dio.postUri(
      Uri.parse(baseUrl),
      data: data,
      options: Options(
        validateStatus: (status) {
          return status! < 400;
        },
      ),
    );

    if (response.statusCode == 302) {
      // Extract the redirection URL from the response headers
      final redirectionUrl = response.headers['location']?.first;

      // Make a new request to the redirection URL
      if (redirectionUrl != null) {
        final redirectionResponse = await dio.get(redirectionUrl);
        checkingResponse(redirectionResponse);
        return redirectionResponse.data;
      } else {
        throw Exception('No Redirect Url!');
      }
    } else {
      checkingResponse(response);
      return response.data;
    }
  } catch (e) {
    devtools.log('Error: $e');
    rethrow;
  }
}

void checkingResponse(dynamic response) {
  final data = response.data;
  if (data[keyStatus] != 'Success') {
    throw data;
  }
}
