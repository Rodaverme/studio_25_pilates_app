import 'package:studio_25_pilates_app/infrastructure/models/ocurrences/ocurrences_response.dart';

class OccurrenceListResponse {
  final int currentPage;
  final List<OccurrenceResponse> data;
  final String? firstPageUrl;
  final int? from;
  final int lastPage;
  final String? lastPageUrl;
  final String? nextPageUrl;
  final String? path;
  final int perPage;
  final String? prevPageUrl;
  final int? to;
  final int total;

  OccurrenceListResponse({
    required this.currentPage,
    required this.data,
    this.firstPageUrl,
    this.from,
    required this.lastPage,
    this.lastPageUrl,
    this.nextPageUrl,
    this.path,
    required this.perPage,
    this.prevPageUrl,
    this.to,
    required this.total,
  });

  factory OccurrenceListResponse.fromJson(Map<String, dynamic> json) =>
      OccurrenceListResponse(
        currentPage: json["current_page"],
        data: List<OccurrenceResponse>.from(
          (json["data"] ?? []).map((x) => OccurrenceResponse.fromJson(x)),
        ),
        firstPageUrl: json["first_page_url"],
        from: json["from"],
        lastPage: json["last_page"],
        lastPageUrl: json["last_page_url"],
        nextPageUrl: json["next_page_url"],
        path: json["path"],
        perPage: int.parse(json["per_page"].toString()),
        prevPageUrl: json["prev_page_url"],
        to: json["to"],
        total: json["total"],
      );
}
