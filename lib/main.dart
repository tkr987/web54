import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

main() {
  Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: "AIzaSyDd55SAcL-qBGe0iidvrEelD0Lxd2FJbBo",
      appId: "myapp-47093.firebaseapp.com",
      messagingSenderId: "202117038660",
      projectId: "myapp-47093",
    )
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) => MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: const MyFirestorePage(),
      );
}

class MyFirestorePage extends StatefulWidget {
  const MyFirestorePage({Key? key}) : super(key: key);
  @override
  State<StatefulWidget> createState() => _MyFirestorePageState();
}

class _MyFirestorePageState extends State<MyFirestorePage> {
  String age = '';
  String uid = '';
  String item = '';
  String name = '';
  String price = '';
  List<DocumentSnapshot> users = [];
  List<String> items = [];

  @override
  Widget build(BuildContext context) => Scaffold(
    body: Center(
      child: Column(
        children: <Widget>[
          TextField(
            decoration: const InputDecoration(hintText: '名前'),
            onChanged: (text) { name = text; },
          ),
          TextField(
            decoration: const InputDecoration(hintText: '年齢'),
            onChanged: (text) { age = text; },
          ),
          Container(
            margin: const EdgeInsets.all(8),
            child: ElevatedButton(
              child: const Text('ユーザー 登録'),
              onPressed: () async {
                final ss = await FirebaseFirestore.instance.collection('users').get();
                int n = ss.docs.length + 1;
                FirebaseFirestore.instance.collection('users').doc(n.toString()).set({'name': name, 'age': age});
              },
            )
          ),
          Container(
            margin: const EdgeInsets.all(8),
            child: ElevatedButton(
              child: const Text('全ユーザー表示'),
              onPressed: () async { // ユーザーを取得してUIに反映
                final ss = await FirebaseFirestore.instance.collection('users').get();
                setState( (){ users = ss.docs; } );
              },
            ),
          ),
          Column(
            children: [
              for (var i = 0; i < users.length; i++) ... {
                Text('user_id = $i ${users[i]['name']}さん ${users[i]['age']}歳'),
              }
            ],
          ),
          TextField(
            decoration: const InputDecoration(hintText: 'user id'),
            onChanged: (text) { uid = text; },
          ),
          TextField(
            decoration: const InputDecoration(hintText: '商品名'),
            onChanged: (text) { item = text; },
          ),
          TextField(
            decoration: const InputDecoration(hintText: '値段'),
            onChanged: (text) { price = text; },
          ),
          Container(
            margin: const EdgeInsets.all(8),
            child: ElevatedButton(
              child: const Text('商品購入'),
              onPressed: () async {
                final ss = await FirebaseFirestore.instance.collection('users').doc(uid.toString()).collection('items').get();
                int n = ss.docs.length + 1;
                FirebaseFirestore.instance.collection('users').doc(uid.toString()).collection('items').doc(n.toString()).set({'name': item, 'price': price});
              },
            ),
          ),
          TextField(
            decoration: const InputDecoration(hintText: 'user id'),
            onChanged: (text) { uid = text; },
          ),
          ElevatedButton(
            child: const Text('購入物を表示'),
            onPressed: () async { // 購入物を取得してUIに反映
              final ss = await FirebaseFirestore.instance.collection('users').doc(uid).collection('items').get();
              for (var e in ss.docs) {
                setState( () { items.add('${e['name']} ${e['price']}円'); } );
              }
            },
          ),
          Column(
            children: [
              for (var e in items) ... { Text(e) }
            ],
          ),
        ],
      ),
    ),
  );
}
