import 'dart:async';

import 'package:collection/collection.dart';

import '/backend/schema/util/firestore_util.dart';
import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class FollowRequestsRecord extends FirestoreRecord {
  FollowRequestsRecord._(
    DocumentReference reference,
    Map<String, dynamic> data,
  ) : super(reference, data) {
    _initializeFields();
  }

  // "fromUserId" field.
  DocumentReference? _fromUserId;
  DocumentReference? get fromUserId => _fromUserId;
  bool hasFromUserId() => _fromUserId != null;

  // "status" field.
  String? _status;
  String get status => _status ?? '';
  bool hasStatus() => _status != null;

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
    _fromUserId = snapshotData['fromUserId'] as DocumentReference?;
    _status = snapshotData['status'] as String?;
    _createdAt = snapshotData['createdAt'] as DateTime?;
    _seen = snapshotData['seen'] as bool?;
  }

  static Query<Map<String, dynamic>> collection([DocumentReference? parent]) =>
      parent != null
          ? parent.collection('followRequests')
          : FirebaseFirestore.instance.collectionGroup('followRequests');

  static DocumentReference createDoc(DocumentReference parent, {String? id}) =>
      parent.collection('followRequests').doc(id);

  static Stream<FollowRequestsRecord> getDocument(DocumentReference ref) =>
      ref.snapshots().map((s) => FollowRequestsRecord.fromSnapshot(s));

  static Future<FollowRequestsRecord> getDocumentOnce(DocumentReference ref) =>
      ref.get().then((s) => FollowRequestsRecord.fromSnapshot(s));

  static FollowRequestsRecord fromSnapshot(DocumentSnapshot snapshot) =>
      FollowRequestsRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static FollowRequestsRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      FollowRequestsRecord._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'FollowRequestsRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is FollowRequestsRecord &&
      reference.path.hashCode == other.reference.path.hashCode;
}

Map<String, dynamic> createFollowRequestsRecordData({
  DocumentReference? fromUserId,
  String? status,
  DateTime? createdAt,
  bool? seen,
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'fromUserId': fromUserId,
      'status': status,
      'createdAt': createdAt,
      'seen': seen,
    }.withoutNulls,
  );

  return firestoreData;
}

class FollowRequestsRecordDocumentEquality
    implements Equality<FollowRequestsRecord> {
  const FollowRequestsRecordDocumentEquality();

  @override
  bool equals(FollowRequestsRecord? e1, FollowRequestsRecord? e2) {
    return e1?.fromUserId == e2?.fromUserId &&
        e1?.status == e2?.status &&
        e1?.createdAt == e2?.createdAt &&
        e1?.seen == e2?.seen;
  }

  @override
  int hash(FollowRequestsRecord? e) => const ListEquality()
      .hash([e?.fromUserId, e?.status, e?.createdAt, e?.seen]);

  @override
  bool isValidKey(Object? o) => o is FollowRequestsRecord;
}
