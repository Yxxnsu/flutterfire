import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_ml_model_downloader/firebase_ml_model_downloader.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

const kModelName = "test";

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // await Firebase.initializeApp(
  //   options: const FirebaseOptions(
  //     apiKey: 'AIzaSyAHAsf51D0A407EklG1bs-5wA7EbyfNFg0',
  //     appId: '1:448618578101:ios:3a3c8ae9cb0b6408ac3efc',
  //     messagingSenderId: '448618578101',
  //     projectId: 'react-native-firebase-testing',
  //     authDomain: 'react-native-firebase-testing.firebaseapp.com',
  //     iosClientId:
  //         '448618578101-m53gtqfnqipj12pts10590l37npccd2r.apps.googleusercontent.com',
  //   ),
  // );
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: 'AIzaSyCPrVGSuuLxinGX8odbEaxez1wLfshOxaY',
      appId: '1:1080692587008:ios:16a8698faea5765d8376e5',
      messagingSenderId: '1080692587008',
      projectId: 'flufire-yeonsu',
      storageBucket: 'flufire-yeonsu.appspot.com',
      iosClientId:
          '1080692587008-hf1pdj4669ctbd6tfiaunuv91p7dji3m.apps.googleusercontent.com',
      iosBundleId: 'com.examp',
    ),
  );
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    initWithLocalModel();
  }

  FirebaseCustomModel? model;
  List<FirebaseCustomModel>? models;

  /// Initially get the lcoal model if found, and asynchronously get the latest one in background.
  initWithLocalModel() async {
    final _model = await FirebaseModelDownloader.instance.getModel(
      kModelName,
      FirebaseModelDownloadType.localModelUpdateInBackground,
    );
    setState(() {
      model = _model;
    });
  }

  Future<void> get initGetModelList async {
    late List<FirebaseCustomModel> _models;
    _models = await FirebaseModelDownloader.instance.listDownloadedModels();
    setState(() {
      models = _models;
    });
  }

  void uploadTempData() {
    FirebaseFirestore.instance
        .collection('TEST')
        .add(
          {'name': 'hello'},
        )
        .then((value) => print('Data Added'))
        .catchError((error) => print("Failed to add user: $error"));
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(primarySwatch: Colors.amber),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: double.infinity,
                  child: Card(
                    margin: EdgeInsets.zero,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: model != null
                          ? Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Model name: ${model!.name}'),
                                Text('Model size: ${model!.size}'),
                              ],
                            )
                          : const Text("No local model found"),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () async {
                          final _model =
                              await FirebaseModelDownloader.instance.getModel(
                            kModelName,
                            FirebaseModelDownloadType.latestModel,
                          );
                          setState(() {
                            model = _model;
                          });
                        },
                        child: const Text('Get latest model'),
                      ),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () async {
                          await FirebaseModelDownloader.instance
                              .deleteDownloadedModel(kModelName);
                          setState(() {
                            model = null;
                          });
                        },
                        child: const Text('Delete local model'),
                      ),
                    ),
                  ],
                ),
                Center(
                  child: ElevatedButton(
                    onPressed: () async {
                      await initGetModelList;
                      // uploadTempData();
                      models!.isEmpty
                          ? print('model is null')
                          : models!.forEach(
                              (element) {
                                print(element.name);
                              },
                            );
                    },
                    child: const Text(
                      'test',
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
