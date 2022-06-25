import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';

class Confirmation extends StatefulWidget {
  const Confirmation({Key? key, required this.price}) : super(key: key);

  final double price;
  @override
  State<Confirmation> createState() => _ConfirmationState();
}

class _ConfirmationState extends State<Confirmation> {
  bool temp = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    Future.delayed(const Duration(milliseconds: 3000), () {
      setState(() {
        // Here you can write your code for open new view
        temp = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: temp ? Colors.white : Colors.black,
      appBar: AppBar(
        centerTitle: true,
        leadingWidth: 0,
        title: RichText(
            text: TextSpan(
                style: GoogleFonts.poppins(
                    fontSize: 25, fontWeight: FontWeight.bold),
                children: [
              TextSpan(
                  text: "Booking",
                  style: GoogleFonts.poppins(
                      color: Theme.of(context).primaryColorLight)),
              TextSpan(
                  text: "Confirmation",
                  style: GoogleFonts.poppins(
                      color: Theme.of(context).primaryColor)),
            ])),
        backgroundColor: temp ? Colors.white : Colors.black,
        elevation: 30,
        shadowColor: Colors.black26,
      ),
      body: !temp
          ? Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SpinKitFadingCube(
                  color: Theme.of(context).primaryColorLight,
                  size: 50,
                ),
                SizedBox(height: 40),
                Text(
                  "Confirming your LyfT",
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).primaryColorLight),
                ),
              ],
            )
          : SingleChildScrollView(
              child: Center(
                child: Container(
                  width: 335,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Align(
                          alignment: Alignment.center,
                          child: Text(
                            "- LyfT Booked -",
                            style: TextStyle(
                                fontSize: 30,
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).primaryColor),
                          ),
                        ),
                      ),
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
                                      primary: Theme.of(context).primaryColor),
                                  onPressed: () {
                                    // Navigator.push(
                                    //     context,
                                    //     MaterialPageRoute(
                                    //       builder: (context) =>
                                    //           Confirmation(),
                                    //     ));
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
                            "⭐ 5.0 - Autorikshaw ACE\nPrice = Rs. ${double.parse(widget.price.toString()).toStringAsFixed(2)}"),
                        trailing: CircleAvatar(
                          radius: 20,
                          backgroundColor: Theme.of(context).primaryColorLight,
                          child: Icon(
                            Icons.account_circle,
                            color: Colors.white,
                            size: 40,
                          ),
                        ),
                      ),
                      ListTile(
                        title: Text("Name"),
                        trailing: Text(
                          "Ajil Ibrahim",
                          style: TextStyle(color: Colors.green, fontSize: 25),
                        ),
                      ),
                      ListTile(
                        title: Text("Price"),
                        trailing: Text(
                          "Rs. ${double.parse(widget.price.toString()).toStringAsFixed(2)}",
                          style: TextStyle(color: Colors.green, fontSize: 25),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
