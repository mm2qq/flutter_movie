class VideoSource {
  final String name;
  final String icon;

  VideoSource({
    this.name,
    this.icon,
  });

  VideoSource.fromJSON(Map<String, dynamic> json)
      : name = json['name'],
        icon = json['pic'];
}

class Video {
  final bool needPay;
  final String link;
  final VideoSource source;

  Video({
    this.needPay,
    this.link,
    this.source,
  });

  Video.fromJSON(Map<String, dynamic> json)
      : needPay = json['need_pay'],
        link = json['sample_link'],
        source = VideoSource.fromJSON(json['source']);
}
