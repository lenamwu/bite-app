import '/auth/firebase_auth/auth_util.dart';
import '/backend/backend.dart';
import '/components/notificationcomp_widget.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import '/index.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collection/collection.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:provider/provider.dart';
import 'notification_model.dart';
export 'notification_model.dart';
import '/components/bite_logo.dart';

class NotificationWidget extends StatefulWidget {
  const NotificationWidget({super.key});

  static String routeName = 'notification';
  static String routePath = '/notification';

  @override
  State<NotificationWidget> createState() => _NotificationWidgetState();
}

class _NotificationWidgetState extends State<NotificationWidget> {
  late NotificationModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => NotificationModel());

    // On page load action.
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      await currentUserReference!.update(createUsersRecordData(
        unseenNotifications: 0,
      ));
      _model.unseennotifs = await queryNotificationsRecordOnce(
        parent: currentUserReference,
        queryBuilder: (notificationsRecord) => notificationsRecord.where(
          'seen',
          isEqualTo: false,
        ),
      );
      for (int loop1Index = 0;
          loop1Index < _model.unseennotifs!.length;
          loop1Index++) {
        final currentLoop1Item = _model.unseennotifs![loop1Index];

        await currentLoop1Item.reference.update(createNotificationsRecordData(
          seen: true,
        ));
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
          title: Stack(
            children: [
              Align(
                alignment: AlignmentDirectional(-1.0, -1.0),
                child: BiteLogo(),
              ),
            ],
          ),
          actions: [],
          centerTitle: false,
          elevation: 2.0,
        ),
        body: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (valueOrDefault<bool>(currentUserDocument?.isPrivate, false))
                AuthUserStreamWidget(
                  builder: (context) => Container(
                    height: 50.0,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Color(0x1A030303),
                        width: 2.0,
                      ),
                    ),
                    child: FutureBuilder<int>(
                      future: queryFollowRequestsRecordCount(
                        parent: currentUserReference,
                        queryBuilder: (followRequestsRecord) =>
                            followRequestsRecord.where(
                          'status',
                          isEqualTo: 'pending',
                        ),
                      ),
                      builder: (context, snapshot) {
                        // Customize what your widget looks like when it's loading.
                        if (!snapshot.hasData) {
                          return Center(
                            child: SizedBox(
                              width: 20.0,
                              height: 20.0,
                              child: CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  FlutterFlowTheme.of(context).primary,
                                ),
                              ),
                            ),
                          );
                        }
                        int rowCount = snapshot.data!;

                        return InkWell(
                          splashColor: Colors.transparent,
                          focusColor: Colors.transparent,
                          hoverColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          onTap: () async {
                            context
                                .pushNamed(FollowRequestpageWidget.routeName);
                          },
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    12.0, 0.0, 0.0, 0.0),
                                child: RichText(
                                  textScaler: MediaQuery.of(context).textScaler,
                                  text: TextSpan(
                                    children: [
                                      TextSpan(
                                        text: rowCount.toString(),
                                        style: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .override(
                                              fontFamily:
                                                  FlutterFlowTheme.of(context)
                                                      .bodyMediumFamily,
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .accent3,
                                              fontSize: 16.0,
                                              letterSpacing: 0.0,
                                              fontWeight: FontWeight.w600,
                                              useGoogleFonts:
                                                  !FlutterFlowTheme.of(context)
                                                      .bodyMediumIsCustom,
                                            ),
                                      ),
                                      TextSpan(
                                        text: ' follow requests',
                                        style: FlutterFlowTheme.of(context)
                                            .labelLarge
                                            .override(
                                              fontFamily:
                                                  FlutterFlowTheme.of(context)
                                                      .labelLargeFamily,
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .accent3,
                                              letterSpacing: 0.0,
                                              fontWeight: FontWeight.w600,
                                              useGoogleFonts:
                                                  !FlutterFlowTheme.of(context)
                                                      .labelLargeIsCustom,
                                            ),
                                      )
                                    ],
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
                                  ),
                                ),
                              ),
                              Align(
                                alignment: AlignmentDirectional(1.0, 0.0),
                                child: Icon(
                                  Icons.chevron_right_rounded,
                                  color: FlutterFlowTheme.of(context).accent3,
                                  size: 34.0,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ),
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(0.0, 10.0, 0.0, 0.0),
                child: PagedListView<DocumentSnapshot<Object?>?,
                    NotificationsRecord>(
                  pagingController: _model.setListViewController(
                      NotificationsRecord.collection(currentUserReference)
                          .orderBy('createdAt', descending: true),
                      parent: currentUserReference),
                  padding: EdgeInsets.zero,
                  primary: false,
                  shrinkWrap: true,
                  reverse: false,
                  scrollDirection: Axis.vertical,
                  builderDelegate:
                      PagedChildBuilderDelegate<NotificationsRecord>(
                    // Customize what your widget looks like when it's loading the first page.
                    firstPageProgressIndicatorBuilder: (_) => Center(
                      child: SizedBox(
                        width: 30.0,
                        height: 30.0,
                        child: SpinKitFadingGrid(
                          color: FlutterFlowTheme.of(context).tertiary,
                          size: 30.0,
                        ),
                      ),
                    ),
                    // Customize what your widget looks like when it's loading another page.
                    newPageProgressIndicatorBuilder: (_) => Center(
                      child: SizedBox(
                        width: 30.0,
                        height: 30.0,
                        child: SpinKitFadingGrid(
                          color: FlutterFlowTheme.of(context).tertiary,
                          size: 30.0,
                        ),
                      ),
                    ),
                    noItemsFoundIndicatorBuilder: (_) =>
                        NotificationcompWidget(),
                    itemBuilder: (context, _, listViewIndex) {
                      final listViewNotificationsRecord = _model
                          .listViewPagingController!.itemList![listViewIndex];
                      return StreamBuilder<UsersRecord>(
                        stream: UsersRecord.getDocument(
                            listViewNotificationsRecord.fromUser!),
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

                          return InkWell(
                            splashColor: Colors.transparent,
                            focusColor: Colors.transparent,
                            hoverColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            onTap: () async {
                              await listViewNotificationsRecord.reference
                                  .update(createNotificationsRecordData(
                                seen: true,
                              ));
                            },
                            child: Column(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                if ((listViewNotificationsRecord.type ==
                                        'comment') &&
                                    (columnUsersRecord.displayName != null &&
                                        columnUsersRecord.displayName != ''))
                                  Align(
                                    alignment: AlignmentDirectional(-1.0, 0.0),
                                    child: Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          0.0, 0.0, 10.0, 10.0),
                                      child: SingleChildScrollView(
                                        scrollDirection: Axis.horizontal,
                                        child: Row(
                                          mainAxisSize: MainAxisSize.max,
                                          children: [
                                            Align(
                                              alignment: AlignmentDirectional(
                                                  -1.0, 0.0),
                                              child: Padding(
                                                padding: EdgeInsetsDirectional
                                                    .fromSTEB(
                                                        10.0, 0.0, 10.0, 0.0),
                                                child: InkWell(
                                                  splashColor:
                                                      Colors.transparent,
                                                  focusColor:
                                                      Colors.transparent,
                                                  hoverColor:
                                                      Colors.transparent,
                                                  highlightColor:
                                                      Colors.transparent,
                                                  onTap: () async {
                                                    if (listViewNotificationsRecord
                                                            .fromUser ==
                                                        currentUserReference) {
                                                      context.pushNamed(
                                                          ProfilePage2Widget
                                                              .routeName);
                                                    } else {
                                                      context.pushNamed(
                                                        SearchedProfilePageWidget
                                                            .routeName,
                                                        queryParameters: {
                                                          'profileparameters':
                                                              serializeParam(
                                                            listViewNotificationsRecord
                                                                .fromUser,
                                                            ParamType
                                                                .DocumentReference,
                                                          ),
                                                        }.withoutNulls,
                                                      );
                                                    }
                                                  },
                                                  child: Container(
                                                    width: 40.0,
                                                    height: 40.0,
                                                    clipBehavior:
                                                        Clip.antiAlias,
                                                    decoration: BoxDecoration(
                                                      shape: BoxShape.circle,
                                                    ),
                                                    child: columnUsersRecord.photoUrl.isNotEmpty
                                                        ? Image.network(
                                                            columnUsersRecord.photoUrl,
                                                            fit: BoxFit.cover,
                                                            errorBuilder: (context, error, stackTrace) => Image.asset(
                                                              'assets/images/prof_pic.jpg',
                                                              fit: BoxFit.cover,
                                                            ),
                                                          )
                                                        : Image.asset(
                                                            'assets/images/prof_pic.jpg',
                                                            width: 40.0,
                                                            height: 40.0,
                                                            fit: BoxFit.cover,
                                                          ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            if (listViewNotificationsRecord
                                                    .fromUser !=
                                                currentUserReference)
                                              InkWell(
                                                splashColor: Colors.transparent,
                                                focusColor: Colors.transparent,
                                                hoverColor: Colors.transparent,
                                                highlightColor:
                                                    Colors.transparent,
                                                onTap: () async {
                                                  if (listViewNotificationsRecord
                                                          .fromUser ==
                                                      currentUserReference) {
                                                    context.pushNamed(
                                                        ProfilePage2Widget
                                                            .routeName);
                                                  } else {
                                                    context.pushNamed(
                                                      SearchedProfilePageWidget
                                                          .routeName,
                                                      queryParameters: {
                                                        'profileparameters':
                                                            serializeParam(
                                                          listViewNotificationsRecord
                                                              .fromUser,
                                                          ParamType
                                                              .DocumentReference,
                                                        ),
                                                      }.withoutNulls,
                                                    );
                                                  }
                                                },
                                                child: Text(
                                                  columnUsersRecord.displayName,
                                                  style:
                                                      FlutterFlowTheme.of(
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
                                                                !FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodyMediumIsCustom,
                                                          ),
                                                ),
                                              ),
                                            if (listViewNotificationsRecord
                                                    .fromUser ==
                                                currentUserReference)
                                              InkWell(
                                                splashColor: Colors.transparent,
                                                focusColor: Colors.transparent,
                                                hoverColor: Colors.transparent,
                                                highlightColor:
                                                    Colors.transparent,
                                                onTap: () async {
                                                  context.pushNamed(
                                                      ProfilePage2Widget
                                                          .routeName);
                                                },
                                                child: Text(
                                                  'you',
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
                                              ),
                                            RichText(
                                              textScaler: MediaQuery.of(context)
                                                  .textScaler,
                                              text: TextSpan(
                                                children: [
                                                  TextSpan(
                                                    text: ' commented \"',
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
                                                              FontWeight.normal,
                                                          useGoogleFonts:
                                                              !FlutterFlowTheme
                                                                      .of(context)
                                                                  .bodyMediumIsCustom,
                                                        ),
                                                  ),
                                                  TextSpan(
                                                    text:
                                                        listViewNotificationsRecord
                                                            .commentText,
                                                    style: FlutterFlowTheme.of(
                                                            context)
                                                        .bodyMedium
                                                        .override(
                                                          fontFamily:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .bodyMediumFamily,
                                                          letterSpacing: 0.0,
                                                          useGoogleFonts:
                                                              !FlutterFlowTheme
                                                                      .of(context)
                                                                  .bodyMediumIsCustom,
                                                        ),
                                                  ),
                                                  TextSpan(
                                                    text: '\" on this ',
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
                                                          useGoogleFonts:
                                                              !FlutterFlowTheme
                                                                      .of(context)
                                                                  .bodyMediumIsCustom,
                                                        ),
                                                  )
                                                ],
                                                style:
                                                    FlutterFlowTheme.of(context)
                                                        .bodyMedium
                                                        .override(
                                                          fontFamily:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .bodyMediumFamily,
                                                          letterSpacing: 0.0,
                                                          useGoogleFonts:
                                                              !FlutterFlowTheme
                                                                      .of(context)
                                                                  .bodyMediumIsCustom,
                                                        ),
                                              ),
                                              maxLines: 5,
                                            ),
                                            InkWell(
                                              splashColor: Colors.transparent,
                                              focusColor: Colors.transparent,
                                              hoverColor: Colors.transparent,
                                              highlightColor:
                                                  Colors.transparent,
                                              onTap: () async {
                                                _model.notificationpost1 =
                                                    await PostsRecord
                                                        .getDocumentOnce(
                                                            listViewNotificationsRecord
                                                                .post!);
                                                if (_model.notificationpost1
                                                        ?.hasRecipe ==
                                                    true) {
                                                  _model.reciperead1 =
                                                      await RecipesRecord
                                                          .getDocumentOnce(_model
                                                              .notificationpost1!
                                                              .recipeRef!);

                                                  context.pushNamed(
                                                    CommentRecipeWidget
                                                        .routeName,
                                                    queryParameters: {
                                                      'docref': serializeParam(
                                                        _model.reciperead1
                                                            ?.postId,
                                                        ParamType
                                                            .DocumentReference,
                                                      ),
                                                      'reciperef':
                                                          serializeParam(
                                                        _model.reciperead1
                                                            ?.reference,
                                                        ParamType
                                                            .DocumentReference,
                                                      ),
                                                      'userref': serializeParam(
                                                        _model.reciperead1
                                                            ?.userId,
                                                        ParamType
                                                            .DocumentReference,
                                                      ),
                                                    }.withoutNulls,
                                                  );
                                                } else {
                                                  context.pushNamed(
                                                    CommentWidget.routeName,
                                                    queryParameters: {
                                                      'docref': serializeParam(
                                                        listViewNotificationsRecord
                                                            .post,
                                                        ParamType
                                                            .DocumentReference,
                                                      ),
                                                      'userref': serializeParam(
                                                        currentUserReference,
                                                        ParamType
                                                            .DocumentReference,
                                                      ),
                                                    }.withoutNulls,
                                                  );
                                                }

                                                safeSetState(() {});
                                              },
                                              child: Text(
                                                'post ',
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
                                                              .accent3,
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
                                            Text(
                                              dateTimeFormat(
                                                "relative",
                                                listViewNotificationsRecord
                                                    .createdAt!,
                                                locale:
                                                    FFLocalizations.of(context)
                                                        .languageCode,
                                              ),
                                              style:
                                                  FlutterFlowTheme.of(context)
                                                      .bodyMedium
                                                      .override(
                                                        fontFamily:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .bodyMediumFamily,
                                                        fontSize: 12.0,
                                                        letterSpacing: 0.0,
                                                        useGoogleFonts:
                                                            !FlutterFlowTheme
                                                                    .of(context)
                                                                .bodyMediumIsCustom,
                                                      ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                if ((listViewNotificationsRecord.type ==
                                        'like') &&
                                    (columnUsersRecord.displayName != null &&
                                        columnUsersRecord.displayName != ''))
                                  Align(
                                    alignment: AlignmentDirectional(-1.0, 0.0),
                                    child: Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          0.0, 0.0, 10.0, 10.0),
                                      child: SingleChildScrollView(
                                        scrollDirection: Axis.horizontal,
                                        child: Row(
                                          mainAxisSize: MainAxisSize.max,
                                          children: [
                                            Align(
                                              alignment: AlignmentDirectional(
                                                  -1.0, 0.0),
                                              child: Padding(
                                                padding: EdgeInsetsDirectional
                                                    .fromSTEB(
                                                        10.0, 0.0, 10.0, 0.0),
                                                child: InkWell(
                                                  splashColor:
                                                      Colors.transparent,
                                                  focusColor:
                                                      Colors.transparent,
                                                  hoverColor:
                                                      Colors.transparent,
                                                  highlightColor:
                                                      Colors.transparent,
                                                  onTap: () async {
                                                    if (listViewNotificationsRecord
                                                            .fromUser ==
                                                        currentUserReference) {
                                                      context.pushNamed(
                                                          ProfilePage2Widget
                                                              .routeName);
                                                    } else {
                                                      context.pushNamed(
                                                        SearchedProfilePageWidget
                                                            .routeName,
                                                        queryParameters: {
                                                          'profileparameters':
                                                              serializeParam(
                                                            listViewNotificationsRecord
                                                                .fromUser,
                                                            ParamType
                                                                .DocumentReference,
                                                          ),
                                                        }.withoutNulls,
                                                      );
                                                    }
                                                  },
                                                  child: Container(
                                                    width: 40.0,
                                                    height: 40.0,
                                                    clipBehavior:
                                                        Clip.antiAlias,
                                                    decoration: BoxDecoration(
                                                      shape: BoxShape.circle,
                                                    ),
                                                    child: columnUsersRecord.photoUrl.isNotEmpty
                                                        ? Image.network(
                                                            columnUsersRecord.photoUrl,
                                                            fit: BoxFit.cover,
                                                            errorBuilder: (context, error, stackTrace) => Image.asset(
                                                              'assets/images/prof_pic.jpg',
                                                              fit: BoxFit.cover,
                                                            ),
                                                          )
                                                        : Image.asset(
                                                            'assets/images/prof_pic.jpg',
                                                            width: 40.0,
                                                            height: 40.0,
                                                            fit: BoxFit.cover,
                                                          ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            if (listViewNotificationsRecord
                                                    .fromUser !=
                                                currentUserReference)
                                              Padding(
                                                padding: EdgeInsetsDirectional
                                                    .fromSTEB(
                                                        1.0, 0.0, 0.0, 0.0),
                                                child: InkWell(
                                                  splashColor:
                                                      Colors.transparent,
                                                  focusColor:
                                                      Colors.transparent,
                                                  hoverColor:
                                                      Colors.transparent,
                                                  highlightColor:
                                                      Colors.transparent,
                                                  onTap: () async {
                                                    if (listViewNotificationsRecord
                                                            .fromUser ==
                                                        currentUserReference) {
                                                      context.pushNamed(
                                                          ProfilePage2Widget
                                                              .routeName);
                                                    } else {
                                                      context.pushNamed(
                                                        SearchedProfilePageWidget
                                                            .routeName,
                                                        queryParameters: {
                                                          'profileparameters':
                                                              serializeParam(
                                                            listViewNotificationsRecord
                                                                .fromUser,
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
                                                ),
                                              ),
                                            if (listViewNotificationsRecord
                                                    .fromUser ==
                                                currentUserReference)
                                              InkWell(
                                                splashColor: Colors.transparent,
                                                focusColor: Colors.transparent,
                                                hoverColor: Colors.transparent,
                                                highlightColor:
                                                    Colors.transparent,
                                                onTap: () async {
                                                  context.pushNamed(
                                                      ProfilePage2Widget
                                                          .routeName);
                                                },
                                                child: Text(
                                                  'you',
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
                                              ),
                                            Text(
                                              ' liked your ',
                                              style: FlutterFlowTheme.of(
                                                      context)
                                                  .bodyMedium
                                                  .override(
                                                    fontFamily:
                                                        FlutterFlowTheme.of(
                                                                context)
                                                            .bodyMediumFamily,
                                                    color: FlutterFlowTheme.of(
                                                            context)
                                                        .accent3,
                                                    letterSpacing: 0.0,
                                                    useGoogleFonts:
                                                        !FlutterFlowTheme.of(
                                                                context)
                                                            .bodyMediumIsCustom,
                                                  ),
                                            ),
                                            InkWell(
                                              splashColor: Colors.transparent,
                                              focusColor: Colors.transparent,
                                              hoverColor: Colors.transparent,
                                              highlightColor:
                                                  Colors.transparent,
                                              onTap: () async {
                                                _model.notificationpost2 =
                                                    await PostsRecord
                                                        .getDocumentOnce(
                                                            listViewNotificationsRecord
                                                                .post!);
                                                if (_model.notificationpost1
                                                        ?.hasRecipe ==
                                                    true) {
                                                  _model.reciperead2 =
                                                      await RecipesRecord
                                                          .getDocumentOnce(_model
                                                              .notificationpost3!
                                                              .recipeRef!);

                                                  context.pushNamed(
                                                    CommentRecipeWidget
                                                        .routeName,
                                                    queryParameters: {
                                                      'docref': serializeParam(
                                                        _model.reciperead2
                                                            ?.postId,
                                                        ParamType
                                                            .DocumentReference,
                                                      ),
                                                      'reciperef':
                                                          serializeParam(
                                                        _model.reciperead2
                                                            ?.reference,
                                                        ParamType
                                                            .DocumentReference,
                                                      ),
                                                      'userref': serializeParam(
                                                        _model.reciperead2
                                                            ?.userId,
                                                        ParamType
                                                            .DocumentReference,
                                                      ),
                                                    }.withoutNulls,
                                                  );
                                                } else {
                                                  context.pushNamed(
                                                    CommentWidget.routeName,
                                                    queryParameters: {
                                                      'docref': serializeParam(
                                                        listViewNotificationsRecord
                                                            .post,
                                                        ParamType
                                                            .DocumentReference,
                                                      ),
                                                      'userref': serializeParam(
                                                        currentUserReference,
                                                        ParamType
                                                            .DocumentReference,
                                                      ),
                                                    }.withoutNulls,
                                                  );
                                                }

                                                safeSetState(() {});
                                              },
                                              child: Text(
                                                'post ',
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
                                                              .accent3,
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
                                            Text(
                                              dateTimeFormat(
                                                "relative",
                                                listViewNotificationsRecord
                                                    .createdAt!,
                                                locale:
                                                    FFLocalizations.of(context)
                                                        .languageCode,
                                              ),
                                              style:
                                                  FlutterFlowTheme.of(context)
                                                      .bodyMedium
                                                      .override(
                                                        fontFamily:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .bodyMediumFamily,
                                                        fontSize: 12.0,
                                                        letterSpacing: 0.0,
                                                        useGoogleFonts:
                                                            !FlutterFlowTheme
                                                                    .of(context)
                                                                .bodyMediumIsCustom,
                                                      ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                if ((listViewNotificationsRecord.type ==
                                        'cookedThis') &&
                                    (columnUsersRecord.displayName != null &&
                                        columnUsersRecord.displayName != ''))
                                  Align(
                                    alignment: AlignmentDirectional(-1.0, 0.0),
                                    child: Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          0.0, 0.0, 10.0, 10.0),
                                      child: SingleChildScrollView(
                                        scrollDirection: Axis.horizontal,
                                        child: Row(
                                          mainAxisSize: MainAxisSize.max,
                                          children: [
                                            Align(
                                              alignment: AlignmentDirectional(
                                                  -1.0, 0.0),
                                              child: Padding(
                                                padding: EdgeInsetsDirectional
                                                    .fromSTEB(
                                                        10.0, 0.0, 10.0, 0.0),
                                                child: InkWell(
                                                  splashColor:
                                                      Colors.transparent,
                                                  focusColor:
                                                      Colors.transparent,
                                                  hoverColor:
                                                      Colors.transparent,
                                                  highlightColor:
                                                      Colors.transparent,
                                                  onTap: () async {
                                                    if (listViewNotificationsRecord
                                                            .fromUser ==
                                                        currentUserReference) {
                                                      context.pushNamed(
                                                          ProfilePage2Widget
                                                              .routeName);
                                                    } else {
                                                      context.pushNamed(
                                                        SearchedProfilePageWidget
                                                            .routeName,
                                                        queryParameters: {
                                                          'profileparameters':
                                                              serializeParam(
                                                            listViewNotificationsRecord
                                                                .fromUser,
                                                            ParamType
                                                                .DocumentReference,
                                                          ),
                                                        }.withoutNulls,
                                                      );
                                                    }
                                                  },
                                                  child: Container(
                                                    width: 40.0,
                                                    height: 40.0,
                                                    clipBehavior:
                                                        Clip.antiAlias,
                                                    decoration: BoxDecoration(
                                                      shape: BoxShape.circle,
                                                    ),
                                                    child: columnUsersRecord.photoUrl.isNotEmpty
                                                        ? Image.network(
                                                            columnUsersRecord.photoUrl,
                                                            fit: BoxFit.cover,
                                                            errorBuilder: (context, error, stackTrace) => Image.asset(
                                                              'assets/images/prof_pic.jpg',
                                                              fit: BoxFit.cover,
                                                            ),
                                                          )
                                                        : Image.asset(
                                                            'assets/images/prof_pic.jpg',
                                                            width: 40.0,
                                                            height: 40.0,
                                                            fit: BoxFit.cover,
                                                          ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            if (listViewNotificationsRecord
                                                    .fromUser !=
                                                currentUserReference)
                                              InkWell(
                                                splashColor: Colors.transparent,
                                                focusColor: Colors.transparent,
                                                hoverColor: Colors.transparent,
                                                highlightColor:
                                                    Colors.transparent,
                                                onTap: () async {
                                                  if (listViewNotificationsRecord
                                                          .fromUser ==
                                                      currentUserReference) {
                                                    context.pushNamed(
                                                        ProfilePage2Widget
                                                            .routeName);
                                                  } else {
                                                    context.pushNamed(
                                                      SearchedProfilePageWidget
                                                          .routeName,
                                                      queryParameters: {
                                                        'profileparameters':
                                                            serializeParam(
                                                          listViewNotificationsRecord
                                                              .fromUser,
                                                          ParamType
                                                              .DocumentReference,
                                                        ),
                                                      }.withoutNulls,
                                                    );
                                                  }
                                                },
                                                child: Text(
                                                  columnUsersRecord.displayName,
                                                  style:
                                                      FlutterFlowTheme.of(
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
                                                                !FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodyMediumIsCustom,
                                                          ),
                                                ),
                                              ),
                                            if (listViewNotificationsRecord
                                                    .fromUser ==
                                                currentUserReference)
                                              InkWell(
                                                splashColor: Colors.transparent,
                                                focusColor: Colors.transparent,
                                                hoverColor: Colors.transparent,
                                                highlightColor:
                                                    Colors.transparent,
                                                onTap: () async {
                                                  context.pushNamed(
                                                      ProfilePage2Widget
                                                          .routeName);
                                                },
                                                child: Text(
                                                  'you',
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
                                              ),
                                            Text(
                                              '  cooked your ',
                                              style: FlutterFlowTheme.of(
                                                      context)
                                                  .bodyMedium
                                                  .override(
                                                    fontFamily:
                                                        FlutterFlowTheme.of(
                                                                context)
                                                            .bodyMediumFamily,
                                                    color: FlutterFlowTheme.of(
                                                            context)
                                                        .accent3,
                                                    letterSpacing: 0.0,
                                                    useGoogleFonts:
                                                        !FlutterFlowTheme.of(
                                                                context)
                                                            .bodyMediumIsCustom,
                                                  ),
                                            ),
                                            InkWell(
                                              splashColor: Colors.transparent,
                                              focusColor: Colors.transparent,
                                              hoverColor: Colors.transparent,
                                              highlightColor:
                                                  Colors.transparent,
                                              onTap: () async {
                                                _model.notificationpost3 =
                                                    await PostsRecord
                                                        .getDocumentOnce(
                                                            listViewNotificationsRecord
                                                                .post!);
                                                if (_model.notificationpost3
                                                        ?.hasRecipe ==
                                                    true) {
                                                  _model.reciperead3 =
                                                      await RecipesRecord
                                                          .getDocumentOnce(_model
                                                              .notificationpost3!
                                                              .recipeRef!);

                                                  context.pushNamed(
                                                    CommentRecipeWidget
                                                        .routeName,
                                                    queryParameters: {
                                                      'docref': serializeParam(
                                                        _model.reciperead3
                                                            ?.postId,
                                                        ParamType
                                                            .DocumentReference,
                                                      ),
                                                      'reciperef':
                                                          serializeParam(
                                                        _model.reciperead3
                                                            ?.reference,
                                                        ParamType
                                                            .DocumentReference,
                                                      ),
                                                      'userref': serializeParam(
                                                        _model.reciperead3
                                                            ?.userId,
                                                        ParamType
                                                            .DocumentReference,
                                                      ),
                                                    }.withoutNulls,
                                                  );
                                                } else {
                                                  context.pushNamed(
                                                    CommentWidget.routeName,
                                                    queryParameters: {
                                                      'docref': serializeParam(
                                                        listViewNotificationsRecord
                                                            .post,
                                                        ParamType
                                                            .DocumentReference,
                                                      ),
                                                      'userref': serializeParam(
                                                        currentUserReference,
                                                        ParamType
                                                            .DocumentReference,
                                                      ),
                                                    }.withoutNulls,
                                                  );
                                                }

                                                safeSetState(() {});
                                              },
                                              child: Text(
                                                'recipe ',
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
                                                              .accent3,
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
                                            Text(
                                              dateTimeFormat(
                                                "relative",
                                                listViewNotificationsRecord
                                                    .createdAt!,
                                                locale:
                                                    FFLocalizations.of(context)
                                                        .languageCode,
                                              ),
                                              style:
                                                  FlutterFlowTheme.of(context)
                                                      .bodyMedium
                                                      .override(
                                                        fontFamily:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .bodyMediumFamily,
                                                        fontSize: 12.0,
                                                        letterSpacing: 0.0,
                                                        useGoogleFonts:
                                                            !FlutterFlowTheme
                                                                    .of(context)
                                                                .bodyMediumIsCustom,
                                                      ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                if ((listViewNotificationsRecord.type ==
                                        'follow') &&
                                    (columnUsersRecord.displayName != null &&
                                        columnUsersRecord.displayName != ''))
                                  Align(
                                    alignment: AlignmentDirectional(-1.0, 0.0),
                                    child: Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          0.0, 0.0, 10.0, 10.0),
                                      child: SingleChildScrollView(
                                        scrollDirection: Axis.horizontal,
                                        child: Row(
                                          mainAxisSize: MainAxisSize.max,
                                          children: [
                                            Align(
                                              alignment: AlignmentDirectional(
                                                  -1.0, 0.0),
                                              child: Padding(
                                                padding: EdgeInsetsDirectional
                                                    .fromSTEB(
                                                        10.0, 0.0, 10.0, 0.0),
                                                child: InkWell(
                                                  splashColor:
                                                      Colors.transparent,
                                                  focusColor:
                                                      Colors.transparent,
                                                  hoverColor:
                                                      Colors.transparent,
                                                  highlightColor:
                                                      Colors.transparent,
                                                  onTap: () async {
                                                    if (listViewNotificationsRecord
                                                            .fromUser ==
                                                        currentUserReference) {
                                                      context.pushNamed(
                                                          ProfilePage2Widget
                                                              .routeName);
                                                    } else {
                                                      context.pushNamed(
                                                        SearchedProfilePageWidget
                                                            .routeName,
                                                        queryParameters: {
                                                          'profileparameters':
                                                              serializeParam(
                                                            listViewNotificationsRecord
                                                                .fromUser,
                                                            ParamType
                                                                .DocumentReference,
                                                          ),
                                                        }.withoutNulls,
                                                      );
                                                    }
                                                  },
                                                  child: Container(
                                                    width: 40.0,
                                                    height: 40.0,
                                                    clipBehavior:
                                                        Clip.antiAlias,
                                                    decoration: BoxDecoration(
                                                      shape: BoxShape.circle,
                                                    ),
                                                    child: columnUsersRecord.photoUrl.isNotEmpty
                                                        ? Image.network(
                                                            columnUsersRecord.photoUrl,
                                                            fit: BoxFit.cover,
                                                            errorBuilder: (context, error, stackTrace) => Image.asset(
                                                              'assets/images/prof_pic.jpg',
                                                              fit: BoxFit.cover,
                                                            ),
                                                          )
                                                        : Image.asset(
                                                            'assets/images/prof_pic.jpg',
                                                            width: 40.0,
                                                            height: 40.0,
                                                            fit: BoxFit.cover,
                                                          ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding: EdgeInsetsDirectional
                                                  .fromSTEB(1.0, 0.0, 0.0, 0.0),
                                              child: InkWell(
                                                splashColor: Colors.transparent,
                                                focusColor: Colors.transparent,
                                                hoverColor: Colors.transparent,
                                                highlightColor:
                                                    Colors.transparent,
                                                onTap: () async {
                                                  if (listViewNotificationsRecord
                                                          .fromUser ==
                                                      currentUserReference) {
                                                    context.pushNamed(
                                                        ProfilePage2Widget
                                                            .routeName);
                                                  } else {
                                                    context.pushNamed(
                                                      SearchedProfilePageWidget
                                                          .routeName,
                                                      queryParameters: {
                                                        'profileparameters':
                                                            serializeParam(
                                                          listViewNotificationsRecord
                                                              .fromUser,
                                                          ParamType
                                                              .DocumentReference,
                                                        ),
                                                      }.withoutNulls,
                                                    );
                                                  }
                                                },
                                                child: Text(
                                                  columnUsersRecord.displayName,
                                                  style:
                                                      FlutterFlowTheme.of(
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
                                                                !FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodyMediumIsCustom,
                                                          ),
                                                ),
                                              ),
                                            ),
                                            Text(
                                              ' started following you! ',
                                              style: FlutterFlowTheme.of(
                                                      context)
                                                  .bodyMedium
                                                  .override(
                                                    fontFamily:
                                                        FlutterFlowTheme.of(
                                                                context)
                                                            .bodyMediumFamily,
                                                    color: FlutterFlowTheme.of(
                                                            context)
                                                        .accent3,
                                                    letterSpacing: 0.0,
                                                    useGoogleFonts:
                                                        !FlutterFlowTheme.of(
                                                                context)
                                                            .bodyMediumIsCustom,
                                                  ),
                                            ),
                                            Text(
                                              dateTimeFormat(
                                                "relative",
                                                listViewNotificationsRecord
                                                    .createdAt!,
                                                locale:
                                                    FFLocalizations.of(context)
                                                        .languageCode,
                                              ),
                                              style:
                                                  FlutterFlowTheme.of(context)
                                                      .bodyMedium
                                                      .override(
                                                        fontFamily:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .bodyMediumFamily,
                                                        fontSize: 12.0,
                                                        letterSpacing: 0.0,
                                                        useGoogleFonts:
                                                            !FlutterFlowTheme
                                                                    .of(context)
                                                                .bodyMediumIsCustom,
                                                      ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                              ],
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
      ),
    );
  }
}
