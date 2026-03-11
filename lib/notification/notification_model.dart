import '/auth/firebase_auth/auth_util.dart';
import '/backend/backend.dart';
import '/components/notificationcomp_widget.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import '/flutter_flow/request_manager.dart';

import '/index.dart';
import 'notification_widget.dart' show NotificationWidget;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collection/collection.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:provider/provider.dart';

class NotificationModel extends FlutterFlowModel<NotificationWidget> {
  ///  State fields for stateful widgets in this page.

  // Stores action output result for [Firestore Query - Query a collection] action in notification widget.
  List<NotificationsRecord>? unseennotifs;
  // State field(s) for ListView widget.

  PagingController<DocumentSnapshot?, NotificationsRecord>?
      listViewPagingController;
  Query? listViewPagingQuery;
  List<StreamSubscription?> listViewStreamSubscriptions = [];

  // Stores action output result for [Backend Call - Read Document] action in Text widget.
  PostsRecord? notificationpost1;
  // Stores action output result for [Backend Call - Read Document] action in Text widget.
  RecipesRecord? reciperead1;
  // Stores action output result for [Backend Call - Read Document] action in Text widget.
  PostsRecord? notificationpost2;
  // Stores action output result for [Backend Call - Read Document] action in Text widget.
  RecipesRecord? reciperead2;
  // Stores action output result for [Backend Call - Read Document] action in Text widget.
  PostsRecord? notificationpost3;
  // Stores action output result for [Backend Call - Read Document] action in Text widget.
  RecipesRecord? reciperead3;

  /// Query cache managers for this widget.

  final _notificationsManager =
      StreamRequestManager<List<NotificationsRecord>>();
  Stream<List<NotificationsRecord>> notifications({
    String? uniqueQueryKey,
    bool? overrideCache,
    required Stream<List<NotificationsRecord>> Function() requestFn,
  }) =>
      _notificationsManager.performRequest(
        uniqueQueryKey: uniqueQueryKey,
        overrideCache: overrideCache,
        requestFn: requestFn,
      );
  void clearNotificationsCache() => _notificationsManager.clear();
  void clearNotificationsCacheKey(String? uniqueKey) =>
      _notificationsManager.clearRequest(uniqueKey);

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    listViewStreamSubscriptions.forEach((s) => s?.cancel());
    listViewPagingController?.dispose();

    /// Dispose query cache managers for this widget.

    clearNotificationsCache();
  }

  /// Additional helper methods.
  PagingController<DocumentSnapshot?, NotificationsRecord>
      setListViewController(
    Query query, {
    DocumentReference<Object?>? parent,
  }) {
    listViewPagingController ??= _createListViewController(query, parent);
    if (listViewPagingQuery != query) {
      listViewPagingQuery = query;
      listViewPagingController?.refresh();
    }
    return listViewPagingController!;
  }

  PagingController<DocumentSnapshot?, NotificationsRecord>
      _createListViewController(
    Query query,
    DocumentReference<Object?>? parent,
  ) {
    final controller = PagingController<DocumentSnapshot?, NotificationsRecord>(
        firstPageKey: null);
    return controller
      ..addPageRequestListener(
        (nextPageMarker) => queryNotificationsRecordPage(
          parent: parent,
          queryBuilder: (_) => listViewPagingQuery ??= query,
          nextPageMarker: nextPageMarker,
          streamSubscriptions: listViewStreamSubscriptions,
          controller: controller,
          pageSize: 25,
          isStream: true,
        ),
      );
  }
}
