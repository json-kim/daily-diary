class BackupItem {
  final String id;
  final String url;
  final DateTime uploadDate;

  BackupItem({
    required this.id,
    required this.url,
    required this.uploadDate,
  });

  factory BackupItem.fromJson(Map<String, dynamic> json) {
    return BackupItem(
      id: json['id'],
      url: json['url'],
      uploadDate: DateTime.parse(json['uploadDate']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'url': url,
      'uploadDate': uploadDate.toIso8601String(),
    };
  }
}
