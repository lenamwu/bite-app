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
import 'searched_profile_page_widget.dart' show SearchedProfilePageWidget;
import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:provider/provider.dart';

class SearchedProfilePageModel
    extends FlutterFlowModel<SearchedProfilePageWidget> {
  ///  Local state fields for this page.

  String? followingState = '';

  ///  State fields for stateful widgets in this page.

  // Stores action output result for [Backend Call - Create Document] action in Button widget.
  FollowRequestsRecord? iclickedfollow;
  // Stores action output result for [Backend Call - Create Document] action in Button widget.
  NotificationsRecord? followreqnotification;
  // Stores action output result for [Backend Call - Create Document] action in Button widget.
  NotificationsRecord? follownotification;
  // State field(s) for TabBar widget.
  TabController? tabBarController1;
  int get tabBarCurrentIndex1 =>
      tabBarController1 != null ? tabBarController1!.index : 0;
  int get tabBarPreviousIndex1 =>
      tabBarController1 != null ? tabBarController1!.previousIndex : 0;

  // State field(s) for GridView widget.

  PagingController<DocumentSnapshot?, PostsRecord>? gridViewPagingController1;
  Query? gridViewPagingQuery1;
  List<StreamSubscription?> gridViewStreamSubscriptions1 = [];

  // State field(s) for GridView widget.

  PagingController<DocumentSnapshot?, PostsRecord>? gridViewPagingController2;
  Query? gridViewPagingQuery2;
  List<StreamSubscription?> gridViewStreamSubscriptions2 = [];

  // State field(s) for TabBar widget.
  TabController? tabBarController2;
  int get tabBarCurrentIndex2 =>
      tabBarController2 != null ? tabBarController2!.index : 0;
  int get tabBarPreviousIndex2 =>
      tabBarController2 != null ? tabBarController2!.previousIndex : 0;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    tabBarController1?.dispose();
    gridViewStreamSubscriptions1.forEach((s) => s?.cancel());
    gridViewPagingController1?.dispose();

    gridViewStreamSubscriptions2.forEach((s) => s?.cancel());
    gridViewPagingController2?.dispose();

    tabBarController2?.dispose();
  }

  /// Additional helper methods.
  PagingController<DocumentSnapshot?, PostsRecord> setGridViewController1(
    Query query, {
    DocumentReference<Object?>? parent,
  }) {
    gridViewPagingController1 ??= _createGridViewController1(query, parent);
    if (gridViewPagingQuery1 != query) {
      gridViewPagingQuery1 = query;
      gridViewPagingController1?.refresh();
    }
    return gridViewPagingController1!;
  }

  PagingController<DocumentSnapshot?, PostsRecord> _createGridViewController1(
    Query query,
    DocumentReference<Object?>? parent,
  ) {
    final controller =
        PagingController<DocumentSnapshot?, PostsRecord>(firstPageKey: null);
    return controller
      ..addPageRequestListener(
        (nextPageMarker) => queryPostsRecordPage(
          queryBuilder: (_) => gridViewPagingQuery1 ??= query,
          nextPageMarker: nextPageMarker,
          streamSubscriptions: gridViewStreamSubscriptions1,
          controller: controller,
          pageSize: 25,
          isStream: true,
        ),
      );
  }

  PagingController<DocumentSnapshot?, PostsRecord> setGridViewController2(
    Query query, {
    DocumentReference<Object?>? parent,
  }) {
    gridViewPagingController2 ??= _createGridViewController2(query, parent);
    if (gridViewPagingQuery2 != query) {
      gridViewPagingQuery2 = query;
      gridViewPagingController2?.refresh();
    }
    return gridViewPagingController2!;
  }

  PagingController<DocumentSnapshot?, PostsRecord> _createGridViewController2(
    Query query,
    DocumentReference<Object?>? parent,
  ) {
    final controller =
        PagingController<DocumentSnapshot?, PostsRecord>(firstPageKey: null);
    return controller
      ..addPageRequestListener(
        (nextPageMarker) => queryPostsRecordPage(
          queryBuilder: (_) => gridViewPagingQuery2 ??= query,
          nextPageMarker: nextPageMarker,
          streamSubscriptions: gridViewStreamSubscriptions2,
          controller: controller,
          pageSize: 25,
          isStream: true,
        ),
      );
  }
}
