
import 'package:flutter/material.dart';

class JoinRequestNotification extends Notification{
  final bool state;
  final String id;
  JoinRequestNotification(this.state, this.id);
}