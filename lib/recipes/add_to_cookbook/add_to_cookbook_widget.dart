import '/auth/firebase_auth/auth_util.dart';
import '/backend/backend.dart';
import '/backend/firebase_storage/storage.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/flutter_flow/upload_data.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'add_to_cookbook_model.dart';
export 'add_to_cookbook_model.dart';

class AddToCookbookWidget extends StatefulWidget {
  const AddToCookbookWidget({
    super.key,
    required this.recipeRef,
  });

  final DocumentReference recipeRef;

  @override
  State<AddToCookbookWidget> createState() => _AddToCookbookWidgetState();
}

class _AddToCookbookWidgetState extends State<AddToCookbookWidget> {
  late AddToCookbookModel _model;

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => AddToCookbookModel());
    _model.captionTextController ??= TextEditingController();
    _model.captionFocusNode ??= FocusNode();
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: FlutterFlowTheme.of(context).primaryBackground,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16.0),
          topRight: Radius.circular(16.0),
        ),
      ),
      child: Padding(
        padding: EdgeInsetsDirectional.fromSTEB(20.0, 16.0, 20.0, 32.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Drag handle
            Center(
              child: Container(
                width: 40.0,
                height: 4.0,
                decoration: BoxDecoration(
                  color: FlutterFlowTheme.of(context).secondary,
                  borderRadius: BorderRadius.circular(2.0),
                ),
              ),
            ),
            SizedBox(height: 16.0),
            // Title
            Text(
              'add to cookbook',
              style: FlutterFlowTheme.of(context).titleMedium.override(
                    fontFamily:
                        FlutterFlowTheme.of(context).titleMediumFamily,
                    color: FlutterFlowTheme.of(context).primary,
                    letterSpacing: 0.0,
                    fontWeight: FontWeight.bold,
                    useGoogleFonts: !FlutterFlowTheme.of(context)
                        .titleMediumIsCustom,
                  ),
            ),
            SizedBox(height: 4.0),
            Text(
              'share that you made this recipe!',
              style: FlutterFlowTheme.of(context).bodySmall.override(
                    fontFamily:
                        FlutterFlowTheme.of(context).bodySmallFamily,
                    color: FlutterFlowTheme.of(context).secondary,
                    letterSpacing: 0.0,
                    useGoogleFonts:
                        !FlutterFlowTheme.of(context).bodySmallIsCustom,
                  ),
            ),
            SizedBox(height: 16.0),
            // Photo upload area
            _model.uploadedFileUrls.isNotEmpty
                ? Column(
                    children: [
                      SizedBox(
                        height: 180.0,
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          itemCount: _model.uploadedFileUrls.length,
                          separatorBuilder: (_, __) => SizedBox(width: 8.0),
                          itemBuilder: (context, index) {
                            return ClipRRect(
                              borderRadius: BorderRadius.circular(12.0),
                              child: Stack(
                                children: [
                                  Image.network(
                                    _model.uploadedFileUrls[index],
                                    width: 180.0,
                                    height: 180.0,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) => Container(
                                      width: 180.0,
                                      height: 180.0,
                                      color: FlutterFlowTheme.of(context).primaryBackground,
                                      child: Icon(Icons.broken_image, size: 40.0),
                                    ),
                                  ),
                                  Positioned(
                                    top: 6.0,
                                    right: 6.0,
                                    child: GestureDetector(
                                      onTap: () {
                                        safeSetState(() {
                                          _model.uploadedFileUrls.removeAt(index);
                                          _model.uploadedLocalFiles.removeAt(index);
                                        });
                                      },
                                      child: Container(
                                        padding: EdgeInsets.all(4.0),
                                        decoration: BoxDecoration(
                                          color: Colors.black54,
                                          shape: BoxShape.circle,
                                        ),
                                        child: Icon(
                                          Icons.close,
                                          color: Colors.white,
                                          size: 16.0,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                      SizedBox(height: 8.0),
                      GestureDetector(
                        onTap: () async {
                          final selectedMedia =
                              await selectMediaWithSourceBottomSheet(
                            context: context,
                            maxWidth: 500.00,
                            maxHeight: 500.00,
                            allowPhoto: true,
                          );
                          if (selectedMedia != null &&
                              selectedMedia.every((m) =>
                                  validateFileFormat(m.storagePath, context))) {
                            safeSetState(() => _model.isDataUploading = true);
                            try {
                              final newFiles = selectedMedia
                                  .map((m) => FFUploadedFile(
                                        name: m.storagePath.split('/').last,
                                        bytes: m.bytes,
                                        height: m.dimensions?.height,
                                        width: m.dimensions?.width,
                                        blurHash: m.blurHash,
                                        originalFilename: m.originalFilename,
                                      ))
                                  .toList();
                              final newUrls = (await Future.wait(
                                selectedMedia.map(
                                  (m) async =>
                                      await uploadData(m.storagePath, m.bytes),
                                ),
                              ))
                                  .where((u) => u != null)
                                  .map((u) => u!)
                                  .toList();
                              if (newFiles.length == selectedMedia.length &&
                                  newUrls.length == selectedMedia.length) {
                                safeSetState(() {
                                  _model.uploadedLocalFiles.addAll(newFiles);
                                  _model.uploadedFileUrls.addAll(newUrls);
                                });
                              }
                            } finally {
                              safeSetState(() => _model.isDataUploading = false);
                            }
                          }
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.add_photo_alternate_outlined,
                              color: FlutterFlowTheme.of(context).secondary,
                              size: 20.0,
                            ),
                            SizedBox(width: 4.0),
                            Text(
                              'add more photos',
                              style: FlutterFlowTheme.of(context)
                                  .bodySmall
                                  .override(
                                    fontFamily: FlutterFlowTheme.of(context)
                                        .bodySmallFamily,
                                    color: FlutterFlowTheme.of(context).secondary,
                                    letterSpacing: 0.0,
                                    useGoogleFonts: !FlutterFlowTheme.of(context)
                                        .bodySmallIsCustom,
                                  ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  )
                : GestureDetector(
                    onTap: () async {
                      final selectedMedia =
                          await selectMediaWithSourceBottomSheet(
                        context: context,
                        maxWidth: 500.00,
                        maxHeight: 500.00,
                        allowPhoto: true,
                      );
                      if (selectedMedia != null &&
                          selectedMedia.every((m) =>
                              validateFileFormat(m.storagePath, context))) {
                        safeSetState(() => _model.isDataUploading = true);
                        try {
                          final newFiles = selectedMedia
                              .map((m) => FFUploadedFile(
                                    name: m.storagePath.split('/').last,
                                    bytes: m.bytes,
                                    height: m.dimensions?.height,
                                    width: m.dimensions?.width,
                                    blurHash: m.blurHash,
                                    originalFilename: m.originalFilename,
                                  ))
                              .toList();
                          final newUrls = (await Future.wait(
                            selectedMedia.map(
                              (m) async =>
                                  await uploadData(m.storagePath, m.bytes),
                            ),
                          ))
                              .where((u) => u != null)
                              .map((u) => u!)
                              .toList();
                          if (newFiles.length == selectedMedia.length &&
                              newUrls.length == selectedMedia.length) {
                            safeSetState(() {
                              _model.uploadedLocalFiles = newFiles;
                              _model.uploadedFileUrls = newUrls;
                            });
                          }
                        } finally {
                          safeSetState(() => _model.isDataUploading = false);
                        }
                      }
                    },
                    child: Container(
                      width: double.infinity,
                      height: 180.0,
                      decoration: BoxDecoration(
                        color: FlutterFlowTheme.of(context).secondaryBackground,
                        borderRadius: BorderRadius.circular(12.0),
                        border: Border.all(
                          color: FlutterFlowTheme.of(context).tertiary,
                          width: 1.5,
                        ),
                      ),
                      child: _model.isDataUploading
                          ? Center(
                              child: SizedBox(
                                width: 24.0,
                                height: 24.0,
                                child: CircularProgressIndicator(
                                  color: FlutterFlowTheme.of(context).tertiary,
                                  strokeWidth: 2.0,
                                ),
                              ),
                            )
                          : Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.add_a_photo_outlined,
                                  color: FlutterFlowTheme.of(context).secondary,
                                  size: 36.0,
                                ),
                                SizedBox(height: 8.0),
                                Text(
                                  'add photos (optional)',
                                  style: FlutterFlowTheme.of(context)
                                      .bodyMedium
                                      .override(
                                        fontFamily:
                                            FlutterFlowTheme.of(context)
                                                .bodyMediumFamily,
                                        color: FlutterFlowTheme.of(context)
                                            .secondary,
                                        letterSpacing: 0.0,
                                        useGoogleFonts:
                                            !FlutterFlowTheme.of(context)
                                                .bodyMediumIsCustom,
                                      ),
                                ),
                              ],
                            ),
                    ),
                  ),
            SizedBox(height: 16.0),
            // Caption text field
            TextFormField(
              controller: _model.captionTextController,
              focusNode: _model.captionFocusNode,
              decoration: InputDecoration(
                hintText: 'add a caption (optional)',
                hintStyle: FlutterFlowTheme.of(context)
                    .bodyMedium
                    .override(
                      fontFamily:
                          FlutterFlowTheme.of(context).bodyMediumFamily,
                      color: FlutterFlowTheme.of(context).secondary,
                      letterSpacing: 0.0,
                      useGoogleFonts: !FlutterFlowTheme.of(context)
                          .bodyMediumIsCustom,
                    ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: FlutterFlowTheme.of(context).tertiary,
                    width: 1.5,
                  ),
                  borderRadius: BorderRadius.circular(12.0),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: FlutterFlowTheme.of(context).primary,
                    width: 1.5,
                  ),
                  borderRadius: BorderRadius.circular(12.0),
                ),
                contentPadding: EdgeInsetsDirectional.fromSTEB(
                    16.0, 12.0, 16.0, 12.0),
              ),
              style: FlutterFlowTheme.of(context).bodyMedium.override(
                    fontFamily:
                        FlutterFlowTheme.of(context).bodyMediumFamily,
                    color: FlutterFlowTheme.of(context).primaryText,
                    letterSpacing: 0.0,
                    useGoogleFonts: !FlutterFlowTheme.of(context)
                        .bodyMediumIsCustom,
                  ),
              maxLines: 3,
              minLines: 1,
            ),
            SizedBox(height: 20.0),
            // Post button
            SizedBox(
              width: double.infinity,
              height: 48.0,
              child: FFButtonWidget(
                onPressed: _model.isSubmitting
                    ? null
                    : () async {
                        safeSetState(() => _model.isSubmitting = true);

                        try {
                          // Fetch the recipe to check ownership
                          final originalRecipe =
                              await RecipesRecord.getDocumentOnce(
                                  widget.recipeRef);

                          DocumentReference recipeRefForPost;

                          if (originalRecipe.userId ==
                              currentUserReference) {
                            // User already owns this recipe
                            recipeRefForPost = widget.recipeRef;
                          } else {
                            // Check if user already has a copy
                            final existingCopies =
                                await queryRecipesRecordOnce(
                              queryBuilder: (r) => r
                                  .where('user_id',
                                      isEqualTo: currentUserReference)
                                  .where('forked_from',
                                      isEqualTo: widget.recipeRef),
                              singleRecord: true,
                            );
                            if (existingCopies.isNotEmpty) {
                              recipeRefForPost =
                                  existingCopies.first.reference;
                            } else {
                              // Create a personal copy
                              final copyRef =
                                  RecipesRecord.collection.doc();
                              await copyRef.set({
                                ...createRecipesRecordData(
                                  title: originalRecipe.title,
                                  notes: originalRecipe.notes,
                                  difficulty: originalRecipe.difficulty,
                                  cookingtime:
                                      originalRecipe.cookingtime,
                                  servings: originalRecipe.servings,
                                  url: originalRecipe.url,
                                  publicrecipeimage:
                                      originalRecipe.publicrecipeimage,
                                  usercreated:
                                      originalRecipe.usercreated,
                                  rating: originalRecipe.rating,
                                  userId: currentUserReference,
                                  forkedFrom: widget.recipeRef,
                                ),
                                ...mapToFirestore({
                                  'ingredients':
                                      originalRecipe.ingredients,
                                  'preparation':
                                      originalRecipe.preparation,
                                  'recipe_images':
                                      originalRecipe.recipeImages,
                                  'recipe_saved_by': [
                                    currentUserReference
                                  ],
                                  'time_generated':
                                      FieldValue.serverTimestamp(),
                                }),
                              });

                              // Move bookmark from original to fork
                              await widget.recipeRef.update({
                                ...mapToFirestore({
                                  'recipe_saved_by':
                                      FieldValue.arrayRemove([
                                    currentUserReference
                                  ]),
                                }),
                              });
                              recipeRefForPost = copyRef;
                            }
                          }

                          // Create the post
                          final postRef =
                              PostsRecord.collection.doc();
                          final postData = createPostsRecordData(
                            postUser: currentUserReference,
                            postText: _model
                                    .captionTextController!.text
                                    .trim()
                                    .isNotEmpty
                                ? _model.captionTextController!.text
                                    .trim()
                                : null,
                            createdTime: getCurrentTimestamp,
                            hasRecipe: true,
                            recipeRef: recipeRefForPost,
                            displayName: currentUserDisplayName,
                            photoUrl: currentUserPhoto,
                            uid: currentUserUid,
                          );

                          // Add photos if uploaded
                          final dataWithPhoto =
                              <String, dynamic>{...postData};
                          if (_model.uploadedFileUrls.isNotEmpty) {
                            dataWithPhoto['postMultPhotos'] =
                                _model.uploadedFileUrls;
                          }

                          await postRef.set(dataWithPhoto);

                          if (context.mounted) {
                            Navigator.pop(context, true);
                            ScaffoldMessenger.of(context)
                              ..hideCurrentSnackBar()
                              ..showSnackBar(
                                SnackBar(
                                  content: Text(
                                    'added to cookbook!',
                                    style: TextStyle(
                                      color: FlutterFlowTheme.of(context)
                                          .primaryBackground,
                                    ),
                                  ),
                                  backgroundColor:
                                      FlutterFlowTheme.of(context)
                                          .accent3,
                                  duration: Duration(seconds: 2),
                                ),
                              );
                          }
                        } finally {
                          if (mounted) {
                            safeSetState(
                                () => _model.isSubmitting = false);
                          }
                        }
                      },
                text: _model.isSubmitting ? 'posting...' : 'post to cookbook',
                options: FFButtonOptions(
                  color: FlutterFlowTheme.of(context).primary,
                  textStyle: FlutterFlowTheme.of(context)
                      .titleSmall
                      .override(
                        fontFamily:
                            FlutterFlowTheme.of(context).titleSmallFamily,
                        color:
                            FlutterFlowTheme.of(context).primaryBackground,
                        letterSpacing: 0.0,
                        fontWeight: FontWeight.w600,
                        useGoogleFonts: !FlutterFlowTheme.of(context)
                            .titleSmallIsCustom,
                      ),
                  borderRadius: BorderRadius.circular(12.0),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
