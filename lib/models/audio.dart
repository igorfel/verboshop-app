class Audio {
  String title;
  String author;
  String date;
  String url;

  Audio({this.title, this.author, this.date, this.url});

  Audio.fromMap(Map<String, dynamic> data)
      : this(title: data['title'], author: data['author'], url: data['url']);
}
