import 'package:creative_blogger_app/components/custom_decoration.dart';
import 'package:creative_blogger_app/screens/login.dart';
import 'package:creative_blogger_app/utils/home.dart';
import 'package:creative_blogger_app/utils/me_route.dart';
import 'package:creative_blogger_app/utils/structs/post.dart';
import 'package:creative_blogger_app/utils/structs/user.dart';
import 'package:creative_blogger_app/utils/token.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  static const routeName = '/home';

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<PreviewPost> posts = [];
  bool arePostsLoading = true;
  User? me;
  bool isGetMeLoading = true;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      getPosts().then((previewPosts) {
        if (mounted) {
          setState(
            () {
              posts = previewPosts;
              arePostsLoading = false;
            },
          );
        }
      });
      getMe().then((user) {
        if (!mounted) {
          return;
        }
        if (user == null) {
          return;
        }
        setState(() => me = user);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: customDecoration(),
        ),
        leading: GestureDetector(
          onTap: () {},
          child: me == null || me?.pp == null
              ? const Icon(Icons.person)
              : Image.network(
                  me!.pp!,
                ),
        ),
        actions: [
          IconButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (innerContext) => AlertDialog(
                    title: Text(AppLocalizations.of(context)!.confirm),
                    content: Text(AppLocalizations.of(context)!
                        .do_you_really_want_to_log_out),
                    actions: [
                      ElevatedButton(
                        onPressed: () => Navigator.pop(innerContext),
                        child: Text(AppLocalizations.of(context)!.cancel),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pop(innerContext);
                          deleteToken().then((_) {
                            Navigator.pushReplacementNamed(
                              context,
                              LoginScreen.routeName,
                            );
                          });
                        },
                        child: Text(AppLocalizations.of(context)!.yes),
                      ),
                    ],
                  ),
                );
              },
              icon: const Icon(Icons.exit_to_app_rounded))
        ],
        title: const Text("Creative Blogger"),
        centerTitle: true,
      ),
      body: RefreshIndicator(
        child: arePostsLoading
            ? const Center(child: CircularProgressIndicator())
            : posts.isNotEmpty
                ? ListView(
                    padding: const EdgeInsets.all(16),
                    children: [
                      for (var post in posts) ...{
                        GestureDetector(
                          onTap: () {
                            //TODO redirect to post
                          },
                          child: Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Row(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(360),
                                    child: Image.network(
                                      post.image,
                                      loadingBuilder:
                                          (context, child, loadingProgress) {
                                        if (loadingProgress == null) {
                                          return child;
                                        }
                                        return const Icon(Icons.image);
                                      },
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          post.title,
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
                                        const Divider(),
                                        Text(
                                          "@${post.author.username}",
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
                                          post.description,
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        )
                      }
                    ],
                  )
                : const Text("Pas de posts"),
        onRefresh: () {
          setState(() => arePostsLoading = true);
          return getPosts().then(
            (previewPosts) => setState(
              () {
                posts = previewPosts;
                arePostsLoading = false;
              },
            ),
          );
        },
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
