import '/auth/firebase_auth/auth_util.dart';
import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import '/index.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'followerslist_model.dart';
export 'followerslist_model.dart';
import '/components/bite_logo.dart';

class FollowerslistWidget extends StatefulWidget {
  const FollowerslistWidget({
    super.key,
    required this.followerslist,
  });

  final List<DocumentReference>? followerslist;

  static String routeName = 'followerslist';
  static String routePath = '/followerslist';

  @override
  State<FollowerslistWidget> createState() => _FollowerslistWidgetState();
}

class _FollowerslistWidgetState extends State<FollowerslistWidget> {
  late FollowerslistModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => FollowerslistModel());

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
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(0.0, 10.0, 0.0, 0.0),
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: FlutterFlowTheme.of(context).secondaryBackground,
                    ),
                    child: Visibility(
                      visible: widget!.followerslist != null &&
                          (widget!.followerslist)!.isNotEmpty,
                      child: Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(
                            12.0, 0.0, 0.0, 10.0),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Text(
                              widget!.followerslist!.length.toString(),
                              style: FlutterFlowTheme.of(context)
                                  .titleSmall
                                  .override(
                                    fontFamily: FlutterFlowTheme.of(context)
                                        .titleSmallFamily,
                                    letterSpacing: 0.0,
                                    useGoogleFonts:
                                        !FlutterFlowTheme.of(context)
                                            .titleSmallIsCustom,
                                  ),
                            ),
                            Text(
                              ' followers',
                              style: FlutterFlowTheme.of(context)
                                  .titleSmall
                                  .override(
                                    fontFamily: FlutterFlowTheme.of(context)
                                        .titleSmallFamily,
                                    color: FlutterFlowTheme.of(context).accent3,
                                    letterSpacing: 0.0,
                                    useGoogleFonts:
                                        !FlutterFlowTheme.of(context)
                                            .titleSmallIsCustom,
                                  ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                if (widget!.followerslist != null &&
                    (widget!.followerslist)!.isNotEmpty)
                  Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(0.0, 1.0, 0.0, 0.0),
                    child: Builder(
                      builder: (context) {
                        final followerlist = widget!.followerslist!.toList();

                        return ListView.builder(
                          padding: EdgeInsets.zero,
                          primary: false,
                          shrinkWrap: true,
                          scrollDirection: Axis.vertical,
                          itemCount: followerlist.length,
                          itemBuilder: (context, followerlistIndex) {
                            final followerlistItem =
                                followerlist[followerlistIndex];
                            return Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  0.0, 0.0, 0.0, 1.0),
                              child: StreamBuilder<UsersRecord>(
                                stream:
                                    UsersRecord.getDocument(followerlistItem),
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

                                  final containerUsersRecord = snapshot.data!;

                                  return Container(
                                    width: 100.0,
                                    height: 72.0,
                                    decoration: BoxDecoration(
                                      color: FlutterFlowTheme.of(context)
                                          .secondaryBackground,
                                    ),
                                    child: Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          16.0, 0.0, 16.0, 0.0),
                                      child: InkWell(
                                        splashColor: Colors.transparent,
                                        focusColor: Colors.transparent,
                                        hoverColor: Colors.transparent,
                                        highlightColor: Colors.transparent,
                                        onTap: () async {
                                          if (followerlistItem ==
                                              currentUserReference) {
                                            context.pushNamed(
                                                ProfilePage2Widget.routeName);
                                          } else {
                                            context.pushNamed(
                                              SearchedProfilePageWidget
                                                  .routeName,
                                              queryParameters: {
                                                'profileparameters':
                                                    serializeParam(
                                                  containerUsersRecord
                                                      .reference,
                                                  ParamType.DocumentReference,
                                                ),
                                              }.withoutNulls,
                                            );
                                          }
                                        },
                                        child: Row(
                                          mainAxisSize: MainAxisSize.max,
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Container(
                                              width: 44.0,
                                              height: 44.0,
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                              ),
                                              child: Padding(
                                                padding: EdgeInsets.all(2.0),
                                                child: ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          44.0),
                                                  child: Image.network(
                                                    containerUsersRecord
                                                        .photoUrl,
                                                    width: 44.0,
                                                    height: 44.0,
                                                    fit: BoxFit.cover,
                                                    errorBuilder: (context,
                                                            error,
                                                            stackTrace) =>
                                                        Image.asset(
                                                      'assets/images/error_image.png',
                                                      width: 44.0,
                                                      height: 44.0,
                                                      fit: BoxFit.cover,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Expanded(
                                              child: Padding(
                                                padding: EdgeInsetsDirectional
                                                    .fromSTEB(
                                                        12.0, 0.0, 0.0, 0.0),
                                                child: Column(
                                                  mainAxisSize:
                                                      MainAxisSize.max,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Padding(
                                                      padding:
                                                          EdgeInsetsDirectional
                                                              .fromSTEB(
                                                                  0.0,
                                                                  0.0,
                                                                  0.0,
                                                                  4.0),
                                                      child: Text(
                                                        containerUsersRecord
                                                            .displayName,
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
                                                                  useGoogleFonts:
                                                                      !FlutterFlowTheme.of(
                                                                              context)
                                                                          .bodyLargeIsCustom,
                                                                ),
                                                      ),
                                                    ),
                                                    Text(
                                                      containerUsersRecord
                                                          .username,
                                                      style: FlutterFlowTheme
                                                              .of(context)
                                                          .labelMedium
                                                          .override(
                                                            fontFamily:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .labelMediumFamily,
                                                            letterSpacing: 0.0,
                                                            useGoogleFonts:
                                                                !FlutterFlowTheme.of(
                                                                        context)
                                                                    .labelMediumIsCustom,
                                                          ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            Icon(
                                              Icons.chevron_right_rounded,
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .secondaryText,
                                              size: 24.0,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                },
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
        ),
      ),
    );
  }
}
