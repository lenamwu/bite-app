import 'dart:async';

import 'package:collection/collection.dart';

import '/backend/schema/util/firestore_util.dart';
import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class PostsRecord extends FirestoreRecord {
  PostsRecord._(
    DocumentReference reference,
    Map<String, dynamic> data,
  ) : super(reference, data) {
    _initializeFields();
  }

  // "postImage" field.
  String? _postImage;
  String get postImage => _postImage ?? '';
  bool hasPostImage() => _postImage != null;

  // "postUser" field.
  DocumentReference? _postUser;
  DocumentReference? get postUser => _postUser;
  bool hasPostUser() => _postUser != null;

  // "postText" field.
  String? _postText;
  String get postText => _postText ?? '';
  bool hasPostText() => _postText != null;

  // "created_time" field.
  DateTime? _createdTime;
  DateTime? get createdTime => _createdTime;
  bool hasCreatedTime() => _createdTime != null;

  // "likes" field.
  List<DocumentReference>? _likes;
  List<DocumentReference> get likes => _likes ?? const [];
  bool hasLikes() => _likes != null;

  // "comments" field.
  DocumentReference? _comments;
  DocumentReference? get comments => _comments;
  bool hasComments() => _comments != null;

  // "userCookedThis" field.
  List<DocumentReference>? _userCookedThis;
  List<DocumentReference> get userCookedThis => _userCookedThis ?? const [];
  bool hasUserCookedThis() => _userCookedThis != null;

  // "email" field.
  String? _email;
  String get email => _email ?? '';
  bool hasEmail() => _email != null;

  // "display_name" field.
  String? _displayName;
  String get displayName => _displayName ?? '';
  bool hasDisplayName() => _displayName != null;

  // "photo_url" field.
  String? _photoUrl;
  String get photoUrl => _photoUrl ?? '';
  bool hasPhotoUrl() => _photoUrl != null;

  // "uid" field.
  String? _uid;
  String get uid => _uid ?? '';
  bool hasUid() => _uid != null;

  // "phone_number" field.
  String? _phoneNumber;
  String get phoneNumber => _phoneNumber ?? '';
  bool hasPhoneNumber() => _phoneNumber != null;

  // "post_saved_by" field.
  List<DocumentReference>? _postSavedBy;
  List<DocumentReference> get postSavedBy => _postSavedBy ?? const [];
  bool hasPostSavedBy() => _postSavedBy != null;

  // "has_recipe" field.
  bool? _hasRecipe;
  bool get hasRecipe => _hasRecipe ?? false;
  bool hasHasRecipe() => _hasRecipe != null;

  // "recipe_ref" field.
  DocumentReference? _recipeRef;
  DocumentReference? get recipeRef => _recipeRef;
  bool hasRecipeRef() => _recipeRef != null;

  // "postMultPhotos" field.
  List<String>? _postMultPhotos;
  List<String> get postMultPhotos => _postMultPhotos ?? const [];
  bool hasPostMultPhotos() => _postMultPhotos != null;

  void _initializeFields() {
    _postImage = snapshotData['postImage'] as String?;
    _postUser = snapshotData['postUser'] as DocumentReference?;
    _postText = snapshotData['postText'] as String?;
    _createdTime = snapshotData['created_time'] as DateTime?;
    _likes = getDataList(snapshotData['likes']);
    _comments = snapshotData['comments'] as DocumentReference?;
    _userCookedThis = getDataList(snapshotData['userCookedThis']);
    _email = snapshotData['email'] as String?;
    _displayName = snapshotData['display_name'] as String?;
    _photoUrl = snapshotData['photo_url'] as String?;
    _uid = snapshotData['uid'] as String?;
    _phoneNumber = snapshotData['phone_number'] as String?;
    _postSavedBy = getDataList(snapshotData['post_saved_by']);
    _hasRecipe = snapshotData['has_recipe'] as bool?;
    _recipeRef = snapshotData['recipe_ref'] as DocumentReference?;
    _postMultPhotos = getDataList(snapshotData['postMultPhotos']);
  }

  static CollectionReference get collection =>
      FirebaseFirestore.instance.collection('posts');

  static Stream<PostsRecord> getDocument(DocumentReference ref) =>
      ref.snapshots().map((s) => PostsRecord.fromSnapshot(s));

  static Future<PostsRecord> getDocumentOnce(DocumentReference ref) =>
      ref.get().then((s) => PostsRecord.fromSnapshot(s));

  static PostsRecord fromSnapshot(DocumentSnapshot snapshot) => PostsRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static PostsRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      PostsRecord._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'PostsRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is PostsRecord &&
      reference.path.hashCode == other.reference.path.hashCode;
}

Map<String, dynamic> createPostsRecordData({
  String? postImage,
  DocumentReference? postUser,
  String? postText,
  DateTime? createdTime,
  DocumentReference? comments,
  String? email,
  String? displayName,
  String? photoUrl,
  String? uid,
  String? phoneNumber,
  bool? hasRecipe,
  DocumentReference? recipeRef,
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'postImage': postImage,
      'postUser': postUser,
      'postText': postText,
      'created_time': createdTime,
      'comments': comments,
      'email': email,
      'display_name': displayName,
      'photo_url': photoUrl,
      'uid': uid,
      'phone_number': phoneNumber,
      'has_recipe': hasRecipe,
      'recipe_ref': recipeRef,
    }.withoutNulls,
  );

  return firestoreData;
}

class PostsRecordDocumentEquality implements Equality<PostsRecord> {
  const PostsRecordDocumentEquality();

  @override
  bool equals(PostsRecord? e1, PostsRecord? e2) {
    const listEquality = ListEquality();
    return e1?.postImage == e2?.postImage &&
        e1?.postUser == e2?.postUser &&
        e1?.postText == e2?.postText &&
        e1?.createdTime == e2?.createdTime &&
        listEquality.equals(e1?.likes, e2?.likes) &&
        e1?.comments == e2?.comments &&
        listEquality.equals(e1?.userCookedThis, e2?.userCookedThis) &&
        e1?.email == e2?.email &&
        e1?.displayName == e2?.displayName &&
        e1?.photoUrl == e2?.photoUrl &&
        e1?.uid == e2?.uid &&
        e1?.phoneNumber == e2?.phoneNumber &&
        listEquality.equals(e1?.postSavedBy, e2?.postSavedBy) &&
        e1?.hasRecipe == e2?.hasRecipe &&
        e1?.recipeRef == e2?.recipeRef &&
        listEquality.equals(e1?.postMultPhotos, e2?.postMultPhotos);
  }

  @override
  int hash(PostsRecord? e) => const ListEquality().hash([
        e?.postImage,
        e?.postUser,
        e?.postText,
        e?.createdTime,
        e?.likes,
        e?.comments,
        e?.userCookedThis,
        e?.email,
        e?.displayName,
        e?.photoUrl,
        e?.uid,
        e?.phoneNumber,
        e?.postSavedBy,
        e?.hasRecipe,
        e?.recipeRef,
        e?.postMultPhotos
      ]);

  @override
  bool isValidKey(Object? o) => o is PostsRecord;
}
