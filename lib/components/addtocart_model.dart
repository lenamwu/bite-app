import '/auth/firebase_auth/auth_util.dart';
import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'addtocart_widget.dart' show AddtocartWidget;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class AddtocartModel extends FlutterFlowModel<AddtocartWidget> {
  late TextEditingController ingredientTextController;
  late FocusNode ingredientFocusNode;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    ingredientTextController.dispose();
    ingredientFocusNode.dispose();
  }
}
