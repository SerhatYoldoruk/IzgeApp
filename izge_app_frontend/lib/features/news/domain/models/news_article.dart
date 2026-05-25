class NewsArticle {
  const NewsArticle({
    required this.title,
    required this.date,
    required this.summary,
    required this.imageAsset,
    required this.tag,
  });

  final String title;
  final String date;
  final String summary;
  final String imageAsset;
  final String tag;
}
