class LightChannel {
  final int id;
  final String title;
  final String? image;
  final String? link;

  const LightChannel({
    required this.id,
    required this.title,
    required this.link,
    this.image,
  });
}
