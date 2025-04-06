

import 'package:cloud_firestore/cloud_firestore.dart';

class Event{
  final String speaker;
  final String avatar;
  final String type;
  final Timestamp timestamp;
  final String subject;
  Event({required this.subject,
    required this.speaker,
    required this.avatar,
    required this.timestamp,
    required this.type
     });
  factory Event.fromData(dynamic data){
    return Event(subject: data["sujet"], speaker: data["speaker"], avatar: data["avatar"], timestamp:data['date'], type: data['type']);
  }

}