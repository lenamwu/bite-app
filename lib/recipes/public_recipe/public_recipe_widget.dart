import '/auth/base_auth_user_provider.dart';
import '/auth/firebase_auth/auth_util.dart';
import '/backend/backend.dart';
import '/components/addtocart_widget.dart';
import '/flutter_flow/flutter_flow_animations.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_toggle_icon.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:math';
import 'dart:ui';
import '/index.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'public_recipe_model.dart';
export 'public_recipe_model.dart';
import '/components/bite_logo.dart';
import '/recipes/add_to_cookbook/add_to_cookbook_widget.dart';

class PublicRecipeWidget extends StatefulWidget {
  const PublicRecipeWidget({
    super.key,
    required this.userparam,
    this.recipeParam,
  });

  final DocumentReference? userparam;
  final DocumentReference? recipeParam;

  static String routeName = 'publicRecipe';
  static String routePath = '/publicRecipe';

  @override
  State<PublicRecipeWidget> createState() => _PublicRecipeWidgetState();
}

class _PublicRecipeWidgetState extends State<PublicRecipeWidget>
    with TickerProviderStateMixin {
  late PublicRecipeModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  final animationsMap = <String, AnimationInfo>{};

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => PublicRecipeModel());

    // On page load action.
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      _model.isSaved = !_model.isSaved;
      safeSetState(() {});
    });

    _model.tabBarController = TabController(
      vsync: this,
      length: 2,
      initialIndex: 0,
    )..addListener(() => safeSetState(() {}));

    animationsMap.addAll({
      'columnOnPageLoadAnimation': AnimationInfo(
        trigger: AnimationTrigger.onPageLoad,
        effectsBuilder: () => [
          FadeEffect(
            curve: Curves.easeInOut,
            delay: 0.0.ms,
            duration: 600.0.ms,
            begin: 0.0,
            end: 1.0,
          ),
          MoveEffect(
            curve: Curves.easeInOut,
            delay: 0.0.ms,
            duration: 600.0.ms,
            begin: Offset(0.0, 80.0),
            end: Offset(0.0, 0.0),
          ),
        ],
      ),
    });
    setupAnimations(
      animationsMap.values.where((anim) =>
          anim.trigger == AnimationTrigger.onActionTrigger ||
          !anim.applyInitialState),
      this,
    );

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<RecipesRecord>(
      stream: RecipesRecord.getDocument(widget!.recipeParam!),
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

        final publicRecipeRecipesRecord = snapshot.data!;

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
              leading: Container(
                decoration: BoxDecoration(),
                child: FlutterFlowIconButton(
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
                  },
                ),
              ),
              title: Align(
                alignment: AlignmentDirectional(-1.0, -1.0),
                child: BiteLogo(),
              ),
              actions: [
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(0.0, 5.0, 5.0, 5.0),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(24.0),
                      shape: BoxShape.rectangle,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Column(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            if (publicRecipeRecipesRecord.recipeSavedBy
                                    .contains(currentUserReference) ==
                                false)
                              Align(
                                alignment: AlignmentDirectional(0.0, 0.0),
                                child: Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      10.0, 0.0, 0.0, 0.0),
                                  child: Text(
                                    'save recipe',
                                    style: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .override(
                                          fontFamily:
                                              FlutterFlowTheme.of(context)
                                                  .bodyMediumFamily,
                                          color: FlutterFlowTheme.of(context)
                                              .primary,
                                          fontSize: 16.0,
                                          letterSpacing: 0.0,
                                          fontWeight: FontWeight.bold,
                                          useGoogleFonts:
                                              !FlutterFlowTheme.of(context)
                                                  .bodyMediumIsCustom,
                                        ),
                                  ),
                                ),
                              ),
                            if (publicRecipeRecipesRecord.recipeSavedBy
                                    .contains(currentUserReference) ==
                                true)
                              Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    10.0, 0.0, 0.0, 0.0),
                                child: Text(
                                  'recipe saved!',
                                  style: FlutterFlowTheme.of(context)
                                      .bodyMedium
                                      .override(
                                        fontFamily: FlutterFlowTheme.of(context)
                                            .bodyMediumFamily,
                                        color: FlutterFlowTheme.of(context)
                                            .primary,
                                        fontSize: 16.0,
                                        letterSpacing: 0.0,
                                        fontWeight: FontWeight.bold,
                                        useGoogleFonts:
                                            !FlutterFlowTheme.of(context)
                                                .bodyMediumIsCustom,
                                      ),
                                ),
                              ),
                          ],
                        ),
                        Align(
                          alignment: AlignmentDirectional(0.0, 0.0),
                          child: ToggleIcon(
                            onPressed: () async {
                              if (loggedIn != true) {
                                context.pushNamed(OnboardingWidget.routeName);
                                return;
                              }
                              if (publicRecipeRecipesRecord.recipeSavedBy
                                      .contains(currentUserReference) ==
                                  false) {
                                await publicRecipeRecipesRecord.reference
                                    .update({
                                  ...mapToFirestore(
                                    {
                                      'recipe_saved_by': FieldValue.arrayUnion(
                                          [currentUserReference]),
                                    },
                                  ),
                                });
                              } else {
                                // If this is a forked copy, delete it entirely
                                if (publicRecipeRecipesRecord.hasForkedFrom()) {
                                  await publicRecipeRecipesRecord.reference.delete();
                                  if (context.mounted) context.pop();
                                  return;
                                }
                                await publicRecipeRecipesRecord.reference
                                    .update({
                                  ...mapToFirestore(
                                    {
                                      'recipe_saved_by': FieldValue.arrayRemove(
                                          [currentUserReference]),
                                    },
                                  ),
                                });
                              }
                            },
                            value: publicRecipeRecipesRecord.recipeSavedBy
                                .contains(currentUserReference),
                            onIcon: Icon(
                              Icons.bookmark_rounded,
                              color: FlutterFlowTheme.of(context).accent1,
                              size: 30.0,
                            ),
                            offIcon: Icon(
                              Icons.bookmark_border,
                              color: FlutterFlowTheme.of(context).accent1,
                              size: 30.0,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
              centerTitle: false,
              elevation: 2.0,
            ),
            body: SafeArea(
              top: true,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Column(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Align(
                              alignment: AlignmentDirectional(-1.0, -1.0),
                              child: Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    10.0, 10.0, 0.0, 0.0),
                                child: Text(
                                  publicRecipeRecipesRecord.title,
                                  maxLines: 3,
                                  style: FlutterFlowTheme.of(context)
                                      .headlineSmall
                                      .override(
                                        fontFamily: FlutterFlowTheme.of(context)
                                            .headlineSmallFamily,
                                        color: FlutterFlowTheme.of(context)
                                            .customColor4,
                                        letterSpacing: 0.0,
                                        fontWeight: FontWeight.bold,
                                        useGoogleFonts:
                                            !FlutterFlowTheme.of(context)
                                                .headlineSmallIsCustom,
                                      ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  10.0, 16.0, 10.0, 0.0),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(0.0),
                                    child: Image.network(
                                      publicRecipeRecipesRecord
                                          .publicrecipeimage,
                                      width: 140.0,
                                      height: 140.0,
                                      fit: BoxFit.cover,
                                      errorBuilder:
                                          (context, error, stackTrace) =>
                                              Image.asset(
                                        'assets/images/error_image.png',
                                        width: 140.0,
                                        height: 140.0,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 14.0),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        if (publicRecipeRecipesRecord.hasRating() && publicRecipeRecipesRecord.rating > 0)
                                          Padding(
                                            padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 8.0),
                                            child: Row(
                                              children: List.generate(5, (index) {
                                                final rating = publicRecipeRecipesRecord.rating;
                                                if (index < rating.floor()) {
                                                  return Icon(Icons.star_rounded, color: Color(0xFFFFE082), size: 20.0);
                                                } else if (index < rating.ceil() && rating % 1 >= 0.5) {
                                                  return Icon(Icons.star_half_rounded, color: Color(0xFFFFE082), size: 20.0);
                                                } else {
                                                  return Icon(Icons.star_outline_rounded, color: Color(0xFF000000), size: 20.0);
                                                }
                                              }),
                                            ),
                                          ),
                                        if (publicRecipeRecipesRecord.cookingtime.isNotEmpty)
                                          Padding(
                                            padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 6.0),
                                            child: Row(
                                              children: [
                                                Text(
                                                  'cooking time: ',
                                                  style: FlutterFlowTheme.of(context).bodyLarge.override(
                                                    fontFamily: FlutterFlowTheme.of(context).bodyLargeFamily,
                                                    color: FlutterFlowTheme.of(context).alternate,
                                                    fontSize: 13.0,
                                                    letterSpacing: 0.0,
                                                    fontWeight: FontWeight.bold,
                                                    useGoogleFonts: !FlutterFlowTheme.of(context).bodyLargeIsCustom,
                                                  ),
                                                ),
                                                Flexible(
                                                  child: Text(
                                                    publicRecipeRecipesRecord.cookingtime,
                                                    overflow: TextOverflow.ellipsis,
                                                    style: FlutterFlowTheme.of(context).bodyLarge.override(
                                                      fontFamily: FlutterFlowTheme.of(context).bodyLargeFamily,
                                                      color: FlutterFlowTheme.of(context).accent1,
                                                      fontSize: 13.0,
                                                      letterSpacing: 0.0,
                                                      fontWeight: FontWeight.bold,
                                                      useGoogleFonts: !FlutterFlowTheme.of(context).bodyLargeIsCustom,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        if (publicRecipeRecipesRecord.servings.isNotEmpty)
                                          Padding(
                                            padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 6.0),
                                            child: Row(
                                              children: [
                                                Text(
                                                  'servings: ',
                                                  style: FlutterFlowTheme.of(context).bodyLarge.override(
                                                    fontFamily: FlutterFlowTheme.of(context).bodyLargeFamily,
                                                    color: FlutterFlowTheme.of(context).alternate,
                                                    fontSize: 13.0,
                                                    letterSpacing: 0.0,
                                                    fontWeight: FontWeight.bold,
                                                    useGoogleFonts: !FlutterFlowTheme.of(context).bodyLargeIsCustom,
                                                  ),
                                                ),
                                                Flexible(
                                                  child: Text(
                                                    publicRecipeRecipesRecord.servings,
                                                    overflow: TextOverflow.ellipsis,
                                                    style: FlutterFlowTheme.of(context).bodyLarge.override(
                                                      fontFamily: FlutterFlowTheme.of(context).bodyLargeFamily,
                                                      color: FlutterFlowTheme.of(context).accent1,
                                                      fontSize: 13.0,
                                                      letterSpacing: 0.0,
                                                      fontWeight: FontWeight.bold,
                                                      useGoogleFonts: !FlutterFlowTheme.of(context).bodyLargeIsCustom,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        Builder(
                                          builder: (context) {
                                            final otherSaves = publicRecipeRecipesRecord.recipeSavedBy
                                                .where((ref) => ref != currentUserReference)
                                                .length;
                                            if (otherSaves < 1) return SizedBox.shrink();
                                            return Padding(
                                              padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 6.0),
                                              child: Text(
                                                'saved by $otherSaves other user${otherSaves == 1 ? '' : 's'}',
                                                style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                  fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                                                  color: FlutterFlowTheme.of(context).secondaryText,
                                                  fontSize: 13.0,
                                                  letterSpacing: 0.0,
                                                  fontWeight: FontWeight.w600,
                                                  useGoogleFonts: !FlutterFlowTheme.of(context).bodyMediumIsCustom,
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                        if (publicRecipeRecipesRecord.url.isNotEmpty)
                                          if (publicRecipeRecipesRecord.url.isNotEmpty)
                                          Padding(
                                            padding: EdgeInsetsDirectional.fromSTEB(0.0, 4.0, 0.0, 0.0),
                                            child: InkWell(
                                              onTap: () async {
                                                await launchUrl(
                                                  Uri.parse(publicRecipeRecipesRecord.url),
                                                  mode: LaunchMode.externalApplication,
                                                );
                                              },
                                              child: Text(
                                                'view original recipe',
                                                style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                  fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                                                  color: FlutterFlowTheme.of(context).primary,
                                                  letterSpacing: 0.0,
                                                  fontWeight: FontWeight.bold,
                                                  useGoogleFonts: !FlutterFlowTheme.of(context).bodyMediumIsCustom,
                                                ),
                                              ),
                                            ),
                                          ),
                                        if (loggedIn &&
                                            publicRecipeRecipesRecord.recipeSavedBy
                                                .contains(currentUserReference))
                                          Padding(
                                            padding: EdgeInsetsDirectional.fromSTEB(0.0, 8.0, 0.0, 0.0),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                InkWell(
                                                  splashColor: Colors.transparent,
                                                  focusColor: Colors.transparent,
                                                  hoverColor: Colors.transparent,
                                                  highlightColor: Colors.transparent,
                                                  onTap: () {
                                                    context.pushNamed(
                                                      EditSavedRecipeWidget.routeName,
                                                      queryParameters: {
                                                        'recipeRef': serializeParam(
                                                          publicRecipeRecipesRecord.reference,
                                                          ParamType.DocumentReference,
                                                        ),
                                                      }.withoutNulls,
                                                    );
                                                  },
                                                  child: Row(
                                                    mainAxisSize: MainAxisSize.min,
                                                    children: [
                                                      Text(
                                                        'edit',
                                                        style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                          fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                                                          color: FlutterFlowTheme.of(context).customColor4,
                                                          letterSpacing: 0.0,
                                                          fontSize: 13.0,
                                                          fontWeight: FontWeight.bold,
                                                          useGoogleFonts: !FlutterFlowTheme.of(context).bodyMediumIsCustom,
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding: EdgeInsetsDirectional.fromSTEB(4.0, 0.0, 0.0, 0.0),
                                                        child: Icon(
                                                          Icons.edit_outlined,
                                                          color: FlutterFlowTheme.of(context).accent3,
                                                          size: 16.0,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                if (publicRecipeRecipesRecord.usercreated != true)
                                                  Padding(
                                                    padding: EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 0.0, 0.0),
                                                    child: InkWell(
                                                      splashColor: Colors.transparent,
                                                      focusColor: Colors.transparent,
                                                      hoverColor: Colors.transparent,
                                                      highlightColor: Colors.transparent,
                                                      onTap: () async {
                                                        // Check if already in cookbook
                                                        final existingPosts = await queryPostsRecordOnce(
                                                          queryBuilder: (postsRecord) => postsRecord
                                                              .where('postUser', isEqualTo: currentUserReference)
                                                              .where('has_recipe', isEqualTo: true)
                                                              .where('recipe_ref', isEqualTo: publicRecipeRecipesRecord.reference),
                                                        );
                                                        if (existingPosts.isNotEmpty) {
                                                          if (context.mounted) {
                                                            ScaffoldMessenger.of(context)
                                                              ..hideCurrentSnackBar()
                                                              ..showSnackBar(
                                                                SnackBar(
                                                                  content: Text(
                                                                    'this recipe is already in your cookbook!',
                                                                    style: TextStyle(
                                                                      color: FlutterFlowTheme.of(context).primaryBackground,
                                                                    ),
                                                                  ),
                                                                  backgroundColor: FlutterFlowTheme.of(context).tertiary,
                                                                  duration: Duration(seconds: 2),
                                                                ),
                                                              );
                                                          }
                                                          return;
                                                        }
                                                        if (context.mounted) {
                                                          await showModalBottomSheet(
                                                            isScrollControlled: true,
                                                            backgroundColor: Colors.transparent,
                                                            context: context,
                                                            builder: (context) {
                                                              return Padding(
                                                                padding: MediaQuery.viewInsetsOf(context),
                                                                child: AddToCookbookWidget(
                                                                  recipeRef: publicRecipeRecipesRecord.reference,
                                                                ),
                                                              );
                                                            },
                                                          );
                                                        }
                                                      },
                                                      child: Row(
                                                        mainAxisSize: MainAxisSize.min,
                                                        children: [
                                                          Text(
                                                            'add to cookbook',
                                                            style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                              fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                                                              color: FlutterFlowTheme.of(context).customColor4,
                                                              letterSpacing: 0.0,
                                                              fontSize: 13.0,
                                                              fontWeight: FontWeight.bold,
                                                              useGoogleFonts: !FlutterFlowTheme.of(context).bodyMediumIsCustom,
                                                            ),
                                                          ),
                                                          Padding(
                                                            padding: EdgeInsetsDirectional.fromSTEB(4.0, 0.0, 0.0, 0.0),
                                                            child: Icon(
                                                              Icons.menu_book_outlined,
                                                              color: FlutterFlowTheme.of(context).accent3,
                                                              size: 16.0,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                              ],
                                            ),
                                          ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.all(16.0),
                              child: Container(
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: FlutterFlowTheme.of(context)
                                      .secondaryBackground,
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                child: SingleChildScrollView(
                                  primary: false,
                                  child: Column(
                                    mainAxisSize: MainAxisSize.max,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                          Stack(
                                            children: [
                                              Container(
                                                height: 500.0,
                                                decoration: BoxDecoration(),
                                                child: InkWell(
                                                  splashColor:
                                                      Colors.transparent,
                                                  focusColor:
                                                      Colors.transparent,
                                                  hoverColor:
                                                      Colors.transparent,
                                                  highlightColor:
                                                      Colors.transparent,
                                                  onDoubleTap: () async {
                                                    FFAppState()
                                                        .searchisactive = false;
                                                    safeSetState(() {});
                                                  },
                                                  child: Column(
                                                    children: [
                                                      Align(
                                                        alignment:
                                                            Alignment(0.0, 0),
                                                        child: TabBar(
                                                          labelColor:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .tertiary,
                                                          unselectedLabelColor:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .secondary,
                                                          labelStyle:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .bodyLarge
                                                                  .override(
                                                                    fontFamily:
                                                                        FlutterFlowTheme.of(context)
                                                                            .bodyLargeFamily,
                                                                    letterSpacing:
                                                                        0.0,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    useGoogleFonts:
                                                                        !FlutterFlowTheme.of(context)
                                                                            .bodyLargeIsCustom,
                                                                  ),
                                                          unselectedLabelStyle:
                                                              TextStyle(),
                                                          indicatorColor:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .tertiary,
                                                          indicatorWeight: 3.0,
                                                          tabs: [
                                                            Tab(
                                                              text:
                                                                  'ingredients',
                                                            ),
                                                            Tab(
                                                              text:
                                                                  'directions',
                                                            ),
                                                          ],
                                                          controller: _model
                                                              .tabBarController,
                                                          onTap: (i) async {
                                                            [
                                                              () async {},
                                                              () async {}
                                                            ][i]();
                                                          },
                                                        ),
                                                      ),
                                                      Expanded(
                                                        child: TabBarView(
                                                          controller: _model
                                                              .tabBarController,
                                                          children: [
                                                            Container(
                                                              width: 100.0,
                                                              height: double
                                                                  .infinity,
                                                              decoration:
                                                                  BoxDecoration(
                                                                color: FlutterFlowTheme.of(
                                                                        context)
                                                                    .primaryBackground,
                                                              ),
                                                              child: Padding(
                                                                padding:
                                                                    EdgeInsetsDirectional
                                                                        .fromSTEB(
                                                                            0.0,
                                                                            0.0,
                                                                            0.0,
                                                                            20.0),
                                                                child: Builder(
                                                                  builder:
                                                                      (context) {
                                                                    final ingredients = publicRecipeRecipesRecord
                                                                        .ingredients
                                                                        .map((e) =>
                                                                            e)
                                                                        .toList();

                                                                    return ListView
                                                                        .builder(
                                                                      padding:
                                                                          EdgeInsets
                                                                              .zero,
                                                                      primary:
                                                                          false,
                                                                      scrollDirection:
                                                                          Axis.vertical,
                                                                      itemCount:
                                                                          ingredients
                                                                              .length,
                                                                      itemBuilder:
                                                                          (context,
                                                                              ingredientsIndex) {
                                                                        final ingredientsItem =
                                                                            ingredients[ingredientsIndex];
                                                                        return Padding(
                                                                          padding: EdgeInsetsDirectional.fromSTEB(
                                                                              0.0,
                                                                              6.0,
                                                                              0.0,
                                                                              0.0),
                                                                          child:
                                                                              InkWell(
                                                                            splashColor:
                                                                                Colors.transparent,
                                                                            focusColor:
                                                                                Colors.transparent,
                                                                            hoverColor:
                                                                                Colors.transparent,
                                                                            highlightColor:
                                                                                Colors.transparent,
                                                                            onTap:
                                                                                () async {
                                                                              await showModalBottomSheet(
                                                                                isScrollControlled: true,
                                                                                backgroundColor: Colors.transparent,
                                                                                enableDrag: false,
                                                                                context: context,
                                                                                builder: (context) {
                                                                                  return GestureDetector(
                                                                                    onTap: () {
                                                                                      FocusScope.of(context).unfocus();
                                                                                      FocusManager.instance.primaryFocus?.unfocus();
                                                                                    },
                                                                                    child: Padding(
                                                                                      padding: MediaQuery.viewInsetsOf(context),
                                                                                      child: AddtocartWidget(
                                                                                        ingredientItem: ingredientsItem,
                                                                                      ),
                                                                                    ),
                                                                                  );
                                                                                },
                                                                              ).then((value) => safeSetState(() {}));
                                                                            },
                                                                            child:
                                                                                Text(
                                                                              ingredientsItem,
                                                                              style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                    fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                                                                                    color: FlutterFlowTheme.of(context).accent1,
                                                                                    letterSpacing: 0.0,
                                                                                    fontWeight: FontWeight.bold,
                                                                                    useGoogleFonts: !FlutterFlowTheme.of(context).bodyMediumIsCustom,
                                                                                  ),
                                                                            ),
                                                                          ),
                                                                        );
                                                                      },
                                                                    );
                                                                  },
                                                                ),
                                                              ),
                                                            ),
                                                            Container(
                                                              width: 100.0,
                                                              height: double
                                                                  .infinity,
                                                              decoration:
                                                                  BoxDecoration(
                                                                color: FlutterFlowTheme.of(
                                                                        context)
                                                                    .primaryBackground,
                                                              ),
                                                              child: Padding(
                                                                padding:
                                                                    EdgeInsetsDirectional
                                                                        .fromSTEB(
                                                                            0.0,
                                                                            0.0,
                                                                            0.0,
                                                                            20.0),
                                                                child: Builder(
                                                                  builder:
                                                                      (context) {
                                                                    final preparation = publicRecipeRecipesRecord
                                                                        .preparation
                                                                        .map((e) =>
                                                                            e)
                                                                        .toList();

                                                                    return ListView
                                                                        .builder(
                                                                      padding:
                                                                          EdgeInsets
                                                                              .zero,
                                                                      primary:
                                                                          false,
                                                                      shrinkWrap:
                                                                          true,
                                                                      scrollDirection:
                                                                          Axis.vertical,
                                                                      itemCount:
                                                                          preparation
                                                                              .length,
                                                                      itemBuilder:
                                                                          (context,
                                                                              preparationIndex) {
                                                                        final preparationItem =
                                                                            preparation[preparationIndex];
                                                                        return Padding(
                                                                          padding: EdgeInsetsDirectional.fromSTEB(
                                                                              0.0,
                                                                              6.0,
                                                                              0.0,
                                                                              0.0),
                                                                          child:
                                                                              Text(
                                                                            preparationItem,
                                                                            style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                  fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                                                                                  color: FlutterFlowTheme.of(context).accent1,
                                                                                  letterSpacing: 0.0,
                                                                                  fontWeight: FontWeight.w600,
                                                                                  useGoogleFonts: !FlutterFlowTheme.of(context).bodyMediumIsCustom,
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
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ).animateOnPageLoad(
                            animationsMap['columnOnPageLoadAnimation']!),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
