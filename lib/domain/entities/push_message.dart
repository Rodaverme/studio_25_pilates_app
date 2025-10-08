class PushMessage {
  final String messageId;
  final String title;
  final String body;
  final DateTime sentDate;
  final Map<String, dynamic>? data;
  final String? imageUrl;
  final DateTime? readAt;

  PushMessage({
    required this.messageId,
    required this.title,
    required this.body,
    required this.sentDate,
    this.data,
    this.imageUrl,
    this.readAt,
  });
  bool get isRead => readAt != null; // 👈 helper rápido

  @override
  String toString() {
    return '''
PushMesage -
id:        $messageId
title:     $title
body:      $body
sentDate:  $sentDate
readAt:    $readAt
data:      $data
imageUrl:  $imageUrl
''';
  }
}
