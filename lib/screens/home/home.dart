import 'package:creative_blogger_app/components/custom_button.dart';
import 'package:creative_blogger_app/components/custom_decoration.dart';
import 'package:creative_blogger_app/screens/create_post_screen.dart';
import 'package:creative_blogger_app/screens/home/components/preview_post_tile.dart';
import 'package:creative_blogger_app/screens/login.dart';
import 'package:creative_blogger_app/screens/profile.dart';
import 'package:creative_blogger_app/utils/me_route.dart';
import 'package:creative_blogger_app/utils/posts.dart';
import 'package:creative_blogger_app/utils/structs/me.dart';
import 'package:creative_blogger_app/utils/structs/preview_post.dart';
import 'package:creative_blogger_app/utils/token.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

enum CategoryWithAll {
  all(""),
  fakeOrReal("fakeorreal"),
  tech("tech"),
  culture("culture"),
  news("news"),
  sport("sport"),
  cinema("cinema"),
  litterature("litterature"),
  musique("musique");

  const CategoryWithAll(this.value);
  final String value;
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  static const String routeName = "/home";

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Me? me;
  bool isGetMeLoading = true;
  List<PreviewPost>? _posts = [];
  bool _arePostsLoading = true;
  bool _isShowMoreLoading = false;
  final TextEditingController _searchEditingController =
      TextEditingController();
  int _postsCount = 0;
  CategoryWithAll? _category = CategoryWithAll.all;

  @override
  void initState() {
    super.initState();
    getMe().then((user) {
      if (!mounted) {
        return;
      }
      setState(() => me = user);
    });
    _getPreviewPosts();
  }

  @override
  void dispose() {
    _searchEditingController.dispose();
    super.dispose();
  }

  Future<void> _getPreviewPosts(
      {String content = "", int limit = 20, String tag = ""}) async {
    setState(() => _arePostsLoading = true);
    getPreviewPosts(
      limit: limit,
      query: content,
      tag: tag,
    ).then((previewPosts) {
      if (mounted) {
        setState(
          () {
            _posts = previewPosts.$1;
            _postsCount = previewPosts.$2;
            _arePostsLoading = false;
          },
        );
      }
    });
  }

