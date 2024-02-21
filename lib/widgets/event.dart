class Event {
  final String time;
  final String eventName;
  final String date;
  final String type;
  final String host;
  final List participants;
  final String photo;

  Event({
    required this.type,
    required this.time,
    required this.eventName,
    required this.date,
    required this.host,
    required this.participants,
    required this.photo,
  });
}
