import '/auth/firebase_auth/auth_util.dart';
import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'addtocart_model.dart';
export 'addtocart_model.dart';

class AddtocartWidget extends StatefulWidget {
  const AddtocartWidget({
    super.key,
    required this.ingredientItem,
  });

  final String? ingredientItem;

  @override
  State<AddtocartWidget> createState() => _AddtocartWidgetState();
}

class _AddtocartWidgetState extends State<AddtocartWidget> {
  late AddtocartModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => AddtocartModel());

    // On component load action.
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      await Future.delayed(
        Duration(
          milliseconds: 2500,
        ),
      );
      Navigator.pop(context);
    });

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 100.0,
      decoration: BoxDecoration(
        color: FlutterFlowTheme.of(context).secondaryBackground,
        boxShadow: [
          BoxShadow(
            blurRadius: 5.0,
            color: Color(0x3B1D2429),
            offset: Offset(
              0.0,
              -3.0,
            ),
          )
        ],
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(0.0),
          bottomRight: Radius.circular(0.0),
          topLeft: Radius.circular(0.0),
          topRight: Radius.circular(0.0),
        ),
      ),
      child: Stack(
        children: [
          Padding(
            padding: EdgeInsetsDirectional.fromSTEB(15.0, 20.0, 15.0, 0.0),
            child: FFButtonWidget(
              onPressed: () async {
                await GroceryListRecord.createDoc(currentUserReference!)
                    .set(createGroceryListRecordData(
                  ingredient: widget!.ingredientItem,
                  completed: false,
                  createdTime: getCurrentTimestamp,
                ));
                Navigator.pop(context);
              },
              text: 'add to cart',
              options: FFButtonOptions(
                width: double.infinity,
                height: 60.0,
                padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                iconPadding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                color: FlutterFlowTheme.of(context).primaryBackground,
                textStyle: FlutterFlowTheme.of(context).bodyLarge.override(
                      fontFamily: FlutterFlowTheme.of(context).bodyLargeFamily,
                      letterSpacing: 0.0,
                      fontWeight: FontWeight.bold,
                      useGoogleFonts:
                          !FlutterFlowTheme.of(context).bodyLargeIsCustom,
                    ),
                elevation: 2.0,
                borderSide: BorderSide(
                  color: FlutterFlowTheme.of(context).primary,
                  width: 2.0,
                ),
              ),
            ),
          ),
          Align(
            alignment: AlignmentDirectional(1.0, -1.0),
            child: FlutterFlowIconButton(
              borderRadius: 8.0,
              buttonSize: 50.0,
              fillColor: FlutterFlowTheme.of(context).primaryBackground,
              icon: Icon(
                Icons.cancel_sharp,
                color: Color(0xFFFF000F),
                size: 35.0,
              ),
              onPressed: () async {
                Navigator.pop(context);
              },
            ),
          ),
        ],
      ),
    );
  }
}
