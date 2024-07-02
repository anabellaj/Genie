import 'package:flutter/material.dart';

class FollowRequestNotification extends Notification{
  final bool result;
  final String id;
  FollowRequestNotification(this.result, this.id);
}