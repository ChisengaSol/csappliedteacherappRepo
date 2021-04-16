import 'package:csappliedteacherapp/src/services/database.dart';
import 'package:csappliedteacherapp/src/shared/constants.dart';
import 'package:flutter/material.dart';

class ConversationsScreen extends StatefulWidget {
  final String chatroomId;
  ConversationsScreen(this.chatroomId);
  @override
  _ConversationsScreenState createState() => _ConversationsScreenState();
}

class _ConversationsScreenState extends State<ConversationsScreen> {
  DatabaseService databaseService = new DatabaseService();
  TextEditingController messageController = new TextEditingController();

  Stream chatMessagesStream;

  Widget chatMessageList() {
    return StreamBuilder(
      stream: chatMessagesStream,
      builder: (context, snapshot) {
        return snapshot.hasData
            ? ListView.builder(
                itemCount: snapshot.data.docs.length,
                itemBuilder: (context, index) {
                  return MessagesTile(
                      snapshot.data.docs[index].data()["message"],snapshot.data.docs[index].data()["sendBy"]==Constants.myEmail);
                })
            : Container();
      },
    );
  }

  sendMessage() {
    if (messageController.text.isNotEmpty) {
      Map<String, dynamic> messageMap = {
        "message": messageController.text,
        "sendBy": Constants.myEmail,
        "time": DateTime.now().microsecondsSinceEpoch,
      };

      databaseService.addConvoMessages(widget.chatroomId, messageMap);
      messageController.text = "";
    }
  }

  @override
  void initState() {
    databaseService.getConvoMessages(widget.chatroomId).then((value) {
      setState(() {
        chatMessagesStream = value;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        child: Stack(
          children: [
            chatMessageList(),
            Container(
              alignment: Alignment.bottomCenter,
              child: Container(
                color: Colors.amber,
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: messageController,
                        decoration: InputDecoration(
                          hintText: "Message...",
                          hintStyle: TextStyle(
                            color: Colors.grey,
                          ),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        sendMessage();
                      },
                      child: Container(
                        // height: 45,
                        // width: 45,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              const Color(0x36ffffff),
                              const Color(0x0ffffff),
                            ],
                          ),
                        ),

                        padding: EdgeInsets.all(12),
                        child: Image.asset("assets/images/sent_icon.png"),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MessagesTile extends StatelessWidget {
  final String message;
  final bool isSEntByMe;

  MessagesTile(this.message, this.isSEntByMe);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: isSEntByMe ? 0: 24, right: isSEntByMe ? 24: 0),
      width: MediaQuery.of(context).size.width,
      alignment: isSEntByMe ? Alignment.centerRight : Alignment.centerLeft,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          margin: EdgeInsets.symmetric(vertical: 8),          
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: isSEntByMe ? [
                const Color(0xff007ef4),
                const Color(0xff2a75bc)
              ]
                 : [

                   const Color(0x1affffff),
                   const Color(0x1affffff)
                 ],
            ),
            borderRadius: isSEntByMe ? BorderRadius.only(
              topLeft: Radius.circular(23),
              topRight: Radius.circular(23),
              bottomLeft: Radius.circular(23) 
            ): BorderRadius.only(
              topLeft: Radius.circular(23),
              topRight: Radius.circular(23),
              bottomRight: Radius.circular(23),
               )
          ) ,
        child: Text(
          message,
          style: TextStyle(
            color: Colors.green,
            fontSize: 17,
          ),
        ),
      ),
    );
  }
}
