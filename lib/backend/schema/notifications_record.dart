import 'dart:async';

import 'package:collection/collection.dart';

import '/backend/schema/util/firestore_util.dart';
import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class NotificationsRecord extends FirestoreRecord {
  NotificationsRecord._(
    DocumentReference reference,
    Map<String, dynamic> data,
  ) : super(reference, data) {
    _initializeFields();
  }

  // "type" field.
  String? _type;
  String get type => _type ?? '';
  bool hasType() => _type != null;

  // "fromUser" field.
  DocumentReference? _fromUser;
  DocumentReference? get fromUser => _fromUser;
  bool hasFromUser() => _fromUser != null;

  // "post" field.
  DocumentReference? _post;
  DocumentReference? get post => _post;
  bool hasPost() => _post != null;

  // "commentText" field.
  String? _commentText;
  String get commentText => _commentText ?? '';
  bool hasCommentText() => _commentText != null;

  // "createdAt" field.
  DateTime? _createdAt;
  DateTime? get createdAt => _createdAt;
  bool hasCreatedAt() => _createdAt != null;

  // "seen" field.
  bool? _seen;
  bool get seen => _seen ?? false;
  bool hasSeen() => _seen != null;

  DocumentReference get parentReference => reference.parent.parent!;

  void _initializeFields() {
    _type = snapshotData['type'] as String?;
    _fromUser = snapshotData['fromUser'] as DocumentReference?;
    _post = snapshotData['post'] as DocumentReference?;
    _commentText = snapshotData['commentText'] as String?;
    _createdAt = snapshotData['createdAt'] as DateTime?;
    _seen = snapshotData['seen'] as bool?;
  }

  static Query<Map<String, dynamic>> collection([DocumentReference? parent]) =>
      parent != null
          ? parent.collection('notifications')
          : FirebaseFirestore.instance.collectionGroup('notifications');

  static DocumentReference createDoc(DocumentReference parent, {String? id}) =>
      parent.collection('notifications').doc(id);

  static Stream<NotificationsRecord> getDocument(DocumentReference ref) =>
      ref.snapshots().map((s) => NotificationsRecord.fromSnapshot(s));

  static Future<NotificationsRecord> getDocumentOnce(DocumentReference ref) =>
      ref.get().then((s) => NotificationsRecord.fromSnapshot(s));

  static NotificationsRecord fromSnapshot(DocumentSnapshot snapshot) =>
      NotificationsRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static NotificationsRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      NotificationsRecord._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'NotificationsRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is NotificationsRecord &&
      reference.path.hashCode == other.reference.path.hashCode;
}

Map<String, dynamic> createNotificationsRecordData({
  String? type,
  DocumentReference? fromUser,
  DocumentReference? post,
  String? commentText,
  DateTime? createdAt,
  bool? seen,
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'type': type,
      'fromUser': fromUser,
      'post': post,
      'commentText': commentText,
      'createdAt': createdAt,
      'seen': seen,
    }.withoutNulls,
  );

  return firestoreData;
}

class NotificationsRecordDocumentEquality
    implements Equality<NotificationsRecord> {
  const NotificationsRecordDocumentEquality();

  @override
  bool equals(NotificationsRecord? e1, NotificationsRecord? e2) {
    return e1?.type == e2?.type &&
        e1?.fromUser == e2?.fromUser &&
        e1?.post == e2?.post &&
        e1?.commentText == e2?.commentText &&
        e1?.createdAt == e2?.createdAt &&
        e1?.seen == e2?.seen;
  }

  @override
  int hash(NotificationsRecord? e) => const ListEquality().hash(
      [e?.type, e?.fromUser, e?.post, e?.commentText, e?.createdAt, e?.seen]);

  @override
  bool isValidKey(Object? o) => o is NotificationsRecord;
}
