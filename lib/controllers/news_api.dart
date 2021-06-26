import 'package:http/http.dart' as http;
import 'dart:convert';

import '../models/news.dart';

String apiKey = 'KiAIGZThixkARnIWwknYXFGPB7nh2skG';
Future<News> fetchAllNews() async {
  final url = Uri.parse(
      'https://api.nytimes.com/svc/topstories/v2/home.json?api-key=$apiKey');

  http.Response response = await http.get(url);
  final data = jsonDecode(response.body);

  return News.fromJson(data);
}

Future<News> fetchTopicsNews(String topic) async {
  final url =
      'https://api.nytimes.com/svc/topstories/v2/$topic.json?api-key=$apiKey';
  http.Response response = await http.get(url);

  final data = jsonDecode(response.body);

  return News.fromJson(data);
}
