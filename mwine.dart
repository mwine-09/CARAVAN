// class ChatScreen extends StatelessWidget {
//   final ChatRoom chatRoom;

//   ChatScreen({required this.chatRoom});

//   @override
//   Widget build(BuildContext context) {
//     final chatProvider = Provider.of<ChatProvider>(context);

//     return Scaffold(
//       appBar: AppBar(
//         title: Text(chatRoom.title),
//       ),
//       body: StreamBuilder<List<Message>>(
//         stream: chatProvider.getMessagesStream(chatRoom.id),
//         builder: (context, snapshot) {
//           if (snapshot.hasError) {
//             return Text('Error: ${snapshot.error}');
//           } else if (snapshot.connectionState == ConnectionState.waiting) {
//             return CircularProgressIndicator();
//           } else {
//             return ListView.builder(
//               itemCount: snapshot.data!.length,
//               itemBuilder: (context, index) {
//                 return Text(snapshot.data![index].content);
//               },
//             );
//           }
//         },
//       ),
//     );
//   }
// }
