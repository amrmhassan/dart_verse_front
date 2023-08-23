// ignore_for_file: prefer_const_constructors

import 'dart:io';

import 'package:frontend/package/features/db/verse_db.dart';
import 'package:frontend/package/features/storage/verse_storage.dart';
import 'package:flutter/material.dart';

import 'features/auth/verse_auth.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool loading = false;
  @override
  void initState() {
    Future.delayed(Duration.zero).then((value) async {
      loading = true;
      setState(() {});
      await VerseDb.instance.setupDb();
      loading = false;
      setState(() {});
    });
    super.initState();
  }

  var user = VerseAuth.instance.currentUser!;
  @override
  Widget build(BuildContext context) {
    if (loading) {
      return Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('User email: '),
              Text(user.email),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('User id: '),
              Text(user.id),
            ],
          ),
          ...(user.userData ?? {}).entries.map((e) => Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(e.key),
                  Text(e.value.toString()),
                ],
              )),
          ElevatedButton(
            onPressed: () async {
              File file = File('/sdcard/001.mp3');
              VerseStorage.instance.putFile(file);
            },
            child: Text('Upload File'),
          ),
          ElevatedButton(
            onPressed: () async {
              //! a file ref must contain the file parent bucket and the file ref inside that bucket
              //! and the bucket will refer to an actual bucket on the server
              //! but for security measures i should hide the actual path for the bucket on the server
              //! and the file ref inside that bucket will be the path inside that bucket
              VerseStorage.instance.downloadFile(
                bucketName: 'storage',
                fileRef: '001.mp3',
                downloadDir: 'sdcard',
              );
            },
            child: Text('Download File'),
          ),
          ElevatedButton(
            onPressed: () async {
              VerseStorage.instance.delete('dir');
            },
            child: Text('Delete File'),
          ),
          ElevatedButton(
            onPressed: () async {
              var docs = await VerseDb.instance
                  .collection('auth_data')
                  .doc('64a6e7ebd5ffe680e02b2c4c')
                  .getData();
              print(docs);
            },
            child: Text('Db Get'),
          ),
          ElevatedButton(
            style: ButtonStyle(
                backgroundColor: MaterialStatePropertyAll(Colors.red)),
            onPressed: () async {
              var auth = VerseAuth.instance;
              await auth.logout(logoutFromBackend: false);

              print('user logged out successfully');
            },
            child: Text('Logout'),
          ),
        ],
      ),
    );
  }
}
