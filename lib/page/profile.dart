import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:my_first_app/config/config.dart';
import 'package:my_first_app/model/res/ProfileidxProfilePrsponse.dart';

// ignore: must_be_immutable
class ProfilePage extends StatefulWidget {
  int idx = 0;
  ProfilePage({super.key, required this.idx});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String url = '';
  // ignore: non_constant_identifier_names
  late ProfileGetIdRes profileres;
  late Future<void> loadData;

  TextEditingController nameCtl = TextEditingController();
  TextEditingController phoneCtl = TextEditingController();
  TextEditingController emailCtl = TextEditingController();
  TextEditingController imageCtl = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadData = loadDataAsync();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ข้อมูลส่วนตัว'),
        actions: [
          PopupMenuButton<String>(
            onSelected: delete,
            itemBuilder: (context) => [
              const PopupMenuItem<String>(
                value: 'delete',
                child: Text('ยกเลิกสมาชิก'),
              ),
            ],
          ),
        ],
      ),
      body: FutureBuilder(
        future: loadData,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return Center(child: const CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('เกิดข้อผิดพลาด: ${snapshot.error}'));
          }
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: CircleAvatar(
                    radius: 80,
                    backgroundImage: NetworkImage(profileres.image),
                    onBackgroundImageError: (exception, stackTrace) {
                      setState(() {});
                    },
                  ),
                ),
                const SizedBox(height: 24),

                Text('ชื่อ-นามสกุล', style: TextStyle(fontSize: 18)),
                TextField(controller: nameCtl),
                const SizedBox(height: 16),

                Text('หมายเลขโทรศัพท์', style: TextStyle(fontSize: 18)),
                TextField(
                  controller: phoneCtl,
                  keyboardType: TextInputType.phone,
                ),
                SizedBox(height: 16),

                Text('อีเมลล์', style: TextStyle(fontSize: 18)),
                TextField(
                  controller: emailCtl,
                  keyboardType: TextInputType.emailAddress,
                ),
                SizedBox(height: 16),

                Text('รูปภาพ', style: TextStyle(fontSize: 18)),
                TextField(controller: imageCtl),

                SizedBox(height: 24),
                Center(
                  child: FilledButton(
                    onPressed: update,
                    child: const Text('บันทึกข้อมูล'),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Future<void> loadDataAsync() async {
    var config = await Configuration.getConfig();
    url = config['apiEndpoint'];
    var res = await http.get(Uri.parse('$url/customers/${widget.idx}'));
    log(res.body);
    profileres = profileGetIdResFromJson(res.body);

    nameCtl.text = profileres.fullname;
    phoneCtl.text = profileres.phone;
    emailCtl.text = profileres.email;
    imageCtl.text = profileres.image;
  }

  void update() async {
    var config = await Configuration.getConfig();
    url = config['apiEndpoint'];
    var json = {
      "fullname": nameCtl.text,
      "phone": phoneCtl.text,
      "email": emailCtl.text,
      "image": imageCtl.text,
    };
    try {
      var res = await http.put(
        Uri.parse('$url/customers/${widget.idx}'),
        headers: {"Content-Type": "application/json; charset=utf-8"},
        body: jsonEncode(json),
      );
      log(res.body);
      var result = jsonDecode(res.body);
      // Need to know json's property by reading from API Tester
      log(result['message']);
      if (res.statusCode == 200) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('สำเร็จ'),
            content: Text('ลบข้อมูลสำเร็จ'),
            actions: [
              FilledButton(
                onPressed: () {
                  Navigator.popUntil(context, (route) => route.isFirst);
                },
                child: const Text('ปิด'),
              ),
            ],
          ),
        ).then((s) {
          Navigator.popUntil(context, (route) => route.isFirst);
        });
      } else {
        Navigator.pop(context);
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('ผิดพลาด'),
            content: Text('ลบข้อมูลไม่สำเร็จ'),
            actions: [
              FilledButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('ปิด'),
              ),
            ],
          ),
        );
      }
    } catch (err) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('ผิดพลาด'),
          content: Text('บันทึกข้อมูลไม่สำเร็จ ' + err.toString()),
          actions: [
            FilledButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('ปิด'),
            ),
          ],
        ),
      );
    }
    setState(() {
      loadData = loadDataAsync();
    });
  }

  void delete(String value) async {
    var config = await Configuration.getConfig();
    url = config['apiEndpoint'];
    log(value);

    try {
      var res = await http.delete(
        Uri.parse('$url/customers/${widget.idx}'),
        headers: {"Content-Type": "application/json; charset=utf-8"},
      );
      log(res.statusCode.toString());
      showDialog(
        context: context,
        builder: (context) => SimpleDialog(
          title: const Text('สำเร็จ'),
          contentPadding: const EdgeInsets.all(16),
          children: [
            Text('ยกเลิกสมาชิกเรียบร้อย'),
            Align(
              alignment: Alignment.centerRight,
              child: FilledButton(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
                child: const Text('ปิด'),
              ),
            ),
          ],
        ),
      );
    } catch (e) {
      log('Error: $e');
    }
  }
}
