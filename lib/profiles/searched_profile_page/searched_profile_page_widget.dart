import '/auth/base_auth_user_provider.dart';
import '/auth/firebase_auth/auth_util.dart';
import '/backend/backend.dart';
import '/components/notificationcomp_widget.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import '/index.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:provider/provider.dart';
import 'searched_profile_page_model.dart';
export 'searched_profile_page_model.dart';
import '/components/bite_logo.dart';

class SearchedProfilePageWidget extends StatefulWidget {
  const SearchedProfilePageWidget({
    super.key,
    required this.profileparameters,
  });

  final DocumentReference? profileparameters;

  static String routeName = 'searched_profile_page';
  static String routePath = '/searchedProfilePage';

  @override
  State<SearchedProfilePageWidget> createState() =>
      _SearchedProfilePageWidgetState();
}

class _SearchedProfilePageWidgetState extends State<SearchedProfilePageWidget>
    with TickerProviderStateMixin {
  late SearchedProfilePageModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => SearchedProfilePageModel());

    // Auth check moved to build method.

    _model.tabBarController1 = TabController(
      vsync: this,
      length: 2,
      initialIndex: 0,
    )..addListener(() => safeSetState(() {}));

    _model.tabBarController2 = TabController(
      vsync: this,
      length: 2,
      initialIndex: 0,
    )..addListener(() => safeSetState(() {}));

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return StreamBuilder<UsersRecord>(
      stream: UsersRecord.getDocument(widget!.profileparameters!),
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

        final searchedProfilePageUsersRecord = snapshot.data!;

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
              title: BiteLogo(),
              actions: [],
              centerTitle: false,
              elevation: 2.0,
            ),
            body: Padding(
              padding: EdgeInsetsDirectional.fromSTEB(0.0, 15.0, 0.0, 0.0),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding:
                        EdgeInsetsDirectional.fromSTEB(20.0, 10.0, 0.0, 0.0),
                    child: Container(
                      height: 113.91,
                      child: Stack(
                        children: [
                          Align(
                            alignment: AlignmentDirectional(-1.0, -1.0),
                            child: Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  90.0, 0.0, 0.0, 0.0),
                              child: Text(
                                searchedProfilePageUsersRecord.displayName,
                                style: FlutterFlowTheme.of(context)
                                    .bodyLarge
                                    .override(
                                      fontFamily: FlutterFlowTheme.of(context)
                                          .bodyLargeFamily,
                                      color:
                                          FlutterFlowTheme.of(context).primary,
                                      fontSize: 18.0,
                                      letterSpacing: 0.0,
                                      fontWeight: FontWeight.bold,
                                      useGoogleFonts:
                                          !FlutterFlowTheme.of(context)
                                              .bodyLargeIsCustom,
                                    ),
                              ),
                            ),
                          ),
                          Align(
                            alignment: AlignmentDirectional(-1.0, -1.0),
                            child: Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  90.0, 22.0, 0.0, 0.0),
                              child: Text(
                                searchedProfilePageUsersRecord.username,
                                style: FlutterFlowTheme.of(context)
                                    .bodyMedium
                                    .override(
                                      fontFamily: FlutterFlowTheme.of(context)
                                          .bodyMediumFamily,
                                      color:
                                          FlutterFlowTheme.of(context).accent1,
                                      letterSpacing: 0.0,
                                      fontWeight: FontWeight.bold,
                                      useGoogleFonts:
                                          !FlutterFlowTheme.of(context)
                                              .bodyMediumIsCustom,
                                    ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(
                                90.0, 44.0, 0.0, 0.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    InkWell(
                                      splashColor: Colors.transparent,
                                      focusColor: Colors.transparent,
                                      hoverColor: Colors.transparent,
                                      highlightColor: Colors.transparent,
                                      onTap: () async {
                                        if (searchedProfilePageUsersRecord
                                                .usersFollowingMe.isNotEmpty) {
                                          context.pushNamed(
                                            FollowerslistWidget.routeName,
                                            queryParameters: {
                                              'followerslist': serializeParam(
                                                searchedProfilePageUsersRecord
                                                    .usersFollowingMe,
                                                ParamType.DocumentReference,
                                                isList: true,
                                              ),
                                            }.withoutNulls,
                                          );
                                        }
                                      },
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(
                                            formatNumber(
                                              searchedProfilePageUsersRecord
                                                  .usersFollowingMe.length,
                                              formatType: FormatType.compact,
                                            ),
                                            style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                  fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                                                  color: FlutterFlowTheme.of(context).tertiary,
                                                  fontSize: 16.0,
                                                  letterSpacing: 0.0,
                                                  fontWeight: FontWeight.bold,
                                                  useGoogleFonts: !FlutterFlowTheme.of(context).bodyMediumIsCustom,
                                                ),
                                          ),
                                          const SizedBox(width: 4.0),
                                          Text(
                                            'followers',
                                            style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                  fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                                                  color: FlutterFlowTheme.of(context).secondaryText,
                                                  fontSize: 16.0,
                                                  letterSpacing: 0.0,
                                                  useGoogleFonts: !FlutterFlowTheme.of(context).bodyMediumIsCustom,
                                                ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(width: 12.0),
                                    InkWell(
                                      splashColor: Colors.transparent,
                                      focusColor: Colors.transparent,
                                      hoverColor: Colors.transparent,
                                      highlightColor: Colors.transparent,
                                      onTap: () async {
                                        if (searchedProfilePageUsersRecord
                                                .followingUsers.isNotEmpty) {
                                          context.pushNamed(
                                            FollowinglistWidget.routeName,
                                            queryParameters: {
                                              'followinglist': serializeParam(
                                                searchedProfilePageUsersRecord
                                                    .followingUsers,
                                                ParamType.DocumentReference,
                                                isList: true,
                                              ),
                                            }.withoutNulls,
                                          );
                                        }
                                      },
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(
                                            formatNumber(
                                              searchedProfilePageUsersRecord
                                                  .followingUsers.length,
                                              formatType: FormatType.compact,
                                            ),
                                            style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                  fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                                                  color: FlutterFlowTheme.of(context).tertiary,
                                                  fontSize: 16.0,
                                                  letterSpacing: 0.0,
                                                  fontWeight: FontWeight.bold,
                                                  useGoogleFonts: !FlutterFlowTheme.of(context).bodyMediumIsCustom,
                                                ),
                                          ),
                                          const SizedBox(width: 4.0),
                                          Text(
                                            'following',
                                            style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                  fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                                                  color: FlutterFlowTheme.of(context).secondaryText,
                                                  fontSize: 16.0,
                                                  letterSpacing: 0.0,
                                                  useGoogleFonts: !FlutterFlowTheme.of(context).bodyMediumIsCustom,
                                                ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                if (searchedProfilePageUsersRecord.location.isNotEmpty)
                                  Padding(
                                    padding: const EdgeInsets.only(top: 4.0),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(
                                          Icons.location_on_outlined,
                                          size: 16.0,
                                          color: FlutterFlowTheme.of(context).secondaryText,
                                        ),
                                        const SizedBox(width: 2.0),
                                        Text(
                                          searchedProfilePageUsersRecord.location,
                                          style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                                                color: FlutterFlowTheme.of(context).secondaryText,
                                                fontSize: 16.0,
                                                letterSpacing: 0.0,
                                                useGoogleFonts: !FlutterFlowTheme.of(context).bodyMediumIsCustom,
                                              ),
                                        ),
                                      ],
                                    ),
                                  ),
                              ],
                            ),
                          ),
                          Align(
                            alignment: AlignmentDirectional(-1.0, -1.0),
                            child: ClipRRect(
                                borderRadius: BorderRadius.circular(50.0),
                                child: CachedNetworkImage(
                                  fadeInDuration: Duration(milliseconds: 500),
                                  fadeOutDuration: Duration(milliseconds: 500),
                                  imageUrl:
                                      searchedProfilePageUsersRecord.photoUrl,
                                  width: 72.0,
                                  height: 72.0,
                                  fit: BoxFit.cover,
                                  errorWidget: (context, error, stackTrace) =>
                                      Image.asset(
                                    'assets/images/error_image.png',
                                    width: 72.0,
                                    height: 72.0,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding:
                        EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 10.0),
                    child: StreamBuilder<List<FollowRequestsRecord>>(
                      stream: queryFollowRequestsRecord(
                        parent: searchedProfilePageUsersRecord.reference,
                        queryBuilder: (followRequestsRecord) =>
                            followRequestsRecord.where(
                          'fromUserId',
                          isEqualTo: currentUserReference,
                        ),
                        singleRecord: true,
                      ),
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
                        List<FollowRequestsRecord> rowFollowRequestsRecordList =
                            snapshot.data!;
                        final rowFollowRequestsRecord =
                            rowFollowRequestsRecordList.isNotEmpty
                                ? rowFollowRequestsRecordList.first
                                : null;

                        return Row(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            if ((rowFollowRequestsRecord?.reference == null) &&
                                !(currentUserDocument?.followingUsers
                                            ?.toList() ??
                                        [])
                                    .contains(searchedProfilePageUsersRecord
                                        .reference))
                              Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    20.0, 0.0, 0.0, 0.0),
                                child: AuthUserStreamWidget(
                                  builder: (context) => FFButtonWidget(
                                    onPressed: () async {
                                      if (searchedProfilePageUsersRecord
                                              .isPrivate ==
                                          true) {
                                        var followRequestsRecordReference =
                                            FollowRequestsRecord.createDoc(
                                                searchedProfilePageUsersRecord
                                                    .reference);
                                        await followRequestsRecordReference
                                            .set(createFollowRequestsRecordData(
                                          fromUserId: currentUserReference,
                                          status: 'pending',
                                          createdAt: getCurrentTimestamp,
                                        ));
                                        _model.iclickedfollow = FollowRequestsRecord
                                            .getDocumentFromData(
                                                createFollowRequestsRecordData(
                                                  fromUserId:
                                                      currentUserReference,
                                                  status: 'pending',
                                                  createdAt:
                                                      getCurrentTimestamp,
                                                ),
                                                followRequestsRecordReference);

                                        var notificationsRecordReference1 =
                                            NotificationsRecord.createDoc(
                                                searchedProfilePageUsersRecord
                                                    .reference);
                                        await notificationsRecordReference1
                                            .set(createNotificationsRecordData(
                                          type: 'followRequest',
                                          fromUser: currentUserReference,
                                          createdAt: getCurrentTimestamp,
                                          seen: false,
                                        ));
                                        _model.followreqnotification =
                                            NotificationsRecord.getDocumentFromData(
                                                createNotificationsRecordData(
                                                  type: 'followRequest',
                                                  fromUser:
                                                      currentUserReference,
                                                  createdAt:
                                                      getCurrentTimestamp,
                                                  seen: false,
                                                ),
                                                notificationsRecordReference1);

                                        await searchedProfilePageUsersRecord
                                            .reference
                                            .update({
                                          ...mapToFirestore(
                                            {
                                              'unseenNotifications':
                                                  FieldValue.increment(1),
                                            },
                                          ),
                                        });
                                      } else {
                                        await searchedProfilePageUsersRecord
                                            .reference
                                            .update({
                                          ...mapToFirestore(
                                            {
                                              'users_following_me':
                                                  FieldValue.arrayUnion(
                                                      [currentUserReference]),
                                            },
                                          ),
                                        });

                                        await currentUserReference!.update({
                                          ...mapToFirestore(
                                            {
                                              'following_users':
                                                  FieldValue.arrayUnion([
                                                searchedProfilePageUsersRecord
                                                    .reference
                                              ]),
                                            },
                                          ),
                                        });

                                        var notificationsRecordReference2 =
                                            NotificationsRecord.createDoc(
                                                searchedProfilePageUsersRecord
                                                    .reference);
                                        await notificationsRecordReference2
                                            .set(createNotificationsRecordData(
                                          type: 'follow',
                                          fromUser: currentUserReference,
                                          createdAt: getCurrentTimestamp,
                                          seen: false,
                                        ));
                                        _model.follownotification =
                                            NotificationsRecord.getDocumentFromData(
                                                createNotificationsRecordData(
                                                  type: 'follow',
                                                  fromUser:
                                                      currentUserReference,
                                                  createdAt:
                                                      getCurrentTimestamp,
                                                  seen: false,
                                                ),
                                                notificationsRecordReference2);

                                        await searchedProfilePageUsersRecord
                                            .reference
                                            .update({
                                          ...mapToFirestore(
                                            {
                                              'unseenNotifications':
                                                  FieldValue.increment(1),
                                            },
                                          ),
                                        });
                                      }

                                      safeSetState(() {});
                                    },
                                    text: 'follow',
                                    options: FFButtonOptions(
                                      height: 40.0,
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          16.0, 0.0, 16.0, 0.0),
                                      iconPadding:
                                          EdgeInsetsDirectional.fromSTEB(
                                              0.0, 0.0, 0.0, 0.0),
                                      color: FlutterFlowTheme.of(context)
                                          .primaryBackground,
                                      textStyle: FlutterFlowTheme.of(context)
                                          .titleSmall
                                          .override(
                                            fontFamily:
                                                FlutterFlowTheme.of(context)
                                                    .titleSmallFamily,
                                            color: FlutterFlowTheme.of(context)
                                                .primary,
                                            letterSpacing: 0.0,
                                            useGoogleFonts:
                                                !FlutterFlowTheme.of(context)
                                                    .titleSmallIsCustom,
                                          ),
                                      elevation: 0.0,
                                      borderSide: BorderSide(
                                        color: FlutterFlowTheme.of(context)
                                            .primary,
                                        width: 2.0,
                                      ),
                                      borderRadius: BorderRadius.circular(8.0),
                                    ),
                                  ),
                                ),
                              ),
                            if ((currentUserDocument?.followingUsers
                                            ?.toList() ??
                                        [])
                                    .contains(searchedProfilePageUsersRecord
                                        .reference) ||
                                ((rowFollowRequestsRecord?.reference != null) &&
                                    (rowFollowRequestsRecord?.status ==
                                        'accepted')))
                              Align(
                                alignment: AlignmentDirectional(-1.0, -1.0),
                                child: Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      10.0, 0.0, 0.0, 0.0),
                                  child: AuthUserStreamWidget(
                                    builder: (context) => FFButtonWidget(
                                      onPressed: () async {
                                        await searchedProfilePageUsersRecord
                                            .reference
                                            .update({
                                          ...mapToFirestore(
                                            {
                                              'users_following_me':
                                                  FieldValue.arrayRemove(
                                                      [currentUserReference]),
                                            },
                                          ),
                                        });

                                        await currentUserReference!.update({
                                          ...mapToFirestore(
                                            {
                                              'following_users':
                                                  FieldValue.arrayRemove([
                                                searchedProfilePageUsersRecord
                                                    .reference
                                              ]),
                                            },
                                          ),
                                        });
                                        if (searchedProfilePageUsersRecord
                                                .isPrivate ==
                                            true) {
                                          if (_model.followreqnotification
                                                  ?.seen ==
                                              false) {
                                            await searchedProfilePageUsersRecord
                                                .reference
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
                                          await rowFollowRequestsRecord!
                                              .reference
                                              .delete();
                                          await _model
                                              .followreqnotification!.reference
                                              .delete();
                                        } else {
                                          if (_model.follownotification?.seen ==
                                              false) {
                                            await searchedProfilePageUsersRecord
                                                .reference
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
                                              .follownotification!.reference
                                              .delete();
                                        }
                                      },
                                      text: 'unfollow',
                                      options: FFButtonOptions(
                                        height: 40.0,
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                            16.0, 0.0, 16.0, 0.0),
                                        iconPadding:
                                            EdgeInsetsDirectional.fromSTEB(
                                                0.0, 0.0, 0.0, 0.0),
                                        color: FlutterFlowTheme.of(context)
                                            .primaryBackground,
                                        textStyle: FlutterFlowTheme.of(context)
                                            .titleSmall
                                            .override(
                                              fontFamily:
                                                  FlutterFlowTheme.of(context)
                                                      .titleSmallFamily,
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .primary,
                                              letterSpacing: 0.0,
                                              useGoogleFonts:
                                                  !FlutterFlowTheme.of(context)
                                                      .titleSmallIsCustom,
                                            ),
                                        elevation: 0.0,
                                        borderSide: BorderSide(
                                          color: FlutterFlowTheme.of(context)
                                              .primary,
                                          width: 2.0,
                                        ),
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            if ((rowFollowRequestsRecord?.status ==
                                    'pending') &&
                                (rowFollowRequestsRecord?.reference != null))
                              Align(
                                alignment: AlignmentDirectional(-1.0, -1.0),
                                child: Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      10.0, 0.0, 0.0, 0.0),
                                  child: FFButtonWidget(
                                    onPressed: () async {
                                      if (_model.followreqnotification?.seen ==
                                          false) {
                                        await searchedProfilePageUsersRecord
                                            .reference
                                            .update({
                                          ...mapToFirestore(
                                            {
                                              'unseenNotifications':
                                                  FieldValue.increment(-(1)),
                                            },
                                          ),
                                        });
                                      }
                                      await rowFollowRequestsRecord!.reference
                                          .delete();
                                      await _model
                                          .followreqnotification!.reference
                                          .delete();
                                    },
                                    text: 'requested',
                                    options: FFButtonOptions(
                                      height: 40.0,
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          16.0, 0.0, 16.0, 0.0),
                                      iconPadding:
                                          EdgeInsetsDirectional.fromSTEB(
                                              0.0, 0.0, 0.0, 0.0),
                                      color: FlutterFlowTheme.of(context)
                                          .primaryBackground,
                                      textStyle: FlutterFlowTheme.of(context)
                                          .titleSmall
                                          .override(
                                            fontFamily:
                                                FlutterFlowTheme.of(context)
                                                    .titleSmallFamily,
                                            color: FlutterFlowTheme.of(context)
                                                .primary,
                                            letterSpacing: 0.0,
                                            useGoogleFonts:
                                                !FlutterFlowTheme.of(context)
                                                    .titleSmallIsCustom,
                                          ),
                                      elevation: 0.0,
                                      borderSide: BorderSide(
                                        color: FlutterFlowTheme.of(context)
                                            .primary,
                                        width: 2.0,
                                      ),
                                      borderRadius: BorderRadius.circular(8.0),
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        );
                      },
                    ),
                  ),
                  if (searchedProfilePageUsersRecord.location.isNotEmpty)
                    Padding(
                      padding: const EdgeInsetsDirectional.fromSTEB(20.0, 0.0, 20.0, 4.0),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.location_on_outlined,
                            size: 14.0,
                            color: FlutterFlowTheme.of(context).secondaryText,
                          ),
                          const SizedBox(width: 2.0),
                          Text(
                            searchedProfilePageUsersRecord.location,
                            style: FlutterFlowTheme.of(context).bodySmall.override(
                                  fontFamily: FlutterFlowTheme.of(context).bodySmallFamily,
                                  color: FlutterFlowTheme.of(context).secondaryText,
                                  letterSpacing: 0.0,
                                  useGoogleFonts: !FlutterFlowTheme.of(context).bodySmallIsCustom,
                                ),
                          ),
                        ],
                      ),
                    ),
                  if ((searchedProfilePageUsersRecord.isPrivate == false) ||
                      ((searchedProfilePageUsersRecord.isPrivate == true) &&
                          searchedProfilePageUsersRecord.usersFollowingMe
                              .contains(currentUserReference)))
                    Expanded(
                      child: Column(
                        children: [
                          Align(
                            alignment: Alignment(0.0, 0),
                            child: TabBar(
                              labelColor: FlutterFlowTheme.of(context).accent3,
                              unselectedLabelColor:
                                  FlutterFlowTheme.of(context).warning,
                              labelStyle: FlutterFlowTheme.of(context)
                                  .bodyLarge
                                  .override(
                                    fontFamily: FlutterFlowTheme.of(context)
                                        .bodyLargeFamily,
                                    letterSpacing: 0.0,
                                    fontWeight: FontWeight.bold,
                                    useGoogleFonts:
                                        !FlutterFlowTheme.of(context)
                                            .bodyLargeIsCustom,
                                  ),
                              unselectedLabelStyle: TextStyle(),
                              indicatorColor:
                                  FlutterFlowTheme.of(context).primary,
                              indicatorWeight: 3.0,
                              tabs: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          0.0, 0.0, 5.0, 0.0),
                                      child: Icon(
                                        Icons.cookie_outlined,
                                        color: FlutterFlowTheme.of(context)
                                            .primary,
                                        size: 30.0,
                                      ),
                                    ),
                                    Tab(
                                      text: 'cookbook',
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          0.0, 0.0, 5.0, 0.0),
                                      child: Icon(
                                        Icons.local_dining,
                                        color: FlutterFlowTheme.of(context)
                                            .primary,
                                      ),
                                    ),
                                    Tab(
                                      text: 'posts',
                                    ),
                                  ],
                                ),
                              ],
                              controller: _model.tabBarController1,
                              onTap: (i) async {
                                [() async {}, () async {}][i]();
                              },
                            ),
                          ),
                          Expanded(
                            child: TabBarView(
                              controller: _model.tabBarController1,
                              children: [
                                Container(
                                  width: 100.0,
                                  height: 100.0,
                                  decoration: BoxDecoration(
                                    color: FlutterFlowTheme.of(context)
                                        .primaryBackground,
                                  ),
                                  child: Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        0.0, 0.0, 0.0, 90.0),
                                    child: PagedListView<
                                        DocumentSnapshot<Object?>?,
                                        PostsRecord>(
                                      pagingController:
                                          _model.setGridViewController1(
                                        PostsRecord.collection
                                            .where(
                                              'postUser',
                                              isEqualTo:
                                                  searchedProfilePageUsersRecord
                                                      .reference,
                                            )
                                            .where(
                                              'has_recipe',
                                              isEqualTo: true,
                                            )
                                            .orderBy('created_time',
                                                descending: true),
                                      ),
                                      padding: EdgeInsets.zero,
                                      scrollDirection: Axis.vertical,
                                      builderDelegate:
                                          PagedChildBuilderDelegate<
                                              PostsRecord>(
                                        firstPageProgressIndicatorBuilder:
                                            (_) => Center(
                                          child: SizedBox(
                                            width: 30.0,
                                            height: 30.0,
                                            child: SpinKitFadingGrid(
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .tertiary,
                                              size: 30.0,
                                            ),
                                          ),
                                        ),
                                        newPageProgressIndicatorBuilder:
                                            (_) => Center(
                                          child: SizedBox(
                                            width: 30.0,
                                            height: 30.0,
                                            child: SpinKitFadingGrid(
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .tertiary,
                                              size: 30.0,
                                            ),
                                          ),
                                        ),
                                        noItemsFoundIndicatorBuilder: (_) =>
                                            NotificationcompWidget(),
                                        itemBuilder:
                                            (context, _, listViewIndex) {
                                          final listViewPostsRecord = _model
                                              .gridViewPagingController1!
                                              .itemList![listViewIndex];
                                          if (listViewPostsRecord.recipeRef == null) {
                                            return SizedBox.shrink();
                                          }
                                          return Padding(
                                            padding: EdgeInsetsDirectional.fromSTEB(
                                                12.0, 8.0, 12.0, 0.0),
                                            child: StreamBuilder<RecipesRecord>(
                                              stream: RecipesRecord.getDocument(
                                                  listViewPostsRecord.recipeRef!),
                                              builder: (context, recipeSnapshot) {
                                                if (!recipeSnapshot.hasData) {
                                                  return SizedBox(
                                                    height: 105.0,
                                                    child: Center(
                                                      child: SizedBox(
                                                        width: 20.0,
                                                        height: 20.0,
                                                        child: SpinKitFadingGrid(
                                                          color: FlutterFlowTheme.of(context).tertiary,
                                                          size: 20.0,
                                                        ),
                                                      ),
                                                    ),
                                                  );
                                                }
                                                final recipeRecord = recipeSnapshot.data!;
                                                // Only show user's own photos, not the public recipe image
                                                final postHasPhoto = listViewPostsRecord.postMultPhotos.isNotEmpty &&
                                                    listViewPostsRecord.postMultPhotos.first.isNotEmpty;
                                                final imageUrl = postHasPhoto
                                                    ? listViewPostsRecord.postMultPhotos.first
                                                    : '';
                                                return InkWell(
                                                  splashColor: Colors.transparent,
                                                  focusColor: Colors.transparent,
                                                  hoverColor: Colors.transparent,
                                                  highlightColor: Colors.transparent,
                                                  onTap: () async {
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
                                                  },
                                                  child: Row(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      ClipRRect(
                                                        borderRadius: BorderRadius.circular(8.0),
                                                        child: imageUrl.isNotEmpty
                                                            ? Image.network(
                                                                imageUrl,
                                                                width: 105.0,
                                                                height: 105.0,
                                                                fit: BoxFit.cover,
                                                                errorBuilder: (context, error, stackTrace) =>
                                                                    Image.asset(
                                                                  'assets/images/error_image.png',
                                                                  width: 105.0,
                                                                  height: 105.0,
                                                                  fit: BoxFit.cover,
                                                                ),
                                                              )
                                                            : SizedBox(
                                                                width: 105.0,
                                                                height: 105.0,
                                                                child: Center(
                                                                  child: FractionallySizedBox(
                                                                    widthFactor: 0.55,
                                                                    heightFactor: 0.55,
                                                                    child: Image.asset(
                                                                      'assets/images/ChatGPT_Image_May_2,_2025_at_02_15_40_PM.png',
                                                                      fit: BoxFit.contain,
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                      ),
                                                      SizedBox(width: 12.0),
                                                      Expanded(
                                                        child: SizedBox(
                                                          height: 105.0,
                                                          child: Column(
                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                            mainAxisAlignment: MainAxisAlignment.start,
                                                            children: [
                                                              SizedBox(height: 2.0),
                                                              Text(
                                                                recipeRecord.title.maybeHandleOverflow(
                                                                  maxChars: 50,
                                                                  replacement: '…',
                                                                ),
                                                                maxLines: 2,
                                                                overflow: TextOverflow.ellipsis,
                                                                style: FlutterFlowTheme.of(context)
                                                                    .titleLarge
                                                                    .override(
                                                                      fontFamily: FlutterFlowTheme.of(context).titleLargeFamily,
                                                                      color: FlutterFlowTheme.of(context).customColor4,
                                                                      fontSize: 14.0,
                                                                      letterSpacing: 0.0,
                                                                      fontWeight: FontWeight.w600,
                                                                      useGoogleFonts: !FlutterFlowTheme.of(context).titleLargeIsCustom,
                                                                    ),
                                                              ),
                                                              SizedBox(height: 6.0),
                                                              Row(
                                                                mainAxisSize: MainAxisSize.min,
                                                                children: [
                                                                  if (recipeRecord.rating > 0)
                                                                    Row(
                                                                      mainAxisSize: MainAxisSize.min,
                                                                      children: [
                                                                        Icon(
                                                                          Icons.star_rounded,
                                                                          color: FlutterFlowTheme.of(context).tertiary,
                                                                          size: 16.0,
                                                                        ),
                                                                        SizedBox(width: 2.0),
                                                                        Text(
                                                                          recipeRecord.rating.toStringAsFixed(1),
                                                                          style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                            fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                                                                            color: FlutterFlowTheme.of(context).secondaryText,
                                                                            fontSize: 12.0,
                                                                            letterSpacing: 0.0,
                                                                            fontWeight: FontWeight.w600,
                                                                            useGoogleFonts: !FlutterFlowTheme.of(context).bodyMediumIsCustom,
                                                                          ),
                                                                        ),
                                                                        SizedBox(width: 10.0),
                                                                      ],
                                                                    ),
                                                                  if (recipeRecord.cookingtime.isNotEmpty)
                                                                    Row(
                                                                      mainAxisSize: MainAxisSize.min,
                                                                      children: [
                                                                        Icon(
                                                                          Icons.access_time_rounded,
                                                                          color: FlutterFlowTheme.of(context).secondaryText,
                                                                          size: 14.0,
                                                                        ),
                                                                        SizedBox(width: 3.0),
                                                                        Text(
                                                                          recipeRecord.cookingtime,
                                                                          style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                            fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                                                                            color: FlutterFlowTheme.of(context).tertiary,
                                                                            fontSize: 12.0,
                                                                            letterSpacing: 0.0,
                                                                            fontWeight: FontWeight.w600,
                                                                            useGoogleFonts: !FlutterFlowTheme.of(context).bodyMediumIsCustom,
                                                                          ),
                                                                        ),
                                                                        SizedBox(width: 10.0),
                                                                      ],
                                                                    ),
                                                                  if (listViewPostsRecord.likes.isNotEmpty)
                                                                    Row(
                                                                      mainAxisSize: MainAxisSize.min,
                                                                      children: [
                                                                        Icon(
                                                                          Icons.favorite_rounded,
                                                                          color: FlutterFlowTheme.of(context).secondary,
                                                                          size: 14.0,
                                                                        ),
                                                                        SizedBox(width: 3.0),
                                                                        Text(
                                                                          listViewPostsRecord.likes.length.toString(),
                                                                          style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                            fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                                                                            color: FlutterFlowTheme.of(context).tertiary,
                                                                            fontSize: 12.0,
                                                                            letterSpacing: 0.0,
                                                                            fontWeight: FontWeight.w600,
                                                                            useGoogleFonts: !FlutterFlowTheme.of(context).bodyMediumIsCustom,
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                ],
                                                              ),
                                                              if (listViewPostsRecord.postText.isNotEmpty)
                                                                Flexible(
                                                                  child: Padding(
                                                                    padding: EdgeInsetsDirectional.fromSTEB(0.0, 4.0, 0.0, 0.0),
                                                                    child: Text(
                                                                      listViewPostsRecord.postText,
                                                                      maxLines: 1,
                                                                      overflow: TextOverflow.ellipsis,
                                                                      style: FlutterFlowTheme.of(context).bodySmall.override(
                                                                        fontFamily: FlutterFlowTheme.of(context).bodySmallFamily,
                                                                        color: FlutterFlowTheme.of(context).tertiary,
                                                                        letterSpacing: 0.0,
                                                                        useGoogleFonts: !FlutterFlowTheme.of(context).bodySmallIsCustom,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                              if (recipeRecord.notes.isNotEmpty)
                                                                Flexible(
                                                                  child: Padding(
                                                                    padding: EdgeInsetsDirectional.fromSTEB(0.0, 2.0, 0.0, 0.0),
                                                                    child: Text(
                                                                      recipeRecord.notes,
                                                                      maxLines: 1,
                                                                      overflow: TextOverflow.ellipsis,
                                                                      style: FlutterFlowTheme.of(context).bodySmall.override(
                                                                        fontFamily: FlutterFlowTheme.of(context).bodySmallFamily,
                                                                        color: FlutterFlowTheme.of(context).accent1,
                                                                        letterSpacing: 0.0,
                                                                        useGoogleFonts: !FlutterFlowTheme.of(context).bodySmallIsCustom,
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
                                                );
                                              },
                                            ),
                                          );
                                        },
                                      ),
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
                                  child: Align(
                                    alignment: AlignmentDirectional(0.0, -1.0),
                                    child: Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          0.0, 0.0, 0.0, 90.0),
                                      child: LayoutBuilder(
                                      builder: (context, constraints) {
                                        final crossAxisCount = (constraints.maxWidth / 185.0).floor().clamp(2, 6);
                                        return PagedGridView<
                                          DocumentSnapshot<Object?>?,
                                          PostsRecord>(
                                        pagingController:
                                            _model.setGridViewController2(
                                          PostsRecord.collection
                                              .where(
                                                'postUser',
                                                isEqualTo:
                                                    searchedProfilePageUsersRecord
                                                        .reference,
                                              )
                                              .where(
                                                'has_recipe',
                                                isEqualTo: false,
                                              )
                                              .orderBy('created_time',
                                                  descending: true),
                                        ),
                                        padding: EdgeInsets.zero,
                                        gridDelegate:
                                            SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount: crossAxisCount,
                                          childAspectRatio: 0.85,
                                        ),
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
                                                color:
                                                    FlutterFlowTheme.of(context)
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
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .tertiary,
                                                size: 30.0,
                                              ),
                                            ),
                                          ),
                                          noItemsFoundIndicatorBuilder: (_) =>
                                              NotificationcompWidget(),
                                          itemBuilder:
                                              (context, _, gridViewIndex) {
                                            final gridViewPostsRecord = _model
                                                .gridViewPagingController2!
                                                .itemList![gridViewIndex];
                                            return Column(
                                              mainAxisSize: MainAxisSize.min,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Padding(
                                                  padding:
                                                      EdgeInsetsDirectional
                                                          .fromSTEB(5.0, 5.0,
                                                              5.0, 2.0),
                                                  child: AspectRatio(
                                                    aspectRatio: 1.0,
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
                                                        if (gridViewPostsRecord
                                                            .hasRecipe) {
                                                          context.pushNamed(
                                                            CommentRecipeWidget
                                                                .routeName,
                                                            queryParameters: {
                                                              'docref':
                                                                  serializeParam(
                                                                gridViewPostsRecord
                                                                    .reference,
                                                                ParamType
                                                                    .DocumentReference,
                                                              ),
                                                              'reciperef':
                                                                  serializeParam(
                                                                gridViewPostsRecord
                                                                    .recipeRef,
                                                                ParamType
                                                                    .DocumentReference,
                                                              ),
                                                              'userref':
                                                                  serializeParam(
                                                                gridViewPostsRecord
                                                                    .postUser,
                                                                ParamType
                                                                    .DocumentReference,
                                                              ),
                                                            }.withoutNulls,
                                                          );
                                                        } else {
                                                          context.pushNamed(
                                                            CommentWidget
                                                                .routeName,
                                                            queryParameters: {
                                                              'docref':
                                                                  serializeParam(
                                                                gridViewPostsRecord
                                                                    .reference,
                                                                ParamType
                                                                    .DocumentReference,
                                                              ),
                                                              'userref':
                                                                  serializeParam(
                                                                gridViewPostsRecord
                                                                    .postUser,
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
                                                                .circular(0.0),
                                                        child: (gridViewPostsRecord.postMultPhotos.isNotEmpty &&
                                                                gridViewPostsRecord.postMultPhotos.first.isNotEmpty)
                                                            ? Image.network(
                                                                gridViewPostsRecord
                                                                    .postMultPhotos
                                                                    .first,
                                                                width:
                                                                    double.infinity,
                                                                height:
                                                                    double.infinity,
                                                                fit: BoxFit.cover,
                                                                alignment: Alignment(
                                                                    -1.0, -1.0),
                                                                errorBuilder:
                                                                    (context, error,
                                                                            stackTrace) =>
                                                                        Image.asset(
                                                                  'assets/images/error_image.png',
                                                                  width:
                                                                      double.infinity,
                                                                  height:
                                                                      double.infinity,
                                                                  fit: BoxFit.cover,
                                                                  alignment:
                                                                      Alignment(-1.0,
                                                                          -1.0),
                                                                ),
                                                              )
                                                            : Center(
                                                                child: FractionallySizedBox(
                                                                  widthFactor: 0.55,
                                                                  heightFactor: 0.55,
                                                                  child: Image.asset(
                                                                    'assets/images/ChatGPT_Image_May_2,_2025_at_02_15_40_PM.png',
                                                                    fit: BoxFit.contain,
                                                                  ),
                                                                ),
                                                              ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Flexible(
                                                  child: Padding(
                                                    padding:
                                                        EdgeInsetsDirectional
                                                            .fromSTEB(5.0, 2.0,
                                                                5.0, 2.0),
                                                    child: Text(
                                                      gridViewPostsRecord
                                                          .postText,
                                                      maxLines: 1,
                                                      overflow:
                                                          TextOverflow.ellipsis,
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
                                                                    .tertiary,
                                                            letterSpacing: 0.0,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            useGoogleFonts:
                                                                !FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodyMediumIsCustom,
                                                          ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            );
                                          },
                                        ),
                                      );
                                      },
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  if ((searchedProfilePageUsersRecord.isPrivate == true) &&
                      (searchedProfilePageUsersRecord.usersFollowingMe
                              .contains(currentUserReference) ==
                          false))
                    Expanded(
                      child: Column(
                        children: [
                          Align(
                            alignment: Alignment(0.0, 0),
                            child: TabBar(
                              labelColor: FlutterFlowTheme.of(context).accent3,
                              unselectedLabelColor:
                                  FlutterFlowTheme.of(context).warning,
                              labelStyle: FlutterFlowTheme.of(context)
                                  .bodyLarge
                                  .override(
                                    fontFamily: FlutterFlowTheme.of(context)
                                        .bodyLargeFamily,
                                    letterSpacing: 0.0,
                                    fontWeight: FontWeight.bold,
                                    useGoogleFonts:
                                        !FlutterFlowTheme.of(context)
                                            .bodyLargeIsCustom,
                                  ),
                              unselectedLabelStyle: TextStyle(),
                              indicatorColor:
                                  FlutterFlowTheme.of(context).primary,
                              indicatorWeight: 3.0,
                              tabs: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          0.0, 0.0, 5.0, 0.0),
                                      child: Icon(
                                        Icons.grid_view,
                                        color: FlutterFlowTheme.of(context)
                                            .primary,
                                      ),
                                    ),
                                    Tab(
                                      text: 'posts',
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          0.0, 0.0, 5.0, 0.0),
                                      child: Icon(
                                        Icons.list,
                                        color: FlutterFlowTheme.of(context)
                                            .primary,
                                        size: 30.0,
                                      ),
                                    ),
                                    Tab(
                                      text: 'cookbook',
                                    ),
                                  ],
                                ),
                              ],
                              controller: _model.tabBarController2,
                              onTap: (i) async {
                                [() async {}, () async {}][i]();
                              },
                            ),
                          ),
                          Expanded(
                            child: TabBarView(
                              controller: _model.tabBarController2,
                              children: [
                                Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      0.0, 0.0, 0.0, 80.0),
                                  child: Container(
                                    width: 100.0,
                                    height: 100.0,
                                    decoration: BoxDecoration(
                                      color: FlutterFlowTheme.of(context)
                                          .primaryBackground,
                                    ),
                                    child: Visibility(
                                      visible: (searchedProfilePageUsersRecord
                                                  .isPrivate ==
                                              true) &&
                                          (searchedProfilePageUsersRecord
                                                  .usersFollowingMe
                                                  .contains(
                                                      currentUserReference) ==
                                              false),
                                      child: Align(
                                        alignment:
                                            AlignmentDirectional(0.0, -1.0),
                                        child: Padding(
                                          padding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                  0.0, 90.0, 0.0, 0.0),
                                          child: Column(
                                            mainAxisSize: MainAxisSize.max,
                                            children: [
                                              Text(
                                                'follow user to see posts !',
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
                                              Text(
                                                'private profile ',
                                                style: FlutterFlowTheme.of(
                                                        context)
                                                    .titleSmall
                                                    .override(
                                                      fontFamily:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .titleSmallFamily,
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
                                                              .titleSmallIsCustom,
                                                    ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      0.0, 0.0, 0.0, 80.0),
                                  child: Container(
                                    width: 100.0,
                                    height: 100.0,
                                    decoration: BoxDecoration(
                                      color: FlutterFlowTheme.of(context)
                                          .primaryBackground,
                                    ),
                                    child: Visibility(
                                      visible: (searchedProfilePageUsersRecord
                                                  .isPrivate ==
                                              true) &&
                                          (searchedProfilePageUsersRecord
                                                  .usersFollowingMe
                                                  .contains(
                                                      currentUserReference) ==
                                              false),
                                      child: Align(
                                        alignment:
                                            AlignmentDirectional(0.0, -1.0),
                                        child: Padding(
                                          padding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                  0.0, 90.0, 0.0, 0.0),
                                          child: Column(
                                            mainAxisSize: MainAxisSize.max,
                                            children: [
                                              Text(
                                                'private profile ',
                                                style: FlutterFlowTheme.of(
                                                        context)
                                                    .titleSmall
                                                    .override(
                                                      fontFamily:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .titleSmallFamily,
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
                                                              .titleSmallIsCustom,
                                                    ),
                                              ),
                                              Text(
                                                'follow user to see posts !',
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
                                            ],
                                          ),
                                        ),
                                      ),
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
        );
      },
    );
  }
}
