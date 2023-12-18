import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:insta_clone/screens/profile_screen.dart';
import 'package:insta_clone/utils/colors.dart';

class SearchScreen extends StatefulWidget {
  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchcontroller = SearchController();
  bool showUser = false;
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _searchcontroller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        title: TextFormField(
          onFieldSubmitted: (newValue) {
            print(newValue);
            setState(() {
              showUser = true;
              _searchcontroller.clear();
            });
          },
          controller: _searchcontroller,
          decoration: InputDecoration(
              labelStyle: TextStyle(color: blueColor),
              labelText: 'Search for a user...',
              focusColor: secondaryColor),
        ),
        backgroundColor: mobileBackgroundColor,
      ),
      body: !showUser
          ? FutureBuilder(
              future: FirebaseFirestore.instance.collection('posts').get(),
              builder: (context,
                  AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
                if(snapshot.connectionState==ConnectionState.waiting)
                {
                  return const Center(child:CircularProgressIndicator(color: blueColor,),);
                }
                return GridView.builder(
                  itemCount: snapshot.data!.docs.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
                    itemBuilder: (context, index) => Image.network(
                        '${snapshot.data!.docs[index]['postUrl']}'));
              })
          : FutureBuilder(
              future: FirebaseFirestore.instance
                  .collection('users')
                  .where('username',
                      isGreaterThanOrEqualTo: _searchcontroller.text.trim())
                  .get(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
                if (snapshot.connectionState==ConnectionState.waiting) {
                  return Center(
                      child: CircularProgressIndicator(
                    color: Colors.blue,
                  ));
                }
                return ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) => InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ProfileScreen(
                              uid: snapshot.data!.docs[index]['uid']),
                        ),
                      );
                    },
                    child: ListTile(
                      title: Text('${snapshot.data!.docs[index]['username']}'),
                      leading: CircleAvatar(
                        radius: 20,
                        backgroundImage: NetworkImage(
                            '${snapshot.data!.docs[index]['ProfilePhotoUrl']}'),
                      ),
                    ),
                  ),
                );
              },
            ),
    ));
  }
}
