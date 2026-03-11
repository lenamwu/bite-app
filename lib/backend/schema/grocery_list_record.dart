import 'dart:async';

import 'package:collection/collection.dart';

import '/backend/schema/util/firestore_util.dart';
import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class GroceryListRecord extends FirestoreRecord {
  GroceryListRecord._(
    DocumentReference reference,
    Map<String, dynamic> data,
  ) : super(reference, data) {
    _initializeFields();
  }

  // "ingredient" field.
  String? _ingredient;
  String get ingredient => _ingredient ?? '';
  bool hasIngredient() => _ingredient != null;

  // "completed" field.
  bool? _completed;
  bool get completed => _completed ?? false;
  bool hasCompleted() => _completed != null;

  // "createdTime" field.
  DateTime? _createdTime;
  DateTime? get createdTime => _createdTime;
  bool hasCreatedTime() => _createdTime != null;

  DocumentReference get parentReference => reference.parent.parent!;

  void _initializeFields() {
    _ingredient = snapshotData['ingredient'] as String?;
    _completed = snapshotData['completed'] as bool?;
    _createdTime = snapshotData['createdTime'] as DateTime?;
  }

  static Query<Map<String, dynamic>> collection([DocumentReference? parent]) =>
      parent != null
          ? parent.collection('grocery_list')
          : FirebaseFirestore.instance.collectionGroup('grocery_list');

  static DocumentReference createDoc(DocumentReference parent, {String? id}) =>
      parent.collection('grocery_list').doc(id);

  static Stream<GroceryListRecord> getDocument(DocumentReference ref) =>
      ref.snapshots().map((s) => GroceryListRecord.fromSnapshot(s));

  static Future<GroceryListRecord> getDocumentOnce(DocumentReference ref) =>
      ref.get().then((s) => GroceryListRecord.fromSnapshot(s));

  static GroceryListRecord fromSnapshot(DocumentSnapshot snapshot) =>
      GroceryListRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static GroceryListRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      GroceryListRecord._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'GroceryListRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is GroceryListRecord &&
      reference.path.hashCode == other.reference.path.hashCode;
}

Map<String, dynamic> createGroceryListRecordData({
  String? ingredient,
  bool? completed,
  DateTime? createdTime,
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'ingredient': ingredient,
      'completed': completed,
      'createdTime': createdTime,
    }.withoutNulls,
  );

  return firestoreData;
}

class GroceryListRecordDocumentEquality implements Equality<GroceryListRecord> {
  const GroceryListRecordDocumentEquality();

  @override
  bool equals(GroceryListRecord? e1, GroceryListRecord? e2) {
    return e1?.ingredient == e2?.ingredient &&
        e1?.completed == e2?.completed &&
        e1?.createdTime == e2?.createdTime;
  }

  @override
  int hash(GroceryListRecord? e) =>
      const ListEquality().hash([e?.ingredient, e?.completed, e?.createdTime]);

  @override
  bool isValidKey(Object? o) => o is GroceryListRecord;
}
