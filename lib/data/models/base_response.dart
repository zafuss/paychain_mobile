sealed class BaseResponse<T> {}

class Success<T> extends BaseResponse<T> {
  Success([this.data, this.message, this.statusCode = 200]);
  final T? data;
  final String? message;
  final int statusCode;
}

class Failure<T> extends BaseResponse<T> {
  Failure({this.message = "", this.statusCode = 200});
  final String message;
  final int statusCode;
}
