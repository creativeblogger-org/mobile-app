import 'package:creative_blogger_app/utils/shorts.dart';
import 'package:creative_blogger_app/utils/structs/short.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ShortTile extends StatelessWidget {
  const ShortTile({super.key, required this.short, required this.reload});

  final Short short;
  final Function() reload;

  @override
  Widget build(BuildContext context) {
    var title = Text(
      short.title,
      style: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: Theme.of(context).textTheme.titleLarge!.fontSize,
      ),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );

    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: BorderSide(color: Theme.of(context).colorScheme.primary),
      ),
      elevation: 10.0,
      shadowColor: Theme.of(context).colorScheme.primary,
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        title: short.hasPermission
            ? Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  title,
                  IconButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (innerContext) => AlertDialog(
                          title:
                              Text(AppLocalizations.of(context)!.are_you_sure),
                          content: Text(AppLocalizations.of(context)!
                              .this_short_will_be_definitely_deleted),
                          actions: [
                            ElevatedButton(
                              onPressed: () => Navigator.pop(innerContext),
                              style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      Theme.of(context).colorScheme.primary),
                              child: Text(AppLocalizations.of(context)!.cancel),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                Navigator.pop(innerContext);
                                removeShort(short.id).then((fine) {
                                  if (fine) {
                                    reload();
                                  }
                                });
                              },
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.red),
                              child:
                                  Text(AppLocalizations.of(context)!.im_sure),
                            )
                          ],
                        ),
                      );
                    },
                    icon: const Icon(
                      Icons.delete,
                      color: Colors.red,
                    ),
                  )
                ],
              )
            : title,
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Divider(),
            Text(
              "@${short.author.username}",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: Theme.of(context).textTheme.bodyLarge!.fontSize,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 5),
            MarkdownBody(
              data: short.content,
              onTapLink: (text, url, title) => launchUrl(Uri.parse(url!),
                  mode: LaunchMode.externalApplication),
            ),
          ],
        ),
        tileColor: Theme.of(context).colorScheme.background.withOpacity(0.5),
      ),
    );
  }
}
