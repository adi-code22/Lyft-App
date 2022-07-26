import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TravelCard extends StatefulWidget {
  const TravelCard({Key? key}) : super(key: key);

  @override
  State<TravelCard> createState() => _TravelCardState();
}

class _TravelCardState extends State<TravelCard> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.arrow_back),
          color: Colors.black,
        ),
        backgroundColor: Colors.white,
        centerTitle: true,
        title: RichText(
            text: TextSpan(
                style: GoogleFonts.poppins(
                    fontSize: 30, fontWeight: FontWeight.bold),
                children: [
              TextSpan(
                  text: "Travel",
                  style: GoogleFonts.poppins(
                      color: Theme.of(context).primaryColorLight)),
              TextSpan(
                  text: "Card",
                  style: GoogleFonts.poppins(
                      color: Theme.of(context).primaryColor)),
            ])),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
              height: 15,
            ),
            ListTile(
              title: Text(
                "M Akhil P Raj",
                style: TextStyle(fontSize: 25),
              ),
              subtitle: Text("⭐ 5.0"),
              trailing: CircleAvatar(
                radius: 35,
                backgroundColor: Theme.of(context).primaryColorLight,
                child: Icon(
                  Icons.account_circle,
                  color: Colors.white,
                  size: 40,
                ),
              ),
            ),
            SizedBox(
              height: 15,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                height: 175,
                decoration: BoxDecoration(
                    border:
                        Border.all(color: Theme.of(context).primaryColorLight),
                    borderRadius: BorderRadius.circular(25),
                    image: DecorationImage(
                        fit: BoxFit.contain,
                        image: AssetImage('assets/tcard.PNG'))),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  GestureDetector(
                    onTap: () {
                      // Navigator.push(
                      //     context,
                      //     MaterialPageRoute(
                      //       builder: (context) => ScanScreen(),
                      //     ));
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          // gradient: LinearGradient(
                          //   begin: Alignment.topRight,
                          //   end: Alignment.bottomLeft,
                          //   colors: [
                          //     Theme.of(context).primaryColor,
                          //     Theme.of(context).primaryColorLight,
                          //   ],
                          // ),
                          borderRadius: BorderRadius.circular(20),
                          color: Theme.of(context).primaryColor,
                          border: Border.all(
                              color: Theme.of(context).primaryColorLight,
                              width: 0)),
                      height: 140,
                      width: 165,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Icon(
                            Icons.confirmation_num_outlined,
                            size: 50,
                            color: Colors.white,
                          ),
                          Text(
                            "Credits Earned",
                            style: GoogleFonts.aBeeZee(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => TravelCard(),
                          ));
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          // gradient: LinearGradient(
                          //   begin: Alignment.topRight,
                          //   end: Alignment.bottomLeft,
                          //   colors: [
                          //     Theme.of(context).primaryColorLight,
                          //     Theme.of(context).primaryColor,
                          //   ],
                          // ),
                          borderRadius: BorderRadius.circular(20),
                          color: Theme.of(context).primaryColor,
                          border: Border.all(
                              color: Theme.of(context).primaryColorLight,
                              width: 0)),
                      height: 140,
                      width: 165,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Icon(
                            Icons.directions_walk_outlined,
                            size: 50,
                            color: Colors.white,
                          ),
                          Text(
                            "Distance Covered",
                            style: GoogleFonts.aBeeZee(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Text(
                "See Travelling History!",
                style: TextStyle(fontSize: 15),
              ),
            ),
            Icon(Icons.keyboard_double_arrow_down_rounded),
            SizedBox(
              height: 20,
            ),
            Container(
              decoration: BoxDecoration(
                  border: Border.all(
                      color: Theme.of(context)
                          .primaryColorLight
                          .withOpacity(0.4))),
              child: ListTile(
                subtitle: Text(
                  "Earned 10 Points",
                  style: TextStyle(color: Colors.green),
                ),
                title: Text(
                  "Reached Kasaragod",
                  style: TextStyle(fontSize: 20),
                ),
                trailing: Icon(Icons.confirmation_num_outlined),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                  border: Border.all(
                      color: Theme.of(context)
                          .primaryColorLight
                          .withOpacity(0.4))),
              child: ListTile(
                subtitle: Text(
                  "Earned 10 Points",
                  style: TextStyle(color: Colors.green),
                ),
                title: Text(
                  "Reached Thrissur",
                  style: TextStyle(fontSize: 20),
                ),
                trailing: Icon(Icons.confirmation_num_outlined),
              ),
            )
          ],
        ),
      ),
    );
  }
}
