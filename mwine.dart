class ChatScreen extends StatelessWidget {
  final List<Message> messages = [
    Message(
      id: 1,
      text: 'Hi, I saw your ride offer. Is the seat still available?',
      createdAt: '10:00 AM',
      isMe: false,
    ),
    Message(
      id: 2,
      text: 'Yes, the seat is still available. Are you interested?',
      createdAt: '10:01 AM',
      isMe: true,
    ),
    Message(
      id: 3,
      text:
          'Yes, I would like to book a seat. Can you please share the details?',
      createdAt: '10:02 AM',
      isMe: false,
    ),
    Message(
      id: 4,
      text: 'Sure! I will pick you up at 8:00 AM from your location.',
      createdAt: '10:03 AM',
      isMe: true,
    ),
    Message(
      id: 5,
      text: 'That works for me. How much will the ride cost?',
      createdAt: '10:04 AM',
      isMe: false,
    ),
    Message(
      id: 6,
      text: 'The ride will cost 20. Is that okay with you?',
      createdAt: '10:05 AM',
      isMe: true,
    ),
    Message(
      id: 7,
      text: 'Yes, that sounds good. See you tomorrow!',
      createdAt: '10:06 AM',
      isMe: false,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        title: Row(children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              shape: BoxShape.rectangle,
              image: const DecorationImage(
                image: AssetImage('assets/default_profile.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(width: 8),
          const Text(
            'John Doe',
            style: TextStyle(color: Colors.white),
          ),
        ]),
      ),
      body: SafeArea(
        child: Container(
          color: Colors.black,
          padding: const EdgeInsets.all(8),
          child: ListView.builder(
            itemCount: messages.length,
            itemBuilder: (context, index) {
              return MessageWidget(message: messages[index]);
            },
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.black,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          child: const Row(
            children: [
              Expanded(
                child: TextField(
                    decoration: InputDecoration(
                        hintStyle: TextStyle(color: Colors.white70),
                        hintText: 'Type a message...',
                        border: OutlineInputBorder(),
                        suffixIcon: Icon(Icons.send),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                        ))),
              ),
            ],
          ),
        ),
      ),
      resizeToAvoidBottomInset:
          false, // Ensure that the text field remains visible above the keyboard
    );
  }
}