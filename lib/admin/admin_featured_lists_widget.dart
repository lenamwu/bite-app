import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';

import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';

class AdminFeaturedListsWidget extends StatefulWidget {
  const AdminFeaturedListsWidget({super.key});

  static const String routeName = 'AdminFeaturedLists';
  static const String routePath = '/adminFeaturedLists';

  @override
  State<AdminFeaturedListsWidget> createState() =>
      _AdminFeaturedListsWidgetState();
}

class _AdminFeaturedListsWidgetState extends State<AdminFeaturedListsWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
      appBar: AppBar(
        backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
        iconTheme:
            IconThemeData(color: FlutterFlowTheme.of(context).primaryText),
        title: Text(
          'manage featured lists',
          style: FlutterFlowTheme.of(context).titleMedium.override(
                fontFamily: FlutterFlowTheme.of(context).titleMediumFamily,
                color: FlutterFlowTheme.of(context).primaryText,
                useGoogleFonts: GoogleFonts.asMap()
                    .containsKey(FlutterFlowTheme.of(context).titleMediumFamily),
              ),
        ),
        elevation: 0.0,
      ),
      body: StreamBuilder<List<FeaturedListsRecord>>(
        stream: queryFeaturedListsRecord(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final lists = snapshot.data!;
          if (lists.isEmpty) {
            return Center(
              child: Text(
                'no featured lists yet',
                style: FlutterFlowTheme.of(context).bodyMedium,
              ),
            );
          }
          return ListView.builder(
            padding: const EdgeInsets.all(16.0),
            itemCount: lists.length,
            itemBuilder: (context, index) {
              final featuredList = lists[index];
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => _AdminEditFeaturedListPage(
                        featuredListRef: featuredList.reference,
                      ),
                    ),
                  );
                },
                child: Container(
                  margin: const EdgeInsets.only(bottom: 12.0),
                  decoration: BoxDecoration(
                    color: FlutterFlowTheme.of(context).secondaryBackground,
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  child: Row(
                    children: [
                      if (featuredList.image.isNotEmpty)
                        ClipRRect(
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(12.0),
                            bottomLeft: Radius.circular(12.0),
                          ),
                          child: Image.network(
                            featuredList.image,
                            width: 80.0,
                            height: 80.0,
                            fit: BoxFit.cover,
                          ),
                        ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                featuredList.title,
                                style: FlutterFlowTheme.of(context)
                                    .bodyLarge
                                    .override(
                                      fontFamily: FlutterFlowTheme.of(context)
                                          .bodyLargeFamily,
                                      fontWeight: FontWeight.w600,
                                      useGoogleFonts: GoogleFonts.asMap()
                                          .containsKey(
                                              FlutterFlowTheme.of(context)
                                                  .bodyLargeFamily),
                                    ),
                              ),
                              const SizedBox(height: 4.0),
                              Text(
                                '${featuredList.recipes.length} recipes',
                                style: FlutterFlowTheme.of(context)
                                    .bodySmall
                                    .override(
                                      fontFamily: FlutterFlowTheme.of(context)
                                          .bodySmallFamily,
                                      color: FlutterFlowTheme.of(context)
                                          .secondaryText,
                                      useGoogleFonts: GoogleFonts.asMap()
                                          .containsKey(
                                              FlutterFlowTheme.of(context)
                                                  .bodySmallFamily),
                                    ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 12.0),
                        child: Icon(
                          Icons.chevron_right,
                          color: FlutterFlowTheme.of(context).secondaryText,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class _AdminEditFeaturedListPage extends StatefulWidget {
  const _AdminEditFeaturedListPage({required this.featuredListRef});

  final DocumentReference featuredListRef;

  @override
  State<_AdminEditFeaturedListPage> createState() =>
      _AdminEditFeaturedListPageState();
}

class _AdminEditFeaturedListPageState
    extends State<_AdminEditFeaturedListPage> {
  final TextEditingController _searchController = TextEditingController();
  List<RecipesRecord> _searchResults = [];
  bool _isSearching = false;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _searchRecipes(String query) async {
    if (query.trim().isEmpty) {
      setState(() {
        _searchResults = [];
        _isSearching = false;
      });
      return;
    }

    setState(() => _isSearching = true);

    final snapshot = await RecipesRecord.collection.get();
    final allRecipes =
        snapshot.docs.map((d) => RecipesRecord.fromSnapshot(d)).toList();

    final lowerQuery = query.toLowerCase();
    final filtered = allRecipes
        .where((r) => r.title.toLowerCase().contains(lowerQuery))
        .toList();

    setState(() {
      _searchResults = filtered;
      _isSearching = false;
    });
  }

  Future<void> _addRecipe(
      DocumentReference recipeRef, List<DocumentReference> currentRecipes) async {
    if (currentRecipes.contains(recipeRef)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('recipe already in this list')),
      );
      return;
    }
    await widget.featuredListRef.update({
      'recipes': FieldValue.arrayUnion([recipeRef]),
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('recipe added!')),
    );
  }

  Future<void> _removeRecipe(DocumentReference recipeRef) async {
    await widget.featuredListRef.update({
      'recipes': FieldValue.arrayRemove([recipeRef]),
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
      appBar: AppBar(
        backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
        iconTheme:
            IconThemeData(color: FlutterFlowTheme.of(context).primaryText),
        title: Text(
          'edit featured list',
          style: FlutterFlowTheme.of(context).titleMedium.override(
                fontFamily: FlutterFlowTheme.of(context).titleMediumFamily,
                color: FlutterFlowTheme.of(context).primaryText,
                useGoogleFonts: GoogleFonts.asMap()
                    .containsKey(FlutterFlowTheme.of(context).titleMediumFamily),
              ),
        ),
        elevation: 0.0,
      ),
      body: StreamBuilder<FeaturedListsRecord>(
        stream: FeaturedListsRecord.getDocument(widget.featuredListRef),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final featuredList = snapshot.data!;

          return Column(
            children: [
              // Search bar to add recipes
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'search recipes to add...',
                    hintStyle: FlutterFlowTheme.of(context).bodyMedium.override(
                          fontFamily:
                              FlutterFlowTheme.of(context).bodyMediumFamily,
                          color: FlutterFlowTheme.of(context).secondaryText,
                          useGoogleFonts: GoogleFonts.asMap().containsKey(
                              FlutterFlowTheme.of(context).bodyMediumFamily),
                        ),
                    prefixIcon: Icon(Icons.search,
                        color: FlutterFlowTheme.of(context).secondaryText),
                    suffixIcon: _searchController.text.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () {
                              _searchController.clear();
                              setState(() => _searchResults = []);
                            },
                          )
                        : null,
                    filled: true,
                    fillColor:
                        FlutterFlowTheme.of(context).secondaryBackground,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  style: FlutterFlowTheme.of(context).bodyMedium,
                  onChanged: (value) => _searchRecipes(value),
                ),
              ),

              // Search results
              if (_isSearching)
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: CircularProgressIndicator(),
                ),
              if (_searchResults.isNotEmpty)
                Container(
                  constraints: const BoxConstraints(maxHeight: 250.0),
                  margin: const EdgeInsets.symmetric(horizontal: 16.0),
                  decoration: BoxDecoration(
                    color: FlutterFlowTheme.of(context).secondaryBackground,
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: _searchResults.length,
                    itemBuilder: (context, index) {
                      final recipe = _searchResults[index];
                      final alreadyAdded =
                          featuredList.recipes.contains(recipe.reference);
                      return ListTile(
                        leading: recipe.publicrecipeimage.isNotEmpty
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(6.0),
                                child: Image.network(
                                  recipe.publicrecipeimage,
                                  width: 45.0,
                                  height: 45.0,
                                  fit: BoxFit.cover,
                                ),
                              )
                            : Container(
                                width: 45.0,
                                height: 45.0,
                                decoration: BoxDecoration(
                                  color: FlutterFlowTheme.of(context)
                                      .primaryBackground,
                                  borderRadius: BorderRadius.circular(6.0),
                                ),
                                child: Icon(Icons.restaurant,
                                    color: FlutterFlowTheme.of(context)
                                        .secondaryText),
                              ),
                        title: Text(
                          recipe.title,
                          style: FlutterFlowTheme.of(context).bodyMedium,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        subtitle: recipe.cookingtime.isNotEmpty
                            ? Text(
                                recipe.cookingtime,
                                style: FlutterFlowTheme.of(context)
                                    .bodySmall
                                    .override(
                                      fontFamily: FlutterFlowTheme.of(context)
                                          .bodySmallFamily,
                                      color: FlutterFlowTheme.of(context)
                                          .secondaryText,
                                      useGoogleFonts: GoogleFonts.asMap()
                                          .containsKey(
                                              FlutterFlowTheme.of(context)
                                                  .bodySmallFamily),
                                    ),
                              )
                            : null,
                        trailing: IconButton(
                          icon: Icon(
                            alreadyAdded ? Icons.check_circle : Icons.add_circle_outline,
                            color: alreadyAdded
                                ? FlutterFlowTheme.of(context).tertiary
                                : FlutterFlowTheme.of(context).primaryText,
                          ),
                          onPressed: alreadyAdded
                              ? null
                              : () => _addRecipe(
                                  recipe.reference, featuredList.recipes),
                        ),
                      );
                    },
                  ),
                ),

              // Divider
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: Row(
                  children: [
                    Text(
                      'current recipes (${featuredList.recipes.length})',
                      style: FlutterFlowTheme.of(context).bodyMedium.override(
                            fontFamily:
                                FlutterFlowTheme.of(context).bodyMediumFamily,
                            fontWeight: FontWeight.w600,
                            useGoogleFonts: GoogleFonts.asMap().containsKey(
                                FlutterFlowTheme.of(context).bodyMediumFamily),
                          ),
                    ),
                  ],
                ),
              ),

              // Current recipes list
              Expanded(
                child: featuredList.recipes.isEmpty
                    ? Center(
                        child: Text(
                          'no recipes in this list',
                          style: FlutterFlowTheme.of(context).bodyMedium.override(
                                fontFamily: FlutterFlowTheme.of(context)
                                    .bodyMediumFamily,
                                color: FlutterFlowTheme.of(context)
                                    .secondaryText,
                                useGoogleFonts: GoogleFonts.asMap().containsKey(
                                    FlutterFlowTheme.of(context)
                                        .bodyMediumFamily),
                              ),
                        ),
                      )
                    : ReorderableListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        itemCount: featuredList.recipes.length,
                        onReorder: (oldIndex, newIndex) async {
                          if (newIndex > oldIndex) newIndex--;
                          final reordered =
                              List<DocumentReference>.from(featuredList.recipes);
                          final item = reordered.removeAt(oldIndex);
                          reordered.insert(newIndex, item);
                          await widget.featuredListRef.update({
                            'recipes': reordered,
                          });
                        },
                        itemBuilder: (context, index) {
                          final recipeRef = featuredList.recipes[index];
                          return StreamBuilder<RecipesRecord>(
                            key: ValueKey(recipeRef.path),
                            stream: RecipesRecord.getDocument(recipeRef),
                            builder: (context, recipeSnap) {
                              if (!recipeSnap.hasData) {
                                return Container(
                                  key: ValueKey(recipeRef.path),
                                  height: 70.0,
                                  margin: const EdgeInsets.only(bottom: 8.0),
                                  decoration: BoxDecoration(
                                    color: FlutterFlowTheme.of(context)
                                        .secondaryBackground,
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  child: const Center(
                                      child: CircularProgressIndicator()),
                                );
                              }
                              final recipe = recipeSnap.data!;
                              return Dismissible(
                                key: ValueKey(recipeRef.path),
                                direction: DismissDirection.endToStart,
                                background: Container(
                                  margin: const EdgeInsets.only(bottom: 8.0),
                                  decoration: BoxDecoration(
                                    color: Colors.red.shade400,
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  alignment: Alignment.centerRight,
                                  padding: const EdgeInsets.only(right: 20.0),
                                  child: const Icon(Icons.delete,
                                      color: Colors.white),
                                ),
                                onDismissed: (_) =>
                                    _removeRecipe(recipeRef),
                                child: Container(
                                  margin: const EdgeInsets.only(bottom: 8.0),
                                  decoration: BoxDecoration(
                                    color: FlutterFlowTheme.of(context)
                                        .secondaryBackground,
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  child: ListTile(
                                    leading: recipe.publicrecipeimage.isNotEmpty
                                        ? ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(6.0),
                                            child: Image.network(
                                              recipe.publicrecipeimage,
                                              width: 50.0,
                                              height: 50.0,
                                              fit: BoxFit.cover,
                                            ),
                                          )
                                        : Container(
                                            width: 50.0,
                                            height: 50.0,
                                            decoration: BoxDecoration(
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .primaryBackground,
                                              borderRadius:
                                                  BorderRadius.circular(6.0),
                                            ),
                                            child: Icon(Icons.restaurant,
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .secondaryText),
                                          ),
                                    title: Text(
                                      recipe.title,
                                      style: FlutterFlowTheme.of(context)
                                          .bodyMedium,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    subtitle: Text(
                                      recipe.rating > 0
                                          ? '${recipe.rating} stars'
                                          : 'no rating',
                                      style: FlutterFlowTheme.of(context)
                                          .bodySmall
                                          .override(
                                            fontFamily:
                                                FlutterFlowTheme.of(context)
                                                    .bodySmallFamily,
                                            color: FlutterFlowTheme.of(context)
                                                .secondaryText,
                                            useGoogleFonts: GoogleFonts.asMap()
                                                .containsKey(
                                                    FlutterFlowTheme.of(context)
                                                        .bodySmallFamily),
                                          ),
                                    ),
                                    trailing: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(
                                          Icons.drag_handle,
                                          color: FlutterFlowTheme.of(context)
                                              .secondaryText,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      ),
              ),
            ],
          );
        },
      ),
    );
  }
}
