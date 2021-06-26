import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../constants.dart';

class DetailsScreen extends StatelessWidget {
  final String title;
  final String author;
  final String time;
  final String abstract;
  final String image;

  DetailsScreen({
    this.title,
    this.author,
    this.time,
    this.abstract,
    this.image,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding:
        const EdgeInsets.only(left: 15, top: 30, bottom: 10, right: 15),
        child: SingleChildScrollView(
          child:
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            FlatButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Icon(
                Icons.arrow_back,
                color: kBackIconColor,
                size: kBackIconSize,
              ),
            ),
            SizedBox(height: 20),
            Hero(
              tag: 'hero$title',
              child: Container(
                height: 230,
                width: double.infinity,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.network(
                    image,
                    fit: BoxFit.fill,
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
            Text(
              title,
              style: kTitleTextStyleOfDetailsScreen,
            ),
            SizedBox(height: 20),
            Text(
              author,
              style: kAuthorTextStyleOfDetailsScreen,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  DateFormat('dd/MM/yyyy hh:mm').format(
                    DateTime.parse(time),
                  ),
                  style: kTimeTextStyleOfDetailsScreen,
                ),
              ],
            ),
            SizedBox(height: 15),
            Text(
              abstract,
              style: kAbstractTextStyleOfDetailsScreen,
            ),
          ]),
        ),
      ),
    );
  }
}
