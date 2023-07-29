import 'package:creative_blogger_app/components/custom_button.dart';
import 'package:creative_blogger_app/utils/shorts.dart';
import 'package:creative_blogger_app/utils/structs/short.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:url_launcher/url_launcher.dart';

class ShortsScreen extends StatefulWidget {
  const ShortsScreen({super.key});

  @override
  State<ShortsScreen> createState() => _ShortsScreenState();
}

class _ShortsScreenState extends State<ShortsScreen> {
  List<Short> shorts = [];
  bool areShortsLoading = true;
  bool isShowMoreLoading = false;

  @override
  void initState() {
    super.initState();
    getShorts().then((receivedShorts) {
      if (mounted) {
        setState(
          () {
            shorts = receivedShorts;
            areShortsLoading = false;
          },
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () {
        setState(() => areShortsLoading = true);
        return getShorts(limit: shorts.length).then(
          (receivedShorts) => setState(
            () {
              shorts = receivedShorts;
              areShortsLoading = false;
            },
          ),
        );
      },
      child: areShortsLoading
          ? const Center(
              child: SpinKitSpinningLines(
                color: Colors.blue,
                size: 100,
                duration: Duration(milliseconds: 1500),
              ),
            )
          : shorts.isNotEmpty
              ? Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: shorts.length,
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
                            contentPadding: const EdgeInsets.all(16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            title: Text(
                              shorts[index].title,
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
                                  "@${shorts[index].author.username}",
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
                                MarkdownBody(
                                  data: shorts[index].content,
                                  onTapLink: (text, url, title) => launchUrl(
                                      Uri.parse(url!),
                                      mode: LaunchMode.externalApplication),
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
                    if (!areShortsLoading &&
                        shorts.isNotEmpty &&
                        shorts.length % 20 == 0) ...{
                      CustomButton(
                        onPressed: isShowMoreLoading
                            ? null
                            : () {
                                setState(() => isShowMoreLoading = true);
                                getShorts(page: shorts.length ~/ 20)
                                    .then((receivedShorts) {
                                  shorts.addAll(receivedShorts);
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
