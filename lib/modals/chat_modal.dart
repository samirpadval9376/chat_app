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
}
