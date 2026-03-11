import 'dart:async';

import 'package:collection/collection.dart';

import '/backend/schema/util/firestore_util.dart';
import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class CommentsRecord extends FirestoreRecord {
  CommentsRecord._(
    DocumentReference reference,
    Map<String, dynamic> data,
  ) : super(reference, data) {
    _initializeFields();
  }

  // "comment" field.
  String? _comment;
  String get comment => _comment ?? '';
  bool hasComment() => _comment != null;

  // "time" field.
  DateTime? _time;
  DateTime? get time => _time;
  bool hasTime() => _time != null;

  // "postref" field.
  DocumentReference? _postref;
  DocumentReference? get postref => _postref;
  bool hasPostref() => _postref != null;

  // "userref" field.
  DocumentReference? _userref;
  DocumentReference? get userref => _userref;
  bool hasUserref() => _userref != null;

  // "reciperef" field.
  DocumentReference? _reciperef;
  DocumentReference? get reciperef => _reciperef;
  bool hasReciperef() => _reciperef != null;

  // "displayname" field.
  String? _displayname;
  String get displayname => _displayname ?? '';
  bool hasDisplayname() => _displayname != null;

  // "profileimage" field.
  String? _profileimage;
  String get profileimage => _profileimage ?? '';
  bool hasProfileimage() => _profileimage != null;

  void _initializeFields() {
    _comment = snapshotData['comment'] as String?;
    _time = snapshotData['time'] as DateTime?;
    _postref = snapshotData['postref'] as DocumentReference?;
    _userref = snapshotData['userref'] as DocumentReference?;
    _reciperef = snapshotData['reciperef'] as DocumentReference?;
    _displayname = snapshotData['displayname'] as String?;
    _profileimage = snapshotData['profileimage'] as String?;
  }

  static CollectionReference get collection =>
      FirebaseFirestore.instance.collection('comments');

  static Stream<CommentsRecord> getDocument(DocumentReference ref) =>
      ref.snapshots().map((s) => CommentsRecord.fromSnapshot(s));

  static Future<CommentsRecord> getDocumentOnce(DocumentReference ref) =>
      ref.get().then((s) => CommentsRecord.fromSnapshot(s));

  static CommentsRecord fromSnapshot(DocumentSnapshot snapshot) =>
      CommentsRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static CommentsRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      CommentsRecord._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'CommentsRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is CommentsRecord &&
      reference.path.hashCode == other.reference.path.hashCode;
}

Map<String, dynamic> createCommentsRecordData({
  String? comment,
  DateTime? time,
  DocumentReference? postref,
  DocumentReference? userref,
  DocumentReference? reciperef,
  String? displayname,
  String? profileimage,
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'comment': comment,
      'time': time,
      'postref': postref,
      'userref': userref,
      'reciperef': reciperef,
      'displayname': displayname,
      'profileimage': profileimage,
    }.withoutNulls,
  );

  return firestoreData;
}

class CommentsRecordDocumentEquality implements Equality<CommentsRecord> {
  const CommentsRecordDocumentEquality();

  @override
  bool equals(CommentsRecord? e1, CommentsRecord? e2) {
    return e1?.comment == e2?.comment &&
        e1?.time == e2?.time &&
        e1?.postref == e2?.postref &&
        e1?.userref == e2?.userref &&
        e1?.reciperef == e2?.reciperef &&
        e1?.displayname == e2?.displayname &&
        e1?.profileimage == e2?.profileimage;
  }

  @override
  int hash(CommentsRecord? e) => const ListEquality().hash([
        e?.comment,
        e?.time,
        e?.postref,
        e?.userref,
        e?.reciperef,
        e?.displayname,
        e?.profileimage
      ]);

  @override
  bool isValidKey(Object? o) => o is CommentsRecord;
}
