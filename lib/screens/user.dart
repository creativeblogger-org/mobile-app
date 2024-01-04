import 'package:creative_blogger_app/components/custom_button.dart';
import 'package:creative_blogger_app/components/custom_decoration.dart';
import 'package:creative_blogger_app/screens/components/custom_error_while_loading.dart';
import 'package:creative_blogger_app/screens/home/components/preview_post_tile.dart';
import 'package:creative_blogger_app/utils/posts.dart';
import 'package:creative_blogger_app/utils/structs/preview_post.dart';
import 'package:creative_blogger_app/utils/user.dart';
import 'package:creative_blogger_app/utils/structs/public_user.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:url_launcher/url_launcher_string.dart';

class UserScreen extends StatefulWidget {
  const UserScreen({super.key, required this.username});

  static const routeName = "/user";

  final String username;

  @override
  State<UserScreen> createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  PublicUser? _user;
  List<PreviewPost>? _posts;
  bool _isLoading = true;
  bool _arePreviewPostsLoading = true;
  bool _isShowMoreLoading = false;
  int _postsCount = 0;

  @override
  void initState() {
    super.initState();
    _getPublicUser();
  }

  void _getPublicUser() {
    setState(() => _isLoading = true);
    getPublicUser(widget.username).then(
      (user) {
        setState(
          () {
            _user = user;
            _isLoading = false;
          },
        );
        if (_user != null) {
          _getPreviewPostsByAuthor(_user!.id);
        }
      },
    );
  }

  Future<void> _getPreviewPostsByAuthor(int authorId,
      {int limit = 20, int page = 0}) async {
    setState(() => _arePreviewPostsLoading = true);
    var (posts, count) = await getPreviewPosts(
        authorId: authorId.toString(), limit: limit, page: page);
    setState(() {
      _posts = posts;
      _postsCount = count;
      _arePreviewPostsLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    bool showShowMoreButton = _posts != null &&
        !_arePreviewPostsLoading &&
        _postsCount > _posts!.length;

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.user),
        flexibleSpace: Container(decoration: customDecoration()),
      ),
      body: RefreshIndicator(
        onRefresh: () async => _getPublicUser(),
        child: _isLoading
            ? const Center(
                child: SpinKitSpinningLines(
                  color: Colors.blue,
                  size: 100,
                  duration: Duration(milliseconds: 1500),
                ),
              )
            : _user == null
                ? CustomErrorWhileLoadingComponent(
                    message: AppLocalizations.of(context)!
                        .an_error_occured_while_loading_user,
                  )
                : Padding(
                    padding: const EdgeInsets.all(16),
                    child: SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      child: SizedBox(
                        width: double.infinity,
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                CircleAvatar(
                                  radius: 20,
                                  backgroundColor: _user!.pp == null
                                      ? null
                                      : Colors.transparent,
                                  backgroundImage: _user!.pp == null
                                      ? null
                                      : NetworkImage(_user!.pp!),
                                  child: _user!.pp == null
                                      ? const Icon(Icons.person)
                                      : null,
                                ),
                                const SizedBox(width: 5),
                                Text(
                                  _user!.username,
                                  style: TextStyle(
                                    fontSize: Theme.of(context)
                                        .textTheme
                                        .displaySmall!
                                        .fontSize,
                                  ),
                                )
                              ],
                            ),
                            if (_user!.bio != null) ...{
                              const Divider(color: Colors.grey),
                              Text(_user!.bio!),
                              const Divider(color: Colors.grey),
                            },
                            getPermissionWidget(_user!.permission),
                            Text(
                              AppLocalizations.of(context)!.signed_up_the(
                                  getHumanDate(_user!.createdAt)),
                            ),
                            if (_user!.buymeacoffee != null) ...{
                              const SizedBox(height: 16),
                              ElevatedButton(
                                onPressed: () =>
                                    launchUrlString(_user!.buymeacoffee!),
                                child:
                                    Text(AppLocalizations.of(context)!.support),
                              ),
                            },
                            const SizedBox(height: 16),
                            Text(
                              AppLocalizations.of(context)!.users_posts,
                              style: TextStyle(
                                fontSize: Theme.of(context)
                                    .textTheme
                                    .headlineMedium!
                                    .fontSize,
                              ),
                            ),
                            _arePreviewPostsLoading
                                ? const Center(
                                    child: SpinKitSpinningLines(
                                      color: Colors.blue,
                                      size: 100,
                                      duration: Duration(milliseconds: 1500),
                                    ),
                                  )
                                : (_posts ?? []).isEmpty
                                    ? Center(
                                        child: Text(AppLocalizations.of(
                                                context)!
                                            .this_user_hasnt_published_any_post_yet),
                                      )
                                    : ListView.builder(
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        itemBuilder: (context, index) =>
                                            index < _posts!.length - 1
                                                ? Column(
                                                    children: [
                                                      PreviewPostTile(
                                                          post: _posts![index],
                                                          showAuthor: false),
                                                      const Divider(
                                                        height: 1,
                                                        color: Colors.grey,
                                                      )
                                                    ],
                                                  )
                                                : index < _posts!.length
                                                    ? PreviewPostTile(
                                                        post: _posts![index],
                                                        showAuthor: false,
                                                      )
                                                    : CustomButton(
                                                        onPressed:
                                                            _isShowMoreLoading
                                                                ? null
                                                                : () {
                                                                    setState(() =>
                                                                        _isShowMoreLoading =
                                                                            true);
                                                                    getPreviewPosts(
                                                                            authorId:
                                                                                _user!.id.toString(),
                                                                            page: _posts!.length ~/ 20)
                                                                        .then(
                                                                      (previewPosts) {
                                                                        if (previewPosts.$1 ==
                                                                            null) {
                                                                          setState(() =>
                                                                              _isShowMoreLoading = false);
                                                                          return;
                                                                        }
                                                                        _posts!.addAll(
                                                                            previewPosts.$1!);
                                                                        setState(
                                                                            () {
                                                                          _isShowMoreLoading =
                                                                              false;
                                                                          _postsCount =
                                                                              previewPosts.$2;
                                                                        });
                                                                      },
                                                                    );
                                                                  },
                                                        child:
                                                            _isShowMoreLoading
                                                                ? SpinKitRing(
                                                                    color: Theme.of(
                                                                            context)
                                                                        .colorScheme
                                                                        .primary,
                                                                    size: 20,
                                                                    lineWidth:
                                                                        2,
                                                                  )
                                                                : Text(AppLocalizations.of(
                                                                        context)!
                                                                    .show_more),
                                                      ),
                                        itemCount: showShowMoreButton
                                            ? (_posts ?? []).length + 1
                                            : (_posts ?? []).length,
                                        shrinkWrap: true,
                                      ),
                          ],
                        ),
                      ),
                    ),
                  ),
      ),
    );
  }
}
