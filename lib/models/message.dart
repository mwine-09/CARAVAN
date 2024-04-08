class Message {
  Message({
    required this.id,
    required this.text,
    required this.createdAt,
    required this.isMe,
  });

  int id;
  String? text;
 
  String createdAt;
  bool isMe;

  Message copyWith({
    required int id,
    String? text,
 
    required String createdAt,
    required bool isMe, required textColor,
  }) =>
      Message(
        id: id,
        text: text,
        
        isMe: isMe,
        createdAt: createdAt,
      );

  factory Message.fromJson(Map<String, dynamic> json) => Message(
        id: json["id"],
        text: json["text"],
      
        isMe: json["isMe"],
        createdAt: json["createdAt"],
         
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "text": text,
     
        "isMe": isMe,
        "createdAt": createdAt,
      };
}
