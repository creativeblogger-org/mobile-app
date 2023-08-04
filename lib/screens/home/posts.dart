import 'package:creative_blogger_app/components/custom_button.dart';
import 'package:creative_blogger_app/screens/home/components/preview_post_tile.dart';
import 'package:creative_blogger_app/utils/posts.dart';
import 'package:creative_blogger_app/utils/structs/preview_post.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class PostsScreen extends StatefulWidget {
  const PostsScreen({super.key});

  @override
  State<PostsScreen> createState() => _PostsScreenState();
}

class _PostsScreenState extends State<PostsScreen> {
  List<PreviewPost>? posts = [];
  bool arePostsLoading = true;
  bool isShowMoreLoading = false;
  TextEditingController _searchEditingController = TextEditingController();

  Future<void> _getPreviewPosts({int limit = 20}) async {
    setState(() => arePostsLoading = true);
    getPreviewPosts(limit: limit).then((previewPosts) {
      if (mounted) {
        setState(
          () {
            posts = previewPosts;
            arePostsLoading = false;
          },
        );
      }
    });
  }

  Future<void> _searchPreviewPostsByContent(String content,
      {int limit = 20}) async {
    setState(() => arePostsLoading = true);
    searchPreviewPostsByContent(content, limit: limit).then((previewPosts) {
      if (mounted) {
        setState(
          () {
            posts = previewPosts;
            arePostsLoading = false;
          },
        );
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _getPreviewPosts();
  }

  @override
  void dispose() {
    _searchEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool showShowMoreButton = posts != null &&
        !arePostsLoading &&
        posts!.isNotEmpty &&
        posts!.last.id != 86 &&
        posts!.length % 20 == 0;

    return RefreshIndicator(
      onRefresh: () => _getPreviewPosts(
        limit: posts == null
            ? 20
            : posts!.length < 20
                ? 20
                : posts!.length,
      ),
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _searchEditingController,
              decoration: InputDecoration(
                hintText: AppLocalizations.of(context)!.search_posts,
                hintStyle: const TextStyle(fontWeight: FontWeight.normal),
                border: UnderlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor:
                    Theme.of(context).colorScheme.onBackground.withOpacity(0.1),
              ),
              onChanged: (value) {
                value = value.trim();
                if (value.isEmpty) {
                  _getPreviewPosts();
                  return;
                }
                _searchPreviewPostsByContent(value);
              },
            ),
            const SizedBox(height: 16),
            arePostsLoading
                ? const Center(
                    child: SpinKitSpinningLines(
                      color: Colors.blue,
                      size: 100,
                      duration: Duration(milliseconds: 1500),
                    ),
                  )
                : posts == null || posts!.isEmpty
                    ? Center(
                        child: Text(
                          posts == null
                              ? AppLocalizations.of(context)!
                                  .an_error_occured_while_loading_posts
                              : AppLocalizations.of(context)!
                                  .no_post_for_the_moment,
                        ),
                      )
                    : ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: showShowMoreButton
                            ? posts!.length + 1
                            : posts!.length,
                        itemBuilder: (context, index) {
                          if (index < posts!.length) {
                            return PreviewPostTile(post: posts![index]);
                          }
                          return CustomButton(
                            onPressed: isShowMoreLoading
                                ? null
                                : () {
                                    if (_searchEditingController.text.isEmpty) {
                                      setState(() => isShowMoreLoading = true);
                                      getPreviewPosts(page: posts!.length ~/ 20)
                                          .then(
                                        (previewPosts) {
                                          if (previewPosts == null) {
                                            setState(() =>
                                                isShowMoreLoading = false);
                                            return;
                                          }
                                          posts!.addAll(previewPosts);
                                          setState(
                                              () => isShowMoreLoading = false);
                                        },
                                      );
                                    } else {
                                      setState(() => isShowMoreLoading = true);
                                      searchPreviewPostsByContent(
                                              _searchEditingController.text,
                                              page: posts!.length ~/ 20)
                                          .then(
                                        (previewPosts) {
                                          if (previewPosts == null) {
                                            setState(() =>
                                                isShowMoreLoading = false);
                                            return;
                                          }
                                          posts!.addAll(previewPosts);
                                          setState(
                                              () => isShowMoreLoading = false);
                                        },
                                      );
                                    }
                                  },
                            child: isShowMoreLoading
                                ? SpinKitRing(
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                    size: 20,
                                    lineWidth: 2,
                                  )
                                : Text(AppLocalizations.of(context)!.show_more),
                          );
                        },
                        shrinkWrap: true,
                      ),
          ],
        ),
      ),
    );
  }
}
