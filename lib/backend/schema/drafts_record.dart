import 'dart:async';

import 'package:collection/collection.dart';

import '/backend/schema/util/firestore_util.dart';
import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class DraftsRecord extends FirestoreRecord {
  DraftsRecord._(
    DocumentReference reference,
    Map<String, dynamic> data,
  ) : super(reference, data) {
    _initializeFields();
  }

  // "user_id" field.
  DocumentReference? _userId;
  DocumentReference? get userId => _userId;
  bool hasUserId() => _userId != null;

  // "caption" field.
  String? _caption;
  String get caption => _caption ?? '';
  bool hasCaption() => _caption != null;

  // "images" field.
  List<String>? _images;
  List<String> get images => _images ?? const [];
  bool hasImages() => _images != null;

  // "has_recipe" field.
  bool? _hasRecipe;
  bool get hasRecipe => _hasRecipe ?? false;
  bool hasHasRecipe() => _hasRecipe != null;

  // "recipe_title" field.
  String? _recipeTitle;
  String get recipeTitle => _recipeTitle ?? '';
  bool hasRecipeTitle() => _recipeTitle != null;

  // "recipe_notes" field.
  String? _recipeNotes;
  String get recipeNotes => _recipeNotes ?? '';
  bool hasRecipeNotes() => _recipeNotes != null;

  // "recipe_difficulty" field.
  String? _recipeDifficulty;
  String get recipeDifficulty => _recipeDifficulty ?? '';
  bool hasRecipeDifficulty() => _recipeDifficulty != null;

  // "recipe_cookingtime" field.
  String? _recipeCookingtime;
  String get recipeCookingtime => _recipeCookingtime ?? '';
  bool hasRecipeCookingtime() => _recipeCookingtime != null;

  // "recipe_servings" field.
  String? _recipeServings;
  String get recipeServings => _recipeServings ?? '';
  bool hasRecipeServings() => _recipeServings != null;

  // "ingredients" field.
  List<String>? _ingredients;
  List<String> get ingredients => _ingredients ?? const [];
  bool hasIngredients() => _ingredients != null;

  // "preparation" field.
  List<String>? _preparation;
  List<String> get preparation => _preparation ?? const [];
  bool hasPreparation() => _preparation != null;

  // "last_saved" field.
  DateTime? _lastSaved;
  DateTime? get lastSaved => _lastSaved;
  bool hasLastSaved() => _lastSaved != null;

  void _initializeFields() {
    _userId = snapshotData['user_id'] as DocumentReference?;
    _caption = snapshotData['caption'] as String?;
    _images = getDataList(snapshotData['images']);
    _hasRecipe = snapshotData['has_recipe'] as bool?;
    _recipeTitle = snapshotData['recipe_title'] as String?;
    _recipeNotes = snapshotData['recipe_notes'] as String?;
    _recipeDifficulty = snapshotData['recipe_difficulty'] as String?;
    _recipeCookingtime = snapshotData['recipe_cookingtime'] as String?;
    _recipeServings = snapshotData['recipe_servings'] as String?;
    _ingredients = getDataList(snapshotData['ingredients']);
    _preparation = getDataList(snapshotData['preparation']);
    _lastSaved = snapshotData['last_saved'] as DateTime?;
  }

  static CollectionReference get collection =>
      FirebaseFirestore.instance.collection('drafts');

  static Stream<DraftsRecord> getDocument(DocumentReference ref) =>
      ref.snapshots().map((s) => DraftsRecord.fromSnapshot(s));

  static Future<DraftsRecord> getDocumentOnce(DocumentReference ref) =>
      ref.get().then((s) => DraftsRecord.fromSnapshot(s));

  static DraftsRecord fromSnapshot(DocumentSnapshot snapshot) => DraftsRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static DraftsRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      DraftsRecord._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'DraftsRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is DraftsRecord &&
      reference.path.hashCode == other.reference.path.hashCode;
}

Map<String, dynamic> createDraftsRecordData({
  DocumentReference? userId,
  String? caption,
  bool? hasRecipe,
  String? recipeTitle,
  String? recipeNotes,
  String? recipeDifficulty,
  String? recipeCookingtime,
  String? recipeServings,
  DateTime? lastSaved,
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'user_id': userId,
      'caption': caption,
      'has_recipe': hasRecipe,
      'recipe_title': recipeTitle,
      'recipe_notes': recipeNotes,
      'recipe_difficulty': recipeDifficulty,
      'recipe_cookingtime': recipeCookingtime,
      'recipe_servings': recipeServings,
      'last_saved': lastSaved,
    }.withoutNulls,
  );

  return firestoreData;
}

class DraftsRecordDocumentEquality implements Equality<DraftsRecord> {
  const DraftsRecordDocumentEquality();

  @override
  bool equals(DraftsRecord? e1, DraftsRecord? e2) {
    const listEquality = ListEquality();
    return e1?.userId == e2?.userId &&
        e1?.caption == e2?.caption &&
        listEquality.equals(e1?.images, e2?.images) &&
        e1?.hasRecipe == e2?.hasRecipe &&
        e1?.recipeTitle == e2?.recipeTitle &&
        e1?.recipeNotes == e2?.recipeNotes &&
        e1?.recipeDifficulty == e2?.recipeDifficulty &&
        e1?.recipeCookingtime == e2?.recipeCookingtime &&
        e1?.recipeServings == e2?.recipeServings &&
        listEquality.equals(e1?.ingredients, e2?.ingredients) &&
        listEquality.equals(e1?.preparation, e2?.preparation) &&
        e1?.lastSaved == e2?.lastSaved;
  }

  @override
  int hash(DraftsRecord? e) => const ListEquality().hash([
        e?.userId,
        e?.caption,
        e?.images,
        e?.hasRecipe,
        e?.recipeTitle,
        e?.recipeNotes,
        e?.recipeDifficulty,
        e?.recipeCookingtime,
        e?.recipeServings,
        e?.ingredients,
        e?.preparation,
        e?.lastSaved,
      ]);

  @override
  bool isValidKey(Object? o) => o is DraftsRecord;
}
