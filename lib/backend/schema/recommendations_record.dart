import 'dart:async';

import 'package:collection/collection.dart';

import '/backend/schema/util/firestore_util.dart';
import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class RecommendationsRecord extends FirestoreRecord {
  RecommendationsRecord._(
    DocumentReference reference,
    Map<String, dynamic> data,
  ) : super(reference, data) {
    _initializeFields();
  }

  // "url" field.
  String? _url;
  String get url => _url ?? '';
  bool hasUrl() => _url != null;

  // "title" field.
  String? _title;
  String get title => _title ?? '';
  bool hasTitle() => _title != null;

  // "image" field.
  String? _image;
  String get image => _image ?? '';
  bool hasImage() => _image != null;

  void _initializeFields() {
    _url = snapshotData['url'] as String?;
    _title = snapshotData['title'] as String?;
    _image = snapshotData['image'] as String?;
  }

  static CollectionReference get collection =>
      FirebaseFirestore.instance.collection('recommendations');

  static Stream<RecommendationsRecord> getDocument(DocumentReference ref) =>
      ref.snapshots().map((s) => RecommendationsRecord.fromSnapshot(s));

  static Future<RecommendationsRecord> getDocumentOnce(DocumentReference ref) =>
      ref.get().then((s) => RecommendationsRecord.fromSnapshot(s));

  static RecommendationsRecord fromSnapshot(DocumentSnapshot snapshot) =>
      RecommendationsRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static RecommendationsRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      RecommendationsRecord._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'RecommendationsRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is RecommendationsRecord &&
      reference.path.hashCode == other.reference.path.hashCode;
}

Map<String, dynamic> createRecommendationsRecordData({
  String? url,
  String? title,
  String? image,
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'url': url,
      'title': title,
      'image': image,
    }.withoutNulls,
  );

  return firestoreData;
}

class RecommendationsRecordDocumentEquality
    implements Equality<RecommendationsRecord> {
  const RecommendationsRecordDocumentEquality();

  @override
  bool equals(RecommendationsRecord? e1, RecommendationsRecord? e2) {
    return e1?.url == e2?.url &&
        e1?.title == e2?.title &&
        e1?.image == e2?.image;
  }

  @override
  int hash(RecommendationsRecord? e) =>
      const ListEquality().hash([e?.url, e?.title, e?.image]);

  @override
  bool isValidKey(Object? o) => o is RecommendationsRecord;
}
