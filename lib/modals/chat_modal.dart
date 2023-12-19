class ChatModal {
  String msg;
  DateTime time = DateTime.now();
  String type;

  ChatModal(
    this.msg,
    this.time,
    this.type,
  );

  factory ChatModal.fromMap({required Map data}) {
    return ChatModal(
      data['msg'],
      DateTime.fromMillisecondsSinceEpoch(data['time']),
      data['type'],
    );
  }

  Map<String, dynamic> get toMap {
    return {
      'msg': msg,
      'time': time.millisecondsSinceEpoch,
      'type': type,
    };
  }
}
