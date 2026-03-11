import '/auth/base_auth_user_provider.dart';
import '/auth/firebase_auth/auth_util.dart';
import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import '/flutter_flow/request_manager.dart';

import '/index.dart';
import 'recipe_page_widget.dart' show RecipePageWidget;
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class RecipePageModel extends FlutterFlowModel<RecipePageWidget> {
  /// Query cache managers for this widget.

  final _recipesavedManager = StreamRequestManager<List<RecipesRecord>>();
  Stream<List<RecipesRecord>> recipesaved({
    String? uniqueQueryKey,
    bool? overrideCache,
    required Stream<List<RecipesRecord>> Function() requestFn,
  }) =>
      _recipesavedManager.performRequest(
        uniqueQueryKey: uniqueQueryKey,
        overrideCache: overrideCache,
        requestFn: requestFn,
      );
  void clearRecipesavedCache() => _recipesavedManager.clear();
  void clearRecipesavedCacheKey(String? uniqueKey) =>
      _recipesavedManager.clearRequest(uniqueKey);

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    /// Dispose query cache managers for this widget.

    clearRecipesavedCache();
  }
}
