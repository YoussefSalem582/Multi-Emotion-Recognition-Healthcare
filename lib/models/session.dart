import 'package:flutter/material.dart';

class Session {
  final String id;
  final String customer;
  final String time;
  final String duration;
  final String emotion;
  final String agentAction;
  final Color emotionColor;

  Session({
    required this.id,
    required this.customer,
    required this.time,
    required this.duration,
    required this.emotion,
    required this.agentAction,
    required this.emotionColor,
  });
}
