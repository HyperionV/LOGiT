import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:logit/model/user.dart';

class MessageData {
  final UserData sender;
  final String body;
  final Timestamp createAt;

  MessageData(this.sender, this.body, this.createAt);

  Map<String, dynamic> toMap() {
    return {
      'sender': sender,
      'body': body,
      'createAt': createAt,
    };
  }
}

Future<String> fetchConversationId(String patientUid, String doctorUid) async {
  DocumentSnapshot connectionDoc = await FirebaseFirestore.instance
      .collection('users')
      .doc(patientUid)
      .collection('connections')
      .doc(doctorUid)
      .get();

  if (!connectionDoc.exists) {
    return 'No conversation found';
  }

  return (connectionDoc.data() as Map<String, dynamic>)['conversations'];
}

Future<List<MessageData>> fetchMessages(
    String patientUid, String doctorUid) async {
  String conversationId = await fetchConversationId(patientUid, doctorUid);
  if (conversationId == 'No conversation found') {
    return [];
  }
  QuerySnapshot messagesSnapshot = await FirebaseFirestore.instance
      .collection('conversations')
      .doc(conversationId)
      .collection('messages')
      .orderBy('createAt', descending: false)
      .get();

  if (messagesSnapshot == 'No conversation found') {
    return [];
  }

  List<Future<MessageData>> messages = messagesSnapshot.docs.map((doc) async {
    Map<String, dynamic> messageData = doc.data() as Map<String, dynamic>;
    UserData sender = await fetchWithUID(doctorUid);
    return MessageData(
      sender,
      messageData['body'],
      messageData['createAt'],
    );
  }).toList();

  return await Future.wait(messages);
}

Future<void> sendNewMessage(
    String patientUid, String doctorUid, MessageData message) async {
  CollectionReference messagesCollection = FirebaseFirestore.instance
      .collection('conversations')
      .doc(await fetchConversationId(patientUid, doctorUid))
      .collection('messages');

  await messagesCollection.add({
    'body': message.body,
    'createAt': message.createAt,
  });
}
