import 'package:dio/dio.dart';

class Failure {
  final String message;

  Failure(this.message);
}

class ServerFailure extends Failure {
  ServerFailure(super.message);

  factory ServerFailure.fromDioException(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
        return ServerFailure('Connection timeout with API server');
      case DioExceptionType.sendTimeout:
        return ServerFailure('Send timeout with API server');
      case DioExceptionType.receiveTimeout:
        return ServerFailure('Receive timeout with API server');
      case DioExceptionType.badCertificate:
        return ServerFailure('Bad certificate from API server');
      case DioExceptionType.badResponse:
        return ServerFailure.fromResponse(
          e.response?.statusCode ?? 0,
          e.response?.data,
        );
      case DioExceptionType.cancel:
        return ServerFailure('Request to API server was cancelled');
      case DioExceptionType.connectionError:
        return ServerFailure('No internet connection');
      case DioExceptionType.unknown:
        return ServerFailure('Unexpected error occurred. Please try again');
      case DioExceptionType.transformTimeout:
        return ServerFailure('Transform timeout with API server');
    }
  }

  factory ServerFailure.fromResponse(int statusCode, dynamic response) {
    if (statusCode == 404) {
      return ServerFailure('Your request was not found, please try later');
    } else if (statusCode == 500) {
      return ServerFailure('There is a problem with server, please try later');
    }

    String message = 'There was an error, please try again';

    if (response is Map<String, dynamic>) {
      if (response['message'] is String &&
          (response['message'] as String).isNotEmpty) {
        message = response['message'] as String;
      }

      if ((message == 'There was an error, please try again') &&
          response['errors'] is Map<String, dynamic>) {
        final errors = response['errors'] as Map<String, dynamic>;
        if (errors.isNotEmpty) {
          final firstErrorEntry = errors.entries.first.value;
          if (firstErrorEntry is List && firstErrorEntry.isNotEmpty) {
            message = firstErrorEntry.first.toString();
          } else if (firstErrorEntry is String) {
            message = firstErrorEntry;
          }
        }
      }

      if ((message == 'There was an error, please try again') &&
          response['error'] is Map<String, dynamic>) {
        final errorMap = response['error'] as Map<String, dynamic>;
        if (errorMap['message'] is String &&
            (errorMap['message'] as String).isNotEmpty) {
          message = errorMap['message'] as String;
        }
      }
    }

    return ServerFailure(message);
  }
}
