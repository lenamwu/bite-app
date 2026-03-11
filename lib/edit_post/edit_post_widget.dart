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
import 'edit_post_model.dart';
export 'edit_post_model.dart';

class EditPostWidget extends StatefulWidget {
  const EditPostWidget({
    super.key,
    required this.postparameter,
  });

  final DocumentReference? postparameter;

  static String routeName = 'edit_post';
  static String routePath = '/editPost';

  @override
  State<EditPostWidget> createState() => _EditPostWidgetState();
}

class _EditPostWidgetState extends State<EditPostWidget> {
  late EditPostModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => EditPostModel());

    // On page load action.
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      _model.uploadedImages =
          _model.uploadedFileUrls_uploadDataL1m.toList().cast<String>();
      _model.existingRecipe = false;
      safeSetState(() {});
    });

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

    return StreamBuilder<PostsRecord>(
      stream: PostsRecord.getDocument(widget!.postparameter!),
      builder: (context, snapshot) {
        // Customize what your widget looks like when it's loading.
        if (!snapshot.hasData) {
          return Scaffold(
            backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
            body: Center(
              child: SizedBox(
                width: 30.0,
                height: 30.0,
                child: SpinKitFadingGrid(
                  color: FlutterFlowTheme.of(context).tertiary,
                  size: 30.0,
                ),
              ),
            ),
          );
        }

        final editPostPostsRecord = snapshot.data!;

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
                  Icons.arrow_back_rounded,
                  color: FlutterFlowTheme.of(context).primary,
                  size: 30.0,
                ),
                onPressed: () async {
                  context.pop();
                  FFAppState().ingredientsList = [];
                  FFAppState().preparationList = [];
                  FFAppState().hasRecipe = false;
                  FFAppState().recipetitle = '';
                  FFAppState().recipenotes = '';
                  FFAppState().difficulty = '';
                  FFAppState().cookingtime = '';
                  FFAppState().servings = '';
                  FFAppState().editedRecipe = false;
                },
              ),
              title: Align(
                alignment: AlignmentDirectional(-1.0, -1.0),
                child: Text(
                  'bite',
                  style: FlutterFlowTheme.of(context).headlineMedium.override(
                        fontFamily:
                            FlutterFlowTheme.of(context).headlineMediumFamily,
                        fontSize: 22.0,
                        letterSpacing: 0.0,
                        useGoogleFonts: !FlutterFlowTheme.of(context)
                            .headlineMediumIsCustom,
                      ),
                ),
              ),
              actions: [],
              centerTitle: false,
              elevation: 2.0,
            ),
            body: SafeArea(
              top: true,
              child: Form(
                key: _model.formKey,
                autovalidateMode: AutovalidateMode.disabled,
                child: Align(
                  alignment: AlignmentDirectional(0.0, 0.0),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(
                              0.0, 25.0, 0.0, 0.0),
                          child: Builder(
                            builder: (context) {
                              final imageItems =
                                  editPostPostsRecord.postMultPhotos.toList();

                              return SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: List.generate(imageItems.length,
                                      (imageItemsIndex) {
                                    final imageItemsItem =
                                        imageItems[imageItemsIndex];
                                    return Stack(
                                      children: [
                                        ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(0.0),
                                          child: Image.network(
                                            imageItemsItem,
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
                                          padding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                  150.0, 155.0, 0.0, 0.0),
                                          child: InkWell(
                                            splashColor: Colors.transparent,
                                            focusColor: Colors.transparent,
                                            hoverColor: Colors.transparent,
                                            highlightColor: Colors.transparent,
                                            onTap: () async {
                                              await widget!.postparameter!
                                                  .update({
                                                ...mapToFirestore(
                                                  {
                                                    'postMultPhotos':
                                                        FieldValue.arrayRemove(
                                                            [imageItemsItem]),
                                                  },
                                                ),
                                              });
                                            },
                                            child: Icon(
                                              Icons.delete_outline,
                                              color:
                                                  FlutterFlowTheme.of(context)
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
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(
                              0.0, 20.0, 0.0, 0.0),
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
                                            color: FlutterFlowTheme.of(context)
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
                                  alignment: AlignmentDirectional(-0.03, -0.07),
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
                                                .isDataUploading_uploadDataL1m =
                                            true);
                                        var selectedUploadedFiles =
                                            <FFUploadedFile>[];

                                        var downloadUrls = <String>[];
                                        try {
                                          selectedUploadedFiles = selectedMedia
                                              .map((m) => FFUploadedFile(
                                                    name: m.storagePath
                                                        .split('/')
                                                        .last,
                                                    bytes: m.bytes,
                                                    height:
                                                        m.dimensions?.height,
                                                    width: m.dimensions?.width,
                                                    blurHash: m.blurHash,
                                                    originalFilename:
                                                        m.originalFilename,
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
                                          _model.isDataUploading_uploadDataL1m =
                                              false;
                                        }
                                        if (selectedUploadedFiles.length ==
                                                selectedMedia.length &&
                                            downloadUrls.length ==
                                                selectedMedia.length) {
                                          safeSetState(() {
                                            _model.uploadedLocalFiles_uploadDataL1m =
                                                selectedUploadedFiles;
                                            _model.uploadedFileUrls_uploadDataL1m =
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
                                                  .uploadedFileUrls_uploadDataL1m
                                                  .length;
                                          loop1Index++) {
                                        final currentLoop1Item = _model
                                                .uploadedFileUrls_uploadDataL1m[
                                            loop1Index];

                                        await widget!.postparameter!.update({
                                          ...mapToFirestore(
                                            {
                                              'postMultPhotos':
                                                  FieldValue.arrayUnion(
                                                      [currentLoop1Item]),
                                            },
                                          ),
                                        });
                                      }
                                    },
                                    child: Container(
                                      width: 146.3,
                                      height: 112.1,
                                      decoration: BoxDecoration(
                                        color: Color(0x19336600),
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
                        Align(
                          alignment: AlignmentDirectional(0.0, -1.0),
                          child: Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(
                                0.0, 20.0, 0.0, 20.0),
                            child: Container(
                              width: 370.0,
                              child: TextFormField(
                                controller: _model.addCaptionTextController ??=
                                    TextEditingController(
                                  text: editPostPostsRecord.postText,
                                ),
                                focusNode: _model.addCaptionFocusNode,
                                autofocus: false,
                                autofillHints: [AutofillHints.email],
                                obscureText: false,
                                decoration: InputDecoration(
                                  labelText: 'caption',
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
                                      color:
                                          FlutterFlowTheme.of(context).primary,
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
                                      color:
                                          FlutterFlowTheme.of(context).primary,
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
                            if (editPostPostsRecord.hasRecipe == true) {
                              _model.recipedoc =
                                  await RecipesRecord.getDocumentOnce(
                                      editPostPostsRecord.recipeRef!);
                              FFAppState().ingredientsList = _model
                                  .recipedoc!.ingredients
                                  .toList()
                                  .cast<String>();
                              FFAppState().preparationList = _model
                                  .recipedoc!.preparation
                                  .toList()
                                  .cast<String>();
                              FFAppState().hasRecipe = true;
                              FFAppState().recipetitle =
                                  _model.recipedoc!.title;
                              FFAppState().recipenotes =
                                  _model.recipedoc!.notes;
                              FFAppState().difficulty = FFAppState().difficulty;
                              FFAppState().cookingtime =
                                  _model.recipedoc!.cookingtime;
                              FFAppState().servings =
                                  _model.recipedoc!.servings;
                              FFAppState().editedRecipe = true;
                            } else {
                              FFAppState().addToIngredientsList('');
                              FFAppState().addToPreparationList('');
                            }

                            context.pushNamed(RecipeFormWidget.routeName);

                            safeSetState(() {});
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
                                color: FlutterFlowTheme.of(context).tertiary,
                                width: 2.0,
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    if (editPostPostsRecord.hasRecipe == true)
                                      Align(
                                        alignment:
                                            AlignmentDirectional(-1.0, 0.0),
                                        child: Padding(
                                          padding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                  10.0, 0.0, 0.0, 0.0),
                                          child: Text(
                                            'edit recipe (optional)',
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
                                    if (!editPostPostsRecord.hasRecipe)
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
                                  ],
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
                                10.0, 20.0, 0.0, 0.0),
                            child: FFButtonWidget(
                              onPressed: () async {
                                if (_model.formKey.currentState == null ||
                                    !_model.formKey.currentState!.validate()) {
                                  return;
                                }

                                await editPostPostsRecord.reference
                                    .update(createPostsRecordData(
                                  postText:
                                      _model.addCaptionTextController.text,
                                ));
                                if (editPostPostsRecord.postMultPhotos.length >=
                                    1) {
                                  if (editPostPostsRecord.recipeRef != null) {
                                    if (FFAppState().editedRecipe == true) {
                                      await editPostPostsRecord.recipeRef!
                                          .update({
                                        ...createRecipesRecordData(
                                          title: FFAppState().recipetitle,
                                          notes: FFAppState().recipenotes,
                                          difficulty: FFAppState().difficulty,
                                          cookingtime: FFAppState().cookingtime,
                                          servings: FFAppState().servings,
                                          publicrecipeimage: editPostPostsRecord
                                              .postMultPhotos.firstOrNull,
                                        ),
                                        ...mapToFirestore(
                                          {
                                            'ingredients':
                                                FFAppState().ingredientsList,
                                            'preparation':
                                                FFAppState().preparationList,
                                            'time_generated':
                                                FieldValue.serverTimestamp(),
                                          },
                                        ),
                                      });
                                    }
                                  } else {
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
                                          postId: editPostPostsRecord.reference,
                                          publicrecipeimage: editPostPostsRecord
                                              .postMultPhotos.firstOrNull,
                                          userId: currentUserReference,
                                          usercreated: true,
                                        ),
                                        ...mapToFirestore(
                                          {
                                            'ingredients':
                                                FFAppState().ingredientsList,
                                            'preparation':
                                                FFAppState().preparationList,
                                            'recipe_images': editPostPostsRecord
                                                .postMultPhotos,
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
                                          postId: editPostPostsRecord.reference,
                                          publicrecipeimage: editPostPostsRecord
                                              .postMultPhotos.firstOrNull,
                                          userId: currentUserReference,
                                          usercreated: true,
                                        ),
                                        ...mapToFirestore(
                                          {
                                            'ingredients':
                                                FFAppState().ingredientsList,
                                            'preparation':
                                                FFAppState().preparationList,
                                            'recipe_images': editPostPostsRecord
                                                .postMultPhotos,
                                            'time_generated': DateTime.now(),
                                          },
                                        ),
                                      }, recipesRecordReference);

                                      await editPostPostsRecord.reference
                                          .update(createPostsRecordData(
                                        hasRecipe: true,
                                        recipeRef:
                                            _model.recipeDocument?.reference,
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
                                  }

                                  context.pushNamed(FoodFeedWidget.routeName);
                                } else {
                                  await showDialog(
                                    context: context,
                                    builder: (alertDialogContext) {
                                      return AlertDialog(
                                        content: Text('image is required'),
                                        actions: [
                                          TextButton(
                                            onPressed: () => Navigator.pop(
                                                alertDialogContext),
                                            child: Text('Ok'),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                }

                                FFAppState().ingredientsList = [];
                                FFAppState().preparationList = [];
                                FFAppState().hasRecipe = false;
                                FFAppState().recipetitle = '';
                                FFAppState().recipenotes = '';
                                FFAppState().difficulty = '';
                                FFAppState().cookingtime = '';
                                FFAppState().servings = '';
                                FFAppState().editedRecipe = false;

                                safeSetState(() {});
                              },
                              text: 'save',
                              options: FFButtonOptions(
                                width: 100.0,
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
                                borderSide: BorderSide(
                                  color: Colors.transparent,
                                  width: 1.0,
                                ),
                                borderRadius: BorderRadius.circular(12.0),
                              ),
                            ),
                          ),
                        ),
                        Align(
                          alignment: AlignmentDirectional(0.0, 0.0),
                          child: Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(
                                266.0, 20.0, 0.0, 0.0),
                            child: FFButtonWidget(
                              onPressed: () async {
                                await editPostPostsRecord.reference.delete();
                                if (editPostPostsRecord.hasRecipe == true) {
                                  await editPostPostsRecord.recipeRef!.delete();
                                }

                                context.pushNamed(FoodFeedWidget.routeName);

                                FFAppState().ingredientsList = [];
                                FFAppState().preparationList = [];
                                FFAppState().hasRecipe = false;
                                FFAppState().recipetitle = '';
                                FFAppState().recipenotes = '';
                                FFAppState().difficulty = '';
                                FFAppState().cookingtime = '';
                                FFAppState().servings = '';
                                FFAppState().editedRecipe = false;
                              },
                              text: 'delete',
                              options: FFButtonOptions(
                                width: 100.0,
                                height: 50.0,
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    24.0, 0.0, 24.0, 0.0),
                                iconPadding: EdgeInsetsDirectional.fromSTEB(
                                    0.0, 0.0, 0.0, 0.0),
                                color: FlutterFlowTheme.of(context)
                                    .primaryBackground,
                                textStyle: FlutterFlowTheme.of(context)
                                    .bodyLarge
                                    .override(
                                      fontFamily: FlutterFlowTheme.of(context)
                                          .bodyLargeFamily,
                                      color: FlutterFlowTheme.of(context)
                                          .customColor2,
                                      fontSize: 18.0,
                                      letterSpacing: 0.0,
                                      fontWeight: FontWeight.bold,
                                      useGoogleFonts:
                                          !FlutterFlowTheme.of(context)
                                              .bodyLargeIsCustom,
                                    ),
                                borderSide: BorderSide(
                                  color:
                                      FlutterFlowTheme.of(context).customColor2,
                                  width: 2.0,
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
        );
      },
    );
  }
}
