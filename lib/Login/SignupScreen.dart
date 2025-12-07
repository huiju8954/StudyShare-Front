// SignupScreen.dart

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _nicknameController = TextEditingController();
  final TextEditingController _password1Controller = TextEditingController();
  final TextEditingController _password2Controller = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  bool _registrationAgreed = false;

  static const String _signupUrl = 'http://localhost:8081/member/signup';

  Future<void> _signup() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    if (_password1Controller.text != _password2Controller.text) {
      _showSnackBar('두 비밀번호가 일치하지 않습니다.');
      return;
    }

    if (!_registrationAgreed) {
      _showSnackBar('약관 동의가 필요합니다.');
      return;
    }

    final Map<String, dynamic> data = {
      'username': _usernameController.text,
      'nickname': _nicknameController.text, // 닉네임 필드 전송
      'password1': _password1Controller.text,
      'password2': _password2Controller.text,
      'email': _emailController.text,
      'registration': _registrationAgreed,
    };

    try {
      final response = await http.post(
        Uri.parse(_signupUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(data),
      );

      if (response.statusCode == 201) {
        _showSnackBar('회원가입에 성공했습니다! 로그인 화면으로 이동합니다.');
        Navigator.pop(context);
      } else if (response.statusCode == 409) {
        _showSnackBar('회원가입 실패: 이미 사용 중인 ID, 닉네임 또는 이메일입니다.');
      } else if (response.statusCode == 400) {
        _showSnackBar('회원가입 실패: ${response.body}');
      } else {
        _showSnackBar(
            '회원가입 중 알 수 없는 오류가 발생했습니다. (Status: ${response.statusCode})');
      }
    } catch (e) {
      print('회원가입 네트워크 오류: $e');
      _showSnackBar('네트워크 오류가 발생했습니다. 서버가 실행 중인지 확인하세요.');
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  Widget _buildInputField(String hint, TextEditingController controller,
      {bool obscure = false, String? Function(String?)? validator}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: TextFormField(
        controller: controller,
        obscureText: obscure,
        decoration: InputDecoration(
          labelText: hint,
          border: const OutlineInputBorder(),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
        ),
        validator: validator,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Center(
            child: Container(
              constraints: const BoxConstraints(maxWidth: 450),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // 상단 여백 추가 (전체 콘텐츠를 아래로 이동)
                    const SizedBox(height: 50),

                    Image.asset('assets/StudyShare_Logo.png', height: 60),
                    const SizedBox(height: 30), // 로고와 폼 간격

                    const Text('회원정보를 입력해주세요.',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                    const Divider(height: 30),

                    _buildInputField('사용자 ID', _usernameController,
                        validator: (val) => val == null || val.length < 3
                            ? 'ID는 3자 이상 필수입니다.'
                            : null),
                    _buildInputField('닉네임', _nicknameController,
                        validator: (val) => val == null || val.length < 2
                            ? '닉네임은 2자 이상 필수입니다.'
                            : null), // ⭐️ 닉네임 입력 필드
                    _buildInputField('비밀번호', _password1Controller,
                        obscure: true,
                        validator: (val) => val == null || val.length < 4
                            ? '비밀번호는 4자 이상이어야 합니다.'
                            : null),
                    _buildInputField('비밀번호 확인', _password2Controller,
                        obscure: true,
                        validator: (val) => _password1Controller.text != val
                            ? '비밀번호가 일치하지 않습니다.'
                            : null),
                    _buildInputField('이메일', _emailController,
                        validator: (val) => val == null ||
                                !RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(val)
                            ? '유효한 이메일 형식이 아닙니다.'
                            : null),

                    Padding(
                      padding: const EdgeInsets.only(bottom: 20.0),
                      child: Row(
                        children: [
                          Checkbox(
                            value: _registrationAgreed,
                            onChanged: (bool? newValue) {
                              setState(() {
                                _registrationAgreed = newValue!;
                              });
                            },
                          ),
                          const Text('스터디쉐어 이용 약관에 동의합니다.'),
                        ],
                      ),
                    ),

                    const SizedBox(height: 30),

                    ElevatedButton(
                      onPressed: _signup,
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 50),
                        backgroundColor: const Color(0xFFFFC107),
                        foregroundColor: Colors.white,
                      ),
                      child: const Text('회원가입 완료',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _nicknameController.dispose();
    _password1Controller.dispose();
    _password2Controller.dispose();
    _emailController.dispose();
    super.dispose();
  }
}
