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
  List<PreviewPost>? _posts = [];
  bool _arePostsLoading = true;
  bool _isShowMoreLoading = false;
  final TextEditingController _searchEditingController =
      TextEditingController();

  Future<void> _getPreviewPosts({int limit = 20}) async {
    setState(() => _arePostsLoading = true);
    getPreviewPosts(limit: limit).then((previewPosts) {
      if (mounted) {
        setState(
          () {
            _posts = previewPosts;
            _arePostsLoading = false;
          },
        );
      }
    });
  }

  Future<void> _searchPreviewPostsByContent(String content,
      {int limit = 20}) async {
    setState(() => _arePostsLoading = true);
    searchPreviewPostsByContent(content, limit: limit).then((previewPosts) {
      if (mounted) {
        setState(
          () {
            _posts = previewPosts;
            _arePostsLoading = false;
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
    bool showShowMoreButton = _posts != null &&
        !_arePostsLoading &&
        _posts!.isNotEmpty &&
        _posts!.last.id != 86 &&
        _posts!.length % 20 == 0;

    return RefreshIndicator(
      onRefresh: () => _getPreviewPosts(
        limit: _posts == null || _posts!.length < 20 ? 20 : _posts!.length,
      ),
      child: SingleChildScrollView(
        physics: _arePostsLoading
            ? const NeverScrollableScrollPhysics()
            : const AlwaysScrollableScrollPhysics(),
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
                suffixIcon: IconButton(
                  onPressed: () {
                    _searchEditingController.text = "";
                    FocusScope.of(context).requestFocus(FocusNode());
                    _getPreviewPosts();
                  },
                  icon: Icon(
                    Icons.close,
                    color: Theme.of(context)
                        .colorScheme
                        .onBackground
                        .withOpacity(0.6),
                  ),
                ),
              ),
              onEditingComplete: () {
                var value = _searchEditingController.text.trim();
                FocusScope.of(context).requestFocus(FocusNode());
                if (value.isEmpty) {
                  _getPreviewPosts();
                  return;
                }
                _searchPreviewPostsByContent(value);
              },
              textInputAction: TextInputAction.search,
            ),
            const SizedBox(height: 16),
            _arePostsLoading
                ? Center(
                    child: Container(
                      alignment: Alignment.center,
                      child: const SpinKitSpinningLines(
                        color: Colors.blue,
                        size: 100,
                        duration: Duration(milliseconds: 1500),
                      ),
                    ),
                  )
                : _posts == null || _posts!.isEmpty
                    ? Center(
                        child: Text(
                          _posts == null
                              ? AppLocalizations.of(context)!
                                  .an_error_occured_while_loading_posts
                              : AppLocalizations.of(context)!
                                  .no_post_for_the_moment,
                        ),
                      )
                    : ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: showShowMoreButton
                            ? _posts!.length + 1
                            : _posts!.length,
                        itemBuilder: (context, index) {
                          if (index < _posts!.length) {
                            return PreviewPostTile(post: _posts![index]);
                          }
                          return CustomButton(
                            onPressed: _isShowMoreLoading
                                ? null
                                : () {
                                    if (_searchEditingController.text.isEmpty) {
                                      setState(() => _isShowMoreLoading = true);
                                      getPreviewPosts(
                                              page: _posts!.length ~/ 20)
                                          .then(
                                        (previewPosts) {
                                          if (previewPosts == null) {
                                            setState(() =>
                                                _isShowMoreLoading = false);
                                            return;
                                          }
                                          _posts!.addAll(previewPosts);
                                          setState(
                                              () => _isShowMoreLoading = false);
                                        },
                                      );
                                    } else {
                                      setState(() => _isShowMoreLoading = true);
                                      searchPreviewPostsByContent(
                                              _searchEditingController.text,
                                              page: _posts!.length ~/ 20)
                                          .then(
                                        (previewPosts) {
                                          if (previewPosts == null) {
                                            setState(() =>
                                                _isShowMoreLoading = false);
                                            return;
                                          }
                                          _posts!.addAll(previewPosts);
                                          setState(
                                              () => _isShowMoreLoading = false);
                                        },
                                      );
                                    }
                                  },
                            child: _isShowMoreLoading
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
