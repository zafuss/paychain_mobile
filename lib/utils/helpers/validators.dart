class Validators {
  static String? validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Vui lòng nhập tên của bạn';
    }
    return null;
  }

  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Vui lòng nhập email';
    }
    final emailRegex =
        RegExp(r'^[a-zA-Z0-9._%-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$');
    if (!emailRegex.hasMatch(value)) {
      return 'Email không hợp lệ';
    }
    return null;
  }

  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Vui lòng nhập mật khẩu';
    }
    if (value.length < 6) {
      return 'Mật khẩu phải có ít nhất 6 ký tự';
    }
    return null;
  }

  static String? validateOtp(String? value) {
    if (value == null || value.isEmpty) {
      return 'Mã OTP không được để trống';
    } else if (!RegExp(r'^\d{6}$').hasMatch(value)) {
      return 'Mã OTP phải bao gồm đúng 6 chữ số';
    }
    return null;
  }

  static String? validateConfirmPassword(
      String? password, String? confirmPassword) {
    if (confirmPassword == null || confirmPassword.isEmpty) {
      return 'Vui lòng nhập lại mật khẩu';
    }
    if (password != confirmPassword) {
      return 'Mật khẩu xác nhận không khớp';
    }
    return null;
  }

  static String? validateTransferAmount(
      double balanceValue, String? amountValue) {
    if (amountValue == null || amountValue.isEmpty) {
      return 'Vui lòng nhập số tiền cần chuyển';
    }

    final amount = double.tryParse(amountValue);

    if (amount == null) {
      return 'Số tiền cần chuyển phải là số hợp lệ';
    }
    if (amount <= 0) {
      return 'Số tiền cần chuyển phải lớn hơn 0';
    }
    if (amount > balanceValue) {
      return 'Số tiền cần chuyển không được vượt quá số dư';
    }
    return null;
  }
}
