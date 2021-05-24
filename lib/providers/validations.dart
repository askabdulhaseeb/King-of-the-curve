import 'package:flutter/material.dart';
import 'package:kings_of_the_curve/models/validation_item.dart';

class Validations with ChangeNotifier {
  ValidationItem _firstName = ValidationItem(error: 'First name is required');
  ValidationItem _lastName = ValidationItem(error: 'Last name is required');
  ValidationItem _phoneNumber =
  ValidationItem(error: 'Phone number is required');
  ValidationItem _password = ValidationItem(error: 'Password is required');
  ValidationItem _confirmPassword =
  ValidationItem(error: 'confirm password is required');
  ValidationItem _username = ValidationItem(error: 'Username is required');
  ValidationItem _verificationCode =
  ValidationItem(error: 'Verification code is required');
  ValidationItem _email = ValidationItem(error: 'Email is required');

  ValidationItem get firstName => _firstName;

  ValidationItem get lastName => _lastName;

  ValidationItem get phoneNumber => _phoneNumber;

  ValidationItem get password => _password;

  ValidationItem get userName => _username;

  ValidationItem get confirmPassword => _confirmPassword;

  ValidationItem get verificationCode => _verificationCode;
  ValidationItem get email =>_email;

  bool get isSignUpValid {
    if (_username.value != null &&
        _email.value != null &&
        /*_phoneNumber.value != null &&*/
        _password.value != null &&
        _confirmPassword.value != null) {
      return true;
    } else {
      return false;
    }
  }

  bool get isSignInValid {
    if (/*_username*/_email.value != null && _password.value != null) {
      return true;
    } else {
      return false;
    }
  }

  bool get isResetPasswordValid {
    if (_password.value != null && _confirmPassword.value != null) {
      return true;
    } else {
      return false;
    }
  }

  bool get isVerificationCodeValid {
    if (_verificationCode.value != null) {
      return true;
    } else {
      return false;
    }
  }

  bool get isPhoneNumberValid {
    if (_phoneNumber.value != null) {
      return true;
    } else {
      return false;
    }
  }

  void changeFirstName(String value) {
    String firstName = value.trim();
    if (firstName.length < 1) {
      _firstName = ValidationItem(
          error: 'First name is required',
          isValidating: _firstName.isValidating);
    } else {
      if (firstName.length >= 2) {
        _firstName = ValidationItem(
            value: firstName, isValidating: _firstName.isValidating);
      } else {
        _firstName = ValidationItem(
            error: 'First name is too short',
            isValidating: _firstName.isValidating);
      }
    }
    notifyListeners();
  }

  void changeUserName(String value) {
    String userName = value.trim();
    if (userName.length < 1) {
      _username = ValidationItem(
          error: 'Username is required', isValidating: _username.isValidating);
    } else {
      if (userName.length >= 2) {
        _username = ValidationItem(
            value: userName, isValidating: _username.isValidating);
      } else {
        _username = ValidationItem(
            error: 'Username is too short',
            isValidating: _username.isValidating);
      }
    }
    notifyListeners();
  }


  void changeLastName(String value) {
    String lastName = value.trim();
    if (lastName.length < 1) {
      _lastName = ValidationItem(
          error: 'Last name is required', isValidating: _lastName.isValidating);
    } else {
      if (lastName.length >= 2) {
        _lastName = ValidationItem(
            value: lastName, isValidating: _lastName.isValidating);
      } else {
        _lastName = ValidationItem(
            error: 'Last name is too short',
            isValidating: _lastName.isValidating);
      }
    }
    notifyListeners();
  }

