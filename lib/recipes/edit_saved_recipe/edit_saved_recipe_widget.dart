import '/auth/firebase_auth/auth_util.dart';
import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_drop_down.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/flutter_flow/form_field_controller.dart';
import '/recipes/ingredient_field/ingredient_field_widget.dart';
import '/recipes/preparation_field/preparation_field_widget.dart';
import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '/index.dart';
import 'edit_saved_recipe_model.dart';
export 'edit_saved_recipe_model.dart';

class EditSavedRecipeWidget extends StatefulWidget {
  const EditSavedRecipeWidget({
    super.key,
    required this.recipeRef,
  });

  final DocumentReference? recipeRef;

  static String routeName = 'editSavedRecipe';
  static String routePath = '/editSavedRecipe';

  @override
  State<EditSavedRecipeWidget> createState() => _EditSavedRecipeWidgetState();
}

class _EditSavedRecipeWidgetState extends State<EditSavedRecipeWidget> {
  late EditSavedRecipeModel _model;
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => EditSavedRecipeModel());

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  void _loadRecipeData(RecipesRecord recipe) {
    if (_model.dataLoaded) return;
    _model.dataLoaded = true;

    _model.titleTextController = TextEditingController(text: recipe.title);
    _model.titleFocusNode = FocusNode();
    _model.notesTextController = TextEditingController(text: recipe.notes);
    _model.notesFocusNode = FocusNode();

    _model.cookingtimeValue = recipe.cookingtime.isNotEmpty ? recipe.cookingtime : null;
    _model.difficultyValue = recipe.difficulty.isNotEmpty ? recipe.difficulty : null;
    _model.servingsValue = recipe.servings.isNotEmpty ? recipe.servings : null;

    // Store original values for change detection
    _model.originalTitle = recipe.title;
    _model.originalNotes = recipe.notes;
    _model.originalCookingtime = recipe.cookingtime.isNotEmpty ? recipe.cookingtime : null;
    _model.originalDifficulty = recipe.difficulty.isNotEmpty ? recipe.difficulty : null;
    _model.originalServings = recipe.servings.isNotEmpty ? recipe.servings : null;
    _model.originalIngredients = recipe.ingredients.toList();
    _model.originalPreparation = recipe.preparation.toList();

    // Load ingredients into FFAppState
    FFAppState().ingredientsList = recipe.ingredients.isNotEmpty
        ? recipe.ingredients.toList()
        : [''];
    // Load preparation into FFAppState
    FFAppState().preparationList = recipe.preparation.isNotEmpty
        ? recipe.preparation.toList()
        : [''];
  }

  bool _hasChanges(String title, String notes, String? cookingtime,
      String? difficulty, String? servings,
      List<String> ingredients, List<String> preparation) {
    if (title != _model.originalTitle) return true;
    if (notes != _model.originalNotes) return true;
    if (cookingtime != _model.originalCookingtime) return true;
    if (difficulty != _model.originalDifficulty) return true;
    if (servings != _model.originalServings) return true;
    if (ingredients.length != _model.originalIngredients.length) return true;
    for (int i = 0; i < ingredients.length; i++) {
      if (ingredients[i] != _model.originalIngredients[i]) return true;
    }
    if (preparation.length != _model.originalPreparation.length) return true;
    for (int i = 0; i < preparation.length; i++) {
      if (preparation[i] != _model.originalPreparation[i]) return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    context.watch<FFAppState>();

    return StreamBuilder<RecipesRecord>(
      stream: RecipesRecord.getDocument(widget.recipeRef!),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Scaffold(
            backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
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
        final recipe = snapshot.data!;
        _loadRecipeData(recipe);

        return GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
            FocusManager.instance.primaryFocus?.unfocus();
          },
          child: Scaffold(
            key: scaffoldKey,
            backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
            appBar: AppBar(
              backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
              automaticallyImplyLeading: false,
              leading: FlutterFlowIconButton(
                borderColor: Colors.transparent,
                borderRadius: 30.0,
                borderWidth: 1.0,
                buttonSize: 60.0,
                icon: Icon(
                  Icons.arrow_back_rounded,
                  color: FlutterFlowTheme.of(context).primaryText,
                  size: 30.0,
                ),
                onPressed: () async {
                  context.pop();
                },
              ),
              title: Align(
                alignment: AlignmentDirectional(0.0, -1.0),
                child: Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 40.0, 0.0),
                  child: Text(
                    'edit recipe',
                    style: FlutterFlowTheme.of(context).titleLarge.override(
                          fontFamily:
                              FlutterFlowTheme.of(context).titleLargeFamily,
                          letterSpacing: 0.0,
                          useGoogleFonts: !FlutterFlowTheme.of(context)
                              .titleLargeIsCustom,
                        ),
                  ),
                ),
              ),
              actions: [],
              centerTitle: false,
              elevation: 0.0,
            ),
            body: SafeArea(
              top: true,
              child: Padding(
                padding: EdgeInsetsDirectional.fromSTEB(16.0, 12.0, 16.0, 20.0),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Form(
                        key: _model.formKey,
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
                                        useGoogleFonts: !FlutterFlowTheme.of(context)
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
                                        controller: _model.titleTextController,
                                        focusNode: _model.titleFocusNode,
                                        autofocus: false,
                                        obscureText: false,
                                        decoration: InputDecoration(
                                          isDense: true,
                                          enabledBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color: FlutterFlowTheme.of(context).tertiary,
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
                                              .secondaryBackground,
                                        ),
                                        style: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .override(
                                              fontFamily: FlutterFlowTheme.of(context)
                                                  .bodyMediumFamily,
                                              letterSpacing: 0.0,
                                              useGoogleFonts: !FlutterFlowTheme.of(context)
                                                  .bodyMediumIsCustom,
                                            ),
                                        cursorColor:
                                            FlutterFlowTheme.of(context).primaryText,
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
                                          color: FlutterFlowTheme.of(context).accent3,
                                          letterSpacing: 0.0,
                                          fontWeight: FontWeight.w600,
                                          useGoogleFonts: !FlutterFlowTheme.of(context)
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
                                          controller: _model.notesTextController,
                                          focusNode: _model.notesFocusNode,
                                          autofocus: false,
                                          obscureText: false,
                                          decoration: InputDecoration(
                                            isDense: true,
                                            enabledBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                color: FlutterFlowTheme.of(context).tertiary,
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
                                                .secondaryBackground,
                                          ),
                                          style: FlutterFlowTheme.of(context)
                                              .bodyMedium
                                              .override(
                                                fontFamily: FlutterFlowTheme.of(context)
                                                    .bodyMediumFamily,
                                                letterSpacing: 0.0,
                                                useGoogleFonts: !FlutterFlowTheme.of(context)
                                                    .bodyMediumIsCustom,
                                              ),
                                          maxLength: 200,
                                          buildCounter: (context,
                                                  {required currentLength,
                                                  required isFocused,
                                                  maxLength}) =>
                                              null,
                                          cursorColor:
                                              FlutterFlowTheme.of(context).primaryText,
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
                                      _model.cookingtimeValue,
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
                                    },
                                    width: 160.0,
                                    height: 40.0,
                                    textStyle: FlutterFlowTheme.of(context)
                                        .labelLarge
                                        .override(
                                          fontFamily: FlutterFlowTheme.of(context)
                                              .labelLargeFamily,
                                          color: FlutterFlowTheme.of(context).primary,
                                          letterSpacing: 0.0,
                                          fontWeight: FontWeight.w600,
                                          useGoogleFonts: !FlutterFlowTheme.of(context)
                                              .labelLargeIsCustom,
                                        ),
                                    hintText: 'cooking time',
                                    icon: Icon(
                                      Icons.keyboard_arrow_down_rounded,
                                      color: FlutterFlowTheme.of(context).secondaryText,
                                      size: 24.0,
                                    ),
                                    fillColor: FlutterFlowTheme.of(context)
                                        .secondaryBackground,
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
                            // Difficulty + servings
                            Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  0.0, 8.0, 0.0, 0.0),
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  FlutterFlowDropDown<String>(
                                    controller:
                                        _model.difficultyValueController ??=
                                            FormFieldController<String>(
                                      _model.difficultyValue,
                                    ),
                                    options: ['easy', 'medium', 'hard'],
                                    onChanged: (val) async {
                                      safeSetState(
                                          () => _model.difficultyValue = val);
                                    },
                                    width: 160.0,
                                    height: 40.0,
                                    textStyle: FlutterFlowTheme.of(context)
                                        .labelLarge
                                        .override(
                                          fontFamily: FlutterFlowTheme.of(context)
                                              .labelLargeFamily,
                                          color: FlutterFlowTheme.of(context).primary,
                                          letterSpacing: 0.0,
                                          fontWeight: FontWeight.w600,
                                          useGoogleFonts: !FlutterFlowTheme.of(context)
                                              .labelLargeIsCustom,
                                        ),
                                    hintText: 'difficulty',
                                    icon: Icon(
                                      Icons.keyboard_arrow_down_rounded,
                                      color: FlutterFlowTheme.of(context).secondaryText,
                                      size: 24.0,
                                    ),
                                    fillColor: FlutterFlowTheme.of(context)
                                        .secondaryBackground,
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
                                      controller:
                                          _model.servingsValueController ??=
                                              FormFieldController<String>(
                                        _model.servingsValue,
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
                                            useGoogleFonts: !FlutterFlowTheme.of(context)
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
                                          .secondaryBackground,
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
                            // Ingredients header
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
                                            color: FlutterFlowTheme.of(context).accent3,
                                            letterSpacing: 0.0,
                                            fontWeight: FontWeight.w600,
                                            useGoogleFonts: !FlutterFlowTheme.of(context)
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
                                                      child:
                                                          IngredientFieldWidget(
                                                        key: Key(
                                                          'Keyesr_${ingredientsChildrenIndex.toString()}',
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
                                    color: FlutterFlowTheme.of(context)
                                        .primary
                                        .withOpacity(0.1),
                                    textStyle: FlutterFlowTheme.of(context)
                                        .titleSmall
                                        .override(
                                          fontFamily: FlutterFlowTheme.of(context)
                                              .titleSmallFamily,
                                          color: FlutterFlowTheme.of(context).customColor4,
                                          letterSpacing: 0.0,
                                          fontWeight: FontWeight.bold,
                                          useGoogleFonts: !FlutterFlowTheme.of(context)
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
                            // Preparation steps header
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
                                      alignment:
                                          AlignmentDirectional(0.0, -1.0),
                                      child: Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                            0.0, 8.0, 0.0, 0.0),
                                        child: Builder(
                                          builder: (context) {
                                            final preparationChildren =
                                                FFAppState()
                                                    .preparationList
                                                    .toList();
                                            return ListView.builder(
                                              padding: EdgeInsets.zero,
                                              primary: false,
                                              shrinkWrap: true,
                                              scrollDirection: Axis.vertical,
                                              itemCount:
                                                  preparationChildren.length,
                                              itemBuilder: (context,
                                                  preparationChildrenIndex) {
                                                final preparationChildrenItem =
                                                    preparationChildren[
                                                        preparationChildrenIndex];
                                                return wrapWithModel(
                                                  model: _model
                                                      .preparationFieldModels
                                                      .getModel(
                                                    preparationChildrenIndex
                                                        .toString(),
                                                    preparationChildrenIndex,
                                                  ),
                                                  updateCallback: () =>
                                                      safeSetState(() {}),
                                                  child:
                                                      PreparationFieldWidget(
                                                    key: Key(
                                                      'Keyesr2_${preparationChildrenIndex.toString()}',
                                                    ),
                                                    preparationText:
                                                        preparationChildrenItem,
                                                    index:
                                                        preparationChildrenIndex,
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
                              child: Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    0.0, 5.0, 0.0, 16.0),
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
                                    color: FlutterFlowTheme.of(context)
                                        .primary
                                        .withOpacity(0.1),
                                    textStyle: FlutterFlowTheme.of(context)
                                        .titleSmall
                                        .override(
                                          fontFamily: FlutterFlowTheme.of(context)
                                              .titleSmallFamily,
                                          color: FlutterFlowTheme.of(context).customColor4,
                                          letterSpacing: 0.0,
                                          fontWeight: FontWeight.bold,
                                          useGoogleFonts: !FlutterFlowTheme.of(context)
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
                            // Save button
                            FFButtonWidget(
                              onPressed: () async {
                                // Collect ingredients from text controllers
                                final ingredients = _model.ingredientFieldModels
                                    .getValues((m) => m.textController?.text ?? '')
                                    .where((t) => t.trim().isNotEmpty)
                                    .toList();

                                // Collect preparation steps from text controllers
                                final preparation = _model.preparationFieldModels
                                    .getValues((m) => m.textController?.text ?? '')
                                    .where((t) => t.trim().isNotEmpty)
                                    .toList();

                                final title = _model.titleTextController?.text ?? '';
                                final notes = _model.notesTextController?.text ?? '';
                                final difficulty = _model.difficultyValue ?? '';
                                final cookingtime = _model.cookingtimeValue ?? '';
                                final servings = _model.servingsValue ?? '';

                                // Check if anything actually changed
                                if (!_hasChanges(title, notes, cookingtime,
                                    difficulty, servings, ingredients, preparation)) {
                                  if (!context.mounted) return;
                                  context.pop();
                                  return;
                                }

                                if (recipe.userId == currentUserReference) {
                                  // User owns this recipe — update in place
                                  await widget.recipeRef!.update({
                                    ...createRecipesRecordData(
                                      title: title,
                                      notes: notes,
                                      difficulty: difficulty,
                                      cookingtime: cookingtime,
                                      servings: servings,
                                    ),
                                    ...mapToFirestore({
                                      'ingredients': ingredients,
                                      'preparation': preparation,
                                    }),
                                  });

                                  if (!context.mounted) return;
                                  context.pop();
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('recipe updated!'),
                                      duration: Duration(seconds: 2),
                                    ),
                                  );
                                } else {
                                  // Editing someone else's recipe — create a personal copy
                                  final copyRef = RecipesRecord.collection.doc();
                                  await copyRef.set({
                                    ...createRecipesRecordData(
                                      title: title,
                                      notes: notes,
                                      difficulty: difficulty,
                                      cookingtime: cookingtime,
                                      servings: servings,
                                      url: recipe.url,
                                      publicrecipeimage: recipe.publicrecipeimage,
                                      usercreated: recipe.usercreated,
                                      rating: recipe.rating,
                                      userId: currentUserReference,
                                      forkedFrom: widget.recipeRef,
                                    ),
                                    ...mapToFirestore({
                                      'ingredients': ingredients,
                                      'preparation': preparation,
                                      'recipe_saved_by': [currentUserReference],
                                      'time_generated': FieldValue.serverTimestamp(),
                                    }),
                                  });

                                  // Move bookmark from original to fork
                                  await widget.recipeRef!.update({
                                    ...mapToFirestore({
                                      'recipe_saved_by': FieldValue.arrayRemove(
                                          [currentUserReference]),
                                    }),
                                  });

                                  if (!context.mounted) return;
                                  context.pop();
                                  context.pushNamed(
                                    PublicRecipeWidget.routeName,
                                    queryParameters: {
                                      'userparam': serializeParam(
                                        currentUserReference,
                                        ParamType.DocumentReference,
                                      ),
                                      'recipeParam': serializeParam(
                                        copyRef,
                                        ParamType.DocumentReference,
                                      ),
                                    }.withoutNulls,
                                  );
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('recipe saved as your personal copy!'),
                                      duration: Duration(seconds: 2),
                                    ),
                                  );
                                }
                              },
                              text: 'save changes',
                              options: FFButtonOptions(
                                width: double.infinity,
                                height: 50.0,
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    0.0, 0.0, 0.0, 0.0),
                                iconPadding: EdgeInsetsDirectional.fromSTEB(
                                    0.0, 0.0, 0.0, 0.0),
                                color: FlutterFlowTheme.of(context).tertiary,
                                textStyle: FlutterFlowTheme.of(context)
                                    .titleSmall
                                    .override(
                                      fontFamily: FlutterFlowTheme.of(context)
                                          .titleSmallFamily,
                                      color: Colors.white,
                                      letterSpacing: 0.0,
                                      fontWeight: FontWeight.bold,
                                      useGoogleFonts: !FlutterFlowTheme.of(context)
                                          .titleSmallIsCustom,
                                    ),
                                elevation: 2.0,
                                borderSide: BorderSide(
                                  color: Colors.transparent,
                                  width: 1.0,
                                ),
                                borderRadius: BorderRadius.circular(12.0),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
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
