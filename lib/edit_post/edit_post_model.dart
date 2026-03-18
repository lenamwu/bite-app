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
import 'edit_post_widget.dart' show EditPostWidget;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class EditPostModel extends FlutterFlowModel<EditPostWidget> {
  ///  Local state fields for this page.

  List<String> uploadedImages = [];
  void addToUploadedImages(String item) => uploadedImages.add(item);
  void removeFromUploadedImages(String item) => uploadedImages.remove(item);
  void removeAtIndexFromUploadedImages(int index) =>
      uploadedImages.removeAt(index);
  void insertAtIndexInUploadedImages(int index, String item) =>
      uploadedImages.insert(index, item);
  void updateUploadedImagesAtIndex(int index, Function(String) updateFn) =>
      uploadedImages[index] = updateFn(uploadedImages[index]);

  List<FFUploadedFile> localImages = [];
  void addToLocalImages(FFUploadedFile item) => localImages.add(item);
  void removeFromLocalImages(FFUploadedFile item) => localImages.remove(item);
  void removeAtIndexFromLocalImages(int index) => localImages.removeAt(index);
  void insertAtIndexInLocalImages(int index, FFUploadedFile item) =>
      localImages.insert(index, item);
  void updateLocalImagesAtIndex(int index, Function(FFUploadedFile) updateFn) =>
      localImages[index] = updateFn(localImages[index]);

  bool existingRecipe = true;

  ///  State fields for stateful widgets in this page.

  final formKey = GlobalKey<FormState>();
  bool isDataUploading_uploadDataL1m = false;
  List<FFUploadedFile> uploadedLocalFiles_uploadDataL1m = [];
  List<String> uploadedFileUrls_uploadDataL1m = [];

  // State field(s) for addCaption widget.
  FocusNode? addCaptionFocusNode;
  TextEditingController? addCaptionTextController;
  String? Function(BuildContext, String?)? addCaptionTextControllerValidator;
  String? _addCaptionTextControllerValidator(
      BuildContext context, String? val) {
    if (val == null || val.isEmpty) {
      return 'caption is required';
    }

    if (val.length < 3) {
      return 'Requires at least 3 characters.';
    }
    if (val.length > 150) {
      return 'Maximum 150 characters allowed, currently ${val.length}.';
    }

    return null;
  }

  // Stores action output result for [Backend Call - Read Document] action in Container widget.
  RecipesRecord? recipedoc;
  // Stores action output result for [Backend Call - Create Document] action in Button widget.
  RecipesRecord? recipeDocument;

  // Recipe form expand/collapse state.
  bool isRecipeSectionExpanded = false;
  // Whether existing recipe data has been loaded into the form.
  bool recipeDataLoaded = false;

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
