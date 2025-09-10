import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:my_first_app/config/config.dart';
import 'package:my_first_app/model/req/customerRegisterpostRequest.dart';
import 'package:my_first_app/page/login.dart';
import 'package:my_first_app/page/showtrip.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _nameState();
}

class _nameState extends State<RegisterPage> {
  TextEditingController name = TextEditingController();
  TextEditingController phone = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController confirmpassword = TextEditingController();
  String url = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('ลงทะเบียนสมาชิกใหม่')),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 15.0, left: 25),
                  child: Text('ชื่อ-นามสกุล', style: TextStyle(fontSize: 12)),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(top: 5.0, left: 25, right: 25),
              child: TextField(
                controller: name,
                decoration: InputDecoration(border: OutlineInputBorder()),
              ),
            ),
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 15.0, left: 25),
                  child: Text(
                    'หลายเลขโทรศัพท์',
                    style: TextStyle(fontSize: 12),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(top: 5.0, left: 25, right: 25),
              child: TextField(
                controller: phone,
                decoration: InputDecoration(border: OutlineInputBorder()),
              ),
            ),
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 15.0, left: 25),
                  child: Text('อีเมลล์', style: TextStyle(fontSize: 12)),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(top: 5.0, left: 25, right: 25),
              child: TextField(
                controller: email,
                decoration: InputDecoration(border: OutlineInputBorder()),
              ),
            ),
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 15.0, left: 25),
                  child: Text('รหัสผ่าน', style: TextStyle(fontSize: 12)),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(top: 5.0, left: 25, right: 25),
              child: TextField(
                controller: password,
                decoration: InputDecoration(border: OutlineInputBorder()),
              ),
            ),
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 15.0, left: 25),
                  child: Text('ยืนยันรหัสผ่าน', style: TextStyle(fontSize: 12)),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(top: 5.0, left: 25, right: 25),
              child: TextField(
                controller: confirmpassword,
                decoration: InputDecoration(border: OutlineInputBorder()),
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: FilledButton(
                    onPressed: register,
                    child: const Text('สมัครสมาชิก'),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    TextButton(
                      onPressed: register,
                      child: const Text(
                        'หากมีบัญชีอยู่แล้ว?',
                        style: TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
                      ),
                    ),
                    TextButton(
                      onPressed: login,
                      child: const Text('เข้าสู่ระบบ'),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    Configuration.getConfig().then((config) {
      url = config['apiEndpoint'];
    });
  }

  void back() {
    Navigator.pop(context);
  }

  void register() {
    CustomerRegisterPostRequest req = CustomerRegisterPostRequest(
      fullname: name.text,
      phone: phone.text,
      email: email.text,
      image: '',
      password: password.text,
      confirmpassword: confirmpassword.text,
    );

    if (req.password != req.confirmpassword) {
      log("ใส่รหัสไม่ถูก");
    } else if (req.fullname.isEmpty ||
        req.phone.isEmpty ||
        req.email.isEmpty ||
        req.password.isEmpty ||
        req.confirmpassword.isEmpty) {
      log("กรอกข้อมูลไม่ครบ");
    } else {
      http
          .post(
            Uri.parse("$url/customers"),
            headers: {"Content-Type": "application/json; charset=utf-8"},
            body: jsonEncode(req),
          )
          .then((value) {
            log(value.body);
          })
          .catchError((error) {
            log('Error $error');
          });
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => LoginPage()),
      );
    }
  }

  void login() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()),
    );
  }
}
