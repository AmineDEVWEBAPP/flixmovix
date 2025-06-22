import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../firebase_options.dart';
import '../utils/methodes.dart';

class FirebaseService {
  FirebaseService._();
  static final FirebaseService _instance = FirebaseService._();

  static Future init() async {
    logger('init Firebase');
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    if (await checkConnectionStatus()) {
      await _instance.setDownloadsCount();
    }
  }

  Future<List<Map<String, dynamic>>> getShareLinks() async {
    List<Map<String, dynamic>> data = [];
    CollectionReference storeLinks =
        FirebaseFirestore.instance.collection('storeLinks');
    QuerySnapshot<Object?>? querySnapshot = await storeLinks.get();
    for (QueryDocumentSnapshot<Object?> doc in querySnapshot.docs) {
      data.add(doc.data() as Map<String, dynamic>);
    }
    return data;
  }

  static Future<String> getShareableLink() async {
    List<Map<String, dynamic>> links = await _instance.getShareLinks();
    String link = links.where((el) => el['shareable']).toList()[0]['link'];
    return link;
  }

  Future<int> setDownloadsCount() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    bool isAdded = sharedPreferences.getBool('downloadCountIsAdded') ?? false;
    if (isAdded) {
      return 0;
    }
    DocumentReference downloads =
        FirebaseFirestore.instance.collection('info').doc('downloads');
    try {
      await FirebaseFirestore.instance.runTransaction(
        (transaction) async {
          DocumentSnapshot snapshot = await transaction.get(downloads);
          if (snapshot.exists) {
            Map downloadCount = snapshot.data() as Map;
            int newDownloadCount = downloadCount['count'] + 1;

            transaction.update(downloads, {'count': newDownloadCount});
            logger('set Download Count seccuess');
            sharedPreferences.setBool('downloadCountIsAdded', true);
            // Return the new count
            return newDownloadCount;
          }
          logger('set Download Count failed');
        },
      );
    } catch (e) {
      logger('Error : $e');
    }
    return 0;
  }

  static Future<bool?> getShowAds() async {
    if (await checkConnectionStatus()) {
      DocumentReference ads =
          FirebaseFirestore.instance.collection('info').doc('ads');
      bool? showAdsCon;
      await ads.get().then((value) {
        Map data = value.data() as Map;
        showAdsCon = data['showAds'];
      });
      return showAdsCon;
    }
    return true;
  }
}
