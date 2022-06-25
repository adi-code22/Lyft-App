import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lyft/views/confirmation.dart';

class Booking extends StatefulWidget {
  const Booking({Key? key, required this.distance}) : super(key: key);

  final double distance;
  @override
  State<Booking> createState() => _BookingState();
}

class _BookingState extends State<Booking> {
  bool temp = false;
  double dist = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(const Duration(milliseconds: 5000), () {
      setState(() {
        // Here you can write your code for open new view
        temp = true;
        dist = double.parse(widget.distance.toStringAsFixed(2));
      });
    });
  }

  @override
  Widget build(BuildContext context) {
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
              SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  Text(
                    "finding nearest LyfTs  ",
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
                        ListTile(
                          isThreeLine: true,
                          title: Row(
                            children: [
                              Text(
                                "Ajil Ibrahim ",
                                style: TextStyle(fontSize: 20),
                              ),
                              Container(
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
                                                Confirmation(price: dist * 30),
                                          ));
                                    },
                                    child: Text(
                                      "CONFIRM",
                                      style: TextStyle(
                                          color: Theme.of(context)
                                              .primaryColorLight),
                                    )),
                              )
                            ],
                          ),
                          subtitle: Text(
                            "⭐ 5.0 - Autorikshaw ACE\nPrice = Rs. ${double.parse((dist * 30).toString()).toStringAsFixed(2)}",
                            style: TextStyle(fontSize: 15),
                          ),
                          trailing: CircleAvatar(
                            radius: 20,
                            backgroundColor:
                                Theme.of(context).primaryColorLight,
                            child: Icon(
                              Icons.account_circle,
                              color: Colors.white,
                              size: 40,
                            ),
                          ),
                        ),
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
