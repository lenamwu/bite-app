import 'dart:async';

import 'package:collection/collection.dart';

import '/backend/schema/util/firestore_util.dart';
import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class FeaturedListsRecord extends FirestoreRecord {
  FeaturedListsRecord._(
    DocumentReference reference,
    Map<String, dynamic> data,
  ) : super(reference, data) {
    _initializeFields();
  }

  // "image" field.
  String? _image;
  String get image => _image ?? '';
  bool hasImage() => _image != null;

  // "recipes" field.
  List<DocumentReference>? _recipes;
  List<DocumentReference> get recipes => _recipes ?? const [];
  bool hasRecipes() => _recipes != null;

  // "title" field.
  String? _title;
  String get title => _title ?? '';
  bool hasTitle() => _title != null;

  // "extendedTitle" field.
  String? _extendedTitle;
  String get extendedTitle => _extendedTitle ?? '';
  bool hasExtendedTitle() => _extendedTitle != null;

  void _initializeFields() {
    _image = snapshotData['image'] as String?;
    _recipes = getDataList(snapshotData['recipes']);
    _title = snapshotData['title'] as String?;
    _extendedTitle = snapshotData['extendedTitle'] as String?;
  }

  static CollectionReference get collection =>
      FirebaseFirestore.instance.collection('featured_lists');

  static Stream<FeaturedListsRecord> getDocument(DocumentReference ref) =>
      ref.snapshots().map((s) => FeaturedListsRecord.fromSnapshot(s));

  static Future<FeaturedListsRecord> getDocumentOnce(DocumentReference ref) =>
      ref.get().then((s) => FeaturedListsRecord.fromSnapshot(s));

  static FeaturedListsRecord fromSnapshot(DocumentSnapshot snapshot) =>
      FeaturedListsRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static FeaturedListsRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      FeaturedListsRecord._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'FeaturedListsRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is FeaturedListsRecord &&
      reference.path.hashCode == other.reference.path.hashCode;
}

Map<String, dynamic> createFeaturedListsRecordData({
  String? image,
  String? title,
  String? extendedTitle,
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'image': image,
      'title': title,
      'extendedTitle': extendedTitle,
    }.withoutNulls,
  );

  return firestoreData;
}

class FeaturedListsRecordDocumentEquality
    implements Equality<FeaturedListsRecord> {
  const FeaturedListsRecordDocumentEquality();

  @override
  bool equals(FeaturedListsRecord? e1, FeaturedListsRecord? e2) {
    const listEquality = ListEquality();
    return e1?.image == e2?.image &&
        listEquality.equals(e1?.recipes, e2?.recipes) &&
        e1?.title == e2?.title &&
        e1?.extendedTitle == e2?.extendedTitle;
  }

  @override
  int hash(FeaturedListsRecord? e) => const ListEquality()
      .hash([e?.image, e?.recipes, e?.title, e?.extendedTitle]);

  @override
  bool isValidKey(Object? o) => o is FeaturedListsRecord;
}
