import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:the_hit_times_app/features/live/models/livematch.dart';

class LiveMatchRepo {
   static const String _liveSessionCollection = "live_sessions";

  final _db = FirebaseFirestore.instance;
  late final _liveSessionRef;

   LiveMatchRepo() {
     _liveSessionRef = _db.collection(_liveSessionCollection).withConverter(
        fromFirestore: LiveMatch.fromFirestore,
        toFirestore: (LiveMatch liveMatch, options) => liveMatch.toFirestore()
    );
  }

   getLiveMatches() {
     return _liveSessionRef.orderBy(LiveMatch.FIELD_MATCH_LIVE, descending: true)
         .orderBy(LiveMatch.FIELD_MATCH_DATE, descending: true);
   }

   getLiveMatchById(String id) {
     return _db.collection(_liveSessionCollection).doc(id).snapshots();
   }

}