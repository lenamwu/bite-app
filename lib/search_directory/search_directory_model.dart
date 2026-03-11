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
import 'search_directory_widget.dart' show SearchDirectoryWidget;
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

class SearchDirectoryModel extends FlutterFlowModel<SearchDirectoryWidget> {
  ///  Local state fields for this page.

  String searchKeyword = 'chicken';

  List<dynamic> searchResults = [];
  void addToSearchResults(dynamic item) => searchResults.add(item);
  void removeFromSearchResults(dynamic item) => searchResults.remove(item);
  void removeAtIndexFromSearchResults(int index) =>
      searchResults.removeAt(index);
  void insertAtIndexInSearchResults(int index, dynamic item) =>
      searchResults.insert(index, item);
  void updateSearchResultsAtIndex(int index, Function(dynamic) updateFn) =>
      searchResults[index] = updateFn(searchResults[index]);

  ///  State fields for stateful widgets in this page.

  // State field(s) for TabBar widget.
  TabController? tabBarController;
  int get tabBarCurrentIndex =>
      tabBarController != null ? tabBarController!.index : 0;
  int get tabBarPreviousIndex =>
      tabBarController != null ? tabBarController!.previousIndex : 0;

  // State field(s) for TextField widget.
  FocusNode? textFieldFocusNode1;
  TextEditingController? textController1;
  String? Function(BuildContext, String?)? textController1Validator;
  // Stores action output result for [Backend Call - API (recipe)] action in TextField widget.
  ApiCallResponse? recipeoutput;
  // Stores action output result for [Backend Call - API (test)] action in Button widget.
  ApiCallResponse? actionoutput;
  // Stores action output result for [Firestore Query - Query a collection] action in Button widget.
  RecipesRecord? alrsavedrecipe;
  // Stores action output result for [Backend Call - Create Document] action in Button widget.
  RecipesRecord? newRecipe;
  // Stores action output result for [Backend Call - API (test)] action in Button widget.
  ApiCallResponse? actionoutputcustom2;
  // Stores action output result for [Firestore Query - Query a collection] action in Button widget.
  RecipesRecord? alrsavedrecipe2;
  // Stores action output result for [Backend Call - Create Document] action in Button widget.
  RecipesRecord? newRecipe2;
  // State field(s) for TextField widget.
  final textFieldKey2 = GlobalKey();
  FocusNode? textFieldFocusNode2;
  TextEditingController? textController2;
  String? textFieldSelectedOption2;
  String? Function(BuildContext, String?)? textController2Validator;
  List<UsersRecord> simpleSearchResults = [];

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    tabBarController?.dispose();
    textFieldFocusNode1?.dispose();
    textController1?.dispose();

    textFieldFocusNode2?.dispose();
  }
}
