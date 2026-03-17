import '/auth/base_auth_user_provider.dart';
import '/auth/firebase_auth/auth_util.dart';
import '/backend/backend.dart';
import '/backend/firebase_storage/storage.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/flutter_flow/upload_data.dart';
import 'dart:ui';
import '/index.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'create_post_model.dart';
export 'create_post_model.dart';
import '/components/bite_logo.dart';

class CreatePostWidget extends StatefulWidget {
  const CreatePostWidget({super.key});

  static String routeName = 'createPost';
  static String routePath = '/createPost';

  @override
  State<CreatePostWidget> createState() => _CreatePostWidgetState();
}

class _CreatePostWidgetState extends State<CreatePostWidget> {
  late CreatePostModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => CreatePostModel());

    // On page load action.
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      _model.currentimages =
          _model.uploadedFileUrls_uploadDatanewpics2.toList().cast<String>();
      safeSetState(() {});
    });

    _model.addCaptionTextController ??= TextEditingController();
    _model.addCaptionFocusNode ??= FocusNode();

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    context.watch<FFAppState>();

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
        appBar: AppBar(
          backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
          automaticallyImplyLeading: false,
          leading: FlutterFlowIconButton(
            borderColor: Colors.transparent,
            borderRadius: 30.0,
            borderWidth: 1.0,
            buttonSize: 60.0,
            icon: Icon(
              Icons.arrow_back_sharp,
              color: FlutterFlowTheme.of(context).primary,
              size: 30.0,
            ),
            onPressed: () async {
              context.pop();
            },
          ),
          title: Align(
            alignment: AlignmentDirectional(-1.0, -1.0),
            child: BiteLogo(),
          ),
          actions: [],
          centerTitle: false,
          elevation: 2.0,
        ),
        body: SafeArea(
          top: true,
          child: Align(
            alignment: AlignmentDirectional(0.0, 0.0),
            child: Padding(
              padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 40.0),
              child: Form(
                key: _model.formKey,
                autovalidateMode: AutovalidateMode.disabled,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding:
                            EdgeInsetsDirectional.fromSTEB(0.0, 20.0, 0.0, 0.0),
                        child: Builder(
                          builder: (context) {
                            final uploadedphotos =
                                _model.currentimages.toList();

                            return SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                children: List.generate(uploadedphotos.length,
                                    (uploadedphotosIndex) {
                                  final uploadedphotosItem =
                                      uploadedphotos[uploadedphotosIndex];
                                  return Stack(
                                    children: [
                                      ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(0.0),
                                        child: Image.network(
                                          uploadedphotosItem,
                                          width: 200.0,
                                          height: 200.0,
                                          fit: BoxFit.cover,
                                          errorBuilder:
                                              (context, error, stackTrace) =>
                                                  Image.asset(
                                            'assets/images/error_image.png',
                                            width: 200.0,
                                            height: 200.0,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                            150.0, 155.0, 0.0, 0.0),
                                        child: InkWell(
                                          splashColor: Colors.transparent,
                                          focusColor: Colors.transparent,
                                          hoverColor: Colors.transparent,
                                          highlightColor: Colors.transparent,
                                          onTap: () async {
                                            _model.removeFromCurrentimages(
                                                uploadedphotosItem);
                                            safeSetState(() {});
                                          },
                                          child: Icon(
                                            Icons.delete_outline,
                                            color: FlutterFlowTheme.of(context)
                                                .customColor3,
                                            size: 27.0,
                                          ),
                                        ),
                                      ),
                                    ],
                                  );
                                }),
                              ),
                            );
                          },
                        ),
                      ),
                      Stack(
                        children: [
                          Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(
                                0.0, 25.0, 0.0, 0.0),
                            child: Container(
                              width: 150.0,
                              child: Stack(
                                children: [
                                  Align(
                                    alignment: AlignmentDirectional(0.0, 0.0),
                                    child: Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          0.0, 60.0, 0.0, 0.0),
                                      child: Text(
                                        'upload image',
                                        style: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .override(
                                              fontFamily:
                                                  FlutterFlowTheme.of(context)
                                                      .bodyMediumFamily,
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .primary,
                                              letterSpacing: 0.0,
                                              fontWeight: FontWeight.bold,
                                              useGoogleFonts:
                                                  !FlutterFlowTheme.of(context)
                                                      .bodyMediumIsCustom,
                                            ),
                                      ),
                                    ),
                                  ),
                                  Align(
                                    alignment:
                                        AlignmentDirectional(-0.03, -0.07),
                                    child: Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          3.0, 30.0, 0.0, 0.0),
                                      child: Icon(
                                        Icons.upload_file,
                                        color: FlutterFlowTheme.of(context)
                                            .primaryText,
                                        size: 24.0,
                                      ),
                                    ),
                                  ),
                                  Align(
                                    alignment: AlignmentDirectional(0.0, -1.0),
                                    child: InkWell(
                                      splashColor: Colors.transparent,
                                      focusColor: Colors.transparent,
                                      hoverColor: Colors.transparent,
                                      highlightColor: Colors.transparent,
                                      onTap: () async {
                                        if (loggedIn != true) {
                                          context.pushNamed(
                                              OnboardingWidget.routeName);
                                        }
                                        final selectedMedia = await selectMedia(
                                          maxWidth: 500.00,
                                          maxHeight: 500.00,
                                          mediaSource: MediaSource.photoGallery,
                                          multiImage: true,
                                        );
                                        if (selectedMedia != null &&
                                            selectedMedia.every((m) =>
                                                validateFileFormat(
                                                    m.storagePath, context))) {
                                          safeSetState(() => _model
                                                  .isDataUploading_uploadDatanewpics2 =
                                              true);
                                          var selectedUploadedFiles =
                                              <FFUploadedFile>[];

                                          var downloadUrls = <String>[];
                                          try {
                                            selectedUploadedFiles =
                                                selectedMedia
                                                    .map((m) => FFUploadedFile(
                                                          name: m.storagePath
                                                              .split('/')
                                                              .last,
                                                          bytes: m.bytes,
                                                          height: m.dimensions
                                                              ?.height,
                                                          width: m.dimensions
                                                              ?.width,
                                                          blurHash: m.blurHash,
                                                          originalFilename: m
                                                              .originalFilename,
                                                        ))
                                                    .toList();

                                            downloadUrls = (await Future.wait(
                                              selectedMedia.map(
                                                (m) async => await uploadData(
                                                    m.storagePath, m.bytes),
                                              ),
                                            ))
                                                .where((u) => u != null)
                                                .map((u) => u!)
                                                .toList();
                                          } finally {
                                            _model.isDataUploading_uploadDatanewpics2 =
                                                false;
                                          }
                                          if (selectedUploadedFiles.length ==
                                                  selectedMedia.length &&
                                              downloadUrls.length ==
                                                  selectedMedia.length) {
                                            safeSetState(() {
                                              _model.uploadedLocalFiles_uploadDatanewpics2 =
                                                  selectedUploadedFiles;
                                              _model.uploadedFileUrls_uploadDatanewpics2 =
                                                  downloadUrls;
                                            });
                                          } else {
                                            safeSetState(() {});
                                            return;
                                          }
                                        }

                                        for (int loop1Index = 0;
                                            loop1Index <
                                                _model
                                                    .uploadedFileUrls_uploadDatanewpics2
                                                    .length;
                                            loop1Index++) {
                                          final currentLoop1Item = _model
                                                  .uploadedFileUrls_uploadDatanewpics2[
                                              loop1Index];
                                          _model.addToCurrentimages(
                                              currentLoop1Item);
                                          safeSetState(() {});
                                        }
                                      },
                                      child: Container(
                                        width: 146.3,
                                        height: 112.1,
                                        decoration: BoxDecoration(
                                          color: FlutterFlowTheme.of(context).primary.withOpacity(0.1),
                                          borderRadius: BorderRadius.only(
                                            bottomLeft: Radius.circular(12.0),
                                            bottomRight: Radius.circular(12.0),
                                            topLeft: Radius.circular(12.0),
                                            topRight: Radius.circular(12.0),
                                          ),
                                          border: Border.all(
                                            color: FlutterFlowTheme.of(context)
                                                .primary,
                                            width: 2.0,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      Align(
                        alignment: AlignmentDirectional(0.0, -1.0),
                        child: Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(
                              0.0, 30.0, 0.0, 16.0),
                          child: Container(
                            width: 370.0,
                            child: TextFormField(
                              controller: _model.addCaptionTextController,
                              focusNode: _model.addCaptionFocusNode,
                              onFieldSubmitted: (_) async {
                                if (loggedIn != true) {
                                  context.pushNamed(OnboardingWidget.routeName);
                                }
                              },
                              autofocus: false,
                              autofillHints: [AutofillHints.email],
                              obscureText: false,
                              decoration: InputDecoration(
                                labelText: 'add a caption... ',
                                labelStyle: FlutterFlowTheme.of(context)
                                    .labelLarge
                                    .override(
                                      fontFamily: FlutterFlowTheme.of(context)
                                          .labelLargeFamily,
                                      letterSpacing: 0.0,
                                      useGoogleFonts:
                                          !FlutterFlowTheme.of(context)
                                              .labelLargeIsCustom,
                                    ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color:
                                        FlutterFlowTheme.of(context).tertiary,
                                    width: 2.0,
                                  ),
                                  borderRadius: BorderRadius.circular(12.0),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: FlutterFlowTheme.of(context).primary,
                                    width: 2.0,
                                  ),
                                  borderRadius: BorderRadius.circular(12.0),
                                ),
                                errorBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: FlutterFlowTheme.of(context).error,
                                    width: 2.0,
                                  ),
                                  borderRadius: BorderRadius.circular(12.0),
                                ),
                                focusedErrorBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: FlutterFlowTheme.of(context).error,
                                    width: 2.0,
                                  ),
                                  borderRadius: BorderRadius.circular(12.0),
                                ),
                                filled: true,
                                fillColor: FlutterFlowTheme.of(context)
                                    .primaryBackground,
                              ),
                              style: FlutterFlowTheme.of(context)
                                  .labelLarge
                                  .override(
                                    fontFamily: FlutterFlowTheme.of(context)
                                        .labelLargeFamily,
                                    letterSpacing: 0.0,
                                    useGoogleFonts:
                                        !FlutterFlowTheme.of(context)
                                            .labelLargeIsCustom,
                                  ),
                              validator: _model
                                  .addCaptionTextControllerValidator
                                  .asValidator(context),
                            ),
                          ),
                        ),
                      ),
                      InkWell(
                        splashColor: Colors.transparent,
                        focusColor: Colors.transparent,
                        hoverColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        onTap: () async {
                          if (FFAppState().hasRecipe != true) {
                            FFAppState().addToIngredientsList('');
                            FFAppState().addToPreparationList('');
                          }

                          context.pushNamed(RecipeFormWidget.routeName);
                        },
                        child: Container(
                          width: 370.0,
                          height: 60.0,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(12.0),
                              bottomRight: Radius.circular(12.0),
                              topLeft: Radius.circular(12.0),
                              topRight: Radius.circular(12.0),
                            ),
                            border: Border.all(
                              color: FlutterFlowTheme.of(context).primary,
                              width: 2.0,
                            ),
                          ),
                          child: Stack(
                            children: [
                              InkWell(
                                splashColor: Colors.transparent,
                                focusColor: Colors.transparent,
                                hoverColor: Colors.transparent,
                                highlightColor: Colors.transparent,
                                onTap: () async {
                                  if (loggedIn != true) {
                                    context
                                        .pushNamed(OnboardingWidget.routeName);
                                  }
                                },
                                child: Column(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    if (!FFAppState().hasRecipe)
                                      Align(
                                        alignment:
                                            AlignmentDirectional(-1.0, 0.0),
                                        child: Padding(
                                          padding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                  10.0, 0.0, 0.0, 0.0),
                                          child: Text(
                                            'add recipe (optional)',
                                            style: FlutterFlowTheme.of(context)
                                                .labelLarge
                                                .override(
                                                  fontFamily:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .labelLargeFamily,
                                                  letterSpacing: 0.0,
                                                  useGoogleFonts:
                                                      !FlutterFlowTheme.of(
                                                              context)
                                                          .labelLargeIsCustom,
                                                ),
                                          ),
                                        ),
                                      ),
                                    if (FFAppState().hasRecipe)
                                      Align(
                                        alignment:
                                            AlignmentDirectional(-1.0, 0.0),
                                        child: Padding(
                                          padding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                  10.0, 0.0, 0.0, 0.0),
                                          child: Text(
                                            'edit recipe',
                                            style: FlutterFlowTheme.of(context)
                                                .labelLarge
                                                .override(
                                                  fontFamily:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .labelLargeFamily,
                                                  letterSpacing: 0.0,
                                                  useGoogleFonts:
                                                      !FlutterFlowTheme.of(
                                                              context)
                                                          .labelLargeIsCustom,
                                                ),
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                              Align(
                                alignment: AlignmentDirectional(1.0, 0.0),
                                child: Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      0.0, 0.0, 5.0, 0.0),
                                  child: Icon(
                                    Icons.chevron_right_rounded,
                                    color: FlutterFlowTheme.of(context)
                                        .secondaryText,
                                    size: 35.0,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Align(
                        alignment: AlignmentDirectional(0.0, -1.0),
                        child: Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(
                              0.0, 20.0, 0.0, 100.0),
                          child: FFButtonWidget(
                            onPressed: () async {
                              if (loggedIn != true) {
                                context.pushNamed(OnboardingWidget.routeName);
                              }
                              if (_model.formKey.currentState == null ||
                                  !_model.formKey.currentState!.validate()) {
                                return;
                              }
                              if (_model.uploadedFileUrls_uploadDatanewpics2 ==
                                      null ||
                                  _model.uploadedFileUrls_uploadDatanewpics2
                                      .isEmpty) {
                                await showDialog(
                                  context: context,
                                  builder: (alertDialogContext) {
                                    return AlertDialog(
                                      content: Text('image is required'),
                                      actions: [
                                        TextButton(
                                          onPressed: () =>
                                              Navigator.pop(alertDialogContext),
                                          child: Text('Ok'),
                                        ),
                                      ],
                                    );
                                  },
                                );
                                return;
                              }
                              if (_model.currentimages.length >= 1) {
                                var postsRecordReference =
                                    PostsRecord.collection.doc();
                                await postsRecordReference.set({
                                  ...createPostsRecordData(
                                    postUser: currentUserReference,
                                    postText:
                                        _model.addCaptionTextController.text,
                                    createdTime: getCurrentTimestamp,
                                    hasRecipe: false,
                                  ),
                                  ...mapToFirestore(
                                    {
                                      'postMultPhotos': _model.currentimages,
                                    },
                                  ),
                                });
                                _model.postCreated =
                                    PostsRecord.getDocumentFromData({
                                  ...createPostsRecordData(
                                    postUser: currentUserReference,
                                    postText:
                                        _model.addCaptionTextController.text,
                                    createdTime: getCurrentTimestamp,
                                    hasRecipe: false,
                                  ),
                                  ...mapToFirestore(
                                    {
                                      'postMultPhotos': _model.currentimages,
                                    },
                                  ),
                                }, postsRecordReference);
                                if (FFAppState().hasRecipe == true) {
                                  var recipesRecordReference =
                                      RecipesRecord.collection.doc();
                                  await recipesRecordReference.set({
                                    ...createRecipesRecordData(
                                      title: FFAppState().recipetitle,
                                      notes: FFAppState().recipenotes,
                                      cookingtime: FFAppState().cookingtime,
                                      difficulty: FFAppState().difficulty,
                                      servings: FFAppState().servings,
                                      postId: _model.postCreated?.reference,
                                      publicrecipeimage: _model
                                          .uploadedFileUrls_uploadDatanewpics2
                                          .firstOrNull,
                                      userId: currentUserReference,
                                      usercreated: true,
                                    ),
                                    ...mapToFirestore(
                                      {
                                        'ingredients':
                                            FFAppState().ingredientsList,
                                        'preparation':
                                            FFAppState().preparationList,
                                        'recipe_images': _model
                                            .uploadedFileUrls_uploadDatanewpics2,
                                        'time_generated':
                                            FieldValue.serverTimestamp(),
                                      },
                                    ),
                                  });
                                  _model.recipeDocument =
                                      RecipesRecord.getDocumentFromData({
                                    ...createRecipesRecordData(
                                      title: FFAppState().recipetitle,
                                      notes: FFAppState().recipenotes,
                                      cookingtime: FFAppState().cookingtime,
                                      difficulty: FFAppState().difficulty,
                                      servings: FFAppState().servings,
                                      postId: _model.postCreated?.reference,
                                      publicrecipeimage: _model
                                          .uploadedFileUrls_uploadDatanewpics2
                                          .firstOrNull,
                                      userId: currentUserReference,
                                      usercreated: true,
                                    ),
                                    ...mapToFirestore(
                                      {
                                        'ingredients':
                                            FFAppState().ingredientsList,
                                        'preparation':
                                            FFAppState().preparationList,
                                        'recipe_images': _model
                                            .uploadedFileUrls_uploadDatanewpics2,
                                        'time_generated': DateTime.now(),
                                      },
                                    ),
                                  }, recipesRecordReference);

                                  await _model.postCreated!.reference
                                      .update(createPostsRecordData(
                                    hasRecipe: true,
                                    recipeRef: _model.recipeDocument?.reference,
                                  ));
                                  FFAppState().ingredientsList = [];
                                  FFAppState().preparationList = [];
                                  FFAppState().hasRecipe = false;
                                  FFAppState().recipetitle = '';
                                  FFAppState().recipenotes = '';
                                  FFAppState().difficulty = '';
                                  FFAppState().cookingtime = '';
                                  FFAppState().servings = '';
                                }

                                context.pushNamed(FoodFeedWidget.routeName);
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      'must include atleast one image',
                                      style: FlutterFlowTheme.of(context)
                                          .titleMedium
                                          .override(
                                            fontFamily:
                                                FlutterFlowTheme.of(context)
                                                    .titleMediumFamily,
                                            color: FlutterFlowTheme.of(context)
                                                .accent3,
                                            letterSpacing: 0.0,
                                            useGoogleFonts:
                                                !FlutterFlowTheme.of(context)
                                                    .titleMediumIsCustom,
                                          ),
                                    ),
                                    duration: Duration(milliseconds: 4000),
                                    backgroundColor: Color(0x80FF5963),
                                  ),
                                );
                              }

                              safeSetState(() {});
                            },
                            text: 'share',
                            options: FFButtonOptions(
                              width: 146.5,
                              height: 50.0,
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  24.0, 0.0, 24.0, 0.0),
                              iconPadding: EdgeInsetsDirectional.fromSTEB(
                                  0.0, 0.0, 0.0, 0.0),
                              color: FlutterFlowTheme.of(context).primary,
                              textStyle: FlutterFlowTheme.of(context)
                                  .bodyLarge
                                  .override(
                                    fontFamily: FlutterFlowTheme.of(context)
                                        .bodyLargeFamily,
                                    color: FlutterFlowTheme.of(context)
                                        .primaryBackground,
                                    letterSpacing: 0.0,
                                    fontWeight: FontWeight.bold,
                                    useGoogleFonts:
                                        !FlutterFlowTheme.of(context)
                                            .bodyLargeIsCustom,
                                  ),
                              elevation: 3.0,
                              borderSide: BorderSide(
                                color: Colors.transparent,
                                width: 1.0,
                              ),
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