  void changeEmail(String value) {
    String email = value.trim();
    if (email.length < 1) {
      _email = ValidationItem(
          error: 'Email is required', isValidating: _email.isValidating);
    }
    else {
      if (!RegExp(
          r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
          .hasMatch(email)) {
        _email = ValidationItem(error: 'Email format is invalid',
            isValidating: _email.isValidating);
      }
      else {
        _email = ValidationItem(
            value: email, isValidating: _email.isValidating);
      }
    }
    notifyListeners();
  }

    void changePhoneNumber(String value) {
      String number = value.trim();
      if (number.length < 1) {
        _phoneNumber = ValidationItem(
            error: 'Phone number is required',
            isValidating: _phoneNumber.isValidating);
      } else {
        try {
          int.parse(number);
          if (number.startsWith('07') && number.length == 10) {
            _phoneNumber = ValidationItem(
                value: number, isValidating: _phoneNumber.isValidating);
          } else if (number.startsWith('2507') && number.length == 12) {
            _phoneNumber = ValidationItem(
                value: number, isValidating: _phoneNumber.isValidating);
          } else {
            _phoneNumber = ValidationItem(
                error: 'Phone number is invalid',
                isValidating: _phoneNumber.isValidating);
          }
        } catch (_) {
          _phoneNumber = ValidationItem(
              error: 'Phone number must be a number',
              isValidating: _phoneNumber.isValidating);
        }
      }
      notifyListeners();
    }

    void changePassword(String value) {
      String password = value.trim();
      if (password.length < 1) {
        _password = ValidationItem(
            error: 'Password is required',
            isValidating: _password.isValidating);
      } else {
        if (password.length < 6) {
          _password = ValidationItem(
              error: 'Password must have at least 6 characters',
              isValidating: _password.isValidating);
        } else {
          RegExp upperCaseRegExp = new RegExp(r'^(?=.*[A-Z])');
          RegExp lowerCaseRegExp = new RegExp(r'^(?=.*[a-z])');
          RegExp numericOrSpecialCharRegExp =
          new RegExp(r'^(?:(.*[0-9])|(.*[!@#$&*^-_=+<>?.%]))');
          if (!upperCaseRegExp.hasMatch(password)) {
            _password = ValidationItem(
              error: 'Password must have at least one uppercase letter',
              isValidating: _password.isValidating,
            );
          } else if (!lowerCaseRegExp.hasMatch(password)) {
            _password = ValidationItem(
              error: 'Password must have at least one lowercase letter',
              isValidating: _password.isValidating,
            );
          } else if (!numericOrSpecialCharRegExp.hasMatch(password)) {
            _password = ValidationItem(
              error: 'Password must have at least one number or one symbol',
              isValidating: _password.isValidating,
            );
          } else {
            _password = ValidationItem(
              value: password,
              isValidating: _password.isValidating,
            );
          }
        }
      }
      notifyListeners();
    }

    void changeConfirmPassword(String value) {
      String confirmPassword = value.trim();
      if (confirmPassword.length < 1) {
        _confirmPassword = ValidationItem(
            error: 'confirm password is required',
            isValidating: _confirmPassword.isValidating);
      } else {
        if (confirmPassword == _password.value) {
          _confirmPassword = ValidationItem(
              value: confirmPassword,
              isValidating: _confirmPassword.isValidating);
        } else {
          _confirmPassword = ValidationItem(
              error: 'Password must match',
              isValidating: _confirmPassword.isValidating);
        }
      }
      notifyListeners();
    }

    void changeVerificationCode(String value) {
      String verificationCode = value.trim();
      if (verificationCode.length < 1) {
        _verificationCode = ValidationItem(
            error: 'Verification code is required',
            isValidating: _verificationCode.isValidating);
      } else {
        _verificationCode = ValidationItem(
            value: verificationCode,
            isValidating: _verificationCode.isValidating);
      }
      notifyListeners();
    }

    void changeValidationStatus(String value) {
      switch (value) {
        case 'firstName':
          _firstName = ValidationItem(
            isValidating: true,
            value: _firstName.value,
            error: _firstName.error,
          );
          break;
        case 'lastName':
          _lastName = ValidationItem(
            isValidating: true,
            value: _lastName.value,
            error: _lastName.error,
          );
          break;
        case 'phoneNumber':
          _phoneNumber = ValidationItem(
            isValidating: true,
            value: _phoneNumber.value,
            error: _phoneNumber.error,
          );
          break;
        case 'password':
          _password = ValidationItem(
            isValidating: true,
            value: _password.value,
            error: _password.error,
          );
          break;
        case 'confirmPassword':
          _confirmPassword = ValidationItem(
            isValidating: true,
            value: _confirmPassword.value,
            error: _confirmPassword.error,
          );
          break;
        case 'verificationCode':
          _verificationCode = ValidationItem(
            isValidating: true,
            value: _verificationCode.value,
            error: _verificationCode.error,
          );
          break;

        case 'username':
          _username = ValidationItem(
            isValidating: true,
            value: _username.value,
            error: _username.error,
          );
          break;
        case 'email':
          _email = ValidationItem(
            isValidating: true,
            value: _email.value,
            error: _email.error,
          );
          break;
      }
      notifyListeners();
    }

    void resetValidation() {
      _firstName = ValidationItem(error: 'First name is required');
      _lastName = ValidationItem(error: 'Last name is required');
      _phoneNumber = ValidationItem(error: 'Phone number is required');
      _password = ValidationItem(error: 'Password is required');
      _confirmPassword = ValidationItem(error: 'confirm password is required');
      _verificationCode = ValidationItem(error: 'Verification code is required');
      _username = ValidationItem(error: 'Username is required');
      _email = ValidationItem(error: 'Email is required');
      notifyListeners();
    }

}
