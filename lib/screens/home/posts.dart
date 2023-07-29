import 'package:creative_blogger_app/components/custom_button.dart';
import 'package:creative_blogger_app/utils/posts.dart';
import 'package:creative_blogger_app/utils/routes.dart';
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
  List<PreviewPost> posts = [];
  bool arePostsLoading = true;
  bool isShowMoreLoading = false;

  @override
  void initState() {
    super.initState();
    getPreviewPosts().then((previewPosts) {
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
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () {
        setState(() => arePostsLoading = true);
        return getPreviewPosts(limit: posts.length).then(
          (previewPosts) => setState(
            () {
              posts = previewPosts;
              arePostsLoading = false;
            },
          ),
        );
      },
      child: arePostsLoading
          ? const Center(
              child: SpinKitSpinningLines(
                color: Colors.blue,
                size: 100,
                duration: Duration(milliseconds: 1500),
              ),
            )
          : posts.isNotEmpty
              ? Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: posts.length,
                        itemBuilder: (context, index) => Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                            side: BorderSide(
                                color:
                                    Theme.of(context).colorScheme.onBackground),
                          ),
                          elevation: 10.0,
                          shadowColor:
                              Theme.of(context).colorScheme.onBackground,
                          child: ListTile(
                            onTap: () => Navigator.pushNamed(
                              context,
                              "/post",
                              arguments: PostScreenArguments(posts[index].slug),
                            ),
                            contentPadding: const EdgeInsets.all(16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            leading: CircleAvatar(
                              child: Image.network(
                                posts[index].image,
                                loadingBuilder:
                                    (context, child, loadingProgress) {
                                  if (loadingProgress == null) {
                                    return child;
                                  }
                                  return const Icon(Icons.image);
                                },
                              ),
                            ),
                            title: Text(
                              posts[index].title,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: Theme.of(context)
                                    .textTheme
                                    .titleLarge!
                                    .fontSize,
                              ),
                              textAlign: TextAlign.center,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Divider(),
                                Text(
                                  "@${posts[index].author.username}",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: Theme.of(context)
                                        .textTheme
                                        .bodyLarge!
                                        .fontSize,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  posts[index].description,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                            tileColor: Theme.of(context)
                                .colorScheme
                                .background
                                .withOpacity(0.5),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    if (!arePostsLoading &&
                        posts.isNotEmpty &&
                        posts.last.id != 86) ...{
                      CustomButton(
                        onPressed: isShowMoreLoading
                            ? null
                            : () {
                                setState(() => isShowMoreLoading = true);
                                getPreviewPosts(page: posts.length ~/ 20)
                                    .then((previewPosts) {
                                  posts.addAll(previewPosts);
                                  setState(() => isShowMoreLoading = false);
                                });
                              },
                        child: isShowMoreLoading
                            ? const CircularProgressIndicator()
                            : Text(AppLocalizations.of(context)!.show_more),
                      ),
                    },
                  ],
                )
              : Text(AppLocalizations.of(context)!.no_post_for_the_moment),
    );
  }
}
