import '/auth/base_auth_user_provider.dart';
import '/auth/firebase_auth/auth_util.dart';
import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_toggle_icon.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import '/index.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:provider/provider.dart';
import 'food_feed_model.dart';
export 'food_feed_model.dart';

class FoodFeedWidget extends StatefulWidget {
  const FoodFeedWidget({super.key});

  static String routeName = 'foodFeed';
  static String routePath = '/foodFeed';

  @override
  State<FoodFeedWidget> createState() => _FoodFeedWidgetState();
}

class _FoodFeedWidgetState extends State<FoodFeedWidget> {
  late FoodFeedModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => FoodFeedModel());

    // On page load action.
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      FFAppState().ingredientsList = [];
      FFAppState().preparationList = [];
      FFAppState().hasRecipe = false;
      FFAppState().recipetitle = '';
      FFAppState().recipenotes = '';
      FFAppState().difficulty = '';
      FFAppState().cookingtime = '';
      FFAppState().servings = '';
      FFAppState().editedRecipe = false;
      if (loggedIn == true) {
        // Wait for the user document to load from Firestore before checking
        // profileComplete, otherwise it defaults to false and incorrectly
        // redirects to the create profile page.
        if (currentUserDocument == null) {
          await authenticatedUserStream
              .firstWhere((user) => user != null)
              .timeout(const Duration(seconds: 5), onTimeout: () => null);
        }
        if (mounted &&
            !valueOrDefault<bool>(
                currentUserDocument?.profileComplete, false)) {
          context.pushNamed(CreateProfileWidget.routeName);
        }
      }
    });

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
          title: Text(
            'bite',
            style: FlutterFlowTheme.of(context).headlineMedium.override(
                  fontFamily: FlutterFlowTheme.of(context).headlineMediumFamily,
                  color: FlutterFlowTheme.of(context).primary,
                  fontSize: 22.0,
                  letterSpacing: 0.0,
                  useGoogleFonts:
                      !FlutterFlowTheme.of(context).headlineMediumIsCustom,
                ),
          ),
          actions: [
            Align(
              alignment: AlignmentDirectional(-0.97, 0.0),
              child: Padding(
                padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 2.0, 0.0),
                child: InkWell(
                  splashColor: Colors.transparent,
                  focusColor: Colors.transparent,
                  hoverColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  onTap: () async {
                    if (loggedIn) {
                      context.pushNamed(NotificationWidget.routeName);
                    } else {
                      context.pushNamed(OnboardingWidget.routeName);
                    }
                  },
                  child: Icon(
                    Icons.notifications_none,
                    color: FlutterFlowTheme.of(context).primaryText,
                    size: 30.0,
                  ),
                ),
              ),
            ),
            Visibility(
              visible: loggedIn == true,
              child: Align(
                alignment: AlignmentDirectional(-1.0, 0.0),
                child: Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 10.0, 0.0),
                  child: AuthUserStreamWidget(
                    builder: (context) => InkWell(
                      splashColor: Colors.transparent,
                      focusColor: Colors.transparent,
                      hoverColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      onTap: () async {
                        context.pushNamed(NotificationWidget.routeName);
                      },
                      child: Text(
                        valueOrDefault(
                                currentUserDocument?.unseenNotifications, 0)
                            .toString(),
                        style: FlutterFlowTheme.of(context).bodyMedium.override(
                              fontFamily:
                                  FlutterFlowTheme.of(context).bodyMediumFamily,
                              color: FlutterFlowTheme.of(context).accent3,
                              letterSpacing: 0.0,
                              fontWeight: FontWeight.w600,
                              useGoogleFonts: !FlutterFlowTheme.of(context)
                                  .bodyMediumIsCustom,
                            ),
                      ),
                    ),
                  ),
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
                Stack(
                  children: [
                    Padding(
                      padding:
                          EdgeInsetsDirectional.fromSTEB(0.0, 75.0, 0.0, 0.0),
                      child: Stack(
                        children: [
                          if (loggedIn)
                            Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  0.0, 190.0, 0.0, 0.0),
                              child: AuthUserStreamWidget(
                                builder: (context) => Padding(
                                          padding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                  0.0, 0.0, 0.0, 100.0),
                                          child: PagedListView<
                                              DocumentSnapshot<Object?>?,
                                              PostsRecord>(
                                            pagingController:
                                                _model.setListViewController(
                                              PostsRecord.collection
                                                  .where(
                                                    'postUser',
                                                    whereIn: (currentUserDocument
                                                            ?.followingUsers
                                                            ?.toList() ??
                                                        []),
                                                  )
                                                  .orderBy('created_time',
                                                      descending: true),
                                            ),
                                            padding: EdgeInsets.zero,
                                            primary: false,
                                            shrinkWrap: true,
                                            reverse: false,
                                            scrollDirection: Axis.vertical,
                                            builderDelegate:
                                                PagedChildBuilderDelegate<
                                                    PostsRecord>(
                                              // Customize what your widget looks like when it's loading the first page.
                                              firstPageProgressIndicatorBuilder:
                                                  (_) => Center(
                                                child: SizedBox(
                                                  width: 30.0,
                                                  height: 30.0,
                                                  child: SpinKitFadingGrid(
                                                    color: FlutterFlowTheme.of(
                                                            context)
                                                        .tertiary,
                                                    size: 30.0,
                                                  ),
                                                ),
                                              ),
                                              // Customize what your widget looks like when it's loading another page.
                                              newPageProgressIndicatorBuilder:
                                                  (_) => Center(
                                                child: SizedBox(
                                                  width: 30.0,
                                                  height: 30.0,
                                                  child: SpinKitFadingGrid(
                                                    color: FlutterFlowTheme.of(
                                                            context)
                                                        .tertiary,
                                                    size: 30.0,
                                                  ),
                                                ),
                                              ),

                                              itemBuilder:
                                                  (context, _, listViewIndex) {
                                                final listViewPostsRecord = _model
                                                    .listViewPagingController!
                                                    .itemList![listViewIndex];
                                                return Visibility(
                                                  visible: listViewPostsRecord
                                                          .reference !=
                                                      null,
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                      color: FlutterFlowTheme
                                                              .of(context)
                                                          .primaryBackground,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              0.0),
                                                    ),
                                                    child: Padding(
                                                      padding:
                                                          EdgeInsetsDirectional
                                                              .fromSTEB(
                                                                  12.0,
                                                                  5.0,
                                                                  12.0,
                                                                  0.0),
                                                      child: Row(
                                                        mainAxisSize:
                                                            MainAxisSize.max,
                                                        children: [
                                                          Expanded(
                                                            child: Padding(
                                                              padding:
                                                                  EdgeInsetsDirectional
                                                                      .fromSTEB(
                                                                          0.0,
                                                                          0.0,
                                                                          4.0,
                                                                          0.0),
                                                              child: Column(
                                                                mainAxisSize:
                                                                    MainAxisSize
                                                                        .min,
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .center,
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  Stack(
                                                                    children: [
                                                                      FutureBuilder<
                                                                          UsersRecord>(
                                                                        future:
                                                                            _model.getCachedUser(listViewPostsRecord.postUser!),
                                                                        builder:
                                                                            (context,
                                                                                snapshot) {
                                                                          // Customize what your widget looks like when it's loading.
                                                                          if (!snapshot
                                                                              .hasData) {
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

                                                                          final rowUsersRecord =
                                                                              snapshot.data!;

                                                                          return Row(
                                                                            mainAxisSize:
                                                                                MainAxisSize.max,
                                                                            children: [
                                                                              InkWell(
                                                                                splashColor: Colors.transparent,
                                                                                focusColor: Colors.transparent,
                                                                                hoverColor: Colors.transparent,
                                                                                highlightColor: Colors.transparent,
                                                                                onTap: () async {
                                                                                  if (listViewPostsRecord.postUser == currentUserReference) {
                                                                                    context.goNamed(ProfilePage2Widget.routeName);
                                                                                  } else {
                                                                                    context.pushNamed(
                                                                                      SearchedProfilePageWidget.routeName,
                                                                                      queryParameters: {
                                                                                        'profileparameters': serializeParam(
                                                                                          rowUsersRecord.reference,
                                                                                          ParamType.DocumentReference,
                                                                                        ),
                                                                                      }.withoutNulls,
                                                                                    );
                                                                                  }
                                                                                },
                                                                                child: ClipRRect(
                                                                                  borderRadius: BorderRadius.circular(40.0),
                                                                                  child: Image.network(
                                                                                    rowUsersRecord.photoUrl,
                                                                                    width: 35.0,
                                                                                    height: 35.0,
                                                                                    fit: BoxFit.cover,
                                                                                    errorBuilder: (context, error, stackTrace) => Image.asset(
                                                                                      'assets/images/error_image.png',
                                                                                      width: 35.0,
                                                                                      height: 35.0,
                                                                                      fit: BoxFit.cover,
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                              Column(
                                                                                mainAxisSize: MainAxisSize.max,
                                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                                children: [
                                                                                  if (rowUsersRecord.displayName != null && rowUsersRecord.displayName != '')
                                                                                    Align(
                                                                                      alignment: AlignmentDirectional(-1.0, -1.0),
                                                                                      child: Padding(
                                                                                        padding: EdgeInsetsDirectional.fromSTEB(5.0, 0.0, 0.0, 0.0),
                                                                                        child: InkWell(
                                                                                          splashColor: Colors.transparent,
                                                                                          focusColor: Colors.transparent,
                                                                                          hoverColor: Colors.transparent,
                                                                                          highlightColor: Colors.transparent,
                                                                                          onTap: () async {
                                                                                            if (listViewPostsRecord.postUser == currentUserReference) {
                                                                                              context.goNamed(ProfilePage2Widget.routeName);
                                                                                            } else {
                                                                                              context.pushNamed(
                                                                                                SearchedProfilePageWidget.routeName,
                                                                                                queryParameters: {
                                                                                                  'profileparameters': serializeParam(
                                                                                                    rowUsersRecord.reference,
                                                                                                    ParamType.DocumentReference,
                                                                                                  ),
                                                                                                }.withoutNulls,
                                                                                              );
                                                                                            }
                                                                                          },
                                                                                          child: Text(
                                                                                            rowUsersRecord.displayName,
                                                                                            style: FlutterFlowTheme.of(context).bodyLarge.override(
                                                                                                  fontFamily: FlutterFlowTheme.of(context).bodyLargeFamily,
                                                                                                  color: FlutterFlowTheme.of(context).accent3,
                                                                                                  fontSize: 14.0,
                                                                                                  letterSpacing: 0.0,
                                                                                                  fontWeight: FontWeight.w600,
                                                                                                  useGoogleFonts: !FlutterFlowTheme.of(context).bodyLargeIsCustom,
                                                                                                ),
                                                                                          ),
                                                                                        ),
                                                                                      ),
                                                                                    ),
                                                                                  if (listViewPostsRecord.createdTime != null)
                                                                                    Align(
                                                                                      alignment: AlignmentDirectional(-0.54, 0.0),
                                                                                      child: Padding(
                                                                                        padding: EdgeInsetsDirectional.fromSTEB(5.0, 0.0, 0.0, 0.0),
                                                                                        child: Text(
                                                                                          dateTimeFormat(
                                                                                            "relative",
                                                                                            listViewPostsRecord.createdTime!,
                                                                                            locale: FFLocalizations.of(context).languageCode,
                                                                                          ),
                                                                                          style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                                fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                                                                                                fontSize: 10.0,
                                                                                                letterSpacing: 0.0,
                                                                                                useGoogleFonts: !FlutterFlowTheme.of(context).bodyMediumIsCustom,
                                                                                              ),
                                                                                        ),
                                                                                      ),
                                                                                    ),
                                                                                ],
                                                                              ),
                                                                            ],
                                                                          );
                                                                        },
                                                                      ),
                                                                    ],
                                                                  ),
                                                                  Padding(
                                                                    padding: EdgeInsetsDirectional
                                                                        .fromSTEB(
                                                                            0.0,
                                                                            8.0,
                                                                            0.0,
                                                                            0.0),
                                                                    child:
                                                                        Builder(
                                                                      builder:
                                                                          (context) {
                                                                        final images = listViewPostsRecord
                                                                            .postMultPhotos
                                                                            .map((e) =>
                                                                                e)
                                                                            .toList();

                                                                        return SingleChildScrollView(
                                                                          scrollDirection:
                                                                              Axis.horizontal,
                                                                          child:
                                                                              Row(
                                                                            mainAxisSize:
                                                                                MainAxisSize.max,
                                                                            children:
                                                                                List.generate(images.length, (imagesIndex) {
                                                                              final imagesItem = images[imagesIndex];
                                                                              return Visibility(
                                                                                visible: imagesItem != null && imagesItem != '',
                                                                                child: Align(
                                                                                  alignment: AlignmentDirectional(-1.0, -1.0),
                                                                                  child: Padding(
                                                                                    padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 5.0, 0.0),
                                                                                    child: InkWell(
                                                                                      splashColor: Colors.transparent,
                                                                                      focusColor: Colors.transparent,
                                                                                      hoverColor: Colors.transparent,
                                                                                      highlightColor: Colors.transparent,
                                                                                      onTap: () async {
                                                                                        if (listViewPostsRecord.hasRecipe == true) {
                                                                                          context.pushNamed(
                                                                                            CommentRecipeWidget.routeName,
                                                                                            queryParameters: {
                                                                                              'docref': serializeParam(
                                                                                                listViewPostsRecord.reference,
                                                                                                ParamType.DocumentReference,
                                                                                              ),
                                                                                              'reciperef': serializeParam(
                                                                                                listViewPostsRecord.recipeRef,
                                                                                                ParamType.DocumentReference,
                                                                                              ),
                                                                                              'userref': serializeParam(
                                                                                                listViewPostsRecord.postUser,
                                                                                                ParamType.DocumentReference,
                                                                                              ),
                                                                                            }.withoutNulls,
                                                                                          );
                                                                                        } else {
                                                                                          context.pushNamed(
                                                                                            CommentWidget.routeName,
                                                                                            queryParameters: {
                                                                                              'docref': serializeParam(
                                                                                                listViewPostsRecord.reference,
                                                                                                ParamType.DocumentReference,
                                                                                              ),
                                                                                              'userref': serializeParam(
                                                                                                listViewPostsRecord.postUser,
                                                                                                ParamType.DocumentReference,
                                                                                              ),
                                                                                            }.withoutNulls,
                                                                                          );
                                                                                        }
                                                                                      },
                                                                                      child: ClipRRect(
                                                                                        borderRadius: BorderRadius.circular(0.0),
                                                                                        child: Image.network(
                                                                                          imagesItem,
                                                                                          width: 350.0,
                                                                                          height: 350.0,
                                                                                          fit: BoxFit.cover,
                                                                                          errorBuilder: (context, error, stackTrace) => Image.asset(
                                                                                            'assets/images/error_image.png',
                                                                                            width: 350.0,
                                                                                            height: 350.0,
                                                                                            fit: BoxFit.cover,
                                                                                          ),
                                                                                        ),
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                              );
                                                                            }),
                                                                          ),
                                                                        );
                                                                      },
                                                                    ),
                                                                  ),
                                                                  if (listViewPostsRecord
                                                                              .postText !=
                                                                          null &&
                                                                      listViewPostsRecord
                                                                              .postText !=
                                                                          '')
                                                                    Align(
                                                                      alignment: AlignmentDirectional(
                                                                          -1.0,
                                                                          -1.0),
                                                                      child:
                                                                          Padding(
                                                                        padding: EdgeInsetsDirectional.fromSTEB(
                                                                            0.0,
                                                                            5.0,
                                                                            0.0,
                                                                            0.0),
                                                                        child:
                                                                            AutoSizeText(
                                                                          listViewPostsRecord
                                                                              .postText,
                                                                          maxLines:
                                                                              3,
                                                                          style: FlutterFlowTheme.of(context)
                                                                              .bodyMedium
                                                                              .override(
                                                                                fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                                                                                color: FlutterFlowTheme.of(context).accent3,
                                                                                letterSpacing: 0.0,
                                                                                useGoogleFonts: !FlutterFlowTheme.of(context).bodyMediumIsCustom,
                                                                              ),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  Row(
                                                                    mainAxisSize:
                                                                        MainAxisSize
                                                                            .max,
                                                                    children: [
                                                                      Row(
                                                                        mainAxisSize:
                                                                            MainAxisSize.max,
                                                                        children: [
                                                                          if (listViewPostsRecord.hasRecipe ==
                                                                              true)
                                                                            Row(
                                                                              mainAxisSize: MainAxisSize.max,
                                                                              children: [
                                                                                Padding(
                                                                                  padding: EdgeInsetsDirectional.fromSTEB(0.0, 2.0, 0.0, 0.0),
                                                                                  child: Icon(
                                                                                    Icons.check_circle_outline_rounded,
                                                                                    color: FlutterFlowTheme.of(context).accent3,
                                                                                    size: 18.0,
                                                                                  ),
                                                                                ),
                                                                                if (listViewPostsRecord.createdTime != null)
                                                                                  Align(
                                                                                    alignment: AlignmentDirectional(-1.0, -1.0),
                                                                                    child: Padding(
                                                                                      padding: EdgeInsetsDirectional.fromSTEB(2.0, 0.0, 0.0, 0.0),
                                                                                      child: Text(
                                                                                        'recipe included',
                                                                                        style: FlutterFlowTheme.of(context).bodySmall.override(
                                                                                              fontFamily: FlutterFlowTheme.of(context).bodySmallFamily,
                                                                                              color: FlutterFlowTheme.of(context).primary,
                                                                                              letterSpacing: 0.0,
                                                                                              fontWeight: FontWeight.bold,
                                                                                              useGoogleFonts: !FlutterFlowTheme.of(context).bodySmallIsCustom,
                                                                                            ),
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                              ],
                                                                            ),
                                                                        ],
                                                                      ),
                                                                    ],
                                                                  ),
                                                                  Row(
                                                                    mainAxisSize:
                                                                        MainAxisSize
                                                                            .max,
                                                                    children: [
                                                                      ToggleIcon(
                                                                        onPressed:
                                                                            () async {
                                                                          final likesElement =
                                                                              currentUserReference;
                                                                          final likesUpdate = listViewPostsRecord.likes.contains(likesElement)
                                                                              ? FieldValue.arrayRemove([
                                                                                  likesElement
                                                                                ])
                                                                              : FieldValue.arrayUnion([
                                                                                  likesElement
                                                                                ]);
                                                                          await listViewPostsRecord
                                                                              .reference
                                                                              .update({
                                                                            ...mapToFirestore(
                                                                              {
                                                                                'likes': likesUpdate,
                                                                              },
                                                                            ),
                                                                          });
                                                                          if (listViewPostsRecord.likes.contains(currentUserReference) ==
                                                                              true) {
                                                                            await listViewPostsRecord.reference.update({
                                                                              ...mapToFirestore(
                                                                                {
                                                                                  'likes': FieldValue.arrayRemove([
                                                                                    currentUserReference
                                                                                  ]),
                                                                                },
                                                                              ),
                                                                            });
                                                                            _model.likeddoc =
                                                                                await queryNotificationsRecordOnce(
                                                                              parent: listViewPostsRecord.postUser,
                                                                              queryBuilder: (notificationsRecord) => notificationsRecord
                                                                                  .where(
                                                                                    'type',
                                                                                    isEqualTo: 'like',
                                                                                  )
                                                                                  .where(
                                                                                    'post',
                                                                                    isEqualTo: listViewPostsRecord.reference,
                                                                                  )
                                                                                  .where(
                                                                                    'fromUser',
                                                                                    isEqualTo: currentUserReference,
                                                                                  ),
                                                                              singleRecord: true,
                                                                            ).then((s) => s.firstOrNull);
                                                                            if (_model.likeddoc?.seen ==
                                                                                false) {
                                                                              await listViewPostsRecord.postUser!.update({
                                                                                ...mapToFirestore(
                                                                                  {
                                                                                    'unseenNotifications': FieldValue.increment(-(1)),
                                                                                  },
                                                                                ),
                                                                              });
                                                                            }
                                                                            await _model.likeddoc!.reference.delete();
                                                                          } else {
                                                                            await listViewPostsRecord.reference.update({
                                                                              ...mapToFirestore(
                                                                                {
                                                                                  'likes': FieldValue.arrayUnion([
                                                                                    currentUserReference
                                                                                  ]),
                                                                                },
                                                                              ),
                                                                            });

                                                                            var notificationsRecordReference =
                                                                                NotificationsRecord.createDoc(listViewPostsRecord.postUser!);
                                                                            await notificationsRecordReference.set(createNotificationsRecordData(
                                                                              type: 'like',
                                                                              fromUser: currentUserReference,
                                                                              post: listViewPostsRecord.reference,
                                                                              createdAt: getCurrentTimestamp,
                                                                              seen: false,
                                                                            ));
                                                                            _model.creatednotification = NotificationsRecord.getDocumentFromData(
                                                                                createNotificationsRecordData(
                                                                                  type: 'like',
                                                                                  fromUser: currentUserReference,
                                                                                  post: listViewPostsRecord.reference,
                                                                                  createdAt: getCurrentTimestamp,
                                                                                  seen: false,
                                                                                ),
                                                                                notificationsRecordReference);

                                                                            await listViewPostsRecord.postUser!.update({
                                                                              ...mapToFirestore(
                                                                                {
                                                                                  'unseenNotifications': FieldValue.increment(1),
                                                                                },
                                                                              ),
                                                                            });
                                                                          }

                                                                          safeSetState(
                                                                              () {});
                                                                        },
                                                                        value: listViewPostsRecord
                                                                            .likes
                                                                            .contains(currentUserReference),
                                                                        onIcon:
                                                                            Icon(
                                                                          Icons
                                                                              .favorite,
                                                                          color:
                                                                              FlutterFlowTheme.of(context).primary,
                                                                          size:
                                                                              24.0,
                                                                        ),
                                                                        offIcon:
                                                                            Icon(
                                                                          Icons
                                                                              .favorite_border,
                                                                          color:
                                                                              FlutterFlowTheme.of(context).secondaryText,
                                                                          size:
                                                                              24.0,
                                                                        ),
                                                                      ),
                                                                      FlutterFlowIconButton(
                                                                        borderRadius:
                                                                            8.0,
                                                                        buttonSize:
                                                                            40.0,
                                                                        fillColor:
                                                                            FlutterFlowTheme.of(context).primaryBackground,
                                                                        icon:
                                                                            Icon(
                                                                          Icons
                                                                              .insert_comment_outlined,
                                                                          color:
                                                                              FlutterFlowTheme.of(context).primary,
                                                                          size:
                                                                              24.0,
                                                                        ),
                                                                        onPressed:
                                                                            () async {
                                                                          if (listViewPostsRecord.hasRecipe ==
                                                                              true) {
                                                                            context.pushNamed(
                                                                              CommentRecipeWidget.routeName,
                                                                              queryParameters: {
                                                                                'docref': serializeParam(
                                                                                  listViewPostsRecord.reference,
                                                                                  ParamType.DocumentReference,
                                                                                ),
                                                                                'reciperef': serializeParam(
                                                                                  listViewPostsRecord.recipeRef,
                                                                                  ParamType.DocumentReference,
                                                                                ),
                                                                                'userref': serializeParam(
                                                                                  listViewPostsRecord.postUser,
                                                                                  ParamType.DocumentReference,
                                                                                ),
                                                                              }.withoutNulls,
                                                                            );
                                                                          } else {
                                                                            context.pushNamed(
                                                                              CommentWidget.routeName,
                                                                              queryParameters: {
                                                                                'docref': serializeParam(
                                                                                  listViewPostsRecord.reference,
                                                                                  ParamType.DocumentReference,
                                                                                ),
                                                                                'userref': serializeParam(
                                                                                  listViewPostsRecord.postUser,
                                                                                  ParamType.DocumentReference,
                                                                                ),
                                                                              }.withoutNulls,
                                                                            );
                                                                          }
                                                                        },
                                                                      ),
                                                                      ToggleIcon(
                                                                        onPressed:
                                                                            () async {
                                                                          final userCookedThisElement =
                                                                              currentUserReference;
                                                                          final userCookedThisUpdate = listViewPostsRecord.userCookedThis.contains(userCookedThisElement)
                                                                              ? FieldValue.arrayRemove([
                                                                                  userCookedThisElement
                                                                                ])
                                                                              : FieldValue.arrayUnion([
                                                                                  userCookedThisElement
                                                                                ]);
                                                                          await listViewPostsRecord
                                                                              .reference
                                                                              .update({
                                                                            ...mapToFirestore(
                                                                              {
                                                                                'userCookedThis': userCookedThisUpdate,
                                                                              },
                                                                            ),
                                                                          });
                                                                          if (listViewPostsRecord.userCookedThis.contains(currentUserReference) ==
                                                                              true) {
                                                                            await listViewPostsRecord.reference.update({
                                                                              ...mapToFirestore(
                                                                                {
                                                                                  'userCookedThis': FieldValue.arrayRemove([
                                                                                    currentUserReference
                                                                                  ]),
                                                                                },
                                                                              ),
                                                                            });
                                                                            _model.cookedthisdoc =
                                                                                await queryNotificationsRecordOnce(
                                                                              parent: listViewPostsRecord.postUser,
                                                                              queryBuilder: (notificationsRecord) => notificationsRecord
                                                                                  .where(
                                                                                    'type',
                                                                                    isEqualTo: 'cookedThis',
                                                                                  )
                                                                                  .where(
                                                                                    'post',
                                                                                    isEqualTo: listViewPostsRecord.reference,
                                                                                  )
                                                                                  .where(
                                                                                    'fromUser',
                                                                                    isEqualTo: currentUserReference,
                                                                                  ),
                                                                              singleRecord: true,
                                                                            ).then((s) => s.firstOrNull);
                                                                            if (_model.cookedthisdoc?.seen ==
                                                                                false) {
                                                                              await listViewPostsRecord.postUser!.update({
                                                                                ...mapToFirestore(
                                                                                  {
                                                                                    'unseenNotifications': FieldValue.increment(-(1)),
                                                                                  },
                                                                                ),
                                                                              });
                                                                            }
                                                                            await _model.cookedthisdoc!.reference.delete();
                                                                          } else {
                                                                            await listViewPostsRecord.reference.update({
                                                                              ...mapToFirestore(
                                                                                {
                                                                                  'userCookedThis': FieldValue.arrayUnion([
                                                                                    currentUserReference
                                                                                  ]),
                                                                                },
                                                                              ),
                                                                            });

                                                                            await NotificationsRecord.createDoc(listViewPostsRecord.postUser!).set(createNotificationsRecordData(
                                                                              type: 'cookedThis',
                                                                              fromUser: currentUserReference,
                                                                              post: listViewPostsRecord.reference,
                                                                              createdAt: getCurrentTimestamp,
                                                                              seen: false,
                                                                            ));

                                                                            await listViewPostsRecord.postUser!.update({
                                                                              ...mapToFirestore(
                                                                                {
                                                                                  'unseenNotifications': FieldValue.increment(1),
                                                                                },
                                                                              ),
                                                                            });
                                                                          }

                                                                          safeSetState(
                                                                              () {});
                                                                        },
                                                                        value: listViewPostsRecord
                                                                            .userCookedThis
                                                                            .contains(currentUserReference),
                                                                        onIcon:
                                                                            Icon(
                                                                          Icons
                                                                              .cookie,
                                                                          color:
                                                                              FlutterFlowTheme.of(context).primary,
                                                                          size:
                                                                              24.0,
                                                                        ),
                                                                        offIcon:
                                                                            Icon(
                                                                          Icons
                                                                              .cookie_outlined,
                                                                          color:
                                                                              FlutterFlowTheme.of(context).secondaryText,
                                                                          size:
                                                                              24.0,
                                                                        ),
                                                                      ),
                                                                      Text(
                                                                        'cooked this!',
                                                                        style: FlutterFlowTheme.of(context)
                                                                            .bodyMedium
                                                                            .override(
                                                                              fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                                                                              letterSpacing: 0.0,
                                                                              fontWeight: FontWeight.bold,
                                                                              useGoogleFonts: !FlutterFlowTheme.of(context).bodyMediumIsCustom,
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
                                                  ),
                                                );
                                              },
                                            ),
                                          ),
                                        ),
                              ),
                            ),
                          if ((_model.hasPosts == false) || !loggedIn)
                            Opacity(
                              opacity: 0.7,
                              child: Align(
                                alignment: AlignmentDirectional(0.0, -1.0),
                                child: Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      0.0, 240.0, 0.0, 0.0),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(8.0),
                                    child: Image.asset(
                                      'assets/images/ChatGPT_Image_May_2,_2025_at_02_15_40_PM.png',
                                      width: 180.0,
                                      height: 180.0,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          if ((_model.hasPosts == false) || !loggedIn)
                            Align(
                              alignment: AlignmentDirectional(0.0, -1.0),
                              child: Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    0.0, 460.0, 0.0, 0.0),
                                child: Text(
                                  'follow friends or share your first dish',
                                  style: FlutterFlowTheme.of(context)
                                      .bodyMedium
                                      .override(
                                        fontFamily: FlutterFlowTheme.of(context)
                                            .bodyMediumFamily,
                                        letterSpacing: 0.0,
                                        useGoogleFonts:
                                            !FlutterFlowTheme.of(context)
                                                .bodyMediumIsCustom,
                                      ),
                                ),
                              ),
                            ),
                          if ((_model.hasPosts == false) || !loggedIn)
                            Align(
                              alignment: AlignmentDirectional(0.0, -1.0),
                              child: Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    0.0, 430.0, 0.0, 0.0),
                                child: Text(
                                  'your food feed is empty!',
                                  style: FlutterFlowTheme.of(context)
                                      .titleLarge
                                      .override(
                                        fontFamily: FlutterFlowTheme.of(context)
                                            .titleLargeFamily,
                                        fontSize: 18.0,
                                        letterSpacing: 0.0,
                                        fontWeight: FontWeight.bold,
                                        useGoogleFonts:
                                            !FlutterFlowTheme.of(context)
                                                .titleLargeIsCustom,
                                      ),
                                ),
                              ),
                            ),
                          Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(
                                5.0, 170.0, 0.0, 0.0),
                            child: Text(
                              'feed',
                              style: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .override(
                                    fontFamily: FlutterFlowTheme.of(context)
                                        .bodyMediumFamily,
                                    color: FlutterFlowTheme.of(context).accent3,
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
                    ),
                    Padding(
                      padding:
                          EdgeInsetsDirectional.fromSTEB(5.0, 15.0, 5.0, 0.0),
                      child: Container(
                        width: double.infinity,
                        height: 49.3,
                        decoration: BoxDecoration(
                          color:
                              FlutterFlowTheme.of(context).secondaryBackground,
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
                        child: Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(
                              5.0, 0.0, 5.0, 0.0),
                          child: InkWell(
                            splashColor: Colors.transparent,
                            focusColor: Colors.transparent,
                            hoverColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            onTap: () async {
                              context
                                  .pushNamed(SearchDirectory2Widget.routeName);
                            },
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      10.0, 0.0, 0.0, 0.0),
                                  child: Icon(
                                    Icons.search,
                                    color: FlutterFlowTheme.of(context).primary,
                                    size: 24.0,
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      5.0, 0.0, 0.0, 0.0),
                                  child: InkWell(
                                    splashColor: Colors.transparent,
                                    focusColor: Colors.transparent,
                                    hoverColor: Colors.transparent,
                                    highlightColor: Colors.transparent,
                                    onTap: () async {
                                      context.pushNamed(
                                          SearchDirectory2Widget.routeName);
                                    },
                                    child: Text(
                                      'search for members, recipes... ',
                                      style: FlutterFlowTheme.of(context)
                                          .bodyLarge
                                          .override(
                                            fontFamily:
                                                FlutterFlowTheme.of(context)
                                                    .bodyLargeFamily,
                                            color: FlutterFlowTheme.of(context)
                                                .primary,
                                            letterSpacing: 0.0,
                                            fontWeight: FontWeight.bold,
                                            useGoogleFonts:
                                                !FlutterFlowTheme.of(context)
                                                    .bodyLargeIsCustom,
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
                    Padding(
                      padding:
                          EdgeInsetsDirectional.fromSTEB(0.0, 95.0, 0.0, 0.0),
                      child: StreamBuilder<List<FeaturedListsRecord>>(
                        stream: queryFeaturedListsRecord(),
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
                          List<FeaturedListsRecord> rowFeaturedListsRecordList =
                              snapshot.data!;

                          return SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              children: List.generate(
                                  rowFeaturedListsRecordList.length,
                                  (rowIndex) {
                                final rowFeaturedListsRecord =
                                    rowFeaturedListsRecordList[rowIndex];
                                return Container(
                                  width: 135.0,
                                  height: 135.0,
                                  child: Stack(
                                    alignment: AlignmentDirectional(0.0, 0.0),
                                    children: [
                                      InkWell(
                                        splashColor: Colors.transparent,
                                        focusColor: Colors.transparent,
                                        hoverColor: Colors.transparent,
                                        highlightColor: Colors.transparent,
                                        onTap: () async {
                                          context.pushNamed(
                                            FeaturedListWidget.routeName,
                                            queryParameters: {
                                              'categorydocref': serializeParam(
                                                rowFeaturedListsRecord
                                                    .reference,
                                                ParamType.DocumentReference,
                                              ),
                                            }.withoutNulls,
                                          );
                                        },
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(5.0),
                                          child: Image.network(
                                            'https://images.weserv.nl/?url=${rowFeaturedListsRecord.image}',
                                            width: 120.0,
                                            height: 120.0,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                            0.0, 65.0, 0.0, 0.0),
                                        child: Container(
                                          width: 140.0,
                                          height: 18.0,
                                          decoration: BoxDecoration(
                                            color: FlutterFlowTheme.of(context)
                                                .secondaryBackground,
                                          ),
                                          child: Align(
                                            alignment:
                                                AlignmentDirectional(0.0, 0.0),
                                            child: Padding(
                                              padding: EdgeInsetsDirectional
                                                  .fromSTEB(0.0, 0.0, 0.0, 2.0),
                                              child: Text(
                                                rowFeaturedListsRecord.title,
                                                style: FlutterFlowTheme.of(
                                                        context)
                                                    .bodyMedium
                                                    .override(
                                                      fontFamily:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .bodyMediumFamily,
                                                      color:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .customColor3,
                                                      fontSize: 12.0,
                                                      letterSpacing: 0.0,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      useGoogleFonts:
                                                          !FlutterFlowTheme.of(
                                                                  context)
                                                              .bodyMediumIsCustom,
                                                    ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }),
                            ),
                          );
                        },
                      ),
                    ),
                    Padding(
                      padding:
                          EdgeInsetsDirectional.fromSTEB(0.0, 75.0, 0.0, 0.0),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(
                                5.0, 0.0, 0.0, 0.0),
                            child: Text(
                              'featured lists',
                              style: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .override(
                                    fontFamily: FlutterFlowTheme.of(context)
                                        .bodyMediumFamily,
                                    color: FlutterFlowTheme.of(context).accent3,
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
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
