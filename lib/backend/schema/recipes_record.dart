import 'dart:async';

import 'package:collection/collection.dart';

import '/backend/schema/util/firestore_util.dart';
import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class RecipesRecord extends FirestoreRecord {
  RecipesRecord._(
    DocumentReference reference,
    Map<String, dynamic> data,
  ) : super(reference, data) {
    _initializeFields();
  }

  // "title" field.
  String? _title;
  String get title => _title ?? '';
  bool hasTitle() => _title != null;

  // "notes" field.
  String? _notes;
  String get notes => _notes ?? '';
  bool hasNotes() => _notes != null;

  // "difficulty" field.
  String? _difficulty;
  String get difficulty => _difficulty ?? '';
  bool hasDifficulty() => _difficulty != null;

  // "ingredients" field.
  List<String>? _ingredients;
  List<String> get ingredients => _ingredients ?? const [];
  bool hasIngredients() => _ingredients != null;

  // "preparation" field.
  List<String>? _preparation;
  List<String> get preparation => _preparation ?? const [];
  bool hasPreparation() => _preparation != null;

  // "post_id" field.
  DocumentReference? _postId;
  DocumentReference? get postId => _postId;
  bool hasPostId() => _postId != null;

  // "cookingtime" field.
  String? _cookingtime;
  String get cookingtime => _cookingtime ?? '';
  bool hasCookingtime() => _cookingtime != null;

  // "servings" field.
  String? _servings;
  String get servings => _servings ?? '';
  bool hasServings() => _servings != null;

  // "recipe_saved_by" field.
  List<DocumentReference>? _recipeSavedBy;
  List<DocumentReference> get recipeSavedBy => _recipeSavedBy ?? const [];
  bool hasRecipeSavedBy() => _recipeSavedBy != null;

  // "recipe_images" field.
  List<String>? _recipeImages;
  List<String> get recipeImages => _recipeImages ?? const [];
  bool hasRecipeImages() => _recipeImages != null;

  // "user_id" field.
  DocumentReference? _userId;
  DocumentReference? get userId => _userId;
  bool hasUserId() => _userId != null;

  // "time_generated" field.
  DateTime? _timeGenerated;
  DateTime? get timeGenerated => _timeGenerated;
  bool hasTimeGenerated() => _timeGenerated != null;

  // "url" field.
  String? _url;
  String get url => _url ?? '';
  bool hasUrl() => _url != null;

  // "publicrecipeimage" field.
  String? _publicrecipeimage;
  String get publicrecipeimage => _publicrecipeimage ?? '';
  bool hasPublicrecipeimage() => _publicrecipeimage != null;

  // "usercreated" field.
  bool? _usercreated;
  bool get usercreated => _usercreated ?? false;
  bool hasUsercreated() => _usercreated != null;

  // "rating" field.
  double? _rating;
  double get rating => _rating ?? 0.0;
  bool hasRating() => _rating != null;

  // "forked_from" field.
  DocumentReference? _forkedFrom;
  DocumentReference? get forkedFrom => _forkedFrom;
  bool hasForkedFrom() => _forkedFrom != null;

  // "saved_timestamps" field.
  Map<String, DateTime>? _savedTimestamps;
  Map<String, DateTime> get savedTimestamps => _savedTimestamps ?? const {};
  bool hasSavedTimestamps() => _savedTimestamps != null;

  void _initializeFields() {
    _title = snapshotData['title'] as String?;
    _notes = snapshotData['notes'] as String?;
    _difficulty = snapshotData['difficulty'] as String?;
    _ingredients = getDataList(snapshotData['ingredients']);
    _preparation = getDataList(snapshotData['preparation']);
    _postId = snapshotData['post_id'] as DocumentReference?;
    _cookingtime = snapshotData['cookingtime'] as String?;
    _servings = snapshotData['servings'] as String?;
    _recipeSavedBy = getDataList(snapshotData['recipe_saved_by']);
    _recipeImages = getDataList(snapshotData['recipe_images']);
    _userId = snapshotData['user_id'] as DocumentReference?;
    _timeGenerated = snapshotData['time_generated'] as DateTime?;
    _url = snapshotData['url'] as String?;
    _publicrecipeimage = snapshotData['publicrecipeimage'] as String?;
    _usercreated = snapshotData['usercreated'] as bool?;
    _rating = castToType<double>(snapshotData['rating']);
    _forkedFrom = snapshotData['forked_from'] as DocumentReference?;
    final savedTimestampsData = snapshotData['saved_timestamps'] as Map<String, dynamic>?;
    if (savedTimestampsData != null) {
      _savedTimestamps = savedTimestampsData.map((key, value) =>
          MapEntry(key, (value as Timestamp).toDate()));
    }
  }

  static CollectionReference get collection =>
      FirebaseFirestore.instance.collection('recipes');

  static Stream<RecipesRecord> getDocument(DocumentReference ref) =>
      ref.snapshots().map((s) => RecipesRecord.fromSnapshot(s));

  static Future<RecipesRecord> getDocumentOnce(DocumentReference ref) =>
      ref.get().then((s) => RecipesRecord.fromSnapshot(s));

  static RecipesRecord fromSnapshot(DocumentSnapshot snapshot) =>
      RecipesRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static RecipesRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      RecipesRecord._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'RecipesRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is RecipesRecord &&
      reference.path.hashCode == other.reference.path.hashCode;
}

