import '/auth/firebase_auth/auth_util.dart';
import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

/// A bottom sheet that displays comments for a post and allows adding new ones.
///
/// Usage:
/// ```dart
/// showModalBottomSheet(
///   context: context,
///   isScrollControlled: true,
///   backgroundColor: Colors.transparent,
///   builder: (_) => CommentBottomSheetWidget(postRef: ..., postUserRef: ...),
/// );
/// ```
class CommentBottomSheetWidget extends StatefulWidget {
  const CommentBottomSheetWidget({
    super.key,
    required this.postRef,
    required this.postUserRef,
  });

  final DocumentReference postRef;
  final DocumentReference postUserRef;

  @override
  State<CommentBottomSheetWidget> createState() =>
      _CommentBottomSheetWidgetState();
}

class _CommentBottomSheetWidgetState extends State<CommentBottomSheetWidget> {
  final TextEditingController _textController = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  @override
  void dispose() {
    _textController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  Future<void> _submitComment() async {
    final text = _textController.text.trim();
    if (text.isEmpty) return;

    await CommentsRecord.collection.doc().set(createCommentsRecordData(
          comment: text,
          time: getCurrentTimestamp,
          postref: widget.postRef,
          userref: currentUserReference,
          displayname: currentUserDisplayName,
          profileimage: currentUserPhoto,
        ));

    await NotificationsRecord.createDoc(widget.postUserRef).set(
      createNotificationsRecordData(
        type: 'comment',
        fromUser: currentUserReference,
        post: widget.postRef,
        createdAt: getCurrentTimestamp,
        seen: false,
        commentText: text,
      ),
    );

    await widget.postUserRef.update({
      ...mapToFirestore({
        'unseenNotifications': FieldValue.increment(1),
      }),
    });

    setState(() {
      _textController.clear();
    });
  }

  Future<void> _deleteComment(CommentsRecord comment) async {
    await comment.reference.delete();

    if (comment.postref != null) {
      try {
        final postDoc = await comment.postref!.get();
        if (postDoc.exists) {
          final postUser =
              (postDoc.data() as Map<String, dynamic>?)?['postUser']
                  as DocumentReference?;
          if (postUser != null) {
            final notifQuery = await queryNotificationsRecordOnce(
              parent: postUser,
              queryBuilder: (q) => q
                  .where('type', isEqualTo: 'comment')
                  .where('fromUser', isEqualTo: currentUserReference)
                  .where('post', isEqualTo: comment.postref),
            );
            for (final notif in notifQuery) {
              if (notif.seen == false) {
                await postUser.update(mapToFirestore({
                  'unseenNotifications': FieldValue.increment(-1),
                }));
              }
              await notif.reference.delete();
            }
          }
        }
      } catch (e) {
        // Silently handle cleanup errors
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Container(
      height: MediaQuery.sizeOf(context).height * 0.65,
      decoration: BoxDecoration(
        color: FlutterFlowTheme.of(context).secondaryBackground,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20.0),
          topRight: Radius.circular(20.0),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Drag handle
          Padding(
            padding: const EdgeInsets.only(top: 12.0, bottom: 8.0),
            child: Container(
              width: 40.0,
              height: 4.0,
              decoration: BoxDecoration(
                color: FlutterFlowTheme.of(context).alternate,
                borderRadius: BorderRadius.circular(2.0),
              ),
            ),
          ),
          // Title
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Text(
              'comments',
              style: FlutterFlowTheme.of(context).titleMedium.override(
                    fontFamily:
                        FlutterFlowTheme.of(context).titleMediumFamily,
                    letterSpacing: 0.0,
                    fontWeight: FontWeight.bold,
                    useGoogleFonts:
                        !FlutterFlowTheme.of(context).titleMediumIsCustom,
                  ),
            ),
          ),
          Divider(
            height: 1.0,
            thickness: 1.0,
            color: FlutterFlowTheme.of(context).alternate,
          ),
          // Comment list
          Expanded(
            child: StreamBuilder<List<CommentsRecord>>(
              stream: queryCommentsRecord(
                queryBuilder: (commentsRecord) => commentsRecord
                    .where('postref', isEqualTo: widget.postRef)
                    .orderBy('time', descending: true),
              ),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(
                    child: SizedBox(
                      width: 30.0,
                      height: 30.0,
                      child: SpinKitFadingGrid(
                        color: FlutterFlowTheme.of(context).tertiary,
                        size: 30.0,
                      ),
                    ),
                  );
                }
                final comments = snapshot.data!;
                if (comments.isEmpty) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Text(
                        'no comments yet',
                        style: FlutterFlowTheme.of(context)
                            .bodyMedium
                            .override(
                              fontFamily: FlutterFlowTheme.of(context)
                                  .bodyMediumFamily,
                              color:
                                  FlutterFlowTheme.of(context).secondaryText,
                              letterSpacing: 0.0,
                              fontSize: 16,
                              useGoogleFonts: !FlutterFlowTheme.of(context)
                                  .bodyMediumIsCustom,
                            ),
                      ),
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 12.0),
                  itemCount: comments.length,
                  itemBuilder: (context, index) {
                    final comment = comments[index];
                    return _buildCommentItem(context, comment);
                  },
                );
              },
            ),
          ),
          // Input area
          Divider(
            height: 1.0,
            thickness: 1.0,
            color: FlutterFlowTheme.of(context).alternate,
          ),
          SafeArea(
            top: false,
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _textController,
                      focusNode: _focusNode,
                      autofocus: false,
                      obscureText: false,
                      decoration: InputDecoration(
                        isDense: true,
                        hintText: 'add a comment...',
                        hintStyle: FlutterFlowTheme.of(context)
                            .bodyMedium
                            .override(
                              fontFamily: FlutterFlowTheme.of(context)
                                  .bodyMediumFamily,
                              color: FlutterFlowTheme.of(context).alternate,
                              letterSpacing: 0.0,
                              fontSize: 16,
                              useGoogleFonts: !FlutterFlowTheme.of(context)
                                  .bodyMediumIsCustom,
                            ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: FlutterFlowTheme.of(context).alternate,
                            width: 1.5,
                          ),
                          borderRadius: BorderRadius.circular(24.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: FlutterFlowTheme.of(context).primary,
                            width: 1.5,
                          ),
                          borderRadius: BorderRadius.circular(24.0),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: FlutterFlowTheme.of(context).error,
                            width: 1.5,
                          ),
                          borderRadius: BorderRadius.circular(24.0),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: FlutterFlowTheme.of(context).error,
                            width: 1.5,
                          ),
                          borderRadius: BorderRadius.circular(24.0),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16.0, vertical: 10.0),
                        filled: true,
                        fillColor:
                            FlutterFlowTheme.of(context).primaryBackground,
                      ),
                      style: FlutterFlowTheme.of(context).bodyMedium.override(
                            fontFamily:
                                FlutterFlowTheme.of(context).bodyMediumFamily,
                            letterSpacing: 0.0,
                            useGoogleFonts: !FlutterFlowTheme.of(context)
                                .bodyMediumIsCustom,
                          ),
                    ),
                  ),
                  const SizedBox(width: 8.0),
                  FlutterFlowIconButton(
                    borderRadius: 20.0,
                    buttonSize: 40.0,
                    fillColor: FlutterFlowTheme.of(context).primary,
                    icon: Icon(
                      Icons.send,
                      color: FlutterFlowTheme.of(context).primaryBackground,
                      size: 20.0,
                    ),
                    onPressed: _submitComment,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    ),
    );
  }

  Widget _buildCommentItem(BuildContext context, CommentsRecord comment) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            splashColor: Colors.transparent,
            focusColor: Colors.transparent,
            hoverColor: Colors.transparent,
            highlightColor: Colors.transparent,
            onTap: () {
              Navigator.of(context).pop(); // close bottom sheet first
              if (comment.userref == currentUserReference) {
                context.goNamed(ProfilePage2Widget.routeName);
              } else {
                context.pushNamed(
                  SearchedProfilePageWidget.routeName,
                  queryParameters: {
                    'profileparameters': serializeParam(
                      comment.userref,
                      ParamType.DocumentReference,
                    ),
                  }.withoutNulls,
                );
              }
            },
            child: ClipRRect(
              borderRadius: BorderRadius.circular(40.0),
              child: FutureBuilder<UsersRecord>(
                future: comment.userref != null
                    ? UsersRecord.getDocumentOnce(comment.userref!)
                    : null,
                builder: (context, userSnap) {
                  final photoUrl = userSnap.data?.photoUrl ?? '';
                  if (photoUrl.isNotEmpty) {
                    return Image.network(
                      photoUrl,
                      width: 38.0,
                      height: 38.0,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) =>
                          Image.asset(
                        'assets/images/prof_pic.jpg',
                        width: 38.0,
                        height: 38.0,
                        fit: BoxFit.cover,
                      ),
                    );
                  }
                  return Image.asset(
                    'assets/images/prof_pic.jpg',
                    width: 38.0,
                    height: 38.0,
                    fit: BoxFit.cover,
                  );
                },
              ),
            ),
          ),
          const SizedBox(width: 10.0),
          Expanded(
            child: Container(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.sizeOf(context).width * 0.70,
              ),
              decoration: BoxDecoration(
                color: FlutterFlowTheme.of(context).primaryBackground,
                borderRadius: BorderRadius.circular(12.0),
              ),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(2.0, 0.0, 10.0, 6.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        InkWell(
                          splashColor: Colors.transparent,
                          focusColor: Colors.transparent,
                          hoverColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          onTap: () {
                            Navigator.of(context).pop();
                            if (comment.userref == currentUserReference) {
                              context
                                  .goNamed(ProfilePage2Widget.routeName);
                            } else {
                              context.pushNamed(
                                SearchedProfilePageWidget.routeName,
                                queryParameters: {
                                  'profileparameters': serializeParam(
                                    comment.userref,
                                    ParamType.DocumentReference,
                                  ),
                                }.withoutNulls,
                              );
                            }
                          },
                          child: Text(
                            comment.displayname,
                            style: FlutterFlowTheme.of(context)
                                .bodyMedium
                                .override(
                                  fontFamily: FlutterFlowTheme.of(context)
                                      .bodyMediumFamily,
                                  color:
                                      FlutterFlowTheme.of(context).primary,
                                  letterSpacing: 0.0,
                                  fontWeight: FontWeight.bold,
                                  useGoogleFonts:
                                      !FlutterFlowTheme.of(context)
                                          .bodyMediumIsCustom,
                                ),
                          ),
                        ),
                        Padding(
                          padding:
                              const EdgeInsets.fromLTRB(7.0, 2.0, 0.0, 0.0),
                          child: Text(
                            dateTimeFormat(
                              "relative",
                              comment.time!,
                              locale: FFLocalizations.of(context)
                                  .languageCode,
                            ),
                            style: FlutterFlowTheme.of(context)
                                .labelSmall
                                .override(
                                  fontFamily: FlutterFlowTheme.of(context)
                                      .labelSmallFamily,
                                  color: FlutterFlowTheme.of(context)
                                      .tertiary,
                                  fontSize: 10.0,
                                  letterSpacing: 0.0,
                                  fontWeight: FontWeight.bold,
                                  useGoogleFonts:
                                      !FlutterFlowTheme.of(context)
                                          .labelSmallIsCustom,
                                ),
                          ),
                        ),
                      ],
                    ),
                    Text(
                      comment.comment,
                      maxLines: 5,
                      style: FlutterFlowTheme.of(context)
                          .bodyMedium
                          .override(
                            fontFamily: FlutterFlowTheme.of(context)
                                .bodyMediumFamily,
                            color: FlutterFlowTheme.of(context).accent3,
                            letterSpacing: 0.0,
                            useGoogleFonts: !FlutterFlowTheme.of(context)
                                .bodyMediumIsCustom,
                          ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          if (comment.userref == currentUserReference)
            InkWell(
              splashColor: Colors.transparent,
              focusColor: Colors.transparent,
              hoverColor: Colors.transparent,
              highlightColor: Colors.transparent,
              onTap: () => _deleteComment(comment),
              child: Padding(
                padding: const EdgeInsets.only(left: 4.0, top: 8.0),
                child: Icon(
                  Icons.close_rounded,
                  color: FlutterFlowTheme.of(context).secondaryText,
                  size: 18.0,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
