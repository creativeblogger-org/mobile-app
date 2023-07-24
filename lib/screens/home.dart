import 'package:creative_blogger_app/screens/login.dart';
import 'package:creative_blogger_app/utils/home.dart';
import 'package:creative_blogger_app/utils/structs/post.dart';
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
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      getPosts(context).then(
        (previewPosts) => setState(
          () {
            posts = previewPosts;
            isLoading = false;
          },
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(onPressed: () {}, icon: const Icon(Icons.person)),
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
        child: isLoading
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
                                borderRadius: BorderRadius.circular(10)),
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Column(
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
                                  ),
                                  Text(
                                    "@${post.author.username}",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: Theme.of(context)
                                          .textTheme
                                          .bodyLarge!
                                          .fontSize,
                                    ),
                                  ),
                                  Text(
                                    post.description,
                                    textAlign: TextAlign.center,
                                  ),
                                  Image.network(post.image)
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
          setState(() => isLoading = true);
          return getPosts(context).then(
            (previewPosts) => setState(
              () {
                posts = previewPosts;
                isLoading = false;
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          //TODO create post
        },
        tooltip: 'Post',
        backgroundColor: Theme.of(context).colorScheme.primary,
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
