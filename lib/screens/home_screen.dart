import 'dart:convert';

import 'package:affirmations/models/affirmations_model.dart';
import 'package:affirmations/utilities/constants.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Future<Affirmations> getQuote() async {
    final url = Uri.parse('https://www.affirmations.dev');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final jsonQuote = jsonDecode(response.body);
      return Affirmations.fromJson(jsonQuote);
    } else {
      throw Exception();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          CarouselSlider.builder(
            itemCount: 5,
            options: CarouselOptions(
              height: MediaQuery.of(context).size.height,
              viewportFraction: 1,
              initialPage: 0,
              enableInfiniteScroll: true,
              reverse: false,
              autoPlay: true,
              autoPlayAnimationDuration: Duration(milliseconds: 500),
              autoPlayInterval: Duration(minutes: 1),
              autoPlayCurve: Curves.easeInOut,
              scrollDirection: Axis.horizontal,
              enlargeCenterPage: true,
            ),
            itemBuilder: (context, index, x) {
              return Image.network(
                Constants.sliderImages[index],
                fit: BoxFit.fill,
                color: Color(0xff0d69ff).withOpacity(1.0),
                colorBlendMode: BlendMode.modulate,
              );
            },
          ),
          Center(
            child: FutureBuilder<Affirmations>(
              future: getQuote(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final quote = snapshot.data;

                  return Text(
                    quote!.affirmation,
                    style: GoogleFonts.lobster(
                      color: Colors.white,
                      fontSize: 45,
                      fontWeight: FontWeight.w100,
                    ),
                    textAlign: TextAlign.center,
                  );
                } else if (snapshot.hasError) {
                  return Text('${snapshot.error}');
                }

                return CircularProgressIndicator();
              },
            ),
          ),
          Positioned(
            bottom: 20,
            right: MediaQuery.of(context).size.width / 3,
            child: MaterialButton(
              color: Colors.white.withOpacity(0.5),
              padding: EdgeInsets.all(16),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
              onPressed: () {
                setState(() {});
              },
              child: Text(
                'GENERATE',
                style: GoogleFonts.quicksand(
                  fontWeight: FontWeight.w800,
                  fontSize: 20,
                  letterSpacing: 1,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
