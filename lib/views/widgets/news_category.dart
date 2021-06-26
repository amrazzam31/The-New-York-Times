import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../views/screens/category_details_screen.dart';
import '../../controllers/news_api.dart';
import '../../models/news.dart';
import '../../constants.dart';

class NewsCategory extends StatefulWidget {
  @override
  _NewsCategoryState createState() => _NewsCategoryState();
}

class _NewsCategoryState extends State<NewsCategory> {
  final List<String> newsTabs = [
    'Business',
    'Technology',
    'Health',
    'Sports',
    'Science',
    'Travel',
  ];
  String topic = 'Business';
  int _currentColorIndex = 0;
  Future<void> refreshCategoryData() async {
    await fetchAllNews();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: refreshCategoryData,
      child: Column(
        children: [
          Container(
            height: 40,
            child: ListView.builder(
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                itemCount: newsTabs.length,
                itemBuilder: (ctx, index) {
                  return FlatButton(
                    textColor: _currentColorIndex == index
                        ? kActiveFlatButtonColour
                        : kInActiveFlatButtonColour,
                    onPressed: () {
                      setState(() {
                        topic = newsTabs[index];
                        _currentColorIndex = index;
                      });
                    },
                    child: Text(
                      newsTabs[index],
                      style: kNewsTapTextStyle,
                    ),
                  );
                }),
          ),
          FutureBuilder(
              future: fetchTopicsNews(topic),
              builder: (ctx, snapshot) {
                News data = snapshot.data;
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else {
                  if (snapshot.error != null) {
                    return Center(
                      child: Text('An error occurred!',
                          style: kErrorTextStyleOfHomeScreen),
                    );
                  } else {
                    return Container(
                      height: 500,
                      child: ListView.builder(
                          itemCount: data.results.length,
                          itemBuilder: (ctx, index) {
                            final dataType = data.results[index];
                            if (dataType.multimedia != null &&
                                dataType.multimedia is List &&
                                dataType.multimedia.length >= 1) {
                              return GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          CategoryDetailsScreen(
                                            title: dataType.title,
                                            author: dataType.byline,
                                            time: dataType.publishedDate,
                                            abstract: dataType.abstract,
                                            image: dataType.multimedia[0].url,
                                          ),
                                    ),
                                  );
                                },
                                child: Container(
                                  child: ListTile(
                                    leading: Container(
                                      width: 100,
                                      child: Hero(
                                        tag: '${dataType.title}',
                                        child: Image.network(
                                          dataType.multimedia[0].url,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                    title: Text(
                                      dataType.title,
                                      style: kTitleTextStyleOfNewsCategory,
                                    ),
                                    subtitle: Text(
                                      DateFormat('dd/MM/yyyy hh:mm').format(
                                        DateTime.parse(
                                          dataType.publishedDate,
                                        ),
                                      ),
                                      style: kTimeTextStyleOfNewsCategory,
                                    ),
                                  ),
                                ),
                              );
                            }
                            return SizedBox.shrink();
                          }),
                    );
                  }
                }
              }),
        ],
      ),
    );
  }
}
