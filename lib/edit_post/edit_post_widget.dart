import '/auth/firebase_auth/auth_util.dart';
import '/backend/backend.dart';
import '/backend/firebase_storage/storage.dart';
import '/flutter_flow/flutter_flow_drop_down.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/flutter_flow/form_field_controller.dart';
import '/flutter_flow/upload_data.dart';
import '/recipes/ingredient_field/ingredient_field_widget.dart';
import '/recipes/preparation_field/preparation_field_widget.dart';
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
import '/components/bite_logo.dart';

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

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  /// Syncs recipe form fields to FFAppState before saving.
  void _syncRecipeToAppState() {
    FFAppState().recipetitle =
        _model.recipeTextTextController?.text ?? '';
    FFAppState().recipenotes =
        _model.notesTextTextController?.text ?? '';
    if (_model.cookingtimeValue != null) {
      FFAppState().cookingtime = _model.cookingtimeValue!;
    }
    if (_model.difficultyValue != null) {
      FFAppState().difficulty = _model.difficultyValue!;
    }
    if (_model.servingsValue != null) {
      FFAppState().servings = _model.servingsValue!;
    }
    FFAppState().ingredientsList = _model.ingredientFieldModels
        .getValues((m) => m.textController.text)
        .toList()
        .cast<String>();
    FFAppState().preparationList = _model.preparationFieldModels
        .getValues((m) => m.textController.text)
        .toList()
        .cast<String>();
  }

  /// Validates the inline recipe form. Returns true if valid.
  Future<bool> _validateRecipeForm() async {
    if (_model.recipeFormKey.currentState == null ||
        !_model.recipeFormKey.currentState!.validate()) {
      return false;
    }
    if (_model.cookingtimeValue == null) {
      await showDialog(
        context: context,
        builder: (alertDialogContext) {
          return AlertDialog(
            content: Text('cooking time is required'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(alertDialogContext),
                child: Text('Ok'),
              ),
            ],
          );
        },
      );
      return false;
    }
    if (_model.difficultyValue == null) {
      await showDialog(
        context: context,
        builder: (alertDialogContext) {
          return AlertDialog(
            content: Text('recipe difficulty field is empty'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(alertDialogContext),
                child: Text('Ok'),
              ),
            ],
          );
        },
      );
      return false;
    }
    if (_model.servingsValue == null) {
      await showDialog(
        context: context,
        builder: (alertDialogContext) {
          return AlertDialog(
            content: Text('servings field is required'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(alertDialogContext),
                child: Text('Ok'),
              ),
            ],
          );
        },
      );
      return false;
    }
    // Require at least one non-empty ingredient or preparation step.
    final hasIngredients = _model.ingredientFieldModels
        .getValues((m) => m.textController.text)
        .any((t) => t.trim().isNotEmpty);
    final hasSteps = _model.preparationFieldModels
        .getValues((m) => m.textController.text)
        .any((t) => t.trim().isNotEmpty);
    if (!hasIngredients && !hasSteps) {
      await showDialog(
        context: context,
        builder: (alertDialogContext) {
          return AlertDialog(
            content: Text('please add at least one ingredient or preparation step'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(alertDialogContext),
                child: Text('Ok'),
              ),
            ],
          );
        },
      );
      return false;
    }
    return true;
  }

  /// Loads existing recipe data into form fields.
  Future<void> _loadExistingRecipe(PostsRecord postRecord) async {
    if (_model.recipeDataLoaded) return;
    _model.recipeDataLoaded = true;

    _model.recipedoc =
        await RecipesRecord.getDocumentOnce(postRecord.recipeRef!);

    FFAppState().ingredientsList = _model
        .recipedoc!.ingredients
        .toList()
        .cast<String>();
    FFAppState().preparationList = _model
        .recipedoc!.preparation
        .toList()
        .cast<String>();
    FFAppState().hasRecipe = true;
    FFAppState().recipetitle = _model.recipedoc!.title;
    FFAppState().recipenotes = _model.recipedoc!.notes;
    FFAppState().cookingtime = _model.recipedoc!.cookingtime;
    FFAppState().servings = _model.recipedoc!.servings;
    FFAppState().editedRecipe = true;

    _model.recipeTextTextController ??=
        TextEditingController(text: _model.recipedoc!.title);
    _model.recipeTextFocusNode ??= FocusNode();
    _model.notesTextTextController ??=
        TextEditingController(text: _model.recipedoc!.notes);
    _model.notesTextFocusNode ??= FocusNode();
    _model.cookingtimeValue = _model.recipedoc!.cookingtime;
    _model.difficultyValue = _model.recipedoc!.difficulty;
    _model.servingsValue = _model.recipedoc!.servings;

    safeSetState(() {});
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
                  Icons.arrow_back_sharp,
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
                child: BiteLogo(),
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
                  child: Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 40.0),
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // === EXISTING PHOTOS ===
                          Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(
                                0.0, 20.0, 0.0, 0.0),
                            child: Builder(
                              builder: (context) {
                                final imageItems =
                                    editPostPostsRecord.postMultPhotos.toList();

                                return SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Row(
                                    mainAxisSize: MainAxisSize.max,
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
                          // === UPLOAD IMAGE BUTTON ===
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
                                              color: FlutterFlowTheme.of(context).primary.withOpacity(0.1),
                                              borderRadius: BorderRadius.circular(12.0),
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
                          // === CAPTION FIELD ===
                          Align(
                            alignment: AlignmentDirectional(0.0, -1.0),
                            child: Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  0.0, 30.0, 0.0, 16.0),
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
                                    labelText: 'add a caption... ',
                                    labelStyle: FlutterFlowTheme.of(context)
                                        .labelLarge
                                        .override(
                                          fontFamily: FlutterFlowTheme.of(context)
                                              .labelLargeFamily,
                                          letterSpacing: 0.0,
                                          fontWeight: FontWeight.bold,
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
                          // === ADD/EDIT RECIPE EXPANDABLE SECTION ===
                          Align(
                            alignment: AlignmentDirectional(0.0, 0.0),
                            child: Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  0.0, 8.0, 0.0, 0.0),
                              child: InkWell(
                                splashColor: Colors.transparent,
                                focusColor: Colors.transparent,
                                hoverColor: Colors.transparent,
                                highlightColor: Colors.transparent,
                                onTap: () async {
                                  if (!_model.isRecipeSectionExpanded) {
                                    // Opening the section
                                    if (editPostPostsRecord.hasRecipe == true) {
                                      // Load existing recipe data
                                      await _loadExistingRecipe(editPostPostsRecord);
                                    } else if (!FFAppState().hasRecipe) {
                                      // New recipe — seed empty fields
                                      FFAppState().addToIngredientsList('');
                                      FFAppState().addToPreparationList('');
                                      _model.recipeTextTextController ??=
                                          TextEditingController();
                                      _model.recipeTextFocusNode ??= FocusNode();
                                      _model.notesTextTextController ??=
                                          TextEditingController();
                                      _model.notesTextFocusNode ??= FocusNode();
                                    }
                                  }
                                  _model.isRecipeSectionExpanded =
                                      !_model.isRecipeSectionExpanded;
                                  safeSetState(() {});
                                },
                                child: Container(
                                  width: 370.0,
                                  decoration: BoxDecoration(
                                    color: FlutterFlowTheme.of(context).primary.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(12.0),
                                    border: Border.all(
                                      color: FlutterFlowTheme.of(context).primary,
                                      width: 2.0,
                                    ),
                                  ),
                                  child: Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        12.0, 14.0, 12.0, 14.0),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          _model.isRecipeSectionExpanded
                                              ? 'fill in recipe details'
                                              : (editPostPostsRecord.hasRecipe
                                                  ? 'edit recipe'
                                                  : 'add recipe'),
                                          style: FlutterFlowTheme.of(context)
                                              .labelLarge
                                              .override(
                                                fontFamily: FlutterFlowTheme.of(context)
                                                    .labelLargeFamily,
                                                letterSpacing: 0.0,
                                                color: FlutterFlowTheme.of(context).primary,
                                                fontWeight: FontWeight.bold,
                                                useGoogleFonts:
                                                    !FlutterFlowTheme.of(context)
                                                        .labelLargeIsCustom,
                                              ),
                                        ),
                                        AnimatedRotation(
                                          turns: _model.isRecipeSectionExpanded ? 0.25 : 0.0,
                                          duration: Duration(milliseconds: 200),
                                          child: Icon(
                                            Icons.chevron_right_rounded,
                                            color: FlutterFlowTheme.of(context).secondaryText,
                                            size: 28.0,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          // === INLINE RECIPE FORM (shown when expanded) ===
                          if (_model.isRecipeSectionExpanded)
                            Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  16.0, 12.0, 16.0, 0.0),
                              child: Form(
                                key: _model.recipeFormKey,
                                autovalidateMode: AutovalidateMode.disabled,
                                child: Column(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    // Recipe name
                                    Row(
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        Text(
                                          'recipe name: ',
                                          style: FlutterFlowTheme.of(context)
                                              .labelLarge
                                              .override(
                                                fontFamily: FlutterFlowTheme.of(context)
                                                    .labelLargeFamily,
                                                color: FlutterFlowTheme.of(context).accent3,
                                                letterSpacing: 0.0,
                                                fontWeight: FontWeight.w600,
                                                useGoogleFonts:
                                                    !FlutterFlowTheme.of(context)
                                                        .labelLargeIsCustom,
                                              ),
                                        ),
                                        Expanded(
                                          child: Padding(
                                            padding: EdgeInsetsDirectional.fromSTEB(
                                                5.0, 0.0, 0.0, 0.0),
                                            child: Container(
                                              width: 200.0,
                                              child: TextFormField(
                                                controller: _model.recipeTextTextController,
                                                focusNode: _model.recipeTextFocusNode,
                                                autofocus: false,
                                                obscureText: false,
                                                decoration: InputDecoration(
                                                  isDense: true,
                                                  labelStyle: FlutterFlowTheme.of(context)
                                                      .labelMedium
                                                      .override(
                                                        fontFamily:
                                                            FlutterFlowTheme.of(context)
                                                                .labelMediumFamily,
                                                        letterSpacing: 0.0,
                                                        useGoogleFonts:
                                                            !FlutterFlowTheme.of(context)
                                                                .labelMediumIsCustom,
                                                      ),
                                                  hintStyle: FlutterFlowTheme.of(context)
                                                      .labelMedium
                                                      .override(
                                                        fontFamily:
                                                            FlutterFlowTheme.of(context)
                                                                .labelMediumFamily,
                                                        letterSpacing: 0.0,
                                                        useGoogleFonts:
                                                            !FlutterFlowTheme.of(context)
                                                                .labelMediumIsCustom,
                                                      ),
                                                  enabledBorder: OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                      color: FlutterFlowTheme.of(context)
                                                          .tertiary,
                                                      width: 2.0,
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.circular(12.0),
                                                  ),
                                                  focusedBorder: OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                      color: FlutterFlowTheme.of(context)
                                                          .primary,
                                                      width: 2.0,
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.circular(12.0),
                                                  ),
                                                  errorBorder: OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                      color: FlutterFlowTheme.of(context)
                                                          .error,
                                                      width: 2.0,
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.circular(12.0),
                                                  ),
                                                  focusedErrorBorder: OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                      color: FlutterFlowTheme.of(context)
                                                          .error,
                                                      width: 2.0,
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.circular(12.0),
                                                  ),
                                                  filled: true,
                                                  fillColor: FlutterFlowTheme.of(context)
                                                      .primaryBackground,
                                                ),
                                                style: FlutterFlowTheme.of(context)
                                                    .bodyMedium
                                                    .override(
                                                      fontFamily:
                                                          FlutterFlowTheme.of(context)
                                                              .bodyMediumFamily,
                                                      letterSpacing: 0.0,
                                                      useGoogleFonts:
                                                          !FlutterFlowTheme.of(context)
                                                              .bodyMediumIsCustom,
                                                    ),
                                                cursorColor: FlutterFlowTheme.of(context)
                                                    .primaryText,
                                                validator: _model
                                                    .recipeTextTextControllerValidator
                                                    .asValidator(context),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    // Notes
                                    Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          0.0, 8.0, 0.0, 0.0),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.max,
                                        children: [
                                          Text(
                                            'notes: ',
                                            style: FlutterFlowTheme.of(context)
                                                .labelLarge
                                                .override(
                                                  fontFamily: FlutterFlowTheme.of(context)
                                                      .labelLargeFamily,
                                                  color:
                                                      FlutterFlowTheme.of(context).accent3,
                                                  letterSpacing: 0.0,
                                                  fontWeight: FontWeight.w600,
                                                  useGoogleFonts:
                                                      !FlutterFlowTheme.of(context)
                                                          .labelLargeIsCustom,
                                                ),
                                          ),
                                          Expanded(
                                            child: Padding(
                                              padding: EdgeInsetsDirectional.fromSTEB(
                                                  5.0, 0.0, 0.0, 0.0),
                                              child: Container(
                                                width: 200.0,
                                                child: TextFormField(
                                                  controller:
                                                      _model.notesTextTextController,
                                                  focusNode: _model.notesTextFocusNode,
                                                  autofocus: false,
                                                  obscureText: false,
                                                  decoration: InputDecoration(
                                                    isDense: true,
                                                    labelStyle: FlutterFlowTheme.of(context)
                                                        .labelMedium
                                                        .override(
                                                          fontFamily:
                                                              FlutterFlowTheme.of(context)
                                                                  .labelMediumFamily,
                                                          letterSpacing: 0.0,
                                                          useGoogleFonts:
                                                              !FlutterFlowTheme.of(context)
                                                                  .labelMediumIsCustom,
                                                        ),
                                                    hintStyle: FlutterFlowTheme.of(context)
                                                        .labelMedium
                                                        .override(
                                                          fontFamily:
                                                              FlutterFlowTheme.of(context)
                                                                  .labelMediumFamily,
                                                          letterSpacing: 0.0,
                                                          useGoogleFonts:
                                                              !FlutterFlowTheme.of(context)
                                                                  .labelMediumIsCustom,
                                                        ),
                                                    enabledBorder: OutlineInputBorder(
                                                      borderSide: BorderSide(
                                                        color: FlutterFlowTheme.of(context)
                                                            .tertiary,
                                                        width: 2.0,
                                                      ),
                                                      borderRadius:
                                                          BorderRadius.circular(12.0),
                                                    ),
                                                    focusedBorder: OutlineInputBorder(
                                                      borderSide: BorderSide(
                                                        color: FlutterFlowTheme.of(context)
                                                            .primary,
                                                        width: 2.0,
                                                      ),
                                                      borderRadius:
                                                          BorderRadius.circular(12.0),
                                                    ),
                                                    errorBorder: OutlineInputBorder(
                                                      borderSide: BorderSide(
                                                        color: FlutterFlowTheme.of(context)
                                                            .error,
                                                        width: 2.0,
                                                      ),
                                                      borderRadius:
                                                          BorderRadius.circular(12.0),
                                                    ),
                                                    focusedErrorBorder: OutlineInputBorder(
                                                      borderSide: BorderSide(
                                                        color: FlutterFlowTheme.of(context)
                                                            .error,
                                                        width: 2.0,
                                                      ),
                                                      borderRadius:
                                                          BorderRadius.circular(12.0),
                                                    ),
                                                    filled: true,
                                                    fillColor: FlutterFlowTheme.of(context)
                                                        .primaryBackground,
                                                  ),
                                                  style: FlutterFlowTheme.of(context)
                                                      .bodyMedium
                                                      .override(
                                                        fontFamily:
                                                            FlutterFlowTheme.of(context)
                                                                .bodyMediumFamily,
                                                        letterSpacing: 0.0,
                                                        useGoogleFonts:
                                                            !FlutterFlowTheme.of(context)
                                                                .bodyMediumIsCustom,
                                                      ),
                                                  maxLength: 200,
                                                  buildCounter: (context,
                                                          {required currentLength,
                                                          required isFocused,
                                                          maxLength}) =>
                                                      null,
                                                  cursorColor: FlutterFlowTheme.of(context)
                                                      .primaryText,
                                                  validator: _model
                                                      .notesTextTextControllerValidator
                                                      .asValidator(context),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    // Cooking time dropdown
                                    Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          0.0, 8.0, 0.0, 0.0),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.max,
                                        children: [
                                          FlutterFlowDropDown<String>(
                                            controller:
                                                _model.cookingtimeValueController ??=
                                                    FormFieldController<String>(
                                              _model.cookingtimeValue ??=
                                                  FFAppState().cookingtime,
                                            ),
                                            options: [
                                              '5 min', '10 min', '15 min', '20 min',
                                              '25 min', '30 min', '35 min', '40 min',
                                              '45 min', '50 min', '55 min', '1 hr',
                                              '1 hr 15 min', '1 hr 30 min',
                                              '1 hr 45 min', '2 hr', '2 hr 30 min',
                                              '3 hr', '3 hr 30 min', '4 hr',
                                              'over 4 hours'
                                            ],
                                            onChanged: (val) async {
                                              safeSetState(
                                                  () => _model.cookingtimeValue = val);
                                              FFAppState().cookingtime =
                                                  _model.cookingtimeValue!;
                                              safeSetState(() {});
                                            },
                                            width: 160.0,
                                            height: 40.0,
                                            textStyle: FlutterFlowTheme.of(context)
                                                .labelLarge
                                                .override(
                                                  fontFamily: FlutterFlowTheme.of(context)
                                                      .labelLargeFamily,
                                                  color:
                                                      FlutterFlowTheme.of(context).primary,
                                                  letterSpacing: 0.0,
                                                  fontWeight: FontWeight.w600,
                                                  useGoogleFonts:
                                                      !FlutterFlowTheme.of(context)
                                                          .labelLargeIsCustom,
                                                ),
                                            hintText: 'cooking time',
                                            icon: Icon(
                                              Icons.keyboard_arrow_down_rounded,
                                              color: FlutterFlowTheme.of(context)
                                                  .secondaryText,
                                              size: 24.0,
                                            ),
                                            fillColor: FlutterFlowTheme.of(context)
                                                .primaryBackground,
                                            elevation: 2.0,
                                            borderColor:
                                                FlutterFlowTheme.of(context).tertiary,
                                            borderWidth: 2.0,
                                            borderRadius: 8.0,
                                            margin: EdgeInsetsDirectional.fromSTEB(
                                                12.0, 0.0, 12.0, 0.0),
                                            hidesUnderline: true,
                                            isOverButton: false,
                                            isSearchable: false,
                                            isMultiSelect: false,
                                          ),
                                        ],
                                      ),
                                    ),
                                    // Difficulty + Servings dropdowns
                                    Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          0.0, 8.0, 0.0, 0.0),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.max,
                                        children: [
                                          FlutterFlowDropDown<String>(
                                            controller: _model.difficultyValueController ??=
                                                FormFieldController<String>(
                                              _model.difficultyValue ??=
                                                  FFAppState().difficulty,
                                            ),
                                            options: ['easy', 'medium', 'hard'],
                                            onChanged: (val) async {
                                              safeSetState(
                                                  () => _model.difficultyValue = val);
                                              FFAppState().difficulty =
                                                  _model.difficultyValue!;
                                              safeSetState(() {});
                                            },
                                            width: 160.0,
                                            height: 40.0,
                                            textStyle: FlutterFlowTheme.of(context)
                                                .labelLarge
                                                .override(
                                                  fontFamily: FlutterFlowTheme.of(context)
                                                      .labelLargeFamily,
                                                  color:
                                                      FlutterFlowTheme.of(context).primary,
                                                  letterSpacing: 0.0,
                                                  fontWeight: FontWeight.w600,
                                                  useGoogleFonts:
                                                      !FlutterFlowTheme.of(context)
                                                          .labelLargeIsCustom,
                                                ),
                                            hintText: 'difficulty',
                                            icon: Icon(
                                              Icons.keyboard_arrow_down_rounded,
                                              color: FlutterFlowTheme.of(context)
                                                  .secondaryText,
                                              size: 24.0,
                                            ),
                                            fillColor: FlutterFlowTheme.of(context)
                                                .primaryBackground,
                                            elevation: 2.0,
                                            borderColor:
                                                FlutterFlowTheme.of(context).tertiary,
                                            borderWidth: 2.0,
                                            borderRadius: 8.0,
                                            margin: EdgeInsetsDirectional.fromSTEB(
                                                12.0, 0.0, 12.0, 0.0),
                                            hidesUnderline: true,
                                            isOverButton: false,
                                            isSearchable: false,
                                            isMultiSelect: false,
                                          ),
                                          Padding(
                                            padding: EdgeInsetsDirectional.fromSTEB(
                                                10.0, 0.0, 0.0, 0.0),
                                            child: FlutterFlowDropDown<String>(
                                              controller: _model.servingsValueController ??=
                                                  FormFieldController<String>(
                                                _model.servingsValue ??=
                                                    FFAppState().servings,
                                              ),
                                              options: [
                                                '1', '2', '3', '4', '5', '6', '7', '8',
                                                '9', '10', '11', '12', '13', '14', '15',
                                                '16', '17', '18', '19', '20', '21', '22',
                                                '23', '24'
                                              ],
                                              onChanged: (val) async {
                                                safeSetState(
                                                    () => _model.servingsValue = val);
                                                FFAppState().servings =
                                                    _model.servingsValue!;
                                                safeSetState(() {});
                                              },
                                              width: 160.0,
                                              height: 40.0,
                                              textStyle: FlutterFlowTheme.of(context)
                                                  .bodyLarge
                                                  .override(
                                                    fontFamily: FlutterFlowTheme.of(context)
                                                        .bodyLargeFamily,
                                                    letterSpacing: 0.0,
                                                    fontWeight: FontWeight.w600,
                                                    useGoogleFonts:
                                                        !FlutterFlowTheme.of(context)
                                                            .bodyLargeIsCustom,
                                                  ),
                                              hintText: 'servings',
                                              icon: Icon(
                                                Icons.keyboard_arrow_down_rounded,
                                                color: FlutterFlowTheme.of(context)
                                                    .secondaryText,
                                                size: 24.0,
                                              ),
                                              fillColor: FlutterFlowTheme.of(context)
                                                  .primaryBackground,
                                              elevation: 2.0,
                                              borderColor:
                                                  FlutterFlowTheme.of(context).tertiary,
                                              borderWidth: 2.0,
                                              borderRadius: 8.0,
                                              margin: EdgeInsetsDirectional.fromSTEB(
                                                  12.0, 0.0, 12.0, 0.0),
                                              hidesUnderline: true,
                                              isOverButton: false,
                                              isSearchable: false,
                                              isMultiSelect: false,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    // Ingredients label
                                    Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          0.0, 8.0, 0.0, 0.0),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.max,
                                        children: [
                                          Align(
                                            alignment: AlignmentDirectional(-1.0, 0.0),
                                            child: Text(
                                              'ingredients:',
                                              style: FlutterFlowTheme.of(context)
                                                  .bodyLarge
                                                  .override(
                                                    fontFamily: FlutterFlowTheme.of(context)
                                                        .bodyLargeFamily,
                                                    color: FlutterFlowTheme.of(context)
                                                        .accent3,
                                                    letterSpacing: 0.0,
                                                    fontWeight: FontWeight.w600,
                                                    useGoogleFonts:
                                                        !FlutterFlowTheme.of(context)
                                                            .bodyLargeIsCustom,
                                                  ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    // Ingredients list
                                    Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          0.0, 8.0, 0.0, 0.0),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.max,
                                        children: [
                                          Column(
                                            mainAxisSize: MainAxisSize.max,
                                            children: [
                                              Container(
                                                width: 340.0,
                                                child: Align(
                                                  alignment:
                                                      AlignmentDirectional(0.0, -1.0),
                                                  child: Builder(
                                                    builder: (context) {
                                                      final ingredientsChildren =
                                                          FFAppState()
                                                              .ingredientsList
                                                              .toList();

                                                      return ListView.builder(
                                                        padding: EdgeInsets.zero,
                                                        primary: false,
                                                        shrinkWrap: true,
                                                        scrollDirection: Axis.vertical,
                                                        itemCount:
                                                            ingredientsChildren.length,
                                                        itemBuilder: (context,
                                                            ingredientsChildrenIndex) {
                                                          final ingredientsChildrenItem =
                                                              ingredientsChildren[
                                                                  ingredientsChildrenIndex];
                                                          return Padding(
                                                            padding: EdgeInsetsDirectional
                                                                .fromSTEB(
                                                                    0.0, 0.0, 0.0, 10.0),
                                                            child: wrapWithModel(
                                                              model: _model
                                                                  .ingredientFieldModels
                                                                  .getModel(
                                                                ingredientsChildrenIndex
                                                                    .toString(),
                                                                ingredientsChildrenIndex,
                                                              ),
                                                              updateCallback: () =>
                                                                  safeSetState(() {}),
                                                              child: IngredientFieldWidget(
                                                                key: Key(
                                                                  'Keyi1d_${ingredientsChildrenIndex.toString()}',
                                                                ),
                                                                ingredientText:
                                                                    ingredientsChildrenItem,
                                                                index:
                                                                    ingredientsChildrenIndex,
                                                              ),
                                                            ),
                                                          );
                                                        },
                                                      );
                                                    },
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    // Add ingredient button
                                    Align(
                                      alignment: AlignmentDirectional(-1.0, -1.0),
                                      child: Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                            0.0, 0.0, 0.0, 8.0),
                                        child: FFButtonWidget(
                                          onPressed: () async {
                                            FFAppState().addToIngredientsList('');
                                            safeSetState(() {});
                                          },
                                          text: '+add ingredient',
                                          options: FFButtonOptions(
                                            height: 40.0,
                                            padding: EdgeInsetsDirectional.fromSTEB(
                                                16.0, 0.0, 16.0, 0.0),
                                            iconPadding: EdgeInsetsDirectional.fromSTEB(
                                                0.0, 0.0, 0.0, 0.0),
                                            color: FlutterFlowTheme.of(context).primary.withOpacity(0.1),
                                            textStyle: FlutterFlowTheme.of(context)
                                                .titleSmall
                                                .override(
                                                  fontFamily: FlutterFlowTheme.of(context)
                                                      .titleSmallFamily,
                                                  color:
                                                      FlutterFlowTheme.of(context).primary,
                                                  letterSpacing: 0.0,
                                                  fontWeight: FontWeight.bold,
                                                  useGoogleFonts:
                                                      !FlutterFlowTheme.of(context)
                                                          .titleSmallIsCustom,
                                                ),
                                            elevation: 0.0,
                                            borderSide: BorderSide(
                                              color: FlutterFlowTheme.of(context).primary,
                                              width: 2.0,
                                            ),
                                            borderRadius: BorderRadius.circular(8.0),
                                          ),
                                        ),
                                      ),
                                    ),
                                    // Preparation steps label
                                    Align(
                                      alignment: AlignmentDirectional(-1.0, 0.0),
                                      child: Text(
                                        'preparation steps:',
                                        style: FlutterFlowTheme.of(context)
                                            .bodyLarge
                                            .override(
                                              fontFamily: FlutterFlowTheme.of(context)
                                                  .bodyLargeFamily,
                                              color: FlutterFlowTheme.of(context).accent3,
                                              letterSpacing: 0.0,
                                              fontWeight: FontWeight.w600,
                                              useGoogleFonts: !FlutterFlowTheme.of(context)
                                                  .bodyLargeIsCustom,
                                            ),
                                      ),
                                    ),
                                    // Preparation steps list
                                    Align(
                                      alignment: AlignmentDirectional(-1.0, -1.0),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.max,
                                        children: [
                                          Container(
                                            width: 340.0,
                                            child: Align(
                                              alignment: AlignmentDirectional(0.0, -1.0),
                                              child: Padding(
                                                padding: EdgeInsetsDirectional.fromSTEB(
                                                    0.0, 8.0, 0.0, 0.0),
                                                child: Builder(
                                                  builder: (context) {
                                                    final prepChildren = FFAppState()
                                                        .preparationList
                                                        .toList();

                                                    return ListView.builder(
                                                      padding: EdgeInsets.zero,
                                                      primary: false,
                                                      shrinkWrap: true,
                                                      scrollDirection: Axis.vertical,
                                                      itemCount: prepChildren.length,
                                                      itemBuilder:
                                                          (context, prepChildrenIndex) {
                                                        final prepChildrenItem =
                                                            prepChildren[prepChildrenIndex];
                                                        return Container(
                                                          height: 70.0,
                                                          child: wrapWithModel(
                                                            model: _model
                                                                .preparationFieldModels
                                                                .getModel(
                                                              prepChildrenIndex.toString(),
                                                              prepChildrenIndex,
                                                            ),
                                                            updateCallback: () =>
                                                                safeSetState(() {}),
                                                            child: PreparationFieldWidget(
                                                              key: Key(
                                                                'Key18f_${prepChildrenIndex.toString()}',
                                                              ),
                                                              preparationText:
                                                                  prepChildrenItem,
                                                              index: prepChildrenIndex,
                                                            ),
                                                          ),
                                                        );
                                                      },
                                                    );
                                                  },
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    // Add step button
                                    Align(
                                      alignment: AlignmentDirectional(-1.0, -1.0),
                                      child: FFButtonWidget(
                                        onPressed: () async {
                                          FFAppState().addToPreparationList('');
                                          safeSetState(() {});
                                        },
                                        text: '+add step',
                                        options: FFButtonOptions(
                                          height: 40.0,
                                          padding: EdgeInsetsDirectional.fromSTEB(
                                              16.0, 0.0, 16.0, 0.0),
                                          iconPadding: EdgeInsetsDirectional.fromSTEB(
                                              0.0, 0.0, 0.0, 0.0),
                                          color: FlutterFlowTheme.of(context).primary.withOpacity(0.1),
                                          textStyle: FlutterFlowTheme.of(context)
                                              .titleSmall
                                              .override(
                                                fontFamily: FlutterFlowTheme.of(context)
                                                    .titleSmallFamily,
                                                color: FlutterFlowTheme.of(context)
                                                    .primary,
                                                letterSpacing: 0.0,
                                                fontWeight: FontWeight.bold,
                                                useGoogleFonts:
                                                    !FlutterFlowTheme.of(context)
                                                        .titleSmallIsCustom,
                                              ),
                                          elevation: 0.0,
                                          borderSide: BorderSide(
                                            color: FlutterFlowTheme.of(context).primary,
                                            width: 2.0,
                                          ),
                                          borderRadius: BorderRadius.circular(8.0),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          // === SAVE + DELETE ROW ===
                          Align(
                            alignment: AlignmentDirectional(0.0, 0.0),
                            child: Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  0.0, 20.0, 0.0, 0.0),
                              child: Container(
                                width: 370.0,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    FFButtonWidget(
                                      onPressed: () async {
                                        if (_model.formKey.currentState == null ||
                                            !_model.formKey.currentState!.validate()) {
                                          return;
                                        }

                                        // If recipe section is expanded, validate and sync
                                        if (_model.isRecipeSectionExpanded) {
                                          final recipeValid = await _validateRecipeForm();
                                          if (!recipeValid) return;
                                          _syncRecipeToAppState();
                                          FFAppState().hasRecipe = true;
                                          FFAppState().editedRecipe = true;
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
                                        width: 120.0,
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
                                        elevation: 0.0,
                                        borderSide: BorderSide(
                                          color: Colors.transparent,
                                          width: 1.0,
                                        ),
                                        borderRadius: BorderRadius.circular(12.0),
                                      ),
                                    ),
                                    SizedBox(width: 12.0),
                                    FFButtonWidget(
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
                                        width: 120.0,
                                        height: 50.0,
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                            24.0, 0.0, 24.0, 0.0),
                                        iconPadding: EdgeInsetsDirectional.fromSTEB(
                                            0.0, 0.0, 0.0, 0.0),
                                        color: Colors.transparent,
                                        textStyle: FlutterFlowTheme.of(context)
                                            .bodyLarge
                                            .override(
                                              fontFamily: FlutterFlowTheme.of(context)
                                                  .bodyLargeFamily,
                                              color: FlutterFlowTheme.of(context)
                                                  .customColor2,
                                              letterSpacing: 0.0,
                                              fontWeight: FontWeight.bold,
                                              useGoogleFonts:
                                                  !FlutterFlowTheme.of(context)
                                                      .bodyLargeIsCustom,
                                            ),
                                        elevation: 0.0,
                                        borderSide: BorderSide(
                                          color:
                                              FlutterFlowTheme.of(context).customColor2,
                                          width: 2.0,
                                        ),
                                        borderRadius: BorderRadius.circular(12.0),
                                      ),
                                    ),
                                  ],
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
      },
    );
  }
}
