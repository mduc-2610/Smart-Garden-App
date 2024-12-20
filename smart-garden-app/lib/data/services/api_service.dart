import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:smart_garden_app/data/services/reflect.dart';
import 'package:smart_garden_app/features/authentication/models/auth/token.dart';
import 'package:smart_garden_app/utils/constants/api_constants.dart';
import 'package:smart_garden_app/data/services/token_service.dart';
import 'package:smart_garden_app/utils/helpers/helper_functions.dart';
import 'package:http/http.dart' as http;
import 'package:reflectable/reflectable.dart';
import 'package:get/get.dart';

class APIService<T> {
  final String? endpoint;
  final String fullUrl;
  final String queryParams;
  final String retrieveQueryParams;
  final bool pagination;
  final bool fullResponse;
  final bool allNoBearer;
  Dio? dio;
  final bool utf_8;

  APIService({
    this.endpoint,
    this.queryParams = '',
    this.fullUrl = '',
    this.retrieveQueryParams = '',
    this.pagination = true,
    this.fullResponse = false,
    this.allNoBearer = false,
    this.dio,
    this.utf_8 = true,
  });

  dynamic decodeMessage(response) {
    if(utf_8 && dio == null) {
      return json.decode(utf8.decode(response.bodyBytes));
    }
    return json.decode(response.body);
  }

  T Function(Map<String, dynamic>) get fromJson {
    var classMirror = jsonSerializable.reflectType(T) as ClassMirror;
    var constructor = classMirror.declarations["fromJson"];
    return (json) => classMirror.newInstance("fromJson", [json]) as T;
  }

  bool checkParamExist(String x) {
    return x.contains('?');
  }

  String url({dynamic id}) {
    String url = fullUrl.isNotEmpty
        ? fullUrl
        : '${APIConstant.baseUrl}/${endpoint ?? APIConstant.getEndpointFor<T>() ?? ""}';

    if (!checkParamExist(url) && !url.endsWith('/')) {
      url += '/';
    }

    if (id != null) {
      url += '$id/';
    }

    if (queryParams.isNotEmpty) {
      url += checkParamExist(url) ? '&' : '?';
      url += queryParams;
    }

    if (retrieveQueryParams.isNotEmpty) {
      url += checkParamExist(url) ? '&' : '?';
      url += retrieveQueryParams;
    }

    return url;
  }

  Future<dynamic> list({ bool next = false, pagination = true, single = false }) async {
    return _handleRequest<dynamic>((Token? token) async {
      final url_ = url();
      $print("URL: $url_");
      if (dio != null) {
        final response = await dio!.get(
          url_,
          options: Options(headers: await _getHeaders(token)),
        );
        return _handleResponse(response.data, response.statusCode, next: next, pagination: pagination, single: single);
      } else {
        $print("Response before ");
        final response = await http.get(
          Uri.parse(url_),
          headers: await _getHeaders(token),
        );
        return _handleResponse(decodeMessage(response), response.statusCode, next: next, pagination: pagination, single: single);
      }
    });
  }

  Future<T> retrieve(String id) async {
    return _handleRequest<T>((Token? token) async {
      final url_ = url(id: id);
      $print(url_);

      if (dio != null) {
        final response = await dio!.get(
          url_,
          options: Options(headers: await _getHeaders(token)),
        );
        return fromJson(response.data);
      } else {
        final response = await http.get(
          Uri.parse(url_),
          headers: await _getHeaders(token),
        );
        final _x = json.decode(utf8.decode(response.bodyBytes));
        return fromJson(decodeMessage(response));
      }
    });
  }

  Future<dynamic> create(dynamic data, {
    Function(Map<String, dynamic>)? fromJson,
    bool noBearer = false,
    bool isFormData = false,
    bool noFromJson = false,
  }) async {
    return _handleRequest<dynamic>((Token? token) async {
      $print(url());
      final requestData = isFormData
          ? await data.toFormData()
          : (data is Map<String, dynamic> || data is Map) ? data : data.toJson();
      if(isFormData && dio == null) this.dio = Dio();
      if (dio != null) {
        final response = await dio!.post(
          url(),
          data: requestData,
          options: Options(headers: await _getHeaders(token, noBearer: noBearer)),
        );
        var jsonResponse = response.data;
        if(!noFromJson) {
          fromJson = (fromJson != null) ? fromJson : this.fromJson;
          jsonResponse = fromJson?.call(jsonResponse);
        }
        return [response.statusCode, response.headers, jsonResponse];
      } else {
        final response = await http.post(
          Uri.parse(url()),
          headers: await _getHeaders(token, noBearer: noBearer),
          body: json.encode(requestData),
        );
        var jsonResponse = decodeMessage(response);
        if(!noFromJson) {
          fromJson = (fromJson != null) ? fromJson : this.fromJson;
          jsonResponse = fromJson?.call(jsonResponse);
        }
        $print([response.statusCode, response.headers, jsonResponse]);
        return [response.statusCode, response.headers, jsonResponse];
      }
    });
  }

