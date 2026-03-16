import 'package:url_launcher/url_launcher.dart';
import '/auth/base_auth_user_provider.dart';
import '/auth/firebase_auth/auth_util.dart';
import '/backend/api_requests/api_calls.dart';
import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_animations.dart';
import '/flutter_flow/flutter_flow_autocomplete_options_list.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:math';
import 'dart:ui';
import '/index.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collection/collection.dart';
import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:text_search/text_search.dart';
import 'search_directory_model.dart';
export 'search_directory_model.dart';

class SearchDirectoryWidget extends StatefulWidget {
  const SearchDirectoryWidget({super.key});

  static String routeName = 'search_directory';
  static String routePath = '/searchDirectory';

  @override
  State<SearchDirectoryWidget> createState() => _SearchDirectoryWidgetState();
}

class _SearchDirectoryWidgetState extends State<SearchDirectoryWidget>
    with TickerProviderStateMixin {
  late SearchDirectoryModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => SearchDirectoryModel());

    // On page load action.
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      FFAppState().searchisactive = false;
      safeSetState(() {});
    });

    _model.tabBarController = TabController(
      vsync: this,
      length: 2,
      initialIndex: 0,
    )..addListener(() => safeSetState(() {}));

    _model.textController1 ??= TextEditingController();
    _model.textFieldFocusNode1 ??= FocusNode();

    _model.textController2 ??= TextEditingController();

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

    return StreamBuilder<List<UsersRecord>>(
      stream: queryUsersRecord(
        queryBuilder: (usersRecord) =>
            usersRecord.orderBy('username', descending: true),
      ),
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
        List<UsersRecord> searchDirectoryUsersRecordList = snapshot.data!;

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
                  context.pushNamed(FoodFeedWidget.routeName);
                },
              ),
              title: Text(
                'bite',
                style: FlutterFlowTheme.of(context).bodyMedium.override(
                      fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                      fontSize: 22.0,
                      letterSpacing: 0.0,
                      fontWeight: FontWeight.w600,
                      useGoogleFonts:
                          !FlutterFlowTheme.of(context).bodyMediumIsCustom,
                    ),
              ),
              actions: [],
              centerTitle: false,
              elevation: 2.0,
            ),
            body: SafeArea(
              top: true,
              child: Stack(
                children: [
                  InkWell(
                    splashColor: Colors.transparent,
                    focusColor: Colors.transparent,
                    hoverColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    onDoubleTap: () async {
                      FFAppState().searchisactive = false;
                      safeSetState(() {});
                    },
                    child: Column(
                      children: [
                        Align(
                          alignment: Alignment(0.0, 0),
                          child: TabBar(
                            labelColor: FlutterFlowTheme.of(context).accent3,
                            unselectedLabelColor:
                                FlutterFlowTheme.of(context).warning,
                            labelStyle: FlutterFlowTheme.of(context)
                                .titleMedium
                                .override(
                                  fontFamily: FlutterFlowTheme.of(context)
                                      .titleMediumFamily,
                                  letterSpacing: 0.0,
                                  useGoogleFonts: !FlutterFlowTheme.of(context)
                                      .titleMediumIsCustom,
                                ),
                            unselectedLabelStyle: TextStyle(),
                            indicatorColor:
                                FlutterFlowTheme.of(context).primary,
                            indicatorWeight: 3.0,
                            tabs: [
                              Tab(
                                text: 'recipes',
                              ),
                              Tab(
                                text: 'members',
                              ),
                            ],
                            controller: _model.tabBarController,
                            onTap: (i) async {
                              [() async {}, () async {}][i]();
                            },
                          ),
                        ),
                        Expanded(
                          child: TabBarView(
                            controller: _model.tabBarController,
                            children: [
                              Container(
                                width: 100.0,
                                height: 100.0,
                                decoration: BoxDecoration(
                                  color: FlutterFlowTheme.of(context)
                                      .primaryBackground,
                                ),
                                child: SingleChildScrollView(
                                  child: Column(
                                    mainAxisSize: MainAxisSize.max,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Align(
                                        alignment:
                                            AlignmentDirectional(0.0, 0.0),
                                        child: Padding(
                                          padding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                  0.0, 10.0, 0.0, 0.0),
                                          child: Stack(
                                            alignment:
                                                AlignmentDirectional(0.0, 0.0),
                                            children: [
                                              Align(
                                                alignment: AlignmentDirectional(
                                                    0.0, 0.0),
                                                child: Padding(
                                                  padding: EdgeInsetsDirectional
                                                      .fromSTEB(
                                                          12.0, 5.0, 12.0, 0.0),
                                                  child: Container(
                                                    width: double.infinity,
                                                    child: TextFormField(
                                                      controller: _model
                                                          .textController1,
                                                      focusNode: _model
                                                          .textFieldFocusNode1,
                                                      onChanged: (_) =>
                                                          EasyDebounce.debounce(
                                                        '_model.textController1',
                                                        Duration(
                                                            milliseconds: 2000),
                                                        () async {
                                                          _model.searchKeyword =
                                                              _model
                                                                  .textController1
                                                                  .text;
                                                          safeSetState(() {});
                                                          _model.recipeoutput =
                                                              await RecipeCall
                                                                  .call(
                                                            q: '${_model.searchKeyword} recipe',
                                                          );

                                                          _model.searchResults =
                                                              (getJsonField(
                                                            (_model.recipeoutput
                                                                    ?.jsonBody ??
                                                                ''),
                                                            r'''$.items''',
                                                            true,
                                                          ) as List? ?? [])
                                                                  .where((item) {
                                                                    final image = getJsonField(item, r'''$.pagemap.cse_image[0].src''');
                                                                    return image != null && image.toString().isNotEmpty;
                                                                  })
                                                                  .toList()
                                                                  .cast<
                                                                      dynamic>();
                                                          safeSetState(() {});

                                                          safeSetState(() {});
                                                        },
                                                      ),
                                                      obscureText: false,
                                                      decoration:
                                                          InputDecoration(
                                                        isDense: false,
                                                        labelText:
                                                            'search recipes...',
                                                        labelStyle:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .bodyLarge
                                                                .override(
                                                                  fontFamily: FlutterFlowTheme.of(
                                                                          context)
                                                                      .bodyLargeFamily,
                                                                  letterSpacing:
                                                                      0.0,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  useGoogleFonts:
                                                                      !FlutterFlowTheme.of(
                                                                              context)
                                                                          .bodyLargeIsCustom,
                                                                ),
                                                        enabledBorder:
                                                            OutlineInputBorder(
                                                          borderSide:
                                                              BorderSide(
                                                            color: FlutterFlowTheme
                                                                    .of(context)
                                                                .tertiary,
                                                            width: 2.0,
                                                          ),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      12.0),
                                                        ),
                                                        focusedBorder:
                                                            OutlineInputBorder(
                                                          borderSide:
                                                              BorderSide(
                                                            color: FlutterFlowTheme
                                                                    .of(context)
                                                                .primary,
                                                            width: 2.0,
                                                          ),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      12.0),
                                                        ),
                                                        errorBorder:
                                                            OutlineInputBorder(
                                                          borderSide:
                                                              BorderSide(
                                                            color: FlutterFlowTheme
                                                                    .of(context)
                                                                .error,
                                                            width: 2.0,
                                                          ),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      12.0),
                                                        ),
                                                        focusedErrorBorder:
                                                            OutlineInputBorder(
                                                          borderSide:
                                                              BorderSide(
                                                            color: FlutterFlowTheme
                                                                    .of(context)
                                                                .error,
                                                            width: 2.0,
                                                          ),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      12.0),
                                                        ),
                                                        filled: true,
                                                        fillColor:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .primaryBackground,
                                                        prefixIcon: Icon(
                                                          Icons.search_outlined,
                                                          color: FlutterFlowTheme
                                                                  .of(context)
                                                              .secondaryText,
                                                        ),
                                                      ),
                                                      style: FlutterFlowTheme
                                                              .of(context)
                                                          .bodyLarge
                                                          .override(
                                                            fontFamily:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodyLargeFamily,
                                                            letterSpacing: 0.0,
                                                            fontWeight:
                                                                FontWeight
                                                                    .normal,
                                                            useGoogleFonts:
                                                                !FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodyLargeIsCustom,
                                                          ),
                                                      validator: _model
                                                          .textController1Validator
                                                          .asValidator(context),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Align(
                                                alignment: AlignmentDirectional(
                                                    1.0, 0.0),
                                                child: Padding(
                                                  padding: EdgeInsetsDirectional
                                                      .fromSTEB(
                                                          0.0, 5.0, 18.0, 0.0),
                                                  child: FlutterFlowIconButton(
                                                    borderRadius: 8.0,
                                                    buttonSize: 40.0,
                                                    fillColor:
                                                        FlutterFlowTheme.of(
                                                                context)
                                                            .primaryBackground,
                                                    icon: Icon(
                                                      Icons.close,
                                                      color:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .primary,
                                                      size: 24.0,
                                                    ),
                                                    onPressed: () async {
                                                      safeSetState(() {
                                                        _model.textController2
                                                            ?.clear();
                                                        _model.textController1
                                                            ?.clear();
                                                      });
                                                      FFAppState()
                                                              .searchisactive =
                                                          false;
                                                      safeSetState(() {});
                                                    },
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      Row(
                                        mainAxisSize: MainAxisSize.max,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Column(
                                            mainAxisSize: MainAxisSize.max,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              if ((_model.searchResults
                                                      .isNotEmpty) ==
                                                  true)
                                                Padding(
                                                  padding: EdgeInsetsDirectional
                                                      .fromSTEB(
                                                          16.0, 12.0, 0.0, 0.0),
                                                  child: Text(
                                                    'recipes matching search',
                                                    style: FlutterFlowTheme.of(
                                                            context)
                                                        .labelLarge
                                                        .override(
                                                          fontFamily:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .labelLargeFamily,
                                                          letterSpacing: 0.0,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          useGoogleFonts:
                                                              !FlutterFlowTheme
                                                                      .of(context)
                                                                  .labelLargeIsCustom,
                                                        ),
                                                  ),
                                                ),
                                              if ((_model.searchResults
                                                      .isNotEmpty) ==
                                                  false)
                                                Align(
                                                  alignment:
                                                      AlignmentDirectional(
                                                          -1.0, -1.0),
                                                  child: Padding(
                                                    padding:
                                                        EdgeInsetsDirectional
                                                            .fromSTEB(16.0,
                                                                12.0, 0.0, 0.0),
                                                    child: Text(
                                                      'trending right now',
                                                      style: FlutterFlowTheme
                                                              .of(context)
                                                          .labelLarge
                                                          .override(
                                                            fontFamily:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .labelLargeFamily,
                                                            letterSpacing: 0.0,
                                                            fontWeight:
                                                                FontWeight.bold,
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
                                        ],
                                      ),
                                      Stack(
                                        alignment:
                                            AlignmentDirectional(-1.0, -1.0),
                                        children: [
                                          if ((_model
                                                  .searchResults.isNotEmpty) ==
                                              true)
                                            Padding(
                                              padding: EdgeInsetsDirectional
                                                  .fromSTEB(
                                                      0.0, 0.0, 0.0, 20.0),
                                              child: Builder(
                                                builder: (context) {
                                                  final filteredRecipes = _model
                                                      .searchResults
                                                      .toList()
                                                      .take(25)
                                                      .toList();

                                                  return ListView.builder(
                                                    padding: EdgeInsets.zero,
                                                    primary: false,
                                                    itemCount:
                                                        filteredRecipes.length,
                                                    itemBuilder: (context,
                                                        filteredRecipesIndex) {
                                                      final filteredRecipesItem =
                                                          filteredRecipes[
                                                              filteredRecipesIndex];
                                                      return Container(
                                                        decoration:
                                                            BoxDecoration(
                                                          color: FlutterFlowTheme
                                                                  .of(context)
                                                              .primaryBackground,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      0.0),
                                                        ),
                                                        alignment:
                                                            AlignmentDirectional(
                                                                -1.0, -1.0),
                                                        child: Align(
                                                          alignment:
                                                              AlignmentDirectional(
                                                                  -1.0, -1.0),
                                                          child: Padding(
                                                            padding:
                                                                EdgeInsetsDirectional
                                                                    .fromSTEB(
                                                                        12.0,
                                                                        12.0,
                                                                        12.0,
                                                                        0.0),
                                                            child: Row(
                                                              mainAxisSize:
                                                                  MainAxisSize
                                                                      .max,
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                Align(
                                                                  alignment:
                                                                      AlignmentDirectional(
                                                                          -1.0,
                                                                          -1.0),
                                                                  child:
                                                                      InkWell(
                                                                    splashColor:
                                                                        Colors
                                                                            .transparent,
                                                                    focusColor:
                                                                        Colors
                                                                            .transparent,
                                                                    hoverColor:
                                                                        Colors
                                                                            .transparent,
                                                                    highlightColor:
                                                                        Colors
                                                                            .transparent,
                                                                    onTap:
                                                                        () async {
                                                                      await launchURL(
                                                                          getJsonField(
                                                                        filteredRecipesItem,
                                                                        r'''$.link''',
                                                                      ).toString());
                                                                    },
                                                                    child:
                                                                        ClipRRect(
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              0.0),
                                                                      child: Image
                                                                          .network(
                                                                        'https://recipe-image-proxy.lena-m-wu.workers.dev/?url=${getJsonField(
                                                                          filteredRecipesItem,
                                                                          r'''$.pagemap.cse_image[0].src ''',
                                                                        ).toString()}',
                                                                        width:
                                                                            220.0,
                                                                        height:
                                                                            220.0,
                                                                        fit: BoxFit
                                                                            .cover,
                                                                        errorBuilder: (context,
                                                                                error,
                                                                                stackTrace) =>
                                                                            Image.asset(
                                                                          'assets/images/error_image.png',
                                                                          width:
                                                                              220.0,
                                                                          height:
                                                                              220.0,
                                                                          fit: BoxFit
                                                                              .cover,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                                Expanded(
                                                                  child:
                                                                      Container(
                                                                    height:
                                                                        220.0,
                                                                    child:
                                                                        Stack(
                                                                      children: [
                                                                        Align(
                                                                          alignment: AlignmentDirectional(
                                                                              -1.0,
                                                                              -1.0),
                                                                          child:
                                                                              Column(
                                                                            mainAxisSize:
                                                                                MainAxisSize.min,
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.start,
                                                                            crossAxisAlignment:
                                                                                CrossAxisAlignment.start,
                                                                            children: [
                                                                              Padding(
                                                                                padding: EdgeInsetsDirectional.fromSTEB(0.0, 5.0, 0.0, 0.0),
                                                                                child: SelectionArea(
                                                                                    child: Text(
                                                                                  getJsonField(
                                                                                    filteredRecipesItem,
                                                                                    r'''$.title''',
                                                                                  ).toString().maybeHandleOverflow(
                                                                                        maxChars: 40,
                                                                                        replacement: '…',
                                                                                      ),
                                                                                  maxLines: 7,
                                                                                  style: FlutterFlowTheme.of(context).headlineSmall.override(
                                                                                        fontFamily: FlutterFlowTheme.of(context).headlineSmallFamily,
                                                                                        color: FlutterFlowTheme.of(context).accent3,
                                                                                        fontSize: 18.0,
                                                                                        letterSpacing: 0.0,
                                                                                        useGoogleFonts: !FlutterFlowTheme.of(context).headlineSmallIsCustom,
                                                                                      ),
                                                                                )),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        ),
                                                                        Align(
                                                                          alignment: AlignmentDirectional(
                                                                              -1.0,
                                                                              1.0),
                                                                          child:
                                                                              FFButtonWidget(
                                                                            onPressed:
                                                                                () async {
                                                                              _model.actionoutput = await TestCall.call(
                                                                                url: getJsonField(
                                                                                  filteredRecipesItem,
                                                                                  r'''$.link''',
                                                                                ).toString(),
                                                                              );

                                                                              // If scrape failed, open URL in browser
                                                                              final status1 = getJsonField(
                                                                                (_model.actionoutput?.jsonBody ?? ''),
                                                                                r'''$.status''',
                                                                              )?.toString();
                                                                              if (status1 == 'failed') {
                                                                                final recipeUrl = getJsonField(
                                                                                  filteredRecipesItem,
                                                                                  r'''$.link''',
                                                                                ).toString();
                                                                                await launchUrl(Uri.parse(recipeUrl), mode: LaunchMode.externalApplication);
                                                                                return;
                                                                              }

                                                                              _model.alrsavedrecipe = await queryRecipesRecordOnce(
                                                                                queryBuilder: (recipesRecord) => recipesRecord.where(
                                                                                  'url',
                                                                                  isEqualTo: getJsonField(
                                                                                    filteredRecipesItem,
                                                                                    r'''$.link''',
                                                                                  ).toString(),
                                                                                ),
                                                                                singleRecord: true,
                                                                              ).then((s) => s.firstOrNull);
                                                                              if (_model.alrsavedrecipe?.reference != null) {
                                                                                context.pushNamed(
                                                                                  PublicRecipeWidget.routeName,
                                                                                  queryParameters: {
                                                                                    'userparam': serializeParam(
                                                                                      currentUserReference,
                                                                                      ParamType.DocumentReference,
                                                                                    ),
                                                                                    'recipeParam': serializeParam(
                                                                                      _model.alrsavedrecipe?.reference,
                                                                                      ParamType.DocumentReference,
                                                                                    ),
                                                                                  }.withoutNulls,
                                                                                );
                                                                              } else {
                                                                                var recipesRecordReference = RecipesRecord.collection.doc();
                                                                                await recipesRecordReference.set({
                                                                                  ...createRecipesRecordData(
                                                                                    title: getJsonField(
                                                                                      (_model.actionoutput?.jsonBody ?? ''),
                                                                                      r'''$.title''',
                                                                                    ).toString(),
                                                                                    notes: getJsonField(
                                                                                      (_model.actionoutput?.jsonBody ?? ''),
                                                                                      r'''$.notes''',
                                                                                    ).toString(),
                                                                                    url: getJsonField(
                                                                                      filteredRecipesItem,
                                                                                      r'''$.link''',
                                                                                    ).toString(),
                                                                                    cookingtime: getJsonField(
                                                                                      (_model.actionoutput?.jsonBody ?? ''),
                                                                                      r'''$.cooking_time''',
                                                                                    ).toString(),
                                                                                    servings: getJsonField(
                                                                                      (_model.actionoutput?.jsonBody ?? ''),
                                                                                      r'''$.servings''',
                                                                                    ).toString(),
                                                                                    publicrecipeimage: 'https://images.weserv.nl/?url=${getJsonField(
                                                                                      (_model.actionoutput?.jsonBody ?? ''),
                                                                                      r'''$.image_url''',
                                                                                    ).toString()}',
                                                                                    usercreated: false,
                                                                                    rating: castToType<double>(getJsonField((_model.actionoutput?.jsonBody ?? ''), r'''$.rating''')),
                                                                                  ),
                                                                                  ...mapToFirestore(
                                                                                    {
                                                                                      'ingredients': (getJsonField(
                                                                                        (_model.actionoutput?.jsonBody ?? ''),
                                                                                        r'''$.ingredients''',
                                                                                        true,
                                                                                      ) as List?)
                                                                                          ?.map<String>((e) => e.toString())
                                                                                          .toList()
                                                                                          .cast<String>(),
                                                                                      'preparation': (getJsonField(
                                                                                        (_model.actionoutput?.jsonBody ?? ''),
                                                                                        r'''$.instructions''',
                                                                                        true,
                                                                                      ) as List?)
                                                                                          ?.map<String>((e) => e.toString())
                                                                                          .toList()
                                                                                          .cast<String>(),
                                                                                      'time_generated': FieldValue.serverTimestamp(),
                                                                                    },
                                                                                  ),
                                                                                });
                                                                                _model.newRecipe = RecipesRecord.getDocumentFromData({
                                                                                  ...createRecipesRecordData(
                                                                                    title: getJsonField(
                                                                                      (_model.actionoutput?.jsonBody ?? ''),
                                                                                      r'''$.title''',
                                                                                    ).toString(),
                                                                                    notes: getJsonField(
                                                                                      (_model.actionoutput?.jsonBody ?? ''),
                                                                                      r'''$.notes''',
                                                                                    ).toString(),
                                                                                    url: getJsonField(
                                                                                      filteredRecipesItem,
                                                                                      r'''$.link''',
                                                                                    ).toString(),
                                                                                    cookingtime: getJsonField(
                                                                                      (_model.actionoutput?.jsonBody ?? ''),
                                                                                      r'''$.cooking_time''',
                                                                                    ).toString(),
                                                                                    servings: getJsonField(
                                                                                      (_model.actionoutput?.jsonBody ?? ''),
                                                                                      r'''$.servings''',
                                                                                    ).toString(),
                                                                                    publicrecipeimage: 'https://images.weserv.nl/?url=${getJsonField(
                                                                                      (_model.actionoutput?.jsonBody ?? ''),
                                                                                      r'''$.image_url''',
                                                                                    ).toString()}',
                                                                                    usercreated: false,
                                                                                    rating: castToType<double>(getJsonField((_model.actionoutput?.jsonBody ?? ''), r'''$.rating''')),
                                                                                  ),
                                                                                  ...mapToFirestore(
                                                                                    {
                                                                                      'ingredients': (getJsonField(
                                                                                        (_model.actionoutput?.jsonBody ?? ''),
                                                                                        r'''$.ingredients''',
                                                                                        true,
                                                                                      ) as List?)
                                                                                          ?.map<String>((e) => e.toString())
                                                                                          .toList()
                                                                                          .cast<String>(),
                                                                                      'preparation': (getJsonField(
                                                                                        (_model.actionoutput?.jsonBody ?? ''),
                                                                                        r'''$.instructions''',
                                                                                        true,
                                                                                      ) as List?)
                                                                                          ?.map<String>((e) => e.toString())
                                                                                          .toList()
                                                                                          .cast<String>(),
                                                                                      'time_generated': DateTime.now(),
                                                                                    },
                                                                                  ),
                                                                                }, recipesRecordReference);

                                                                                context.pushNamed(
                                                                                  PublicRecipeWidget.routeName,
                                                                                  queryParameters: {
                                                                                    'userparam': serializeParam(
                                                                                      currentUserReference,
                                                                                      ParamType.DocumentReference,
                                                                                    ),
                                                                                    'recipeParam': serializeParam(
                                                                                      _model.newRecipe?.reference,
                                                                                      ParamType.DocumentReference,
                                                                                    ),
                                                                                  }.withoutNulls,
                                                                                );
                                                                              }

                                                                              safeSetState(() {});
                                                                            },
                                                                            text:
                                                                                'save recipe',
                                                                            options:
                                                                                FFButtonOptions(
                                                                              height: 40.0,
                                                                              padding: EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 16.0, 0.0),
                                                                              iconPadding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                                                                              color: FlutterFlowTheme.of(context).primaryBackground,
                                                                              textStyle: FlutterFlowTheme.of(context).titleSmall.override(
                                                                                    fontFamily: FlutterFlowTheme.of(context).titleSmallFamily,
                                                                                    color: FlutterFlowTheme.of(context).primary,
                                                                                    letterSpacing: 0.0,
                                                                                    useGoogleFonts: !FlutterFlowTheme.of(context).titleSmallIsCustom,
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
                                                              ].divide(SizedBox(
                                                                  width: 12.0)),
                                                            ),
                                                          ),
                                                        ),
                                                      );
                                                    },
                                                  );
                                                },
                                              ),
                                            ),
                                          if ((_model
                                                  .searchResults.isNotEmpty) ==
                                              false)
                                            Padding(
                                              padding: EdgeInsetsDirectional
                                                  .fromSTEB(
                                                      0.0, 0.0, 0.0, 20.0),
                                              child: StreamBuilder<
                                                  List<RecommendationsRecord>>(
                                                stream:
                                                    queryRecommendationsRecord(),
                                                builder: (context, snapshot) {
                                                  // Customize what your widget looks like when it's loading.
                                                  if (!snapshot.hasData) {
                                                    return Center(
                                                      child: SizedBox(
                                                        width: 30.0,
                                                        height: 30.0,
                                                        child:
                                                            SpinKitFadingGrid(
                                                          color: FlutterFlowTheme
                                                                  .of(context)
                                                              .tertiary,
                                                          size: 30.0,
                                                        ),
                                                      ),
                                                    );
                                                  }
                                                  List<RecommendationsRecord>
                                                      listViewRecommendationsRecordList =
                                                      snapshot.data!;

                                                  return ListView.builder(
                                                    padding: EdgeInsets.zero,
                                                    primary: false,
                                                    shrinkWrap: true,
                                                    scrollDirection:
                                                        Axis.vertical,
                                                    itemCount:
                                                        listViewRecommendationsRecordList
                                                            .length,
                                                    itemBuilder: (context,
                                                        listViewIndex) {
                                                      final listViewRecommendationsRecord =
                                                          listViewRecommendationsRecordList[
                                                              listViewIndex];
                                                      return Container(
                                                        decoration:
                                                            BoxDecoration(
                                                          color: FlutterFlowTheme
                                                                  .of(context)
                                                              .primaryBackground,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      0.0),
                                                        ),
                                                        child: Padding(
                                                          padding:
                                                              EdgeInsetsDirectional
                                                                  .fromSTEB(
                                                                      12.0,
                                                                      12.0,
                                                                      12.0,
                                                                      0.0),
                                                          child: Row(
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .max,
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Align(
                                                                alignment:
                                                                    AlignmentDirectional(
                                                                        -1.0,
                                                                        -1.0),
                                                                child: InkWell(
                                                                  splashColor:
                                                                      Colors
                                                                          .transparent,
                                                                  focusColor: Colors
                                                                      .transparent,
                                                                  hoverColor: Colors
                                                                      .transparent,
                                                                  highlightColor:
                                                                      Colors
                                                                          .transparent,
                                                                  onTap:
                                                                      () async {
                                                                    if (loggedIn ==
                                                                        false) {
                                                                      context.pushNamed(
                                                                          OnboardingWidget
                                                                              .routeName);
                                                                    } else {
                                                                      await launchURL(
                                                                          listViewRecommendationsRecord
                                                                              .url);
                                                                    }
                                                                  },
                                                                  child:
                                                                      ClipRRect(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            0.0),
                                                                    child: Image
                                                                        .network(
                                                                      'https://recipe-image-proxy.lena-m-wu.workers.dev/?url=${listViewRecommendationsRecord.image}',
                                                                      width:
                                                                          220.0,
                                                                      height:
                                                                          220.0,
                                                                      fit: BoxFit
                                                                          .cover,
                                                                      errorBuilder: (context,
                                                                              error,
                                                                              stackTrace) =>
                                                                          Image
                                                                              .asset(
                                                                        'assets/images/error_image.png',
                                                                        width:
                                                                            220.0,
                                                                        height:
                                                                            220.0,
                                                                        fit: BoxFit
                                                                            .cover,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                              Expanded(
                                                                child:
                                                                    Container(
                                                                  height: 220.0,
                                                                  child: Stack(
                                                                    children: [
                                                                      Align(
                                                                        alignment: AlignmentDirectional(
                                                                            -1.0,
                                                                            1.0),
                                                                        child:
                                                                            FFButtonWidget(
                                                                          onPressed:
                                                                              () async {
                                                                            _model.actionoutputcustom2 =
                                                                                await TestCall.call(
                                                                              url: listViewRecommendationsRecord.url,
                                                                            );

                                                                            // If scrape failed, open URL in browser
                                                                            final status2 = getJsonField(
                                                                              (_model.actionoutputcustom2?.jsonBody ?? ''),
                                                                              r'''$.status''',
                                                                            )?.toString();
                                                                            if (status2 == 'failed') {
                                                                              await launchUrl(Uri.parse(listViewRecommendationsRecord.url), mode: LaunchMode.externalApplication);
                                                                              return;
                                                                            }

                                                                            _model.alrsavedrecipe2 =
                                                                                await queryRecipesRecordOnce(
                                                                              queryBuilder: (recipesRecord) => recipesRecord.where(
                                                                                'url',
                                                                                isEqualTo: listViewRecommendationsRecord.url,
                                                                              ),
                                                                              singleRecord: true,
                                                                            ).then((s) => s.firstOrNull);
                                                                            if (_model.alrsavedrecipe2?.reference !=
                                                                                null) {
                                                                              context.pushNamed(
                                                                                PublicRecipeWidget.routeName,
                                                                                queryParameters: {
                                                                                  'userparam': serializeParam(
                                                                                    currentUserReference,
                                                                                    ParamType.DocumentReference,
                                                                                  ),
                                                                                  'recipeParam': serializeParam(
                                                                                    _model.alrsavedrecipe2?.reference,
                                                                                    ParamType.DocumentReference,
                                                                                  ),
                                                                                }.withoutNulls,
                                                                              );
                                                                            } else {
                                                                              var recipesRecordReference = RecipesRecord.collection.doc();
                                                                              await recipesRecordReference.set({
                                                                                ...createRecipesRecordData(
                                                                                  title: getJsonField(
                                                                                    (_model.actionoutputcustom2?.jsonBody ?? ''),
                                                                                    r'''$.title''',
                                                                                  ).toString(),
                                                                                  notes: getJsonField(
                                                                                    (_model.actionoutputcustom2?.jsonBody ?? ''),
                                                                                    r'''$.notes''',
                                                                                  ).toString(),
                                                                                  url: listViewRecommendationsRecord.url,
                                                                                  cookingtime: getJsonField(
                                                                                    (_model.actionoutputcustom2?.jsonBody ?? ''),
                                                                                    r'''$.cooking_time''',
                                                                                  ).toString(),
                                                                                  servings: getJsonField(
                                                                                    (_model.actionoutputcustom2?.jsonBody ?? ''),
                                                                                    r'''$.servings''',
                                                                                  ).toString(),
                                                                                  publicrecipeimage: 'https://images.weserv.nl/?url=${listViewRecommendationsRecord.image}',
                                                                                  usercreated: false,
                                                                                  rating: castToType<double>(getJsonField((_model.actionoutputcustom2?.jsonBody ?? ''), r'''$.rating''')),
                                                                                ),
                                                                                ...mapToFirestore(
                                                                                  {
                                                                                    'ingredients': (getJsonField(
                                                                                      (_model.actionoutputcustom2?.jsonBody ?? ''),
                                                                                      r'''$.ingredients''',
                                                                                      true,
                                                                                    ) as List?)
                                                                                        ?.map<String>((e) => e.toString())
                                                                                        .toList()
                                                                                        .cast<String>(),
                                                                                    'preparation': (getJsonField(
                                                                                      (_model.actionoutputcustom2?.jsonBody ?? ''),
                                                                                      r'''$.instructions''',
                                                                                      true,
                                                                                    ) as List?)
                                                                                        ?.map<String>((e) => e.toString())
                                                                                        .toList()
                                                                                        .cast<String>(),
                                                                                    'time_generated': FieldValue.serverTimestamp(),
                                                                                  },
                                                                                ),
                                                                              });
                                                                              _model.newRecipe2 = RecipesRecord.getDocumentFromData({
                                                                                ...createRecipesRecordData(
                                                                                  title: getJsonField(
                                                                                    (_model.actionoutputcustom2?.jsonBody ?? ''),
                                                                                    r'''$.title''',
                                                                                  ).toString(),
                                                                                  notes: getJsonField(
                                                                                    (_model.actionoutputcustom2?.jsonBody ?? ''),
                                                                                    r'''$.notes''',
                                                                                  ).toString(),
                                                                                  url: listViewRecommendationsRecord.url,
                                                                                  cookingtime: getJsonField(
                                                                                    (_model.actionoutputcustom2?.jsonBody ?? ''),
                                                                                    r'''$.cooking_time''',
                                                                                  ).toString(),
                                                                                  servings: getJsonField(
                                                                                    (_model.actionoutputcustom2?.jsonBody ?? ''),
                                                                                    r'''$.servings''',
                                                                                  ).toString(),
                                                                                  publicrecipeimage: 'https://images.weserv.nl/?url=${listViewRecommendationsRecord.image}',
                                                                                  usercreated: false,
                                                                                  rating: castToType<double>(getJsonField((_model.actionoutputcustom2?.jsonBody ?? ''), r'''$.rating''')),
                                                                                ),
                                                                                ...mapToFirestore(
                                                                                  {
                                                                                    'ingredients': (getJsonField(
                                                                                      (_model.actionoutputcustom2?.jsonBody ?? ''),
                                                                                      r'''$.ingredients''',
                                                                                      true,
                                                                                    ) as List?)
                                                                                        ?.map<String>((e) => e.toString())
                                                                                        .toList()
                                                                                        .cast<String>(),
                                                                                    'preparation': (getJsonField(
                                                                                      (_model.actionoutputcustom2?.jsonBody ?? ''),
                                                                                      r'''$.instructions''',
                                                                                      true,
                                                                                    ) as List?)
                                                                                        ?.map<String>((e) => e.toString())
                                                                                        .toList()
                                                                                        .cast<String>(),
                                                                                    'time_generated': DateTime.now(),
                                                                                  },
                                                                                ),
                                                                              }, recipesRecordReference);

                                                                              context.pushNamed(
                                                                                PublicRecipeWidget.routeName,
                                                                                queryParameters: {
                                                                                  'userparam': serializeParam(
                                                                                    currentUserReference,
                                                                                    ParamType.DocumentReference,
                                                                                  ),
                                                                                  'recipeParam': serializeParam(
                                                                                    _model.newRecipe2?.reference,
                                                                                    ParamType.DocumentReference,
                                                                                  ),
                                                                                }.withoutNulls,
                                                                              );
                                                                            }

                                                                            safeSetState(() {});
                                                                          },
                                                                          text:
                                                                              'save recipe',
                                                                          options:
                                                                              FFButtonOptions(
                                                                            height:
                                                                                39.6,
                                                                            padding: EdgeInsetsDirectional.fromSTEB(
                                                                                16.0,
                                                                                0.0,
                                                                                16.0,
                                                                                0.0),
                                                                            iconPadding: EdgeInsetsDirectional.fromSTEB(
                                                                                0.0,
                                                                                0.0,
                                                                                0.0,
                                                                                0.0),
                                                                            color:
                                                                                FlutterFlowTheme.of(context).primaryBackground,
                                                                            textStyle: FlutterFlowTheme.of(context).titleSmall.override(
                                                                                  fontFamily: FlutterFlowTheme.of(context).titleSmallFamily,
                                                                                  color: FlutterFlowTheme.of(context).primary,
                                                                                  letterSpacing: 0.0,
                                                                                  useGoogleFonts: !FlutterFlowTheme.of(context).titleSmallIsCustom,
                                                                                ),
                                                                            elevation:
                                                                                0.0,
                                                                            borderSide:
                                                                                BorderSide(
                                                                              color: FlutterFlowTheme.of(context).primary,
                                                                              width: 2.0,
                                                                            ),
                                                                            borderRadius:
                                                                                BorderRadius.circular(8.0),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                      Column(
                                                                        mainAxisSize:
                                                                            MainAxisSize.min,
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.spaceBetween,
                                                                        crossAxisAlignment:
                                                                            CrossAxisAlignment.start,
                                                                        children: [
                                                                          Expanded(
                                                                            child:
                                                                                Align(
                                                                              alignment: AlignmentDirectional(-1.0, -1.0),
                                                                              child: Padding(
                                                                                padding: EdgeInsetsDirectional.fromSTEB(0.0, 5.0, 0.0, 0.0),
                                                                                child: SelectionArea(
                                                                                    child: Text(
                                                                                  listViewRecommendationsRecord.title.maybeHandleOverflow(
                                                                                    maxChars: 40,
                                                                                    replacement: '…',
                                                                                  ),
                                                                                  maxLines: 5,
                                                                                  style: FlutterFlowTheme.of(context).titleLarge.override(
                                                                                        fontFamily: FlutterFlowTheme.of(context).titleLargeFamily,
                                                                                        color: FlutterFlowTheme.of(context).accent3,
                                                                                        fontSize: 18.0,
                                                                                        letterSpacing: 0.0,
                                                                                        useGoogleFonts: !FlutterFlowTheme.of(context).titleLargeIsCustom,
                                                                                      ),
                                                                                )),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                              ),
                                                            ].divide(SizedBox(
                                                                width: 12.0)),
                                                          ),
                                                        ),
                                                      );
                                                    },
                                                  );
                                                },
                                              ),
                                            ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Container(
                                width: 100.0,
                                height: 100.0,
                                decoration: BoxDecoration(
                                  color: FlutterFlowTheme.of(context)
                                      .primaryBackground,
                                ),
                                child: Column(
                                  mainAxisSize: MainAxisSize.max,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Align(
                                      alignment: AlignmentDirectional(0.0, 0.0),
                                      child: Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                            0.0, 10.0, 0.0, 0.0),
                                        child: Stack(
                                          alignment:
                                              AlignmentDirectional(1.0, 0.0),
                                          children: [
                                            Align(
                                              alignment: AlignmentDirectional(
                                                  0.0, 0.0),
                                              child: Padding(
                                                padding: EdgeInsetsDirectional
                                                    .fromSTEB(
                                                        12.0, 5.0, 12.0, 0.0),
                                                child: Container(
                                                  width: double.infinity,
                                                  child: Autocomplete<String>(
                                                    initialValue:
                                                        TextEditingValue(),
                                                    optionsBuilder:
                                                        (textEditingValue) {
                                                      if (textEditingValue
                                                              .text ==
                                                          '') {
                                                        return const Iterable<
                                                            String>.empty();
                                                      }
                                                      return ['Option 1']
                                                          .where((option) {
                                                        final lowercaseOption =
                                                            option
                                                                .toLowerCase();
                                                        return lowercaseOption
                                                            .contains(
                                                                textEditingValue
                                                                    .text
                                                                    .toLowerCase());
                                                      });
                                                    },
                                                    optionsViewBuilder:
                                                        (context, onSelected,
                                                            options) {
                                                      return AutocompleteOptionsList(
                                                        textFieldKey: _model
                                                            .textFieldKey2,
                                                        textController: _model
                                                            .textController2!,
                                                        options:
                                                            options.toList(),
                                                        onSelected: onSelected,
                                                        textStyle:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .bodyMedium
                                                                .override(
                                                                  fontFamily: FlutterFlowTheme.of(
                                                                          context)
                                                                      .bodyMediumFamily,
                                                                  letterSpacing:
                                                                      0.0,
                                                                  useGoogleFonts:
                                                                      !FlutterFlowTheme.of(
                                                                              context)
                                                                          .bodyMediumIsCustom,
                                                                ),
                                                        textHighlightStyle:
                                                            TextStyle(),
                                                        elevation: 4.0,
                                                        optionBackgroundColor:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .primaryBackground,
                                                        optionHighlightColor:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .secondaryBackground,
                                                        maxHeight: 200.0,
                                                      );
                                                    },
                                                    onSelected:
                                                        (String selection) {
                                                      safeSetState(() => _model
                                                              .textFieldSelectedOption2 =
                                                          selection);
                                                      FocusScope.of(context)
                                                          .unfocus();
                                                    },
                                                    fieldViewBuilder: (
                                                      context,
                                                      textEditingController,
                                                      focusNode,
                                                      onEditingComplete,
                                                    ) {
                                                      _model.textFieldFocusNode2 =
                                                          focusNode;

                                                      _model.textController2 =
                                                          textEditingController;
                                                      return TextFormField(
                                                        key: _model
                                                            .textFieldKey2,
                                                        controller:
                                                            textEditingController,
                                                        focusNode: focusNode,
                                                        onEditingComplete:
                                                            onEditingComplete,
                                                        onChanged: (_) =>
                                                            EasyDebounce
                                                                .debounce(
                                                          '_model.textController2',
                                                          Duration(
                                                              milliseconds:
                                                                  2000),
                                                          () async {
                                                            FFAppState()
                                                                    .searchisactive =
                                                                true;
                                                            safeSetState(() {});
                                                            safeSetState(() {
                                                              _model.simpleSearchResults =
                                                                  TextSearch(
                                                                searchDirectoryUsersRecordList
                                                                    .map(
                                                                      (record) =>
                                                                          TextSearchItem.fromTerms(
                                                                              record,
                                                                              [
                                                                            record.username!
                                                                          ]),
                                                                    )
                                                                    .toList(),
                                                              )
                                                                      .search(_model
                                                                          .textController2
                                                                          .text)
                                                                      .map((r) =>
                                                                          r.object)
                                                                      .take(3)
                                                                      .toList();
                                                              ;
                                                            });
                                                          },
                                                        ),
                                                        obscureText: false,
                                                        decoration:
                                                            InputDecoration(
                                                          isDense: false,
                                                          labelText:
                                                              'search members...',
                                                          labelStyle:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .labelLarge
                                                                  .override(
                                                                    fontFamily:
                                                                        FlutterFlowTheme.of(context)
                                                                            .labelLargeFamily,
                                                                    color: FlutterFlowTheme.of(
                                                                            context)
                                                                        .primary,
                                                                    letterSpacing:
                                                                        0.0,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    useGoogleFonts:
                                                                        !FlutterFlowTheme.of(context)
                                                                            .labelLargeIsCustom,
                                                                  ),
                                                          enabledBorder:
                                                              OutlineInputBorder(
                                                            borderSide:
                                                                BorderSide(
                                                              color: FlutterFlowTheme
                                                                      .of(context)
                                                                  .tertiary,
                                                              width: 2.0,
                                                            ),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        12.0),
                                                          ),
                                                          focusedBorder:
                                                              OutlineInputBorder(
                                                            borderSide:
                                                                BorderSide(
                                                              color: FlutterFlowTheme
                                                                      .of(context)
                                                                  .primary,
                                                              width: 2.0,
                                                            ),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        12.0),
                                                          ),
                                                          errorBorder:
                                                              OutlineInputBorder(
                                                            borderSide:
                                                                BorderSide(
                                                              color: FlutterFlowTheme
                                                                      .of(context)
                                                                  .error,
                                                              width: 2.0,
                                                            ),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        12.0),
                                                          ),
                                                          focusedErrorBorder:
                                                              OutlineInputBorder(
                                                            borderSide:
                                                                BorderSide(
                                                              color: FlutterFlowTheme
                                                                      .of(context)
                                                                  .error,
                                                              width: 2.0,
                                                            ),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        12.0),
                                                          ),
                                                          filled: true,
                                                          fillColor: FlutterFlowTheme
                                                                  .of(context)
                                                              .primaryBackground,
                                                          prefixIcon: Icon(
                                                            Icons
                                                                .search_outlined,
                                                            color: FlutterFlowTheme
                                                                    .of(context)
                                                                .secondaryText,
                                                          ),
                                                        ),
                                                        style:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .bodyLarge
                                                                .override(
                                                                  fontFamily: FlutterFlowTheme.of(
                                                                          context)
                                                                      .bodyLargeFamily,
                                                                  letterSpacing:
                                                                      0.0,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  useGoogleFonts:
                                                                      !FlutterFlowTheme.of(
                                                                              context)
                                                                          .bodyLargeIsCustom,
                                                                ),
                                                        validator: _model
                                                            .textController2Validator
                                                            .asValidator(
                                                                context),
                                                      );
                                                    },
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Align(
                                              alignment: AlignmentDirectional(
                                                  1.0, 0.0),
                                              child: Padding(
                                                padding: EdgeInsetsDirectional
                                                    .fromSTEB(
                                                        0.0, 5.0, 18.0, 0.0),
                                                child: FlutterFlowIconButton(
                                                  borderRadius: 8.0,
                                                  buttonSize: 40.0,
                                                  fillColor:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .primaryBackground,
                                                  icon: Icon(
                                                    Icons.close,
                                                    color: FlutterFlowTheme.of(
                                                            context)
                                                        .primary,
                                                    size: 24.0,
                                                  ),
                                                  onPressed: () async {
                                                    safeSetState(() {
                                                      _model.textController2
                                                          ?.clear();
                                                      _model.textController1
                                                          ?.clear();
                                                    });
                                                    FFAppState()
                                                        .searchisactive = false;
                                                    safeSetState(() {});
                                                  },
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Row(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        if (_model.textController2.text ==
                                                null ||
                                            _model.textController2.text == '')
                                          Padding(
                                            padding:
                                                EdgeInsetsDirectional.fromSTEB(
                                                    16.0, 12.0, 0.0, 0.0),
                                            child: Text(
                                              'recently joined',
                                              style: FlutterFlowTheme.of(
                                                      context)
                                                  .labelMedium
                                                  .override(
                                                    fontFamily:
                                                        FlutterFlowTheme.of(
                                                                context)
                                                            .labelMediumFamily,
                                                    fontSize: 16.0,
                                                    letterSpacing: 0.0,
                                                    fontWeight: FontWeight.bold,
                                                    useGoogleFonts:
                                                        !FlutterFlowTheme.of(
                                                                context)
                                                            .labelMediumIsCustom,
                                                  ),
                                            ),
                                          ),
                                      ],
                                    ),
                                    if (!FFAppState().searchisactive)
                                      Expanded(
                                        child: Padding(
                                          padding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                  8.0, 8.0, 8.0, 0.0),
                                          child:
                                              StreamBuilder<List<UsersRecord>>(
                                            stream: queryUsersRecord(
                                              queryBuilder: (usersRecord) =>
                                                  usersRecord.orderBy(
                                                      'created_time',
                                                      descending: true),
                                              limit: 11,
                                            ),
                                            builder: (context, snapshot) {
                                              // Customize what your widget looks like when it's loading.
                                              if (!snapshot.hasData) {
                                                return Center(
                                                  child: SizedBox(
                                                    width: 30.0,
                                                    height: 30.0,
                                                    child: SpinKitFadingGrid(
                                                      color:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .tertiary,
                                                      size: 30.0,
                                                    ),
                                                  ),
                                                );
                                              }
                                              List<UsersRecord>
                                                  listViewUsersRecordList =
                                                  snapshot.data!
                                                      .where((u) =>
                                                          u.uid !=
                                                          currentUserUid)
                                                      .toList();

                                              return ListView.builder(
                                                padding: EdgeInsets.zero,
                                                scrollDirection: Axis.vertical,
                                                itemCount:
                                                    listViewUsersRecordList
                                                        .length,
                                                itemBuilder:
                                                    (context, listViewIndex) {
                                                  final listViewUsersRecord =
                                                      listViewUsersRecordList[
                                                          listViewIndex];
                                                  return Padding(
                                                    padding:
                                                        EdgeInsetsDirectional
                                                            .fromSTEB(0.0, 0.0,
                                                                0.0, 1.0),
                                                    child: Container(
                                                      width: 100.0,
                                                      decoration: BoxDecoration(
                                                        color: FlutterFlowTheme
                                                                .of(context)
                                                            .secondaryBackground,
                                                        boxShadow: [
                                                          BoxShadow(
                                                            blurRadius: 0.0,
                                                            color: FlutterFlowTheme
                                                                    .of(context)
                                                                .alternate,
                                                            offset: Offset(
                                                              0.0,
                                                              1.0,
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                      child: Padding(
                                                        padding:
                                                            EdgeInsets.all(8.0),
                                                        child: InkWell(
                                                          splashColor: Colors
                                                              .transparent,
                                                          focusColor: Colors
                                                              .transparent,
                                                          hoverColor: Colors
                                                              .transparent,
                                                          highlightColor: Colors
                                                              .transparent,
                                                          onTap: () async {
                                                            if (loggedIn ==
                                                                false) {
                                                              context.pushNamed(
                                                                  OnboardingWidget
                                                                      .routeName);
                                                            }
                                                            if (listViewUsersRecord
                                                                    .reference ==
                                                                currentUserReference) {
                                                              context.pushNamed(
                                                                  ProfilePage2Widget
                                                                      .routeName);
                                                            } else {
                                                              context.pushNamed(
                                                                SearchedProfilePageWidget
                                                                    .routeName,
                                                                queryParameters:
                                                                    {
                                                                  'profileparameters':
                                                                      serializeParam(
                                                                    listViewUsersRecord
                                                                        .reference,
                                                                    ParamType
                                                                        .DocumentReference,
                                                                  ),
                                                                }.withoutNulls,
                                                              );
                                                            }
                                                          },
                                                          child: Row(
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .max,
                                                            children: [
                                                              ClipRRect(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            40.0),
                                                                child: Image
                                                                    .network(
                                                                  listViewUsersRecord
                                                                      .photoUrl,
                                                                  width: 60.0,
                                                                  height: 60.0,
                                                                  fit: BoxFit
                                                                      .cover,
                                                                  errorBuilder: (context,
                                                                          error,
                                                                          stackTrace) =>
                                                                      Image
                                                                          .asset(
                                                                    'assets/images/error_image.png',
                                                                    width: 60.0,
                                                                    height:
                                                                        60.0,
                                                                    fit: BoxFit
                                                                        .cover,
                                                                  ),
                                                                ),
                                                              ),
                                                              Expanded(
                                                                child: Column(
                                                                  mainAxisSize:
                                                                      MainAxisSize
                                                                          .max,
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  children: [
                                                                    Padding(
                                                                      padding: EdgeInsetsDirectional.fromSTEB(
                                                                          12.0,
                                                                          0.0,
                                                                          0.0,
                                                                          0.0),
                                                                      child:
                                                                          Text(
                                                                        listViewUsersRecord
                                                                            .displayName,
                                                                        style: FlutterFlowTheme.of(context)
                                                                            .bodyLarge
                                                                            .override(
                                                                              fontFamily: FlutterFlowTheme.of(context).bodyLargeFamily,
                                                                              color: FlutterFlowTheme.of(context).accent3,
                                                                              letterSpacing: 0.0,
                                                                              fontWeight: FontWeight.bold,
                                                                              useGoogleFonts: !FlutterFlowTheme.of(context).bodyLargeIsCustom,
                                                                            ),
                                                                      ),
                                                                    ),
                                                                    Padding(
                                                                      padding: EdgeInsetsDirectional.fromSTEB(
                                                                          0.0,
                                                                          4.0,
                                                                          0.0,
                                                                          0.0),
                                                                      child:
                                                                          Row(
                                                                        mainAxisSize:
                                                                            MainAxisSize.max,
                                                                        children: [
                                                                          Padding(
                                                                            padding: EdgeInsetsDirectional.fromSTEB(
                                                                                12.0,
                                                                                0.0,
                                                                                0.0,
                                                                                0.0),
                                                                            child:
                                                                                Text(
                                                                              listViewUsersRecord.username,
                                                                              style: FlutterFlowTheme.of(context).labelMedium.override(
                                                                                    fontFamily: FlutterFlowTheme.of(context).labelMediumFamily,
                                                                                    color: FlutterFlowTheme.of(context).primary,
                                                                                    letterSpacing: 0.0,
                                                                                    useGoogleFonts: !FlutterFlowTheme.of(context).labelMediumIsCustom,
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
                                                      ),
                                                    ),
                                                  );
                                                },
                                              );
                                            },
                                          ),
                                        ),
                                      ),
                                    Row(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        if (_model.textController2.text !=
                                                null &&
                                            _model.textController2.text != '')
                                          Padding(
                                            padding:
                                                EdgeInsetsDirectional.fromSTEB(
                                                    16.0, 12.0, 0.0, 0.0),
                                            child: Text(
                                              'members matching search',
                                              style: FlutterFlowTheme.of(
                                                      context)
                                                  .labelMedium
                                                  .override(
                                                    fontFamily:
                                                        FlutterFlowTheme.of(
                                                                context)
                                                            .labelMediumFamily,
                                                    fontSize: 16.0,
                                                    letterSpacing: 0.0,
                                                    fontWeight: FontWeight.bold,
                                                    useGoogleFonts:
                                                        !FlutterFlowTheme.of(
                                                                context)
                                                            .labelMediumIsCustom,
                                                  ),
                                            ),
                                          ),
                                      ],
                                    ),
                                    if (FFAppState().searchisactive)
                                      Expanded(
                                        child: Padding(
                                          padding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                  8.0, 8.0, 8.0, 0.0),
                                          child: Builder(
                                            builder: (context) {
                                              final uservariables = _model
                                                  .simpleSearchResults
                                                  .toList()
                                                  .take(10)
                                                  .toList();

                                              return ListView.builder(
                                                padding: EdgeInsets.zero,
                                                shrinkWrap: true,
                                                scrollDirection: Axis.vertical,
                                                itemCount: uservariables.length,
                                                itemBuilder: (context,
                                                    uservariablesIndex) {
                                                  final uservariablesItem =
                                                      uservariables[
                                                          uservariablesIndex];
                                                  return Padding(
                                                    padding:
                                                        EdgeInsetsDirectional
                                                            .fromSTEB(0.0, 0.0,
                                                                0.0, 1.0),
                                                    child: Container(
                                                      width: 100.0,
                                                      decoration: BoxDecoration(
                                                        color: FlutterFlowTheme
                                                                .of(context)
                                                            .secondaryBackground,
                                                        boxShadow: [
                                                          BoxShadow(
                                                            blurRadius: 0.0,
                                                            color: FlutterFlowTheme
                                                                    .of(context)
                                                                .alternate,
                                                            offset: Offset(
                                                              0.0,
                                                              1.0,
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                      child: Padding(
                                                        padding:
                                                            EdgeInsets.all(8.0),
                                                        child: InkWell(
                                                          splashColor: Colors
                                                              .transparent,
                                                          focusColor: Colors
                                                              .transparent,
                                                          hoverColor: Colors
                                                              .transparent,
                                                          highlightColor: Colors
                                                              .transparent,
                                                          onTap: () async {
                                                            if (loggedIn ==
                                                                false) {
                                                              context.pushNamed(
                                                                  OnboardingWidget
                                                                      .routeName);
                                                            }

                                                            context.pushNamed(
                                                              SearchedProfilePageWidget
                                                                  .routeName,
                                                              queryParameters: {
                                                                'profileparameters':
                                                                    serializeParam(
                                                                  uservariablesItem
                                                                      .reference,
                                                                  ParamType
                                                                      .DocumentReference,
                                                                ),
                                                              }.withoutNulls,
                                                            );
                                                          },
                                                          child: Row(
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .max,
                                                            children: [
                                                              ClipRRect(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            40.0),
                                                                child: Image
                                                                    .network(
                                                                  uservariablesItem
                                                                      .photoUrl,
                                                                  width: 60.0,
                                                                  height: 60.0,
                                                                  fit: BoxFit
                                                                      .cover,
                                                                  errorBuilder: (context,
                                                                          error,
                                                                          stackTrace) =>
                                                                      Image
                                                                          .asset(
                                                                    'assets/images/error_image.png',
                                                                    width: 60.0,
                                                                    height:
                                                                        60.0,
                                                                    fit: BoxFit
                                                                        .cover,
                                                                  ),
                                                                ),
                                                              ),
                                                              Expanded(
                                                                child: Column(
                                                                  mainAxisSize:
                                                                      MainAxisSize
                                                                          .max,
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  children: [
                                                                    Padding(
                                                                      padding: EdgeInsetsDirectional.fromSTEB(
                                                                          12.0,
                                                                          0.0,
                                                                          0.0,
                                                                          0.0),
                                                                      child:
                                                                          Text(
                                                                        uservariablesItem
                                                                            .displayName,
                                                                        style: FlutterFlowTheme.of(context)
                                                                            .bodyLarge
                                                                            .override(
                                                                              fontFamily: FlutterFlowTheme.of(context).bodyLargeFamily,
                                                                              color: FlutterFlowTheme.of(context).accent3,
                                                                              letterSpacing: 0.0,
                                                                              fontWeight: FontWeight.bold,
                                                                              useGoogleFonts: !FlutterFlowTheme.of(context).bodyLargeIsCustom,
                                                                            ),
                                                                      ),
                                                                    ),
                                                                    Padding(
                                                                      padding: EdgeInsetsDirectional.fromSTEB(
                                                                          0.0,
                                                                          4.0,
                                                                          0.0,
                                                                          0.0),
                                                                      child:
                                                                          Row(
                                                                        mainAxisSize:
                                                                            MainAxisSize.max,
                                                                        children: [
                                                                          Padding(
                                                                            padding: EdgeInsetsDirectional.fromSTEB(
                                                                                12.0,
                                                                                0.0,
                                                                                0.0,
                                                                                0.0),
                                                                            child:
                                                                                Text(
                                                                              uservariablesItem.username,
                                                                              style: FlutterFlowTheme.of(context).labelMedium.override(
                                                                                    fontFamily: FlutterFlowTheme.of(context).labelMediumFamily,
                                                                                    color: FlutterFlowTheme.of(context).primary,
                                                                                    letterSpacing: 0.0,
                                                                                    useGoogleFonts: !FlutterFlowTheme.of(context).labelMediumIsCustom,
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
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
