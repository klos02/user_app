class RequestModel {
  String fromId;
  String toId;
  String goal;
  int sessionsPerWeek;
  String updateFrequency;
  String? additionalNotes;
  String? status;
  String? requestId;
  String? fromName;

  RequestModel({
    required this.fromId,
    required this.toId,
    required this.goal,
    required this.sessionsPerWeek,
    required this.updateFrequency,
    this.additionalNotes,
    this.status,
    this.requestId,
    this.fromName,
  });

  RequestModel.fromJson(Map<String, dynamic> json)
      : fromId = json['fromId'] ?? '',
        toId = json['toId'] ?? '',
        goal = json['goal'] ?? '',
        sessionsPerWeek = json['sessionsPerWeek'] ?? 0,
        updateFrequency = json['updateFrequency'] ?? '',
        additionalNotes = json['additionalNotes'],
        status = json['status'],
        requestId = json['requestId'],
        fromName = json['fromName'];


    Map<String, dynamic> toJson(){
      final Map<String, dynamic> data = <String, dynamic>{};
      data['fromId'] = fromId;
      data['toId'] = toId;
      data['goal'] = goal;
      data['sessionsPerWeek'] = sessionsPerWeek;
      data['updateFrequency'] = updateFrequency;
      data['additionalNotes'] = additionalNotes;
      data['status'] = status;
      data['requestId'] = requestId;
      data['fromName'] = fromName;
      return data;
    }

}