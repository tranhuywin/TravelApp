import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:google_fonts/google_fonts.dart';
import 'package:travelapp/models/destination_model.dart';
import 'package:travelapp/models/hotel_model.dart';
import 'package:travelapp/widgets/destination_carousel.dart';
import 'package:travelapp/widgets/hotel_carousel.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class HomeScreen extends StatefulWidget {
  static String routeName = '/home_page';
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  int _currentTab = 0;

  String jsonString = null;
  List<Destination> destinations;
  List<Hotel> hotels;

  @override
  void initState() {
    super.initState();
    load().then((data) {
      setState(() {
        this.jsonString = data;
        this.destinations = getDestinations(jsonString);
        this.hotels = getHotels(jsonString);
        log('Set state');
      });
    });
  }

  List<IconData> _icons = [
    FontAwesomeIcons.plane,
    FontAwesomeIcons.bed,
    FontAwesomeIcons.walking,
    FontAwesomeIcons.biking,
  ];

  Widget _buildIcon(int index) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedIndex = index;
        });
      },
      child: Container(
        height: 60.0,
        width: 60.0,
        decoration: BoxDecoration(
          color: _selectedIndex == index
              ? Theme.of(context).accentColor
              : Color(0xFFE7EBEE),
          borderRadius: BorderRadius.circular(30.0),
        ),
        child: Icon(
          _icons[index],
          size: 25.0,
          color: _selectedIndex == index
              ? Theme.of(context).primaryColor
              : Color(0xFFB4C1C4),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (jsonString == null) {
      return Center(
        child: Text(
          "PLEASE WAIT",
          style: GoogleFonts.montserrat(
            fontSize: 20.0,
            fontWeight: FontWeight.w300,
            textStyle: TextStyle(color: Colors.white),
          ),
        ),
      );
    } else {
      log(jsonString);
      return Scaffold(
        body: SafeArea(
          child: ListView(
            padding: EdgeInsets.symmetric(vertical: 30.0),
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(left: 20.0, right: 120.0),
                child: Text(
                  'What would you like to find?',
                  style: TextStyle(
                    fontSize: 30.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(height: 20.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: _icons
                    .asMap()
                    .entries
                    .map(
                      (MapEntry map) => _buildIcon(map.key),
                    )
                    .toList(),
              ),
              SizedBox(height: 20.0),
              DestinationCarousel(destinations),
              SizedBox(height: 20.0),
              HotelCarousel(hotels),
            ],
          ),
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentTab,
          onTap: (int value) {
            setState(() {
              _currentTab = value;
            });
          },
          items: [
            BottomNavigationBarItem(
              icon: Icon(
                Icons.search,
                size: 30.0,
              ),
              title: SizedBox.shrink(),
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.local_pizza,
                size: 30.0,
              ),
              title: SizedBox.shrink(),
            ),
            BottomNavigationBarItem(

              icon: CircleAvatar(
                radius: 15.0,
                backgroundImage: NetworkImage('http://i.imgur.com/zL4Krbz.jpg'),
              ),
              title: SizedBox.shrink(),
            )
          ],
        ),
      );
    }
  }

  Future load() async {
    //jsonString = await rootBundle.loadString('assets/data/data.json');
    final http.Response response = await http.get(
        'https://6007fe54309f8b0017ee51c2.mockapi.io/api/v1/destination',
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        });
    return response.body.toString();

    // log("Data loaded");
    // return jsonString;
  }
}