  Future<dynamic> update(
      dynamic id,
      dynamic data, {
        Function(Map<String, dynamic>)? fromJson,
        bool patch = false,
        bool noBearer = false,
        bool isFormData = false,
        bool noFromJson = false,
      }) async {
    return _handleRequest<dynamic>((Token? token) async {
      final uri = url(id: id);
      final requestData = isFormData
          ? await data.toFormData(patch: patch)
          : (data is Map<String, dynamic>) ? data : data.toJson(patch: patch);
      $print(requestData);
      if(isFormData && dio == null) this.dio = Dio();
      if (dio != null) {
        final response = await dio!.request(
          uri,
          data: requestData,
          options: Options(
            method: patch ? 'PATCH' : 'PUT',
            headers: await _getHeaders(token, noBearer: noBearer),
          ),
        );
        var jsonResponse = response.data;
        if(!noFromJson) {
          fromJson = (fromJson != null) ? fromJson : this.fromJson;
          if (fromJson != null) {
            jsonResponse = fromJson?.call(jsonResponse);
          }
        }
        return [response.statusCode, response.headers, jsonResponse];
      } else {
        final body = isFormData
            ? requestData
            : json.encode(requestData);

        final response = patch
            ? await http.patch(Uri.parse(uri), headers: await _getHeaders(token, noBearer: noBearer), body: body)
            : await http.put(Uri.parse(uri), headers: await _getHeaders(token, noBearer: noBearer), body: body);

        var jsonResponse = decodeMessage(response);
        if(!noFromJson) {
          fromJson = (fromJson != null) ? fromJson : this.fromJson;
          if (fromJson != null) {
            jsonResponse = fromJson?.call(jsonResponse);
          }
        }
        return [response.statusCode, response.headers, jsonResponse];
      }
    });
  }

  Future<bool> delete(String id, { bool noBearer = false }) async {
    return _handleRequest<bool>((Token? token) async {
      final url_ = url(id: id);
      $print(url_);
      if (dio != null) {
        final response = await dio!.delete(
          url_,
          options: Options(headers: await _getHeaders(token, noBearer: noBearer)),
        );

        if (response.statusCode != 204) {
          throw DioError(requestOptions: response.requestOptions, response: response);
        }
        else {
          return true;
        }
      } else {
        final response = await http.delete(
          Uri.parse(url_),
          headers: await _getHeaders(token),
        );

        if (response.statusCode != 204) {
          throw Exception('Failed to delete object: ${response.statusCode}');
        }
        else {
          return true;
        }
      }
    });
  }

  Future<R> _handleRequest<R>(Future<R> Function(Token?) request) async {
    Token? token;
    if(allNoBearer) {
      return await request(token);
    }
    else {
      try {
        token = await TokenService.getToken();
        return await request(token);
      } catch (e) {
        await refreshToken();
        token = await TokenService.getToken();
        return await request(token);
      }
    }
  }

  Future<void> refreshToken() async {
    Token? token = await TokenService.getToken();
    try {
      final response = await http.post(
        Uri.parse('${await APIConstant.baseUrl}/account/refresh-token/'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'refresh': token?.refresh}),
      );

      if (response.statusCode == 200) {
        final jsonResponse = decodeMessage(response);
        token?.access = jsonResponse["access"] ?? "";
        await TokenService.saveToken(token!);

        final userResponse = await http.get(
          Uri.parse('${await APIConstant.baseUrl}/account/user/me'),
          headers: await _getHeaders(token),
        );

        if (userResponse.statusCode == 200) {
          $print("Token refreshed and user validated successfully");
        } else if (userResponse.statusCode == 401 || userResponse.statusCode == 404) {
          $print("User no longer exists or is unauthorized");
          await _handleInvalidUser();
        } else {
          $print("Unexpected error while validating user: ${userResponse.statusCode}");
        }
      } else {
        $print("Failed to refresh token: ${response.statusCode}");
        await _handleInvalidUser();
      }
    } catch (e) {
      $print("Error during token refresh: $e");
      await _handleInvalidUser();
    }
  }

  Future<void> _handleInvalidUser() async {
    await TokenService.deleteToken();
    // Get.to(() => LoginView());
  }

  Future<Map<String, String>> _getHeaders(Token? token, {bool noBearer = false}) async {
    final headers = {'Content-Type': 'application/json'};
    if (!allNoBearer && !noBearer && token?.access != null && token!.access.isNotEmpty) {
      headers['Authorization'] = 'Bearer ${token.access}';
    }
    return headers;
  }

  dynamic _handleResponse(dynamic responseData, int? statusCode, { bool next = false, pagination = true, single = false }) {
    if (statusCode == 200) {
      dynamic jsonResponse = responseData;
      if (single) {
        return fromJson(jsonResponse);
      }
      if (pagination) {
        jsonResponse = jsonResponse["results"];
      }


      var paginatedResult = (jsonResponse as List).map((instance) => fromJson(instance)).toList();
      if (next) {
        var paginationInfo = responseData["pagination"] ?? {};
        return [paginatedResult, paginationInfo];
      }
      return paginatedResult;
    } else {
      throw Exception('Failed to get data: $statusCode');
    }
  }
}
