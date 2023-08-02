import 'package:creative_blogger_app/components/custom_button.dart';
import 'package:creative_blogger_app/screens/components/custom_error_while_loading.dart';
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

  Future<void> _getPreviewPosts({int limit = 20}) async {
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

  @override
  void initState() {
    super.initState();
    _getPreviewPosts();
  }

  @override
  Widget build(BuildContext context) {
    bool showShowMoreButton = posts != null &&
        !arePostsLoading &&
        posts!.isNotEmpty &&
        posts!.last.id != 86;

    return RefreshIndicator(
      onRefresh: () {
        setState(() => arePostsLoading = true);
        return _getPreviewPosts(limit: (posts ?? []).length);
      },
      child: arePostsLoading
          ? const Center(
              child: SpinKitSpinningLines(
                color: Colors.blue,
                size: 100,
                duration: Duration(milliseconds: 1500),
              ),
            )
          : posts == null || posts!.isEmpty
              ? CustomErrorWhileLoadingComponent(
                  message: posts == null
                      ? AppLocalizations.of(context)!
                          .an_error_occured_while_loading_posts
                      : AppLocalizations.of(context)!.no_post_for_the_moment,
                )
              : Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        padding: const EdgeInsets.all(16),
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
                                    setState(() => isShowMoreLoading = true);
                                    getPreviewPosts(page: posts!.length ~/ 20)
                                        .then(
                                      (previewPosts) {
                                        if (previewPosts == null) {
                                          setState(
                                              () => isShowMoreLoading = false);
                                          return;
                                        }
                                        posts!.addAll(previewPosts);
                                        setState(
                                            () => isShowMoreLoading = false);
                                      },
                                    );
                                  },
                            child: isShowMoreLoading
                                ? const CircularProgressIndicator()
                                : Text(AppLocalizations.of(context)!.show_more),
                          );
                        },
                      ),
                    ),
                  ],
                ),
    );
  }
}
