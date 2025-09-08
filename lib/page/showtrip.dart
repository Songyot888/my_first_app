import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:my_first_app/config/config.dart';
import 'package:my_first_app/model/req/tripGetResponseFromJson.dart';
import 'package:my_first_app/model/res/trip_get_res.dart';
import 'package:my_first_app/page/profile.dart';
import 'package:my_first_app/page/trip.dart';

class Showtrip extends StatefulWidget {
  int cid = 0;
  Showtrip({super.key, required this.cid});
  @override
  State<Showtrip> createState() => _nameState();
}

// ignore: camel_case_types
class _nameState extends State<Showtrip> {
  String url = '';
  List<TripGetResponseFromJson> trips = [];
  List<TripGetResponseFromJson> tp_temp = [];
  late Future<void> loadData;

  @override
  void initState() {
    super.initState();
    loadData = loadDataAsync();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('รายการทริป'),
        automaticallyImplyLeading: false,
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              log(value);
              if (value == 'profile') {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ProfilePage(idx:widget.cid,)),
                );
              } else if (value == 'logout') {
                Navigator.of(context).popUntil((route) => route.isFirst);
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem<String>(
                value: 'profile',
                child: Text('ข้อมูลส่วนตัว'),
              ),
              const PopupMenuItem<String>(
                value: 'logout',
                child: Text('ออกจากระบบ'),
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
          return Column(
            children: [
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Text('ปลายทาง'),
                  ),
                ],
              ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: FilledButton(
                        onPressed: getTrips,
                        child: const Text('ทั้งหมด'),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: FilledButton(
                        onPressed: () => getTrips_Zone('เอเชีย'),
                        child: const Text('เอชีย'),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: FilledButton(
                        onPressed: () => getTrips_Zone('ยุโรป'),
                        child: const Text('ยุโรป'),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: FilledButton(
                        onPressed: () => getTrips_Zone('ประเทศไทย'),
                        child: const Text('ไทย'),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(5),
                      child: FilledButton(
                        onPressed: () =>
                            getTrips_Zone('เอเชียตะวันออกเฉียงใต้'),
                        child: const Text('อาเซียน'),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      children: trips
                          .map(
                            (trip) => Card(
                              child: Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          trip.name,
                                          style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Row(
                                          children: [
                                            trip.coverimage != null &&
                                                    trip.coverimage.isNotEmpty
                                                ? Image.network(
                                                    trip.coverimage,
                                                    width: 200,
                                                    height: 130,
                                                    fit: BoxFit.cover,
                                                    errorBuilder:
                                                        (
                                                          context,
                                                          error,
                                                          stackTrace,
                                                        ) => Container(
                                                          width: 200,
                                                          height: 130,
                                                          color: Colors.white,
                                                        ),
                                                  )
                                                : Container(),
                                            const SizedBox(width: 10),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(trip.country),
                                                Text(
                                                  'ระยะเวลา ${trip.duration} วัน',
                                                ),
                                                Text('ราคา ${trip.price} บาท'),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                        top: 8.0,
                                                      ),
                                                  child: FilledButton(
                                                    style: FilledButton.styleFrom(
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                            horizontal: 10,
                                                          ),
                                                      textStyle: TextStyle(
                                                        fontSize: 16,
                                                      ),
                                                    ),
                                                    onPressed: () =>
                                                        about(trip.idx),
                                                    child: Text(
                                                      'รายละเอียดเพิ่มเติม ',
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                          .toList(),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  getTrips() async {
    var res = await http.get(Uri.parse('$url/trips'));
    log(res.body);

    setState(() {
      trips = tripGetResponseFromJsonFromJson(res.body);
    });
  }

  Future<void> loadDataAsync() async {
    var config = await Configuration.getConfig();
    url = config['apiEndpoint'];
    var res = await http.get(Uri.parse('$url/trips'));
    log(res.body);
    trips = tripGetResponseFromJsonFromJson(res.body);
    tp_temp = trips;
    log(trips.length.toString());
  }

  getTrips_Zone(String zone) async {
    List<TripGetResponseFromJson> tp = [];
    for (var t in tp_temp) {
      if (t.destinationZone == zone) {
        tp.add(t);
        log('${t.destinationZone}${t.country}');
      }
      setState(() {
        trips = tp;
      });
    }
  }

  void about(int id) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => TripPage(id: id)),
    );
  }
}