Map<String, dynamic> createRecipesRecordData({
  String? title,
  String? notes,
  String? difficulty,
  DocumentReference? postId,
  String? cookingtime,
  String? servings,
  DocumentReference? userId,
  DateTime? timeGenerated,
  String? url,
  String? publicrecipeimage,
  bool? usercreated,
  double? rating,
  DocumentReference? forkedFrom,
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'title': title,
      'notes': notes,
      'difficulty': difficulty,
      'post_id': postId,
      'cookingtime': cookingtime,
      'servings': servings,
      'user_id': userId,
      'time_generated': timeGenerated,
      'url': url,
      'publicrecipeimage': publicrecipeimage,
      'usercreated': usercreated,
      'rating': rating,
      'forked_from': forkedFrom,
    }.withoutNulls,
  );

  return firestoreData;
}

class RecipesRecordDocumentEquality implements Equality<RecipesRecord> {
  const RecipesRecordDocumentEquality();

  @override
  bool equals(RecipesRecord? e1, RecipesRecord? e2) {
    const listEquality = ListEquality();
    return e1?.title == e2?.title &&
        e1?.notes == e2?.notes &&
        e1?.difficulty == e2?.difficulty &&
        listEquality.equals(e1?.ingredients, e2?.ingredients) &&
        listEquality.equals(e1?.preparation, e2?.preparation) &&
        e1?.postId == e2?.postId &&
        e1?.cookingtime == e2?.cookingtime &&
        e1?.servings == e2?.servings &&
        listEquality.equals(e1?.recipeSavedBy, e2?.recipeSavedBy) &&
        listEquality.equals(e1?.recipeImages, e2?.recipeImages) &&
        e1?.userId == e2?.userId &&
        e1?.timeGenerated == e2?.timeGenerated &&
        e1?.url == e2?.url &&
        e1?.publicrecipeimage == e2?.publicrecipeimage &&
        e1?.usercreated == e2?.usercreated &&
        e1?.rating == e2?.rating &&
        e1?.forkedFrom == e2?.forkedFrom;
  }

  @override
  int hash(RecipesRecord? e) => const ListEquality().hash([
        e?.title,
        e?.notes,
        e?.difficulty,
        e?.ingredients,
        e?.preparation,
        e?.postId,
        e?.cookingtime,
        e?.servings,
        e?.recipeSavedBy,
        e?.recipeImages,
        e?.userId,
        e?.timeGenerated,
        e?.url,
        e?.publicrecipeimage,
        e?.usercreated,
        e?.rating,
        e?.forkedFrom
      ]);

  @override
  bool isValidKey(Object? o) => o is RecipesRecord;
}
