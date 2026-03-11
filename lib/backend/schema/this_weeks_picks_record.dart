import 'dart:async';

import 'package:collection/collection.dart';

import '/backend/schema/util/firestore_util.dart';
import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class ThisWeeksPicksRecord extends FirestoreRecord {
  ThisWeeksPicksRecord._(
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
      FirebaseFirestore.instance.collection('this_weeks_picks');

  static Stream<ThisWeeksPicksRecord> getDocument(DocumentReference ref) =>
      ref.snapshots().map((s) => ThisWeeksPicksRecord.fromSnapshot(s));

  static Future<ThisWeeksPicksRecord> getDocumentOnce(DocumentReference ref) =>
      ref.get().then((s) => ThisWeeksPicksRecord.fromSnapshot(s));

  static ThisWeeksPicksRecord fromSnapshot(DocumentSnapshot snapshot) =>
      ThisWeeksPicksRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static ThisWeeksPicksRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      ThisWeeksPicksRecord._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'ThisWeeksPicksRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is ThisWeeksPicksRecord &&
      reference.path.hashCode == other.reference.path.hashCode;
}

Map<String, dynamic> createThisWeeksPicksRecordData({
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

class ThisWeeksPicksRecordDocumentEquality
    implements Equality<ThisWeeksPicksRecord> {
  const ThisWeeksPicksRecordDocumentEquality();

  @override
  bool equals(ThisWeeksPicksRecord? e1, ThisWeeksPicksRecord? e2) {
    return e1?.url == e2?.url &&
        e1?.title == e2?.title &&
        e1?.image == e2?.image;
  }

  @override
  int hash(ThisWeeksPicksRecord? e) =>
      const ListEquality().hash([e?.url, e?.title, e?.image]);

  @override
  bool isValidKey(Object? o) => o is ThisWeeksPicksRecord;
}
