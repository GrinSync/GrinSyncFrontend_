class Event {
  int id;
  String title;
  int host;
  String? hostName;
  int? org;
  String location;
  String? start;
  String? end;
  String description;
  bool? studentsOnly;
  int? parentOrg;
  List<String>? tags;
  bool isFavorited;
  int? nextRepeat;
  String? contactEmail;

  String? latitude;
  String? longitude;

  Event({
    this.id = -1,
    this.title = '',
    this.host = -1,
    this.hostName,
    this.org,
    this.location = '',
    this.start,
    this.end,
    this.description = 'No description provided.',
    this.studentsOnly = false,
    this.parentOrg,
    this.tags,
    this.isFavorited = false,
    this.nextRepeat,
    this.contactEmail,
    this.latitude,
    this.longitude,
  });

  factory Event.fromJson(json) {
    return Event(
      id: json['id'],
      title: json['title'],
      host: json['host'],
      hostName: json['hostName'],
      org: json['parentOrg'],
      location: json['location'],
      start: json['start'],
      end: json['end'],
      description: json['description'],
      studentsOnly: json['studentsOnly'],
      parentOrg: json['parentOrg'],
      tags: (json['tags'] as List<dynamic>).cast<String>(),
      isFavorited: json['isFavorited'],
      nextRepeat: json['nextRepeat'],
      contactEmail: json['contactEmail'],
      latitude: json['lat'],
      longitude: json['long'],
    );
  }
}
