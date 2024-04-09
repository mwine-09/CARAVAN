
// import 'package:day60/models/message/message.dart';
import '../models/user.dart';
import '../models/message.dart';

// Chat chatFromJson(String str) => Chat.fromJson(json.decode(str));

// String chatToJson(Chat data) => json.encode(data.toJson());

class Chat {
  Chat({
    required this.id,
    required this.user,
    required this.messages,
    required this.unReadCount,
    required this.lastMessageAt,
  });

  int id;
  UserModel user;
  List<Message> messages;
  int unReadCount;
  String lastMessageAt;

  Chat copy() => Chat(
        id: id,
        user: user,
        messages: messages,
        unReadCount: unReadCount,
        lastMessageAt: lastMessageAt,
      );

  Chat copyWith({
    required int id,
    required UserModel user,
    required List<Message> messages,
    required int unReadCount,
    required String lastMessageAt,
  }) =>
      Chat(
          id: id,
          user: user,
          messages: messages,
          unReadCount: unReadCount,
          lastMessageAt: lastMessageAt);
}
