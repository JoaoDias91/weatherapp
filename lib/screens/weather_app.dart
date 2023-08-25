import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

import '../model/constants.dart';
import '../services/geolocation.dart';

class WeatherApp extends StatefulWidget {
  const WeatherApp({super.key});

  @override
  State<WeatherApp> createState() => _WeatherAppState();
}

class _WeatherAppState extends State<WeatherApp> {
  Geolocation geolocation = Geolocation();
  var controller = TextEditingController();
  String content = "";
  Future<Position>? futurePosition;
  Future<bool>? serviceEnabledFuture;
  bool serviceEnabled = false;

  static const List<Tab> myTabs = <Tab>[
    Tab(text: Constants.CURRENT),
    Tab(text: Constants.TODAY),
    Tab(text: Constants.WEEKLY)
  ];
  

  @override
  void initState() {
    serviceEnabledFuture = geolocation.geolocationServiceEnabled();
    serviceEnabledFuture?.then((value) => serviceEnabled = value);
    super.initState();
  }
  
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      darkTheme: ThemeData.dark(useMaterial3: false),
      home: DefaultTabController(
        initialIndex: 0,
        length: 3,
        child: Scaffold(
            appBar: AppBar(
              leading: const Icon(Icons.search),
              title: TextField(
                controller: controller,
                onSubmitted: (value) {
                  setState(() {
                    content = controller.text;
                  });
                },
              ),
              actions: [
                IconButton(
                    onPressed: () {
                        if(serviceEnabled){
                          futurePosition = geolocation.getUserPosition();
                          setState(() {
                          futurePosition?.then((value) {
                            content = "${value.latitude} ${value.longitude}";
                          });
                        });
                        }else{
                          setState(() {
                            content = "Geolocation is disabled. Please enable it in you phone settings";
                          });
                        }
                    }, 
                    icon: const Icon(Icons.send_rounded))
              ],
            ),
            body: TabBarView(
              children: myTabs.map((Tab tab) {
                final String label = tab.text!.toLowerCase();
                return Center(
                  child: Text(
                    serviceEnabled? '$label\n$content' : content,
                    style: const TextStyle(fontSize: 36),
                  ),
                );
              }).toList(),
            ),
            bottomNavigationBar: const TabBar(
              labelColor: Colors.black,
              tabs: <Widget>[
                Tab(
                    icon: Icon(
                      Icons.brightness_5_sharp,
                      color: Colors.blueGrey,
                    ),
                    text: Constants.CURRENT),
                Tab(
                    icon: Icon(
                      Icons.calendar_today,
                      color: Colors.blueGrey,
                    ),
                    text: Constants.TODAY),
                Tab(
                    icon: Icon(
                      Icons.calendar_month,
                      color: Colors.blueGrey,
                    ),
                    text: Constants.WEEKLY),
              ],
            )),
      ),
    );
  }
}
