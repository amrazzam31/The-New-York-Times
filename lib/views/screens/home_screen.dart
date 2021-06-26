import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_swiper/flutter_swiper.dart';

import '../../controllers/news_api.dart';
import '../../views/widgets/news_category.dart';
import '../../views/screens/details_screen.dart';
import '../../models/news.dart';
import '../../constants.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Future<void> refreshData() async {
    await fetchAllNews();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: refreshData,
        child: SingleChildScrollView(
          child:
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Padding(
              padding: const EdgeInsets.only(
                left: 15,
                top: 50,
                bottom: 5,
                right: 15,
              ),
              child: Image.asset('images/the_new_york_times_logo.png'),
            ),
            Column(children: [
              FutureBuilder(
                  future: fetchAllNews(),
                  builder: (ctx, snapshot) {
                    News data = snapshot.data;
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    } else {
                      if (snapshot.error != null) {
                        return Center(
                          child: Text(
                            'An error occurred!',
                            style: kErrorTextStyleOfHomeScreen,
                          ),
                        );
                      } else {
                        return Container(
                          height: 420,
                          width: double.infinity,
                          color: Colors.grey.shade100,
                          padding: EdgeInsets.all(16),
                          child: Swiper(
                              itemCount: data.results.length,
                              autoplay: true,
                              pagination: SwiperPagination(
                                builder: DotSwiperPaginationBuilder(
                                  color: Colors.grey,
                                  activeColor: Colors.red.shade800,
                                  activeSize: 7,
                                  size: 5,
                                  space: 2,
                                ),
                              ),
                              itemBuilder: (BuildContext context, int index) {
                                final dataType = data.results[index];
                                if (dataType.multimedia != null &&
                                    dataType.multimedia is List &&
                                    dataType.multimedia.length >= 1) {
                                  return Column(children: [
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  DetailsScreen(
                                                    title: dataType.title,
                                                    author: dataType.byline,
                                                    time: dataType.publishedDate,
                                                    abstract: dataType.abstract,
                                                    image:
                                                    dataType.multimedia[0].url,
                                                  ),
                                            ));
                                      },
                                      child: Container(
                                        height: 200,
                                        width: double.infinity,
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(10),
                                            topRight: Radius.circular(10),
                                          ),
                                          child: Hero(
                                            tag: '${dataType.title}',
                                            child: Image.network(
                                              dataType.multimedia[0].url,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Container(
                                      height: 150,
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.only(
                                          bottomLeft: Radius.circular(10.0),
                                          bottomRight: Radius.circular(10.0),
                                        ),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(12.0),
                                        child: Column(
                                            mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                dataType.title,
                                                style:
                                                kTitleTextStyleOfHomeScreen,
                                              ),
                                              Text(
                                                dataType.abstract,
                                                style:
                                                kAbstractTextStyleOfHomeScreen,
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                MainAxisAlignment
                                                    .spaceBetween,
                                                children: [
                                                  Text(
                                                    dataType.byline.length < 50
                                                        ? dataType.byline
                                                        : 'Writer',
                                                    style:
                                                    kAuthorTextStyleOfHomeScreen,
                                                  ),
                                                  Text(
                                                    DateFormat(
                                                        'dd/MM/yyyy hh:mm')
                                                        .format(
                                                      DateTime.parse(dataType
                                                          .publishedDate),
                                                    ),
                                                    style:
                                                    kTimeTextStyleOfHomeScreen,
                                                  ),
                                                ],
                                              ),
                                            ]),
                                      ),
                                    ),
                                  ]);
                                }
                                return SizedBox.shrink();
                              }),
                        );
                      }
                    }
                  }),
            ]),
            NewsCategory(),
          ]),
        ),
      ),
    );
  }
}
