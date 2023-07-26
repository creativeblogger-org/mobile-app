import 'package:creative_blogger_app/components/custom_decoration.dart';
import 'package:creative_blogger_app/components/markdown_renderer.dart';
import 'package:creative_blogger_app/utils/post.dart';
import 'package:creative_blogger_app/utils/routes.dart';
import 'package:creative_blogger_app/utils/structs/post.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_html/flutter_html.dart';

class PostScreen extends StatefulWidget {
  const PostScreen({super.key});

  static const routeName = "/post";

  @override
  State<PostScreen> createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  Post? _post;
  bool isPostLoading = true;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      final args =
          ModalRoute.of(context)!.settings.arguments as PostScreenArguments;
      var slug = args.slug;
      getPosts(slug).then((post) {
        if (mounted) {
          setState(() {
            _post = post;
            isPostLoading = false;
          });
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(AppLocalizations.of(context)!.post),
          flexibleSpace: Container(
            decoration: customDecoration(),
          ),
        ),
        body: isPostLoading
            ? const Center(
                child: SpinKitSpinningLines(
                  color: Colors.blue,
                  size: 100,
                  duration: Duration(milliseconds: 1500),
                ),
              )
            : _post == null
                ? Text(AppLocalizations.of(context)!
                    .an_error_occured_while_loading_post)
                : LayoutBuilder(builder: (context, constraints) {
                    return Container(
                      width: constraints.maxWidth,
                      padding: const EdgeInsets.all(16),
                      child: SingleChildScrollView(
                        child: Column(
                          // mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              _post!.title,
                              style: TextStyle(
                                fontSize: Theme.of(context)
                                    .textTheme
                                    .headlineSmall!
                                    .fontSize,
                              ),
                            ),
                            const SizedBox(height: 16),
                            Html(
                                data: MarkdownRenderer(markdown: _post!.content)
                                    .markdown)
                          ],
                        ),
                      ),
                    );
                  }));
  }
}
