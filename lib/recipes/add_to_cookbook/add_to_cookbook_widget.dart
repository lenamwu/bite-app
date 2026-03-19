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
                  safeSetState(
                      () => _model.isDataUploading = true);

                  var selectedUploadedFiles = <FFUploadedFile>[];
                  var downloadUrls = <String>[];

                  try {
                    selectedUploadedFiles = selectedMedia
                        .map((m) => FFUploadedFile(
                              name: m.storagePath.split('/').last,
                              bytes: m.bytes,
                              height: m.dimensions?.height,
                              width: m.dimensions?.width,
                              blurHash: m.blurHash,
                              originalFilename: m.originalFilename,
                            ))
                        .toList();

                    downloadUrls = (await Future.wait(
                      selectedMedia.map(
                        (m) async =>
                            await uploadData(m.storagePath, m.bytes),
                      ),
                    ))
                        .where((u) => u != null)
                        .map((u) => u!)
                        .toList();
                  } finally {
                    _model.isDataUploading = false;
                  }
                  if (selectedUploadedFiles.length ==
                          selectedMedia.length &&
                      downloadUrls.length == selectedMedia.length) {
                    safeSetState(() {
                      _model.uploadedLocalFile =
                          selectedUploadedFiles.first;
                      _model.uploadedFileUrl = downloadUrls.first;
                    });
                  }
                }
              },
              child: Container(
                width: double.infinity,
                height: 180.0,
                decoration: BoxDecoration(
                  color:
                      FlutterFlowTheme.of(context).secondaryBackground,
                  borderRadius: BorderRadius.circular(12.0),
                  border: Border.all(
                    color: FlutterFlowTheme.of(context).tertiary,
                    width: 1.5,
                  ),
                ),
                child: _model.uploadedFileUrl.isNotEmpty
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(11.0),
                        child: Stack(
                          fit: StackFit.expand,
                          children: [
                            Image.network(
                              _model.uploadedFileUrl,
                              fit: BoxFit.cover,
                            ),
                            Positioned(
                              top: 8.0,
                              right: 8.0,
                              child: GestureDetector(
                                onTap: () {
                                  safeSetState(() {
                                    _model.uploadedFileUrl = '';
                                    _model.uploadedLocalFile =
                                        FFUploadedFile(bytes: null);
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
                                    size: 18.0,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    : _model.isDataUploading
                        ? Center(
                            child: SizedBox(
                              width: 24.0,
                              height: 24.0,
                              child: CircularProgressIndicator(
                                color:
                                    FlutterFlowTheme.of(context).tertiary,
                                strokeWidth: 2.0,
                              ),
                            ),
                          )
                        : Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.add_a_photo_outlined,
                                color: FlutterFlowTheme.of(context)
                                    .secondary,
                                size: 36.0,
                              ),
                              SizedBox(height: 8.0),
                              Text(
                                'add a photo (optional)',
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
                            recipeRef: widget.recipeRef,
                            displayName: currentUserDisplayName,
                            photoUrl: currentUserPhoto,
                            uid: currentUserUid,
                          );

                          // Add photo if uploaded
                          final dataWithPhoto =
                              <String, dynamic>{...postData};
                          if (_model.uploadedFileUrl.isNotEmpty) {
                            dataWithPhoto['postMultPhotos'] =
                                [_model.uploadedFileUrl];
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
