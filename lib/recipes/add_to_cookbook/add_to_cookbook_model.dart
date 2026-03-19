import '/flutter_flow/flutter_flow_util.dart';
import 'add_to_cookbook_widget.dart' show AddToCookbookWidget;
import 'package:flutter/material.dart';

class AddToCookbookModel extends FlutterFlowModel<AddToCookbookWidget> {
  // Caption text field
  FocusNode? captionFocusNode;
  TextEditingController? captionTextController;

  // Image upload state
  bool isDataUploading = false;
  FFUploadedFile uploadedLocalFile = FFUploadedFile(bytes: null);
  String uploadedFileUrl = '';

  // Submitting state
  bool isSubmitting = false;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    captionFocusNode?.dispose();
    captionTextController?.dispose();
  }
}
