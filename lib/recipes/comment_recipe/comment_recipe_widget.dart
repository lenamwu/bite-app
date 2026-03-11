import '/auth/firebase_auth/auth_util.dart';
import '/backend/backend.dart';
import '/components/addtocart_widget.dart';
import '/components/notificationcomp_widget.dart';
import '/flutter_flow/flutter_flow_animations.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_toggle_icon.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:math';
import 'dart:ui';
import '/index.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'comment_recipe_model.dart';
export 'comment_recipe_model.dart';

class CommentRecipeWidget extends StatefulWidget {
  const CommentRecipeWidget({
    super.key,
    required this.docref,
    this.reciperef,
    required this.userref,
  });

  final DocumentReference? docref;
  final DocumentReference? reciperef;
  final DocumentReference? userref;

  static String routeName = 'commentRecipe';
  static String routePath = '/commentRecipe';

  @override
  State<CommentRecipeWidget> createState() => _CommentRecipeWidgetState();
}

class _CommentRecipeWidgetState extends State<CommentRecipeWidget>
    with TickerProviderStateMixin {
  late CommentRecipeModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  final animationsMap = <String, AnimationInfo>{};

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => CommentRecipeModel());

    _model.tabBarController = TabController(
      vsync: this,
      length: 2,
      initialIndex: 0,
    )..addListener(() => safeSetState(() {}));

    _model.textController ??= TextEditingController();
    _model.textFieldFocusNode ??= FocusNode();

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
    return StreamBuilder<PostsRecord>(
      stream: PostsRecord.getDocument(widget!.docref!),
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

        final commentRecipePostsRecord = snapshot.data!;

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
              actions: [
                Visibility(
                  visible: (commentRecipePostsRecord.postUser !=
                          currentUserReference) &&
                      (widget!.reciperef != null),
                  child: Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 5.0, 0.0),
                    child: StreamBuilder<RecipesRecord>(
                      stream: RecipesRecord.getDocument(widget!.reciperef!),
                      builder: (context, snapshot) {
                        // Customize what your widget looks like when it's loading.
                        if (!snapshot.hasData) {
                          return Center(
                            child: SizedBox(
                              width: 30.0,
                              height: 30.0,
                              child: SpinKitFadingGrid(
                                color: FlutterFlowTheme.of(context).tertiary,
                                size: 30.0,
                              ),
                            ),
                          );
                        }

                        final toggleIconRecipesRecord = snapshot.data!;

                        return ToggleIcon(
                          onPressed: () async {
                            final recipeSavedByElement = currentUserReference;
                            final recipeSavedByUpdate = toggleIconRecipesRecord
                                    .recipeSavedBy
                                    .contains(recipeSavedByElement)
                                ? FieldValue.arrayRemove([recipeSavedByElement])
                                : FieldValue.arrayUnion([recipeSavedByElement]);
                            await toggleIconRecipesRecord.reference.update({
                              ...mapToFirestore(
                                {
                                  'recipe_saved_by': recipeSavedByUpdate,
                                },
                              ),
                            });
                            if (toggleIconRecipesRecord.recipeSavedBy
                                .contains(currentUserReference)) {
                              await toggleIconRecipesRecord.reference.update({
                                ...mapToFirestore(
                                  {
                                    'recipe_saved_by': FieldValue.arrayRemove(
                                        [currentUserReference]),
                                  },
                                ),
                              });
                            } else {
                              await toggleIconRecipesRecord.reference.update({
                                ...mapToFirestore(
                                  {
                                    'recipe_saved_by': FieldValue.arrayUnion(
                                        [currentUserReference]),
                                  },
                                ),
                              });
                            }
                          },
                          value: toggleIconRecipesRecord.recipeSavedBy
                              .contains(currentUserReference),
                          onIcon: Icon(
                            Icons.bookmark_sharp,
                            color: FlutterFlowTheme.of(context).primary,
                            size: 35.0,
                          ),
                          offIcon: Icon(
                            Icons.bookmark_border,
                            color: FlutterFlowTheme.of(context).secondaryText,
                            size: 35.0,
                          ),
                        );
                      },
                    ),
                  ),
                ),
                Visibility(
                  visible:
                      commentRecipePostsRecord.postUser == currentUserReference,
                  child: Padding(
                    padding:
                        EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 15.0, 0.0),
                    child: InkWell(
                      splashColor: Colors.transparent,
                      focusColor: Colors.transparent,
                      hoverColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      onTap: () async {
                        context.pushNamed(
                          EditPostWidget.routeName,
                          queryParameters: {
                            'postparameter': serializeParam(
                              widget!.docref,
                              ParamType.DocumentReference,
                            ),
                          }.withoutNulls,
                        );
                      },
                      child: Icon(
                        Icons.edit_outlined,
                        color: FlutterFlowTheme.of(context).primaryText,
                        size: 28.0,
                      ),
                    ),
                  ),
                ),
              ],
              centerTitle: false,
              elevation: 2.0,
            ),
            body: StreamBuilder<PostsRecord>(
              stream: PostsRecord.getDocument(widget!.docref!),
              builder: (context, snapshot) {
                // Customize what your widget looks like when it's loading.
                if (!snapshot.hasData) {
                  return Center(
                    child: SizedBox(
                      width: 30.0,
                      height: 30.0,
                      child: SpinKitFadingGrid(
                        color: FlutterFlowTheme.of(context).tertiary,
                        size: 30.0,
                      ),
                    ),
                  );
                }

                final scrollableContentPostsRecord = snapshot.data!;

                return SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      StreamBuilder<UsersRecord>(
                        stream: UsersRecord.getDocument(widget!.userref!),
                        builder: (context, snapshot) {
                          // Customize what your widget looks like when it's loading.
                          if (!snapshot.hasData) {
                            return Center(
                              child: SizedBox(
                                width: 30.0,
                                height: 30.0,
                                child: SpinKitFadingGrid(
                                  color: FlutterFlowTheme.of(context).tertiary,
                                  size: 30.0,
                                ),
                              ),
                            );
                          }

                          final columnUsersRecord = snapshot.data!;

                          return Column(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              StreamBuilder<RecipesRecord>(
                                stream: RecipesRecord.getDocument(
                                    widget!.reciperef!),
                                builder: (context, snapshot) {
                                  // Customize what your widget looks like when it's loading.
                                  if (!snapshot.hasData) {
                                    return Center(
                                      child: SizedBox(
                                        width: 30.0,
                                        height: 30.0,
                                        child: SpinKitFadingGrid(
                                          color: FlutterFlowTheme.of(context)
                                              .tertiary,
                                          size: 30.0,
                                        ),
                                      ),
                                    );
                                  }

                                  final rowRecipesRecord = snapshot.data!;

                                  return Row(
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      Flexible(
                                        child: Flex(
                                          direction: Axis.vertical,
                                          mainAxisSize: MainAxisSize.max,
                                          children: [
                                            Padding(
                                              padding: EdgeInsetsDirectional
                                                  .fromSTEB(
                                                      10.0, 10.0, 0.0, 0.0),
                                              child: Text(
                                                rowRecipesRecord.title,
                                                maxLines: 3,
                                                style:
                                                    FlutterFlowTheme.of(context)
                                                        .headlineSmall
                                                        .override(
                                                          fontFamily:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .headlineSmallFamily,
                                                          letterSpacing: 0.0,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          useGoogleFonts:
                                                              !FlutterFlowTheme
                                                                      .of(context)
                                                                  .headlineSmallIsCustom,
                                                        ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  );
                                },
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
                                        Row(
                                          mainAxisSize: MainAxisSize.max,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Expanded(
                                              child: Column(
                                                mainAxisSize: MainAxisSize.max,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Row(
                                                    mainAxisSize:
                                                        MainAxisSize.max,
                                                    children: [
                                                      InkWell(
                                                        splashColor:
                                                            Colors.transparent,
                                                        focusColor:
                                                            Colors.transparent,
                                                        hoverColor:
                                                            Colors.transparent,
                                                        highlightColor:
                                                            Colors.transparent,
                                                        onTap: () async {
                                                          if (columnUsersRecord
                                                                  .reference ==
                                                              currentUserReference) {
                                                            context.goNamed(
                                                                ProfilePage2Widget
                                                                    .routeName);
                                                          } else {
                                                            context.pushNamed(
                                                              SearchedProfilePageWidget
                                                                  .routeName,
                                                              queryParameters: {
                                                                'profileparameters':
                                                                    serializeParam(
                                                                  columnUsersRecord
                                                                      .reference,
                                                                  ParamType
                                                                      .DocumentReference,
                                                                ),
                                                              }.withoutNulls,
                                                            );
                                                          }
                                                        },
                                                        child: ClipRRect(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      40.0),
                                                          child: Image.network(
                                                            columnUsersRecord
                                                                .photoUrl,
                                                            width: 40.0,
                                                            height: 40.0,
                                                            fit: BoxFit.cover,
                                                            errorBuilder: (context,
                                                                    error,
                                                                    stackTrace) =>
                                                                Image.asset(
                                                              'assets/images/error_image.png',
                                                              width: 40.0,
                                                              height: 40.0,
                                                              fit: BoxFit.cover,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      Column(
                                                        mainAxisSize:
                                                            MainAxisSize.max,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Padding(
                                                            padding:
                                                                EdgeInsetsDirectional
                                                                    .fromSTEB(
                                                                        10.0,
                                                                        0.0,
                                                                        0.0,
                                                                        0.0),
                                                            child: InkWell(
                                                              splashColor: Colors
                                                                  .transparent,
                                                              focusColor: Colors
                                                                  .transparent,
                                                              hoverColor: Colors
                                                                  .transparent,
                                                              highlightColor:
                                                                  Colors
                                                                      .transparent,
                                                              onTap: () async {
                                                                if (columnUsersRecord
                                                                        .reference ==
                                                                    currentUserReference) {
                                                                  context.goNamed(
                                                                      ProfilePage2Widget
                                                                          .routeName);
                                                                } else {
                                                                  context
                                                                      .pushNamed(
                                                                    SearchedProfilePageWidget
                                                                        .routeName,
                                                                    queryParameters:
                                                                        {
                                                                      'profileparameters':
                                                                          serializeParam(
                                                                        columnUsersRecord
                                                                            .reference,
                                                                        ParamType
                                                                            .DocumentReference,
                                                                      ),
                                                                    }.withoutNulls,
                                                                  );
                                                                }
                                                              },
                                                              child: Text(
                                                                columnUsersRecord
                                                                    .displayName,
                                                                style: FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodyLarge
                                                                    .override(
                                                                      fontFamily:
                                                                          FlutterFlowTheme.of(context)
                                                                              .bodyLargeFamily,
                                                                      color: FlutterFlowTheme.of(
                                                                              context)
                                                                          .accent3,
                                                                      letterSpacing:
                                                                          0.0,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      useGoogleFonts:
                                                                          !FlutterFlowTheme.of(context)
                                                                              .bodyLargeIsCustom,
                                                                    ),
                                                              ),
                                                            ),
                                                          ),
                                                          Padding(
                                                            padding:
                                                                EdgeInsetsDirectional
                                                                    .fromSTEB(
                                                                        10.0,
                                                                        0.0,
                                                                        0.0,
                                                                        0.0),
                                                            child: Text(
                                                              dateTimeFormat(
                                                                "relative",
                                                                scrollableContentPostsRecord
                                                                    .createdTime!,
                                                                locale: FFLocalizations.of(
                                                                        context)
                                                                    .languageCode,
                                                              ),
                                                              style: FlutterFlowTheme
                                                                      .of(context)
                                                                  .bodyMedium
                                                                  .override(
                                                                    fontFamily:
                                                                        FlutterFlowTheme.of(context)
                                                                            .bodyMediumFamily,
                                                                    letterSpacing:
                                                                        0.0,
                                                                    useGoogleFonts:
                                                                        !FlutterFlowTheme.of(context)
                                                                            .bodyMediumIsCustom,
                                                                  ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                  Padding(
                                                    padding:
                                                        EdgeInsetsDirectional
                                                            .fromSTEB(0.0, 10.0,
                                                                0.0, 0.0),
                                                    child: Builder(
                                                      builder: (context) {
                                                        final commentImages =
                                                            scrollableContentPostsRecord
                                                                .postMultPhotos
                                                                .toList();

                                                        return SingleChildScrollView(
                                                          scrollDirection:
                                                              Axis.horizontal,
                                                          child: Row(
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .max,
                                                            children: List.generate(
                                                                commentImages
                                                                    .length,
                                                                (commentImagesIndex) {
                                                              final commentImagesItem =
                                                                  commentImages[
                                                                      commentImagesIndex];
                                                              return Align(
                                                                alignment:
                                                                    AlignmentDirectional(
                                                                        0.0,
                                                                        -1.0),
                                                                child:
                                                                    ClipRRect(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              0.0),
                                                                  child: Image
                                                                      .network(
                                                                    commentImagesItem,
                                                                    width:
                                                                        250.0,
                                                                    height:
                                                                        250.0,
                                                                    fit: BoxFit
                                                                        .cover,
                                                                  ),
                                                                ),
                                                              );
                                                            }),
                                                          ),
                                                        );
                                                      },
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                        ClipRRect(
                                          child: Container(
                                            decoration: BoxDecoration(),
                                            child: Padding(
                                              padding: EdgeInsetsDirectional
                                                  .fromSTEB(
                                                      0.0, 10.0, 0.0, 0.0),
                                              child: AutoSizeText(
                                                scrollableContentPostsRecord
                                                    .postText,
                                                maxLines: 3,
                                                style:
                                                    FlutterFlowTheme.of(context)
                                                        .bodyMedium
                                                        .override(
                                                          fontFamily:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .bodyMediumFamily,
                                                          letterSpacing: 0.0,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          useGoogleFonts:
                                                              !FlutterFlowTheme
                                                                      .of(context)
                                                                  .bodyMediumIsCustom,
                                                        ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Stack(
                                          children: [
                                            Padding(
                                              padding: EdgeInsetsDirectional
                                                  .fromSTEB(
                                                      0.0, 10.0, 0.0, 0.0),
                                              child: Row(
                                                mainAxisSize: MainAxisSize.max,
                                                children: [
                                                  Row(
                                                    mainAxisSize:
                                                        MainAxisSize.max,
                                                    children: [
                                                      ToggleIcon(
                                                        onPressed: () async {
                                                          final likesElement =
                                                              currentUserReference;
                                                          final likesUpdate =
                                                              scrollableContentPostsRecord
                                                                      .likes
                                                                      .contains(
                                                                          likesElement)
                                                                  ? FieldValue
                                                                      .arrayRemove([
                                                                      likesElement
                                                                    ])
                                                                  : FieldValue
                                                                      .arrayUnion([
                                                                      likesElement
                                                                    ]);
                                                          await scrollableContentPostsRecord
                                                              .reference
                                                              .update({
                                                            ...mapToFirestore(
                                                              {
                                                                'likes':
                                                                    likesUpdate,
                                                              },
                                                            ),
                                                          });
                                                          if (scrollableContentPostsRecord
                                                                  .likes
                                                                  .contains(
                                                                      currentUserReference) ==
                                                              true) {
                                                            await scrollableContentPostsRecord
                                                                .reference
                                                                .update({
                                                              ...mapToFirestore(
                                                                {
                                                                  'likes':
                                                                      FieldValue
                                                                          .arrayRemove([
                                                                    currentUserReference
                                                                  ]),
                                                                },
                                                              ),
                                                            });
                                                            _model.likeddoc =
                                                                await queryNotificationsRecordOnce(
                                                              parent:
                                                                  scrollableContentPostsRecord
                                                                      .postUser,
                                                              queryBuilder:
                                                                  (notificationsRecord) =>
                                                                      notificationsRecord
                                                                          .where(
                                                                            'type',
                                                                            isEqualTo:
                                                                                'like',
                                                                          )
                                                                          .where(
                                                                            'post',
                                                                            isEqualTo:
                                                                                scrollableContentPostsRecord.reference,
                                                                          )
                                                                          .where(
                                                                            'fromUser',
                                                                            isEqualTo:
                                                                                currentUserReference,
                                                                          ),
                                                              singleRecord:
                                                                  true,
                                                            ).then((s) => s
                                                                    .firstOrNull);
                                                            if (_model.likeddoc
                                                                    ?.seen ==
                                                                false) {
                                                              await scrollableContentPostsRecord
                                                                  .postUser!
                                                                  .update({
                                                                ...mapToFirestore(
                                                                  {
                                                                    'unseenNotifications':
                                                                        FieldValue.increment(
                                                                            -(1)),
                                                                  },
                                                                ),
                                                              });
                                                            }
                                                            await _model
                                                                .likeddoc!
                                                                .reference
                                                                .delete();
                                                          } else {
                                                            await scrollableContentPostsRecord
                                                                .reference
                                                                .update({
                                                              ...mapToFirestore(
                                                                {
                                                                  'likes':
                                                                      FieldValue
                                                                          .arrayUnion([
                                                                    currentUserReference
                                                                  ]),
                                                                },
                                                              ),
                                                            });

                                                            var notificationsRecordReference =
                                                                NotificationsRecord
                                                                    .createDoc(
                                                                        scrollableContentPostsRecord
                                                                            .postUser!);
                                                            await notificationsRecordReference
                                                                .set(
                                                                    createNotificationsRecordData(
                                                              type: 'like',
                                                              fromUser:
                                                                  currentUserReference,
                                                              post:
                                                                  scrollableContentPostsRecord
                                                                      .reference,
                                                              createdAt:
                                                                  getCurrentTimestamp,
                                                              seen: false,
                                                            ));
                                                            _model.creatednotification =
                                                                NotificationsRecord
                                                                    .getDocumentFromData(
                                                                        createNotificationsRecordData(
                                                                          type:
                                                                              'like',
                                                                          fromUser:
                                                                              currentUserReference,
                                                                          post:
                                                                              scrollableContentPostsRecord.reference,
                                                                          createdAt:
                                                                              getCurrentTimestamp,
                                                                          seen:
                                                                              false,
                                                                        ),
                                                                        notificationsRecordReference);

                                                            await scrollableContentPostsRecord
                                                                .postUser!
                                                                .update({
                                                              ...mapToFirestore(
                                                                {
                                                                  'unseenNotifications':
                                                                      FieldValue
                                                                          .increment(
                                                                              1),
                                                                },
                                                              ),
                                                            });
                                                          }

                                                          safeSetState(() {});
                                                        },
                                                        value: scrollableContentPostsRecord
                                                            .likes
                                                            .contains(
                                                                currentUserReference),
                                                        onIcon: Icon(
                                                          Icons.favorite,
                                                          color: FlutterFlowTheme
                                                                  .of(context)
                                                              .primary,
                                                          size: 24.0,
                                                        ),
                                                        offIcon: Icon(
                                                          Icons.favorite_border,
                                                          color: FlutterFlowTheme
                                                                  .of(context)
                                                              .secondaryText,
                                                          size: 24.0,
                                                        ),
                                                      ),
                                                      Text(
                                                        scrollableContentPostsRecord
                                                            .likes.length
                                                            .toString(),
                                                        style:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .bodyMedium
                                                                .override(
                                                                  fontFamily: FlutterFlowTheme.of(
                                                                          context)
                                                                      .bodyMediumFamily,
                                                                  color: FlutterFlowTheme.of(
                                                                          context)
                                                                      .accent3,
                                                                  letterSpacing:
                                                                      0.0,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  useGoogleFonts:
                                                                      !FlutterFlowTheme.of(
                                                                              context)
                                                                          .bodyMediumIsCustom,
                                                                ),
                                                      ),
                                                    ],
                                                  ),
                                                  ToggleIcon(
                                                    onPressed: () async {
                                                      final userCookedThisElement =
                                                          currentUserReference;
                                                      final userCookedThisUpdate =
                                                          scrollableContentPostsRecord
                                                                  .userCookedThis
                                                                  .contains(
                                                                      userCookedThisElement)
                                                              ? FieldValue
                                                                  .arrayRemove([
                                                                  userCookedThisElement
                                                                ])
                                                              : FieldValue
                                                                  .arrayUnion([
                                                                  userCookedThisElement
                                                                ]);
                                                      await scrollableContentPostsRecord
                                                          .reference
                                                          .update({
                                                        ...mapToFirestore(
                                                          {
                                                            'userCookedThis':
                                                                userCookedThisUpdate,
                                                          },
                                                        ),
                                                      });
                                                      if (scrollableContentPostsRecord
                                                              .userCookedThis
                                                              .contains(
                                                                  currentUserReference) ==
                                                          true) {
                                                        await scrollableContentPostsRecord
                                                            .reference
                                                            .update({
                                                          ...mapToFirestore(
                                                            {
                                                              'userCookedThis':
                                                                  FieldValue
                                                                      .arrayRemove([
                                                                currentUserReference
                                                              ]),
                                                            },
                                                          ),
                                                        });
                                                        _model.cookedthisdoc =
                                                            await queryNotificationsRecordOnce(
                                                          parent:
                                                              scrollableContentPostsRecord
                                                                  .postUser,
                                                          queryBuilder:
                                                              (notificationsRecord) =>
                                                                  notificationsRecord
                                                                      .where(
                                                                        'type',
                                                                        isEqualTo:
                                                                            'cookedThis',
                                                                      )
                                                                      .where(
                                                                        'post',
                                                                        isEqualTo:
                                                                            scrollableContentPostsRecord.reference,
                                                                      )
                                                                      .where(
                                                                        'fromUser',
                                                                        isEqualTo:
                                                                            currentUserReference,
                                                                      ),
                                                          singleRecord: true,
                                                        ).then((s) =>
                                                                s.firstOrNull);
                                                        if (_model.cookedthisdoc
                                                                ?.seen ==
                                                            false) {
                                                          await scrollableContentPostsRecord
                                                              .postUser!
                                                              .update({
                                                            ...mapToFirestore(
                                                              {
                                                                'unseenNotifications':
                                                                    FieldValue
                                                                        .increment(
                                                                            -(1)),
                                                              },
                                                            ),
                                                          });
                                                        }
                                                        await _model
                                                            .cookedthisdoc!
                                                            .reference
                                                            .delete();
                                                      } else {
                                                        await scrollableContentPostsRecord
                                                            .reference
                                                            .update({
                                                          ...mapToFirestore(
                                                            {
                                                              'userCookedThis':
                                                                  FieldValue
                                                                      .arrayUnion([
                                                                currentUserReference
                                                              ]),
                                                            },
                                                          ),
                                                        });

                                                        await NotificationsRecord
                                                                .createDoc(
                                                                    scrollableContentPostsRecord
                                                                        .postUser!)
                                                            .set(
                                                                createNotificationsRecordData(
                                                          type: 'cookedThis',
                                                          fromUser:
                                                              currentUserReference,
                                                          post:
                                                              scrollableContentPostsRecord
                                                                  .reference,
                                                          createdAt:
                                                              getCurrentTimestamp,
                                                          seen: false,
                                                        ));

                                                        await scrollableContentPostsRecord
                                                            .postUser!
                                                            .update({
                                                          ...mapToFirestore(
                                                            {
                                                              'unseenNotifications':
                                                                  FieldValue
                                                                      .increment(
                                                                          1),
                                                            },
                                                          ),
                                                        });
                                                      }

                                                      safeSetState(() {});
                                                    },
                                                    value: scrollableContentPostsRecord
                                                        .userCookedThis
                                                        .contains(
                                                            currentUserReference),
                                                    onIcon: Icon(
                                                      Icons.cookie,
                                                      color:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .primary,
                                                      size: 24.0,
                                                    ),
                                                    offIcon: Icon(
                                                      Icons.cookie_outlined,
                                                      color:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .secondaryText,
                                                      size: 24.0,
                                                    ),
                                                  ),
                                                  Text(
                                                    scrollableContentPostsRecord
                                                        .userCookedThis.length
                                                        .toString(),
                                                    style: FlutterFlowTheme.of(
                                                            context)
                                                        .bodyMedium
                                                        .override(
                                                          fontFamily:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .bodyMediumFamily,
                                                          color: FlutterFlowTheme
                                                                  .of(context)
                                                              .accent3,
                                                          letterSpacing: 0.0,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          useGoogleFonts:
                                                              !FlutterFlowTheme
                                                                      .of(context)
                                                                  .bodyMediumIsCustom,
                                                        ),
                                                  ),
                                                  Text(
                                                    ' cooked this!',
                                                    style: FlutterFlowTheme.of(
                                                            context)
                                                        .bodyMedium
                                                        .override(
                                                          fontFamily:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .bodyMediumFamily,
                                                          letterSpacing: 0.0,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          useGoogleFonts:
                                                              !FlutterFlowTheme
                                                                      .of(context)
                                                                  .bodyMediumIsCustom,
                                                        ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                        if (scrollableContentPostsRecord
                                                .hasRecipe ==
                                            true)
                                          StreamBuilder<RecipesRecord>(
                                            stream: RecipesRecord.getDocument(
                                                widget!.reciperef!),
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

                                              final columnRecipesRecord =
                                                  snapshot.data!;

                                              return Column(
                                                mainAxisSize: MainAxisSize.max,
                                                children: [
                                                  Align(
                                                    alignment:
                                                        AlignmentDirectional(
                                                            -1.0, -1.0),
                                                    child: Padding(
                                                      padding:
                                                          EdgeInsetsDirectional
                                                              .fromSTEB(
                                                                  0.0,
                                                                  10.0,
                                                                  0.0,
                                                                  0.0),
                                                      child: Row(
                                                        mainAxisSize:
                                                            MainAxisSize.max,
                                                        children: [
                                                          Flexible(
                                                            child: Align(
                                                              alignment:
                                                                  AlignmentDirectional(
                                                                      -1.0,
                                                                      -1.0),
                                                              child: Flex(
                                                                direction: Axis
                                                                    .vertical,
                                                                mainAxisSize:
                                                                    MainAxisSize
                                                                        .max,
                                                                children: [
                                                                  Text(
                                                                    columnRecipesRecord
                                                                        .title,
                                                                    maxLines: 3,
                                                                    style: FlutterFlowTheme.of(
                                                                            context)
                                                                        .bodyLarge
                                                                        .override(
                                                                          fontFamily:
                                                                              FlutterFlowTheme.of(context).bodyLargeFamily,
                                                                          color:
                                                                              FlutterFlowTheme.of(context).primary,
                                                                          fontSize:
                                                                              16.0,
                                                                          letterSpacing:
                                                                              0.0,
                                                                          fontWeight:
                                                                              FontWeight.bold,
                                                                          useGoogleFonts:
                                                                              !FlutterFlowTheme.of(context).bodyLargeIsCustom,
                                                                        ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        EdgeInsetsDirectional
                                                            .fromSTEB(0.0, 5.0,
                                                                0.0, 10.0),
                                                    child: Row(
                                                      mainAxisSize:
                                                          MainAxisSize.max,
                                                      children: [
                                                        Align(
                                                          alignment:
                                                              AlignmentDirectional(
                                                                  -1.0, -1.0),
                                                          child: Column(
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .max,
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Row(
                                                                mainAxisSize:
                                                                    MainAxisSize
                                                                        .max,
                                                                children: [
                                                                  Text(
                                                                    'cooking time: ',
                                                                    style: FlutterFlowTheme.of(
                                                                            context)
                                                                        .bodyLarge
                                                                        .override(
                                                                          fontFamily:
                                                                              FlutterFlowTheme.of(context).bodyLargeFamily,
                                                                          color:
                                                                              FlutterFlowTheme.of(context).accent3,
                                                                          fontSize:
                                                                              14.0,
                                                                          letterSpacing:
                                                                              0.0,
                                                                          fontWeight:
                                                                              FontWeight.bold,
                                                                          useGoogleFonts:
                                                                              !FlutterFlowTheme.of(context).bodyLargeIsCustom,
                                                                        ),
                                                                  ),
                                                                  Text(
                                                                    columnRecipesRecord
                                                                        .cookingtime,
                                                                    style: FlutterFlowTheme.of(
                                                                            context)
                                                                        .bodyLarge
                                                                        .override(
                                                                          fontFamily:
                                                                              FlutterFlowTheme.of(context).bodyLargeFamily,
                                                                          color:
                                                                              FlutterFlowTheme.of(context).accent3,
                                                                          fontSize:
                                                                              14.0,
                                                                          letterSpacing:
                                                                              0.0,
                                                                          useGoogleFonts:
                                                                              !FlutterFlowTheme.of(context).bodyLargeIsCustom,
                                                                        ),
                                                                  ),
                                                                ],
                                                              ),
                                                              Align(
                                                                alignment:
                                                                    AlignmentDirectional(
                                                                        -1.0,
                                                                        -1.0),
                                                                child: Row(
                                                                  mainAxisSize:
                                                                      MainAxisSize
                                                                          .max,
                                                                  children: [
                                                                    Align(
                                                                      alignment: AlignmentDirectional(
                                                                          -1.0,
                                                                          -1.0),
                                                                      child:
                                                                          Text(
                                                                        'difficulty:  ',
                                                                        style: FlutterFlowTheme.of(context)
                                                                            .bodyLarge
                                                                            .override(
                                                                              fontFamily: FlutterFlowTheme.of(context).bodyLargeFamily,
                                                                              color: FlutterFlowTheme.of(context).accent3,
                                                                              fontSize: 14.0,
                                                                              letterSpacing: 0.0,
                                                                              fontWeight: FontWeight.bold,
                                                                              useGoogleFonts: !FlutterFlowTheme.of(context).bodyLargeIsCustom,
                                                                            ),
                                                                      ),
                                                                    ),
                                                                    Text(
                                                                      columnRecipesRecord
                                                                          .difficulty,
                                                                      style: FlutterFlowTheme.of(
                                                                              context)
                                                                          .bodyLarge
                                                                          .override(
                                                                            fontFamily:
                                                                                FlutterFlowTheme.of(context).bodyLargeFamily,
                                                                            color:
                                                                                FlutterFlowTheme.of(context).accent3,
                                                                            fontSize:
                                                                                14.0,
                                                                            letterSpacing:
                                                                                0.0,
                                                                            useGoogleFonts:
                                                                                !FlutterFlowTheme.of(context).bodyLargeIsCustom,
                                                                          ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                              Align(
                                                                alignment:
                                                                    AlignmentDirectional(
                                                                        -1.0,
                                                                        -1.0),
                                                                child: Row(
                                                                  mainAxisSize:
                                                                      MainAxisSize
                                                                          .max,
                                                                  children: [
                                                                    Text(
                                                                      'servings: ',
                                                                      style: FlutterFlowTheme.of(
                                                                              context)
                                                                          .bodyLarge
                                                                          .override(
                                                                            fontFamily:
                                                                                FlutterFlowTheme.of(context).bodyLargeFamily,
                                                                            color:
                                                                                FlutterFlowTheme.of(context).accent3,
                                                                            fontSize:
                                                                                14.0,
                                                                            letterSpacing:
                                                                                0.0,
                                                                            fontWeight:
                                                                                FontWeight.bold,
                                                                            useGoogleFonts:
                                                                                !FlutterFlowTheme.of(context).bodyLargeIsCustom,
                                                                          ),
                                                                    ),
                                                                    Text(
                                                                      columnRecipesRecord
                                                                          .servings,
                                                                      style: FlutterFlowTheme.of(
                                                                              context)
                                                                          .bodyLarge
                                                                          .override(
                                                                            fontFamily:
                                                                                FlutterFlowTheme.of(context).bodyLargeFamily,
                                                                            color:
                                                                                FlutterFlowTheme.of(context).accent3,
                                                                            fontSize:
                                                                                14.0,
                                                                            letterSpacing:
                                                                                0.0,
                                                                            useGoogleFonts:
                                                                                !FlutterFlowTheme.of(context).bodyLargeIsCustom,
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
                                                  Stack(
                                                    children: [
                                                      Container(
                                                        height: 270.0,
                                                        child: InkWell(
                                                          splashColor: Colors
                                                              .transparent,
                                                          focusColor: Colors
                                                              .transparent,
                                                          hoverColor: Colors
                                                              .transparent,
                                                          highlightColor: Colors
                                                              .transparent,
                                                          onDoubleTap:
                                                              () async {
                                                            FFAppState()
                                                                    .searchisactive =
                                                                false;
                                                            safeSetState(() {});
                                                          },
                                                          child: Column(
                                                            children: [
                                                              Align(
                                                                alignment:
                                                                    Alignment(
                                                                        0.0, 0),
                                                                child: TabBar(
                                                                  labelColor:
                                                                      FlutterFlowTheme.of(
                                                                              context)
                                                                          .accent3,
                                                                  unselectedLabelColor:
                                                                      FlutterFlowTheme.of(
                                                                              context)
                                                                          .warning,
                                                                  labelStyle: FlutterFlowTheme.of(
                                                                          context)
                                                                      .bodyLarge
                                                                      .override(
                                                                        fontFamily:
                                                                            FlutterFlowTheme.of(context).bodyLargeFamily,
                                                                        letterSpacing:
                                                                            0.0,
                                                                        fontWeight:
                                                                            FontWeight.bold,
                                                                        useGoogleFonts:
                                                                            !FlutterFlowTheme.of(context).bodyLargeIsCustom,
                                                                      ),
                                                                  unselectedLabelStyle:
                                                                      TextStyle(),
                                                                  indicatorColor:
                                                                      FlutterFlowTheme.of(
                                                                              context)
                                                                          .primary,
                                                                  indicatorWeight:
                                                                      3.0,
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
                                                                  onTap:
                                                                      (i) async {
                                                                    [
                                                                      () async {},
                                                                      () async {}
                                                                    ][i]();
                                                                  },
                                                                ),
                                                              ),
                                                              Expanded(
                                                                child:
                                                                    TabBarView(
                                                                  controller: _model
                                                                      .tabBarController,
                                                                  children: [
                                                                    Container(
                                                                      width:
                                                                          100.0,
                                                                      height:
                                                                          100.0,
                                                                      decoration:
                                                                          BoxDecoration(
                                                                        color: FlutterFlowTheme.of(context)
                                                                            .primaryBackground,
                                                                      ),
                                                                      child:
                                                                          Builder(
                                                                        builder:
                                                                            (context) {
                                                                          final ingredients = columnRecipesRecord
                                                                              .ingredients
                                                                              .map((e) => e)
                                                                              .toList();

                                                                          return ListView
                                                                              .builder(
                                                                            padding:
                                                                                EdgeInsets.zero,
                                                                            shrinkWrap:
                                                                                true,
                                                                            scrollDirection:
                                                                                Axis.vertical,
                                                                            itemCount:
                                                                                ingredients.length,
                                                                            itemBuilder:
                                                                                (context, ingredientsIndex) {
                                                                              final ingredientsItem = ingredients[ingredientsIndex];
                                                                              return Padding(
                                                                                padding: EdgeInsetsDirectional.fromSTEB(0.0, 6.0, 0.0, 0.0),
                                                                                child: InkWell(
                                                                                  splashColor: Colors.transparent,
                                                                                  focusColor: Colors.transparent,
                                                                                  hoverColor: Colors.transparent,
                                                                                  highlightColor: Colors.transparent,
                                                                                  onTap: () async {
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
                                                                                  child: Text(
                                                                                    ingredientsItem,
                                                                                    style: FlutterFlowTheme.of(context).labelMedium.override(
                                                                                          fontFamily: FlutterFlowTheme.of(context).labelMediumFamily,
                                                                                          color: FlutterFlowTheme.of(context).accent3,
                                                                                          fontSize: 14.0,
                                                                                          letterSpacing: 0.0,
                                                                                          fontWeight: FontWeight.w600,
                                                                                          useGoogleFonts: !FlutterFlowTheme.of(context).labelMediumIsCustom,
                                                                                        ),
                                                                                  ),
                                                                                ),
                                                                              );
                                                                            },
                                                                          );
                                                                        },
                                                                      ),
                                                                    ),
                                                                    Container(
                                                                      width:
                                                                          100.0,
                                                                      height:
                                                                          100.0,
                                                                      decoration:
                                                                          BoxDecoration(
                                                                        color: FlutterFlowTheme.of(context)
                                                                            .primaryBackground,
                                                                      ),
                                                                      child:
                                                                          Builder(
                                                                        builder:
                                                                            (context) {
                                                                          final preparation = columnRecipesRecord
                                                                              .preparation
                                                                              .toList();

                                                                          return ListView
                                                                              .builder(
                                                                            padding:
                                                                                EdgeInsets.zero,
                                                                            primary:
                                                                                false,
                                                                            shrinkWrap:
                                                                                true,
                                                                            scrollDirection:
                                                                                Axis.vertical,
                                                                            itemCount:
                                                                                preparation.length,
                                                                            itemBuilder:
                                                                                (context, preparationIndex) {
                                                                              final preparationItem = preparation[preparationIndex];
                                                                              return Padding(
                                                                                padding: EdgeInsetsDirectional.fromSTEB(0.0, 6.0, 0.0, 0.0),
                                                                                child: Text(
                                                                                  preparationItem,
                                                                                  style: FlutterFlowTheme.of(context).labelMedium.override(
                                                                                        fontFamily: FlutterFlowTheme.of(context).labelMediumFamily,
                                                                                        color: FlutterFlowTheme.of(context).accent3,
                                                                                        fontSize: 14.0,
                                                                                        letterSpacing: 0.0,
                                                                                        fontWeight: FontWeight.w600,
                                                                                        useGoogleFonts: !FlutterFlowTheme.of(context).labelMediumIsCustom,
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
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              );
                                            },
                                          ),
                                        Align(
                                          alignment:
                                              AlignmentDirectional(0.0, 0.0),
                                          child: Stack(
                                            alignment:
                                                AlignmentDirectional(0.0, 0.0),
                                            children: [
                                              Align(
                                                alignment: AlignmentDirectional(
                                                    0.0, 0.0),
                                                child: Container(
                                                  width: double.infinity,
                                                  child: TextFormField(
                                                    controller:
                                                        _model.textController,
                                                    focusNode: _model
                                                        .textFieldFocusNode,
                                                    autofocus: false,
                                                    obscureText: false,
                                                    decoration: InputDecoration(
                                                      isDense: true,
                                                      labelStyle:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .labelMedium
                                                              .override(
                                                                fontFamily: FlutterFlowTheme.of(
                                                                        context)
                                                                    .labelMediumFamily,
                                                                letterSpacing:
                                                                    0.0,
                                                                useGoogleFonts:
                                                                    !FlutterFlowTheme.of(
                                                                            context)
                                                                        .labelMediumIsCustom,
                                                              ),
                                                      hintText:
                                                          'add a comment... ',
                                                      hintStyle:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .bodyLarge
                                                              .override(
                                                                fontFamily: FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodyLargeFamily,
                                                                color: FlutterFlowTheme.of(
                                                                        context)
                                                                    .alternate,
                                                                letterSpacing:
                                                                    0.0,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                                useGoogleFonts:
                                                                    !FlutterFlowTheme.of(
                                                                            context)
                                                                        .bodyLargeIsCustom,
                                                              ),
                                                      enabledBorder:
                                                          OutlineInputBorder(
                                                        borderSide: BorderSide(
                                                          color: FlutterFlowTheme
                                                                  .of(context)
                                                              .tertiary,
                                                          width: 2.0,
                                                        ),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(12.0),
                                                      ),
                                                      focusedBorder:
                                                          OutlineInputBorder(
                                                        borderSide: BorderSide(
                                                          color: FlutterFlowTheme
                                                                  .of(context)
                                                              .primary,
                                                          width: 2.0,
                                                        ),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(12.0),
                                                      ),
                                                      errorBorder:
                                                          OutlineInputBorder(
                                                        borderSide: BorderSide(
                                                          color: FlutterFlowTheme
                                                                  .of(context)
                                                              .error,
                                                          width: 2.0,
                                                        ),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(12.0),
                                                      ),
                                                      focusedErrorBorder:
                                                          OutlineInputBorder(
                                                        borderSide: BorderSide(
                                                          color: FlutterFlowTheme
                                                                  .of(context)
                                                              .error,
                                                          width: 2.0,
                                                        ),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(12.0),
                                                      ),
                                                      filled: true,
                                                      fillColor: FlutterFlowTheme
                                                              .of(context)
                                                          .secondaryBackground,
                                                    ),
                                                    style: FlutterFlowTheme.of(
                                                            context)
                                                        .bodyLarge
                                                        .override(
                                                          fontFamily:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .bodyLargeFamily,
                                                          letterSpacing: 0.0,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          useGoogleFonts:
                                                              !FlutterFlowTheme
                                                                      .of(context)
                                                                  .bodyLargeIsCustom,
                                                        ),
                                                    cursorColor:
                                                        FlutterFlowTheme.of(
                                                                context)
                                                            .primaryText,
                                                    validator: _model
                                                        .textControllerValidator
                                                        .asValidator(context),
                                                  ),
                                                ),
                                              ),
                                              Align(
                                                alignment: AlignmentDirectional(
                                                    1.0, 0.0),
                                                child: Padding(
                                                  padding: EdgeInsetsDirectional
                                                      .fromSTEB(
                                                          0.0, 0.0, 5.0, 0.0),
                                                  child: FlutterFlowIconButton(
                                                    borderRadius: 8.0,
                                                    buttonSize: 45.0,
                                                    fillColor:
                                                        Colors.transparent,
                                                    icon: Icon(
                                                      Icons.send,
                                                      color:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .primary,
                                                      size: 24.0,
                                                    ),
                                                    onPressed: () async {
                                                      if (_model.textController
                                                                  .text !=
                                                              null &&
                                                          _model.textController
                                                                  .text !=
                                                              '') {
                                                        await CommentsRecord
                                                            .collection
                                                            .doc()
                                                            .set(
                                                                createCommentsRecordData(
                                                              comment: _model
                                                                  .textController
                                                                  .text,
                                                              time:
                                                                  getCurrentTimestamp,
                                                              postref:
                                                                  scrollableContentPostsRecord
                                                                      .reference,
                                                              userref:
                                                                  currentUserReference,
                                                              displayname:
                                                                  currentUserDisplayName,
                                                              profileimage:
                                                                  currentUserPhoto,
                                                            ));

                                                        await NotificationsRecord
                                                                .createDoc(
                                                                    scrollableContentPostsRecord
                                                                        .postUser!)
                                                            .set(
                                                                createNotificationsRecordData(
                                                          type: 'comment',
                                                          fromUser:
                                                              currentUserReference,
                                                          post:
                                                              scrollableContentPostsRecord
                                                                  .reference,
                                                          createdAt:
                                                              getCurrentTimestamp,
                                                          seen: false,
                                                          commentText: _model
                                                              .textController
                                                              .text,
                                                        ));

                                                        await scrollableContentPostsRecord
                                                            .postUser!
                                                            .update({
                                                          ...mapToFirestore(
                                                            {
                                                              'unseenNotifications':
                                                                  FieldValue
                                                                      .increment(
                                                                          1),
                                                            },
                                                          ),
                                                        });
                                                        safeSetState(() {
                                                          _model.textController
                                                              ?.clear();
                                                        });
                                                      }
                                                    },
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                  0.0, 12.0, 0.0, 50.0),
                                          child: Column(
                                            mainAxisSize: MainAxisSize.max,
                                            children: [
                                              Padding(
                                                padding: EdgeInsetsDirectional
                                                    .fromSTEB(
                                                        0.0, 0.0, 0.0, 20.0),
                                                child: StreamBuilder<
                                                    List<CommentsRecord>>(
                                                  stream: queryCommentsRecord(
                                                    queryBuilder:
                                                        (commentsRecord) =>
                                                            commentsRecord
                                                                .where(
                                                                  'postref',
                                                                  isEqualTo:
                                                                      widget!
                                                                          .docref,
                                                                )
                                                                .orderBy('time',
                                                                    descending:
                                                                        true),
                                                  ),
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
                                                    List<CommentsRecord>
                                                        listViewCommentsRecordList =
                                                        snapshot.data!;
                                                    if (listViewCommentsRecordList
                                                        .isEmpty) {
                                                      return NotificationcompWidget();
                                                    }

                                                    return ListView.builder(
                                                      padding: EdgeInsets.zero,
                                                      primary: false,
                                                      shrinkWrap: true,
                                                      scrollDirection:
                                                          Axis.vertical,
                                                      itemCount:
                                                          listViewCommentsRecordList
                                                              .length,
                                                      itemBuilder: (context,
                                                          listViewIndex) {
                                                        final listViewCommentsRecord =
                                                            listViewCommentsRecordList[
                                                                listViewIndex];
                                                        return Padding(
                                                          padding:
                                                              EdgeInsetsDirectional
                                                                  .fromSTEB(
                                                                      0.0,
                                                                      0.0,
                                                                      0.0,
                                                                      12.0),
                                                          child: Row(
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .max,
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Column(
                                                                mainAxisSize:
                                                                    MainAxisSize
                                                                        .max,
                                                                children: [
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
                                                                      if (listViewCommentsRecord
                                                                              .userref ==
                                                                          currentUserReference) {
                                                                        context.goNamed(
                                                                            ProfilePage2Widget.routeName);
                                                                      } else {
                                                                        context
                                                                            .pushNamed(
                                                                          SearchedProfilePageWidget
                                                                              .routeName,
                                                                          queryParameters:
                                                                              {
                                                                            'profileparameters':
                                                                                serializeParam(
                                                                              listViewCommentsRecord.userref,
                                                                              ParamType.DocumentReference,
                                                                            ),
                                                                          }.withoutNulls,
                                                                        );
                                                                      }
                                                                    },
                                                                    child:
                                                                        ClipRRect(
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              40.0),
                                                                      child: Image
                                                                          .network(
                                                                        listViewCommentsRecord
                                                                            .profileimage,
                                                                        width:
                                                                            43.0,
                                                                        height:
                                                                            43.0,
                                                                        fit: BoxFit
                                                                            .cover,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                              Column(
                                                                mainAxisSize:
                                                                    MainAxisSize
                                                                        .max,
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  Padding(
                                                                    padding: EdgeInsetsDirectional
                                                                        .fromSTEB(
                                                                            10.0,
                                                                            0.0,
                                                                            0.0,
                                                                            0.0),
                                                                    child:
                                                                        Container(
                                                                      constraints:
                                                                          BoxConstraints(
                                                                        maxWidth:
                                                                            MediaQuery.sizeOf(context).width *
                                                                                0.75,
                                                                      ),
                                                                      decoration:
                                                                          BoxDecoration(
                                                                        color: FlutterFlowTheme.of(context)
                                                                            .primaryBackground,
                                                                        borderRadius:
                                                                            BorderRadius.circular(12.0),
                                                                      ),
                                                                      child:
                                                                          Padding(
                                                                        padding: EdgeInsetsDirectional.fromSTEB(
                                                                            0.0,
                                                                            0.0,
                                                                            0.0,
                                                                            8.0),
                                                                        child:
                                                                            Column(
                                                                          mainAxisSize:
                                                                              MainAxisSize.max,
                                                                          crossAxisAlignment:
                                                                              CrossAxisAlignment.start,
                                                                          children: [
                                                                            Row(
                                                                              mainAxisSize: MainAxisSize.max,
                                                                              children: [
                                                                                InkWell(
                                                                                  splashColor: Colors.transparent,
                                                                                  focusColor: Colors.transparent,
                                                                                  hoverColor: Colors.transparent,
                                                                                  highlightColor: Colors.transparent,
                                                                                  onTap: () async {
                                                                                    if (listViewCommentsRecord.userref == currentUserReference) {
                                                                                      context.goNamed(ProfilePage2Widget.routeName);
                                                                                    } else {
                                                                                      context.pushNamed(
                                                                                        SearchedProfilePageWidget.routeName,
                                                                                        queryParameters: {
                                                                                          'profileparameters': serializeParam(
                                                                                            listViewCommentsRecord.userref,
                                                                                            ParamType.DocumentReference,
                                                                                          ),
                                                                                        }.withoutNulls,
                                                                                      );
                                                                                    }
                                                                                  },
                                                                                  child: Text(
                                                                                    listViewCommentsRecord.displayname,
                                                                                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                          fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                                                                                          color: FlutterFlowTheme.of(context).accent3,
                                                                                          letterSpacing: 0.0,
                                                                                          fontWeight: FontWeight.bold,
                                                                                          useGoogleFonts: !FlutterFlowTheme.of(context).bodyMediumIsCustom,
                                                                                        ),
                                                                                  ),
                                                                                ),
                                                                                Align(
                                                                                  alignment: AlignmentDirectional(0.0, 0.0),
                                                                                  child: Padding(
                                                                                    padding: EdgeInsetsDirectional.fromSTEB(5.0, 0.0, 0.0, 0.0),
                                                                                    child: Text(
                                                                                      dateTimeFormat(
                                                                                        "relative",
                                                                                        listViewCommentsRecord.time!,
                                                                                        locale: FFLocalizations.of(context).languageCode,
                                                                                      ),
                                                                                      maxLines: 5,
                                                                                      style: FlutterFlowTheme.of(context).labelSmall.override(
                                                                                            fontFamily: FlutterFlowTheme.of(context).labelSmallFamily,
                                                                                            fontSize: 10.0,
                                                                                            letterSpacing: 0.0,
                                                                                            useGoogleFonts: !FlutterFlowTheme.of(context).labelSmallIsCustom,
                                                                                          ),
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                              ],
                                                                            ),
                                                                            Text(
                                                                              listViewCommentsRecord.comment,
                                                                              maxLines: 4,
                                                                              style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                    fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                                                                                    letterSpacing: 0.0,
                                                                                    useGoogleFonts: !FlutterFlowTheme.of(context).bodyMediumIsCustom,
                                                                                  ),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ],
                                                          ),
                                                        );
                                                      },
                                                    );
                                                  },
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
                            ],
                          ).animateOnPageLoad(
                              animationsMap['columnOnPageLoadAnimation']!);
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }
}
