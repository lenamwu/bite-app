import '/auth/base_auth_user_provider.dart';
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

    _model.recipeTextTextController ??=
        TextEditingController(text: FFAppState().recipetitle);
    _model.recipeTextFocusNode ??= FocusNode();

    _model.notesTextTextController ??=
        TextEditingController(text: FFAppState().recipenotes);
    _model.notesTextFocusNode ??= FocusNode();

    // If recipe already started, expand the section
    if (FFAppState().hasRecipe) {
      _model.isRecipeSectionExpanded = true;
    }

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  /// Syncs recipe form fields to FFAppState before posting or saving draft.
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

  @override
  Widget build(BuildContext context) {
    context.watch<FFAppState>();

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;
        final hasContent = _model.currentimages.isNotEmpty ||
            (_model.addCaptionTextController?.text ?? '').trim().isNotEmpty ||
            _model.isRecipeSectionExpanded;
        if (!hasContent) {
          Navigator.of(context).pop();
          return;
        }
        final shouldSave = await showDialog<bool>(
          context: context,
          builder: (dialogContext) => AlertDialog(
            title: Text('save as draft?'),
            content: Text('you have unsaved changes. would you like to save them as a draft?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(dialogContext, false),
                child: Text('discard'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(dialogContext, true),
                child: Text('save draft'),
              ),
            ],
          ),
        );
        if (shouldSave == true) {
          _syncRecipeToAppState();
          final draftData = {
            ...createDraftsRecordData(
              userId: currentUserReference,
              caption: _model.addCaptionTextController?.text ?? '',
              hasRecipe: FFAppState().hasRecipe || _model.isRecipeSectionExpanded,
              recipeTitle: FFAppState().recipetitle,
              recipeNotes: FFAppState().recipenotes,
              recipeDifficulty: FFAppState().difficulty,
              recipeCookingtime: FFAppState().cookingtime,
              recipeServings: FFAppState().servings,
              lastSaved: getCurrentTimestamp,
            ),
            ...mapToFirestore({
              'images': _model.currentimages,
              'ingredients': FFAppState().ingredientsList,
              'preparation': FFAppState().preparationList,
            }),
          };
          if (_model.currentDraftRef != null) {
            await _model.currentDraftRef!.update(draftData);
          } else {
            final docRef = DraftsRecord.collection.doc();
            await docRef.set(draftData);
          }
        }
        if (context.mounted) Navigator.of(context).pop();
      },
      child: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
          FocusManager.instance.primaryFocus?.unfocus();
        },
        child: Stack(
          children: [
            Scaffold(
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
                Navigator.of(context).maybePop();
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
                        // === UPLOADED PHOTOS ===
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
                                            height: 200.0,
                                            fit: BoxFit.contain,
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
                                        Positioned(
                                          right: 4.0,
                                          bottom: 4.0,
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
                        // === CAPTION FIELD ===
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
                        // === ADD RECIPE EXPANDABLE SECTION ===
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
                              if (!_model.isRecipeSectionExpanded &&
                                  !FFAppState().hasRecipe) {
                                FFAppState().addToIngredientsList('');
                                FFAppState().addToPreparationList('');
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
                                          : 'add recipe',
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
                                              width: 350.0,
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
                                          width: 350.0,
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
                                                        height: 80.0,
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
                        // === SHARE + SAVE DRAFT ROW ===
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
                                  if (loggedIn != true) {
                                    context.pushNamed(OnboardingWidget.routeName);
                                  }
                                  final hasImages = _model.currentimages.isNotEmpty;
                                  final hasCaption = (_model.addCaptionTextController?.text ?? '').trim().length >= 3;
                                  final hasRecipe = FFAppState().hasRecipe ||
                                      (_model.isRecipeSectionExpanded &&
                                          (_model.recipeTextTextController?.text ?? '').trim().isNotEmpty);

                                  if (!hasRecipe && !hasImages) {
                                    await showDialog(
                                      context: context,
                                      builder: (alertDialogContext) {
                                        return AlertDialog(
                                          content: Text('please add an image or a recipe'),
                                          actions: [
                                            TextButton(
                                              onPressed: () => Navigator.pop(alertDialogContext),
                                              child: Text('Ok'),
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                    return;
                                  }
                                  if (!hasRecipe && !hasCaption) {
                                    await showDialog(
                                      context: context,
                                      builder: (alertDialogContext) {
                                        return AlertDialog(
                                          content: Text('please add a caption'),
                                          actions: [
                                            TextButton(
                                              onPressed: () => Navigator.pop(alertDialogContext),
                                              child: Text('Ok'),
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                    return;
                                  }

                                  if (hasRecipe && _model.isRecipeSectionExpanded) {
                                    final recipeValid = await _validateRecipeForm();
                                    if (!recipeValid) return;
                                    _syncRecipeToAppState();
                                    FFAppState().hasRecipe = true;
                                  }

                                  {
                                    var postsRecordReference = PostsRecord.collection.doc();
                                    await postsRecordReference.set({
                                      ...createPostsRecordData(
                                        postUser: currentUserReference,
                                        postText: _model.addCaptionTextController.text,
                                        createdTime: getCurrentTimestamp,
                                        hasRecipe: false,
                                      ),
                                      ...mapToFirestore({
                                        'postMultPhotos': _model.currentimages,
                                      }),
                                    });
                                    _model.postCreated = PostsRecord.getDocumentFromData({
                                      ...createPostsRecordData(
                                        postUser: currentUserReference,
                                        postText: _model.addCaptionTextController.text,
                                        createdTime: getCurrentTimestamp,
                                        hasRecipe: false,
                                      ),
                                      ...mapToFirestore({
                                        'postMultPhotos': _model.currentimages,
                                      }),
                                    }, postsRecordReference);
                                    if (FFAppState().hasRecipe == true) {
                                      var recipesRecordReference = RecipesRecord.collection.doc();
                                      await recipesRecordReference.set({
                                        ...createRecipesRecordData(
                                          title: FFAppState().recipetitle,
                                          notes: FFAppState().recipenotes,
                                          cookingtime: FFAppState().cookingtime,
                                          difficulty: FFAppState().difficulty,
                                          servings: FFAppState().servings,
                                          postId: _model.postCreated?.reference,
                                          publicrecipeimage: _model.uploadedFileUrls_uploadDatanewpics2.firstOrNull,
                                          userId: currentUserReference,
                                          usercreated: true,
                                        ),
                                        ...mapToFirestore({
                                          'ingredients': FFAppState().ingredientsList,
                                          'preparation': FFAppState().preparationList,
                                          'recipe_images': _model.uploadedFileUrls_uploadDatanewpics2,
                                          'time_generated': FieldValue.serverTimestamp(),
                                        }),
                                      });
                                      _model.recipeDocument = RecipesRecord.getDocumentFromData({
                                        ...createRecipesRecordData(
                                          title: FFAppState().recipetitle,
                                          notes: FFAppState().recipenotes,
                                          cookingtime: FFAppState().cookingtime,
                                          difficulty: FFAppState().difficulty,
                                          servings: FFAppState().servings,
                                          postId: _model.postCreated?.reference,
                                          publicrecipeimage: _model.uploadedFileUrls_uploadDatanewpics2.firstOrNull,
                                          userId: currentUserReference,
                                          usercreated: true,
                                        ),
                                        ...mapToFirestore({
                                          'ingredients': FFAppState().ingredientsList,
                                          'preparation': FFAppState().preparationList,
                                          'recipe_images': _model.uploadedFileUrls_uploadDatanewpics2,
                                          'time_generated': DateTime.now(),
                                        }),
                                      }, recipesRecordReference);

                                      await _model.postCreated!.reference.update(createPostsRecordData(
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

                                    if (_model.currentDraftRef != null) {
                                      await _model.currentDraftRef!.delete();
                                      _model.currentDraftRef = null;
                                    }

                                    context.pushNamed(FoodFeedWidget.routeName);
                                  }

                                  safeSetState(() {});
                                },
                                text: 'share',
                                options: FFButtonOptions(
                                  width: 120.0,
                                  height: 50.0,
                                  padding: EdgeInsetsDirectional.fromSTEB(24.0, 0.0, 24.0, 0.0),
                                  iconPadding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                                  color: FlutterFlowTheme.of(context).primary,
                                  textStyle: FlutterFlowTheme.of(context).bodyLarge.override(
                                    fontFamily: FlutterFlowTheme.of(context).bodyLargeFamily,
                                    color: FlutterFlowTheme.of(context).primaryBackground,
                                    letterSpacing: 0.0,
                                    fontWeight: FontWeight.bold,
                                    useGoogleFonts: !FlutterFlowTheme.of(context).bodyLargeIsCustom,
                                  ),
                                  elevation: 0.0,
                                  borderSide: BorderSide(color: Colors.transparent, width: 1.0),
                                  borderRadius: BorderRadius.circular(12.0),
                                ),
                              ),
                              SizedBox(width: 12.0),
                              FFButtonWidget(
                                onPressed: () async {
                                  if (loggedIn != true) {
                                    context.pushNamed(OnboardingWidget.routeName);
                                    return;
                                  }
                                  _syncRecipeToAppState();
                                  final draftData = {
                                    ...createDraftsRecordData(
                                      userId: currentUserReference,
                                      caption: _model.addCaptionTextController?.text ?? '',
                                      hasRecipe: FFAppState().hasRecipe || _model.isRecipeSectionExpanded,
                                      recipeTitle: FFAppState().recipetitle,
                                      recipeNotes: FFAppState().recipenotes,
                                      recipeDifficulty: FFAppState().difficulty,
                                      recipeCookingtime: FFAppState().cookingtime,
                                      recipeServings: FFAppState().servings,
                                      lastSaved: getCurrentTimestamp,
                                    ),
                                    ...mapToFirestore({
                                      'images': _model.currentimages,
                                      'ingredients': FFAppState().ingredientsList,
                                      'preparation': FFAppState().preparationList,
                                    }),
                                  };
                                  if (_model.currentDraftRef != null) {
                                    await _model.currentDraftRef!.update(draftData);
                                  } else {
                                    final docRef = DraftsRecord.collection.doc();
                                    await docRef.set(draftData);
                                    _model.currentDraftRef = docRef;
                                  }
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('draft saved'),
                                      duration: Duration(seconds: 2),
                                    ),
                                  );
                                },
                                text: 'save draft',
                                options: FFButtonOptions(
                                  width: 120.0,
                                  height: 50.0,
                                  padding: EdgeInsetsDirectional.fromSTEB(24.0, 0.0, 24.0, 0.0),
                                  iconPadding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                                  color: Colors.transparent,
                                  textStyle: FlutterFlowTheme.of(context).bodyLarge.override(
                                    fontFamily: FlutterFlowTheme.of(context).bodyLargeFamily,
                                    color: FlutterFlowTheme.of(context).tertiary,
                                    letterSpacing: 0.0,
                                    fontWeight: FontWeight.bold,
                                    useGoogleFonts: !FlutterFlowTheme.of(context).bodyLargeIsCustom,
                                  ),
                                  elevation: 0.0,
                                  borderSide: BorderSide(
                                    color: FlutterFlowTheme.of(context).tertiary,
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
                        // === VIEW DRAFTS BUTTON ===
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(
                              15.0, 12.0, 15.0, 100.0),
                          child: Align(
                            alignment: AlignmentDirectional(-1.0, 0.0),
                            child: InkWell(
                              splashColor: Colors.transparent,
                              focusColor: Colors.transparent,
                              hoverColor: Colors.transparent,
                              highlightColor: Colors.transparent,
                              onTap: () async {
                                if (loggedIn != true) {
                                  context.pushNamed(OnboardingWidget.routeName);
                                  return;
                                }
                                _showDraftsBottomSheet(context);
                              },
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.folder_open_rounded,
                                    color: FlutterFlowTheme.of(context).accent1,
                                    size: 20.0,
                                  ),
                                  SizedBox(width: 6.0),
                                  Text(
                                    'view drafts',
                                    style: FlutterFlowTheme.of(context).bodyLarge.override(
                                      fontFamily: FlutterFlowTheme.of(context).bodyLargeFamily,
                                      color: FlutterFlowTheme.of(context).accent1,
                                      letterSpacing: 0.0,
                                      fontWeight: FontWeight.w600,
                                      useGoogleFonts: !FlutterFlowTheme.of(context).bodyLargeIsCustom,
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
            if (!loggedIn)
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () {
                  context.pushNamed(OnboardingWidget.routeName);
                },
                child: Container(
                  color: Colors.transparent,
                ),
              ),
          ],
        ),
      ),
    );
  }

  void _showDraftsBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16.0)),
      ),
      builder: (bottomSheetContext) {
        return DraggableScrollableSheet(
          initialChildSize: 0.6,
          minChildSize: 0.3,
          maxChildSize: 0.9,
          expand: false,
          builder: (_, scrollController) {
            return Column(
              children: [
                Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'your drafts',
                        style: FlutterFlowTheme.of(context).titleLarge.override(
                          fontFamily: FlutterFlowTheme.of(context).titleLargeFamily,
                          letterSpacing: 0.0,
                          useGoogleFonts: !FlutterFlowTheme.of(context).titleLargeIsCustom,
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.close),
                        onPressed: () => Navigator.pop(bottomSheetContext),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: StreamBuilder<List<DraftsRecord>>(
                    stream: queryDraftsRecord(
                      queryBuilder: (draftsRecord) => draftsRecord
                          .where('user_id', isEqualTo: currentUserReference)
                          .orderBy('last_saved', descending: true),
                    ),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return Center(
                          child: SizedBox(
                            width: 50.0,
                            height: 50.0,
                            child: SpinKitRipple(
                              color: FlutterFlowTheme.of(context).primary,
                              size: 50.0,
                            ),
                          ),
                        );
                      }
                      final drafts = snapshot.data!;
                      if (drafts.isEmpty) {
                        return Center(
                          child: Text(
                            'no drafts yet',
                            style: FlutterFlowTheme.of(context).bodyLarge.override(
                              fontFamily: FlutterFlowTheme.of(context).bodyLargeFamily,
                              color: FlutterFlowTheme.of(context).secondaryText,
                              letterSpacing: 0.0,
                              useGoogleFonts: !FlutterFlowTheme.of(context).bodyLargeIsCustom,
                            ),
                          ),
                        );
                      }
                      return ListView.builder(
                        controller: scrollController,
                        padding: EdgeInsets.zero,
                        itemCount: drafts.length,
                        itemBuilder: (context, index) {
                          final draft = drafts[index];
                          return Dismissible(
                            key: Key(draft.reference.id),
                            direction: DismissDirection.endToStart,
                            background: Container(
                              color: FlutterFlowTheme.of(context).error,
                              alignment: Alignment.centerRight,
                              padding: EdgeInsets.only(right: 20.0),
                              child: Icon(Icons.delete, color: Colors.white),
                            ),
                            onDismissed: (_) async {
                              await draft.reference.delete();
                            },
                            child: ListTile(
                              title: Text(
                                draft.caption.isNotEmpty
                                    ? draft.caption
                                    : (draft.recipeTitle.isNotEmpty
                                        ? draft.recipeTitle
                                        : 'untitled draft'),
                                style: FlutterFlowTheme.of(context).bodyLarge.override(
                                  fontFamily: FlutterFlowTheme.of(context).bodyLargeFamily,
                                  letterSpacing: 0.0,
                                  useGoogleFonts: !FlutterFlowTheme.of(context).bodyLargeIsCustom,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              subtitle: Text(
                                dateTimeFormat('relative', draft.lastSaved!),
                                style: FlutterFlowTheme.of(context).bodySmall.override(
                                  fontFamily: FlutterFlowTheme.of(context).bodySmallFamily,
                                  color: FlutterFlowTheme.of(context).secondaryText,
                                  letterSpacing: 0.0,
                                  useGoogleFonts: !FlutterFlowTheme.of(context).bodySmallIsCustom,
                                ),
                              ),
                              trailing: Icon(
                                Icons.chevron_right_rounded,
                                color: FlutterFlowTheme.of(context).secondaryText,
                              ),
                              onTap: () {
                                // Load draft data
                                _model.addCaptionTextController?.text = draft.caption;
                                _model.currentimages = draft.images.toList();
                                _model.currentDraftRef = draft.reference;

                                if (draft.hasRecipe) {
                                  _model.isRecipeSectionExpanded = true;
                                  _model.recipeTextTextController?.text = draft.recipeTitle;
                                  _model.notesTextTextController?.text = draft.recipeNotes;
                                  FFAppState().recipetitle = draft.recipeTitle;
                                  FFAppState().recipenotes = draft.recipeNotes;
                                  FFAppState().cookingtime = draft.recipeCookingtime;
                                  FFAppState().difficulty = draft.recipeDifficulty;
                                  FFAppState().servings = draft.recipeServings;
                                  FFAppState().ingredientsList = draft.ingredients.toList();
                                  FFAppState().preparationList = draft.preparation.toList();
                                  FFAppState().hasRecipe = true;

                                  // Reset dropdown controllers to pick up new values
                                  _model.cookingtimeValueController = null;
                                  _model.cookingtimeValue = draft.recipeCookingtime.isNotEmpty ? draft.recipeCookingtime : null;
                                  _model.difficultyValueController = null;
                                  _model.difficultyValue = draft.recipeDifficulty.isNotEmpty ? draft.recipeDifficulty : null;
                                  _model.servingsValueController = null;
                                  _model.servingsValue = draft.recipeServings.isNotEmpty ? draft.recipeServings : null;
                                }

                                Navigator.pop(bottomSheetContext);
                                safeSetState(() {});
                              },
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
