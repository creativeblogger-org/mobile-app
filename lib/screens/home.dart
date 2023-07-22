import 'package:creative_blogger_app/screens/loading.dart';
import 'package:creative_blogger_app/screens/login.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: const Text("Creative Blogger"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
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
                          storage.delete(key: "token").then((_) {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const LoginScreen(),
                              ),
                            );
                          });
                        },
                        child: Text(AppLocalizations.of(context)!.yes),
                      ),
                    ],
                  ),
                );
              },
              child: Text(AppLocalizations.of(context)!.log_out),
            )
          ],
        ),
      ),
      floatingActionButton: const FloatingActionButton(
        onPressed: null,
        tooltip: 'Post',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
