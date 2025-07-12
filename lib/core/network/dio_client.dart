import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:wejha/core/constants/api_constants.dart';
import 'package:wejha/core/services/token_manager.dart';

class DioClient {
  static Dio createDio({required String baseUrl, TokenManager? tokenManager}) {
    final dio = Dio();
    
    // Configure base URL
    dio.options.baseUrl = baseUrl;
    
    // Set default headers
    dio.options.headers = ApiConstants.headers;
    
    // Set timeouts
    dio.options.connectTimeout = Duration(seconds: ApiConstants.connectTimeout);
    dio.options.receiveTimeout = Duration(seconds: ApiConstants.receiveTimeout);
    dio.options.sendTimeout = Duration(seconds: ApiConstants.sendTimeout);
    
    // Add auth interceptor if token manager is provided
    if (tokenManager != null) {
      dio.interceptors.add(
        AuthInterceptor(
          tokenManager: tokenManager,
          dio: dio,
        ),
      );
    }
    
    // Add logging interceptor with more details
    dio.interceptors.add(LogInterceptor(
      requestHeader: true,
      requestBody: true,
      responseHeader: true,
      responseBody: true,
      error: true,
      logPrint: (object) {
        debugPrint('DIO LOG: $object');
      },
    ));
    
    // Add retry interceptor for failed requests
    dio.interceptors.add(
      RetryInterceptor(
        dio: dio,
        logPrint: (message) => debugPrint('RETRY: $message'),
      ),
    );
    
    return dio;
  }
}

class AuthInterceptor extends Interceptor {
  final TokenManager tokenManager;
  final Dio dio;
  
  AuthInterceptor({
    required this.tokenManager,
    required this.dio,
  });
  
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    // Skip authentication for login, register, and forgot password endpoints
    if (_shouldSkipAuth(options.path)) {
      return handler.next(options);
    }
    
    // Add authorization header if available
    final authHeader = tokenManager.getAuthorizationHeader();
    if (authHeader != null) {
      options.headers['Authorization'] = authHeader;
      debugPrint('Adding auth header: $authHeader');
    }
    
    return handler.next(options);
  }
  
  bool _shouldSkipAuth(String path) {
    return path.contains(ApiConstants.login) || 
           path.contains('/register') || 
           path.contains(ApiConstants.forgotPassword) ||
           path.contains(ApiConstants.verifyResetCode) ||
           path.contains(ApiConstants.resetPassword) ||
           path.contains(ApiConstants.googleAuth);
  }
}

class RetryInterceptor extends Interceptor {
  final Dio dio;
  final Function(String) logPrint;
  final int maxRetries;
  
  RetryInterceptor({
    required this.dio,
    required this.logPrint,
    this.maxRetries = 3,
  });
  
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    var retries = err.requestOptions.extra['retries'] ?? 0;
    
    if (_shouldRetry(err) && retries < maxRetries) {
      retries += 1;
      logPrint('Retry attempt $retries for ${err.requestOptions.path}');
      
      // Create new request options for retry
      final options = Options(
        method: err.requestOptions.method,
        headers: err.requestOptions.headers,
      );
      
      // Add retry count to extra
      options.extra = {
        ...err.requestOptions.extra,
        'retries': retries,
      };
      
      // Retry the request
      try {
        final response = await dio.request(
          err.requestOptions.path,
          data: err.requestOptions.data,
          queryParameters: err.requestOptions.queryParameters,
          options: options,
        );
        return handler.resolve(response);
      } catch (e) {
        return super.onError(err, handler);
      }
    }
    
    return super.onError(err, handler);
  }
  
  bool _shouldRetry(DioException err) {
    // Don't retry requests with FormData as they cannot be reused
    if (err.requestOptions.data is FormData) {
      return false;
    }
    
    return err.type == DioExceptionType.connectionTimeout ||
           err.type == DioExceptionType.receiveTimeout ||
           err.type == DioExceptionType.connectionError ||
           err.type == DioExceptionType.badResponse && 
           (err.response?.statusCode == 500 || 
            err.response?.statusCode == 502 || 
            err.response?.statusCode == 503 || 
            err.response?.statusCode == 504);
  }
} 