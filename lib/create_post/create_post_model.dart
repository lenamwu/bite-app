import '/auth/base_auth_user_provider.dart';
import '/auth/firebase_auth/auth_util.dart';
import '/backend/backend.dart';
import '/backend/firebase_storage/storage.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/flutter_flow/upload_data.dart';
import '/flutter_flow/form_field_controller.dart';
import '/recipes/ingredient_field/ingredient_field_widget.dart';
import '/recipes/preparation_field/preparation_field_widget.dart';
import 'dart:ui';
import '/index.dart';
import 'create_post_widget.dart' show CreatePostWidget;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class CreatePostModel extends FlutterFlowModel<CreatePostWidget> {
  ///  Local state fields for this page.

  List<String> currentimages = [];
  void addToCurrentimages(String item) => currentimages.add(item);
  void removeFromCurrentimages(String item) => currentimages.remove(item);
  void removeAtIndexFromCurrentimages(int index) =>
      currentimages.removeAt(index);
  void insertAtIndexInCurrentimages(int index, String item) =>
      currentimages.insert(index, item);
  void updateCurrentimagesAtIndex(int index, Function(String) updateFn) =>
      currentimages[index] = updateFn(currentimages[index]);

  ///  State fields for stateful widgets in this page.

  final formKey = GlobalKey<FormState>();
  bool isDataUploading_uploadDatanewpics2 = false;
  List<FFUploadedFile> uploadedLocalFiles_uploadDatanewpics2 = [];
  List<String> uploadedFileUrls_uploadDatanewpics2 = [];

  // State field(s) for addCaption widget.
  FocusNode? addCaptionFocusNode;
  TextEditingController? addCaptionTextController;
  String? Function(BuildContext, String?)? addCaptionTextControllerValidator;
  String? _addCaptionTextControllerValidator(
      BuildContext context, String? val) {
    if (val != null && val.isNotEmpty && val.length > 150) {
      return 'Maximum 150 characters allowed, currently ${val.length}.';
    }
    return null;
  }

  // Stores action output result for [Backend Call - Create Document] action in Button widget.
  PostsRecord? postCreated;
  // Stores action output result for [Backend Call - Create Document] action in Button widget.
  RecipesRecord? recipeDocument;

  // Draft being edited (null if creating fresh).
  DocumentReference? currentDraftRef;

  // Recipe form expand/collapse state.
  bool isRecipeSectionExpanded = false;

  // Recipe form fields.
  final recipeFormKey = GlobalKey<FormState>();
  FocusNode? recipeTextFocusNode;
  TextEditingController? recipeTextTextController;
  String? Function(BuildContext, String?)? recipeTextTextControllerValidator;
  String? _recipeTextTextControllerValidator(
      BuildContext context, String? val) {
    if (val == null || val.isEmpty) {
      return 'recipe name is required';
    }
    if (val.length < 2) {
      return 'Requires at least 2 characters.';
    }
    if (val.length > 50) {
      return 'Maximum 50 characters allowed, currently ${val.length}.';
    }
    return null;
  }

  FocusNode? notesTextFocusNode;
  TextEditingController? notesTextTextController;
  String? Function(BuildContext, String?)? notesTextTextControllerValidator;

  String? cookingtimeValue;
  FormFieldController<String>? cookingtimeValueController;
  String? difficultyValue;
  FormFieldController<String>? difficultyValueController;
  String? servingsValue;
  FormFieldController<String>? servingsValueController;

  late FlutterFlowDynamicModels<IngredientFieldModel> ingredientFieldModels;
  late FlutterFlowDynamicModels<PreparationFieldModel> preparationFieldModels;

  @override
  void initState(BuildContext context) {
    addCaptionTextControllerValidator = _addCaptionTextControllerValidator;
    recipeTextTextControllerValidator = _recipeTextTextControllerValidator;
    ingredientFieldModels =
        FlutterFlowDynamicModels(() => IngredientFieldModel());
    preparationFieldModels =
        FlutterFlowDynamicModels(() => PreparationFieldModel());
  }

  @override
  void dispose() {
    addCaptionFocusNode?.dispose();
    addCaptionTextController?.dispose();
    recipeTextFocusNode?.dispose();
    recipeTextTextController?.dispose();
    notesTextFocusNode?.dispose();
    notesTextTextController?.dispose();
    ingredientFieldModels.dispose();
    preparationFieldModels.dispose();
  }
}
