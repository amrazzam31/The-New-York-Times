class News {
  List<Results> results;

  News({this.results});

  News.fromJson(Map<String, dynamic> json) {
    if (json['results'] != null) {
      results = new List<Results>();
      json['results'].forEach((v) {
        results.add(new Results.fromJson(v));
      });
    }
  }
}

class Results {
  String title;
  String abstract;
  String byline;
  String publishedDate;
  List<Multimedia> multimedia;

  Results({
    this.title,
    this.abstract,
    this.byline,
    this.publishedDate,
    this.multimedia,
  });

  Results.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    abstract = json['abstract'];
    byline = json['byline'];
    publishedDate = json['published_date'];
    if (json['multimedia'] != null) {
      multimedia = new List<Multimedia>();
      json['multimedia'].forEach((v) {
        multimedia.add(new Multimedia.fromJson(v));
      });
    }
  }
}

class Multimedia {
  String url;
  Multimedia({
    this.url,
  });
  Multimedia.fromJson(Map<String, dynamic> json) {
    url = json['url'];
  }
}
