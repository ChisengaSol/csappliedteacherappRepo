import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:csappliedteacherapp/src/screens/home/conversation_screen.dart';
import 'package:csappliedteacherapp/src/services/database.dart';
import 'package:csappliedteacherapp/src/shared/constants.dart';
import 'package:flutter/material.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  TextEditingController searchTextEditController = new TextEditingController();
  DatabaseService databaseService = new DatabaseService();

  QuerySnapshot searchSnapshot;

  initiateSearch() {
    databaseService.getUserByEmail(searchTextEditController.text).then((value) {
      setState(() {
        searchSnapshot = value;
      });
    });
  }

  //create chatroom, send user to conversation screen
  createChatroomAndStartConvo({String userEmail}) {
    if (userEmail != Constants.myEmail) {
      String chatroomId = getChatrromId(userEmail, Constants.myEmail);

      List<String> users = [userEmail, Constants.myEmail];
      Map<String, dynamic> chatroomMap = {
        "users": users,
        "chatroomId": chatroomId,
      };
      DatabaseService().createChatRoom(chatroomId, chatroomMap);
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => ConversationsScreen(chatroomId)));
    } else {
      print("You cant send messages to yourself");
    }
  }

  Widget searchTile({String userEmail}) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                userEmail,
              ),
            ],
          ),
          Spacer(),
          GestureDetector(
            onTap: () {
              createChatroomAndStartConvo(
                userEmail: userEmail,
              );
            },
            child: Container(
              decoration: BoxDecoration(
                color: Colors.green,
                borderRadius: BorderRadius.circular(30),
              ),
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Text(
                "Message",
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget searchList() {
    return searchSnapshot != null
        ? ListView.builder(
            itemCount: searchSnapshot.docs.length,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return searchTile(
                userEmail: searchSnapshot.docs[index].data()["email"],
              );
            })
        : Container();
  }

  @override
  void initState() {
    //initiateSearch();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        child: Column(
          children: [
            Container(
              color: Colors.amber,
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: searchTextEditController,
                      decoration: InputDecoration(
                        hintText: "Search teacher Email",
                        hintStyle: TextStyle(
                          color: Colors.grey,
                        ),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      initiateSearch();
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
                      child: Image.asset("assets/images/search.png"),
                    ),
                  ),
                ],
              ),
            ),
            searchList(),
          ],
        ),
      ),
    );
  }
}

//create chatroom, send user to conversation screen

// class SearchTile extends StatelessWidget {
//   final String userEmail;
//   SearchTile({this.userEmail});

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
//       child: Row(
//         children: [
//           Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 userEmail,
//               ),
//             ],
//           ),
//           Spacer(),
//           GestureDetector(
//             onTap: () {
//               createChatroomAndStartConvo()
//             },
//             child: Container(
//               decoration: BoxDecoration(
//                 color: Colors.green,
//                 borderRadius: BorderRadius.circular(30),
//               ),
//               padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
//               child: Text(
//                 "Message",
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

getChatrromId(String a, String b) {
  if (a.substring(0, 1).codeUnitAt(0) > b.substring(0, 1).codeUnitAt(0)) {
    return "$b\_$a";
  } else {
    return "$a\_$b";
  }
}
