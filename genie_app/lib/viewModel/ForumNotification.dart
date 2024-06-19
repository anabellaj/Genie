import 'package:flutter/material.dart';

class LikedReply extends Notification{
  final bool val;
  LikedReply(this.val);
}

class LikeState extends Notification{
  final bool state;
  final String id;
  LikeState(this.state, this.id);
}