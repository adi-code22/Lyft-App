import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:lyft/main.dart';
import 'package:lyft/model/api_post.dart';
import 'package:lyft/model/api_service.dart';
import 'package:lyft/model/constants.dart';
import 'package:lyft/model/market_model.dart';
import 'package:lyft/views/confirmation.dart';

class Booking extends StatefulWidget {
  const Booking(
      {Key? key,
      required this.distance,
      required this.pickUp,
      required this.drop})
      : super(key: key);

  final double distance;
  final LatLng pickUp;
  final LatLng drop;

  @override
  State<Booking> createState() => _BookingState();
}

class _BookingState extends State<Booking> {
  bool temp = false;
  double dist = 0;

  void initialisePost() async {
    await ApiServicePost().postInit("001", (dist * 30).round().toString(),
        widget.pickUp.toString(), widget.drop.toString());
  }

  late List<Bids>? _userModel = [];

  void _getData() async {
    _userModel = (await ApiService().getUsers())! as List<Bids>?;
    Future.delayed(const Duration(seconds: 1)).then((value) => setState(() {}));
  }

  void showNotification(String title, String body) {
    flutterLocalNotificationsPlugin.show(
        0,
        title,
        body,
        NotificationDetails(
            android: AndroidNotificationDetails(channel.id, channel.name,
                importance: Importance.high,
                color: Colors.blue,
                playSound: true,
                icon: '@mipmap/ic_launcher')));
  }

  @override
  void initState() {
    // TODO: implement initState
    _getData();
    super.initState();
    setState(() {
      dist = double.parse(widget.distance.toStringAsFixed(2));
    });
    Future.delayed(const Duration(milliseconds: 6000), () {
      setState(() {
        // Here you can write your code for open new view
        temp = true;
      });
    });

    initialisePost();
  }

  @override
  Widget build(BuildContext context) {
    showNotification(
        "Let's wait for bids!", "Chill!, let the drivers put in their bids");
    Future.delayed(const Duration(milliseconds: 5000), () {
      showNotification("Bids ready!", "Yeah!, you got 3 bids!");
    });
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 30,
        shadowColor: Colors.black26,
        centerTitle: true,
        title: RichText(
            text: TextSpan(
                style: GoogleFonts.poppins(
                    fontSize: 30, fontWeight: FontWeight.bold),
                children: [
              TextSpan(
                  text: "Book",
                  style: GoogleFonts.poppins(
                      color: Theme.of(context).primaryColorLight)),
              TextSpan(
                  text: "LyfT",
                  style: GoogleFonts.poppins(
                      color: Theme.of(context).primaryColor)),
            ])),
      ),
      body: SingleChildScrollView(
          child: Center(
        child: Container(
          width: 335,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 15.0),
                child: Text(
                  "Total distance to be covered:",
                  style: TextStyle(fontSize: 17),
                ),
              ),
              Text(
                "${double.parse(widget.distance.toStringAsFixed(2))} KM",
                style: TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).primaryColorLight),
              ),
              Text(
                "Max amount: Rs ${double.parse(widget.distance.toStringAsFixed(2)) * 30}",
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).primaryColorLight),
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  Text(
                    "finding nearest LyfT's  ",
                    style: TextStyle(fontSize: 20),
                  ),
                  Container(
                    height: 20,
                    width: 20,
                    child: temp
                        ? SizedBox()
                        : CircularProgressIndicator(
                            color: Theme.of(context).primaryColorLight,
                          ),
                  )
                ],
              ),
              SizedBox(
                height: 15,
              ),
              temp
                  ? Column(
                      children: [
                        Container(
                          width: 335,
                          height: 500,
                          child: ListView.builder(
                            itemCount: _userModel!.length,
                            itemBuilder: (context, index) {
                              return ListTile(
                                  isThreeLine: true,
                                  title: Row(
                                    children: [
                                      Text(
                                        _userModel![index].name + "      - ",
                                        style: TextStyle(fontSize: 20),
                                      ),
                                      Text(
                                        "Bid: ",
                                        style: TextStyle(fontSize: 15),
                                      ),
                                      Text("Rs." + _userModel![index].amount,
                                          style: TextStyle(
                                              fontSize: 20,
                                              color: Colors.green,
                                              fontWeight: FontWeight.bold))
                                    ],
                                  ),
                                  subtitle: Text(
                                    "⭐ 5.0 - Autorikshaw ACE\nVehicle No. ${_userModel![index].vehicleNo}",
                                    style: TextStyle(fontSize: 15),
                                  ),
                                  trailing: Container(
                                    height: 20,
                                    width: 100,
                                    child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                            primary:
                                                Theme.of(context).primaryColor),
                                        onPressed: () {
                                          Navigator.pushReplacement(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    Confirmation(
                                                        price: dist * 30,
                                                        name: _userModel![index]
                                                            .name),
                                              ));
                                        },
                                        child: Text(
                                          "CONFIRM",
                                          style: TextStyle(
                                              color: Theme.of(context)
                                                  .primaryColorLight),
                                        )),
                                  ));
                            },
                          ),
                        )
                      ],
                    )
                  : SizedBox(),
            ],
          ),
        ),
      )),
    );
  }
}