  void _confirmLogout() {
    showDialog(
      context: context,
      builder: (innerContext) => AlertDialog(
        title: Text(AppLocalizations.of(context)!.confirm),
        content:
            Text(AppLocalizations.of(context)!.do_you_really_want_to_log_out),
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
  }

  @override
  Widget build(BuildContext context) {
    bool showShowMoreButton =
        _posts != null && !_arePostsLoading && _postsCount > _posts!.length;

    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: customDecoration(),
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.pushNamed(context, ProfileScreen.routeName);
          },
          icon: CircleAvatar(
            child: me == null || me?.pp == null
                ? const Icon(Icons.person)
                : Image.network(me!.pp!,
                    errorBuilder: (context, error, stackTrace) {
                    return const Icon(Icons.person);
                  }),
          ),
        ),
        actions: [
          IconButton(
            onPressed: _confirmLogout,
            icon: const Icon(Icons.exit_to_app_rounded),
          )
        ],
        title: Text(
          AppLocalizations.of(context)!.creative_blogger,
          style: const TextStyle(fontFamily: "Pangolin", fontSize: 25),
        ),
        centerTitle: true,
      ),
      body: RefreshIndicator(
        onRefresh: () => _getPreviewPosts(
          content: _searchEditingController.text,
          limit: _posts == null || _posts!.length < 20 ? 20 : _posts!.length,
          tag: _category?.value ?? "",
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(10),
              child: TextField(
                controller: _searchEditingController,
                decoration: InputDecoration(
                  hintText: AppLocalizations.of(context)!.search_posts,
                  hintStyle: const TextStyle(fontWeight: FontWeight.normal),
                  border: UnderlineInputBorder(
                    borderRadius: BorderRadius.circular(25),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: Theme.of(context)
                      .colorScheme
                      .onBackground
                      .withOpacity(0.1),
                  suffixIcon: _searchEditingController.text.trim().isNotEmpty
                      ? IconButton(
                          onPressed: () {
                            _searchEditingController.text = "";
                            FocusScope.of(context).requestFocus(FocusNode());
                            _getPreviewPosts(tag: _category?.value ?? "");
                          },
                          icon: Icon(
                            Icons.close,
                            color: Theme.of(context)
                                .colorScheme
                                .onBackground
                                .withOpacity(0.6),
                          ),
                        )
                      : null,
                ),
                onEditingComplete: () {
                  var value = _searchEditingController.text.trim();
                  FocusScope.of(context).requestFocus(FocusNode());
                  _getPreviewPosts(content: value, tag: _category?.value ?? "");
                },
                textInputAction: TextInputAction.search,
              ),
            ),
            SizedBox(
              height: 50,
              child: ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                children: CategoryWithAll.values
                    .map(
                      (category) => SizedBox(
                        width: 190,
                        child: RadioListTile(
                          value: category,
                          groupValue: _category,
                          onChanged: (CategoryWithAll? category) {
                            setState(() => _category = category);
                            _getPreviewPosts(
                                content: _searchEditingController.text,
                                tag: _category?.value ?? "");
                          },
                          isThreeLine: false,
                          title:
                              Text(getCategoryWithAllName(category, context)),
                        ),
                      ),
                    )
                    .toList(),
              ),
            ),
            _arePostsLoading
                ? const Expanded(
                    child: Center(
                      child: SpinKitSpinningLines(
                        color: Colors.blue,
                        size: 100,
                        duration: Duration(milliseconds: 1500),
                      ),
                    ),
                  )
                : _posts == null || _posts!.isEmpty
                    ? Expanded(
                        child: SingleChildScrollView(
                          physics: const AlwaysScrollableScrollPhysics(),
                          child: Center(
                            child: Text(
                              _posts == null
                                  ? AppLocalizations.of(context)!
                                      .an_error_occured_while_loading_posts
                                  : AppLocalizations.of(context)!
                                      .no_post_for_the_moment,
                            ),
                          ),
                        ),
                      )
                    : Expanded(
                        child: ListView.builder(
                          padding: const EdgeInsets.all(10),
                          physics: const AlwaysScrollableScrollPhysics(),
                          itemCount: showShowMoreButton
                              ? _posts!.length + 1
                              : _posts!.length,
                          itemBuilder: (context, index) {
                            if (index < _posts!.length - 1) {
                              return Column(
                                children: [
                                  PreviewPostTile(
                                      post: _posts![index], showAuthor: true),
                                  const Divider(
                                    color: Colors.grey,
                                  )
                                ],
                              );
                            }
                            if (index < _posts!.length) {
                              return PreviewPostTile(
                                post: _posts![index],
                                showAuthor: true,
                              );
                            }
                            return CustomButton(
                              onPressed: _isShowMoreLoading
                                  ? null
                                  : () {
                                      setState(() => _isShowMoreLoading = true);
                                      getPreviewPosts(
                                              query:
                                                  _searchEditingController.text,
                                              page: _posts!.length ~/ 20)
                                          .then(
                                        (previewPosts) {
                                          if (previewPosts.$1 == null) {
                                            setState(() =>
                                                _isShowMoreLoading = false);
                                            return;
                                          }
                                          _posts!.addAll(previewPosts.$1!);
                                          setState(() {
                                            _isShowMoreLoading = false;
                                            _postsCount = previewPosts.$2;
                                          });
                                        },
                                      );
                                    },
                              child: _isShowMoreLoading
                                  ? SpinKitRing(
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                      size: 20,
                                      lineWidth: 2,
                                    )
                                  : Text(
                                      AppLocalizations.of(context)!.show_more),
                            );
                          },
                          // shrinkWrap: true,
                        ),
                      ),
          ],
        ),
      ),
      floatingActionButton: me != null && me!.permission >= 1
          ? FloatingActionButton(
              onPressed: () => Navigator.pushNamed(
                  context, CreatePostScreen.routeName,
                  arguments: (
                    null,
                    () => _getPreviewPosts(
                          content: _searchEditingController.text,
                          tag: _category?.value ?? "",
                        )
                  )),
              child: const Icon(Icons.add),
            )
          : null,
    );
  }
}
