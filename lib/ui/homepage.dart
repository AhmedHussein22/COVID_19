import 'dart:io';

import 'package:covid_19/models/data_repository.dart';
import 'package:covid_19/models/endpoints_data.dart';
import 'package:covid_19/providers/theme.dart';
import 'package:covid_19/services/api.dart';
import 'package:covid_19/ui/card.dart';
import 'package:covid_19/ui/last_updated_status_text.dart';
import 'package:covid_19/ui/show_alert_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  EndpointsData _endpointsData;

  @override
  void initState() {
    super.initState();
    final dataRepository = Provider.of<DataRepository>(context, listen: false);
    _endpointsData = dataRepository.getAllEndpointsCachedData();
    _updateData();
  }

  Future<void> _updateData() async {
    try {
      final dataRepository =
          Provider.of<DataRepository>(context, listen: false);
      final endpointsData = await dataRepository.getAllEndpointsData();
      setState(() => _endpointsData = endpointsData);
    } on SocketException catch (_) {
      showAlertDialog(
        context: context,
        title: 'Connection Error',
        content: 'Could not retrieve data. Please try again later.',
        defaultActionText: 'OK',
      );
    } catch (_) {
      showAlertDialog(
        context: context,
        title: 'Unknown Error',
        content: 'Please r try again later.',
        defaultActionText: 'OK',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeprovider = Provider.of<DarkMode>(context);
    final formatter = LastUpdatedDateFormatter(
      lastUpdated: _endpointsData != null
          ? _endpointsData.values[Endpoint.cases]?.date
          : null,
    );
    final double sizeheight = MediaQuery.of(context).size.height;
    var padding = MediaQuery.of(context).padding;
    return SafeArea(
      child: Scaffold(
        drawer: Container(
          width: MediaQuery.of(context).size.width * 0.6,
          child: Drawer(
            elevation: 10,
            child: ListView(
              children: [
                UserAccountsDrawerHeader(
                  decoration: BoxDecoration(),
                  accountName: Text(
                    "Developed by:",
                    style: TextStyle(
                      fontFamily: "Exo2",
                      color: Color(0xffe60000),
                    ),
                  ),
                  accountEmail: Text(
                    "Ahmed Hussein",
                    style: TextStyle(
                      fontFamily: "Exo2",
                      color: themeprovider.isdark ? Colors.white : Colors.black,
                      fontSize: 18,
                    ),
                  ),
                  currentAccountPicture: InkWell(
                    child: CircleAvatar(
                      radius: 30,
                      backgroundColor: Color(0xffe60000),
                      child: CircleAvatar(
                        radius: 34,
                        backgroundImage: AssetImage("assets/me.jpg"),
                      ),
                    ),
                  ),
                ),
                SwitchListTile(
                  value: themeprovider.isdark,
                  activeColor: Color(0xffe60000),
                  onChanged: (bool val) {
                    themeprovider.dodarkmode(val);
                  },
                  title: Text(
                    "Dark Theme",
                    style: TextStyle(
                      fontFamily: "Exo2",
                      color: themeprovider.isdark ? Colors.white : Colors.black,
                      fontSize: 16,
                    ),
                  ),
                ),

                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.1,
                ),
                Divider(),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    ListTile(
                      leading:
                          Icon(Icons.location_city, color: Color(0xffe60000)),
                      title: Text(
                        "MR Group",
                        style: TextStyle(
                            fontFamily: "Exo2",
                            color: themeprovider.isdark
                                ? Colors.white
                                : Colors.black),
                      ),
                    ),
                    Divider(),
                    ListTile(
                      leading:
                          Icon(Icons.location_on, color: Color(0xffe60000)),
                      title: Text("Egypt,Fayoum"),
                    ),
                    Divider(),
                    ListTile(
                    leading: Icon(Icons.info, color: Color(0xffe60000)),
                    title: Text("Version: 1.0.0", 
                    style: TextStyle(
                            fontFamily: "Exo2",
                            color: themeprovider.isdark
                                ? Colors.white
                                : Colors.black),
                    ),
                   
                  ),
                  Divider(),
                  ListTile(
                    leading: Icon(Icons.offline_pin, color: Color(0xffe60000)),
                    title: Text("License: Free",
                    style: TextStyle(
                            fontFamily: "Exo2",
                            color: themeprovider.isdark
                                ? Colors.white
                                : Colors.black),
                    ),
                    
                  ),
                  ],
                )
              ],
            ),
          ),
        ),
        appBar: AppBar(
          title: Text(
            "COVID-19",
            style: TextStyle(fontFamily: "Exo2"),
          ),
          actions: [
            InkWell(
              onTap: () async {
                themeprovider.isdark = !themeprovider.isdark;
                print(themeprovider.isdark);
                themeprovider.dodarkmode(themeprovider.isdark);
              },
              child: Row(
                children: [
                  Text(
                    themeprovider.isdark ? "Light Mode" : "Dark Mode",
                    style: TextStyle(
                      fontFamily: "Exo2",
                      color: themeprovider.isdark ? Colors.white : Colors.black,
                    ),
                  ),
                  SizedBox(
                    width: 3,
                  ),
                  Icon(
                    CupertinoIcons.circle_lefthalf_fill,
                    color: themeprovider.isdark ? Colors.white : Colors.black,
                  ),
                  SizedBox(
                    width: 5,
                  ),
                ],
              ),
            ),
          ],
          backgroundColor: Color(0xffe60000),
        ),
        body: RefreshIndicator(
          backgroundColor: Color(0xffe60000),
          color: Colors.white,
          strokeWidth: 3,
          onRefresh: _updateData,
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  height: sizeheight * 0.05,
                  child: LastUpdatedStatusText(
                    text: formatter.lastUpdatedStatusText(),
                  ),
                ),
                Container(
                  height: sizeheight - padding.top - padding.bottom,
                  child: GridView(
                    shrinkWrap: true,
                    physics: ScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: sizeheight * 0.01 / 8,
                    ),
                    children: <Widget>[
                      for (var endpoint in Endpoint.values)
                        EndpointCard(
                          endpoint: endpoint,
                          value: _endpointsData != null
                              ? _endpointsData.values[endpoint]?.value
                              : null,
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
