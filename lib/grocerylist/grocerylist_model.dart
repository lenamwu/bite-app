import '/auth/base_auth_user_provider.dart';
import '/auth/firebase_auth/auth_util.dart';
import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_toggle_icon.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import '/flutter_flow/request_manager.dart';

import '/index.dart';
import 'grocerylist_widget.dart' show GrocerylistWidget;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class GrocerylistModel extends FlutterFlowModel<GrocerylistWidget> {
  ///  State fields for stateful widgets in this page.

  // State field(s) for TextField widget.
  FocusNode? textFieldFocusNode;
  TextEditingController? textController;
  String? Function(BuildContext, String?)? textControllerValidator;

  /// Query cache managers for this widget.

  final _grocerylistManager = StreamRequestManager<List<GroceryListRecord>>();
  Stream<List<GroceryListRecord>> grocerylist({
    String? uniqueQueryKey,
    bool? overrideCache,
    required Stream<List<GroceryListRecord>> Function() requestFn,
  }) =>
      _grocerylistManager.performRequest(
        uniqueQueryKey: uniqueQueryKey,
        overrideCache: overrideCache,
        requestFn: requestFn,
      );
  void clearGrocerylistCache() => _grocerylistManager.clear();
  void clearGrocerylistCacheKey(String? uniqueKey) =>
      _grocerylistManager.clearRequest(uniqueKey);

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    textFieldFocusNode?.dispose();
    textController?.dispose();

    /// Dispose query cache managers for this widget.

    clearGrocerylistCache();
  }
}
