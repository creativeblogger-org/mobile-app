import 'package:creative_blogger_app/components/custom_decoration.dart';
import 'package:creative_blogger_app/screens/home.dart';
import 'package:creative_blogger_app/screens/login.dart';
import 'package:creative_blogger_app/screens/profile.dart';
import 'package:creative_blogger_app/utils/me_route.dart';
import 'package:creative_blogger_app/utils/structs/user.dart';
import 'package:creative_blogger_app/utils/token.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class MainScreenWithBottomAppBar extends StatefulWidget {
  const MainScreenWithBottomAppBar({super.key});

  static const String routeName = "/main";

  @override
  State<MainScreenWithBottomAppBar> createState() =>
      _MainScreenWithBottomAppBarState();
}

class _MainScreenWithBottomAppBarState
    extends State<MainScreenWithBottomAppBar> {
  User? me;
  bool isGetMeLoading = true;
  int _currentIndex = 0;

  //TODO change to [HomeScreen(), CreateScreen(), ShortsScreen()]
  static const pages = [HomeScreen(), HomeScreen(), HomeScreen()];

  @override
  void initState() {
    super.initState();
    getMe().then((user) {
      if (!mounted) {
        return;
      }
      if (user == null) {
        return;
      }
      setState(() => me = user);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: customDecoration(),
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.pushNamed(context, ProfileScreen.routeName);
          },
          icon: ClipRRect(
            borderRadius: BorderRadius.circular(300),
            child: me == null || me?.pp == null
                ? const Icon(Icons.person)
                : Image.network(me!.pp!),
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
            icon: const Icon(Icons.exit_to_app_rounded),
          )
        ],
        title: const Text(
          "Creative Blogger",
          style: TextStyle(fontFamily: "Pangolin", fontSize: 25),
        ),
        centerTitle: true,
      ),
      body: pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
              icon: const Icon(Icons.home),
              label: AppLocalizations.of(context)!.home),
          BottomNavigationBarItem(
              icon: const Icon(Icons.add_circle_outline),
              label: AppLocalizations.of(context)!.create),
          BottomNavigationBarItem(
              icon: const Icon(Icons.hourglass_bottom_rounded),
              label: AppLocalizations.of(context)!.shorts),
        ],
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        // showSelectedLabels: false,
        // showUnselectedLabels: false,
        selectedItemColor: Theme.of(context).colorScheme.primary,
        type: BottomNavigationBarType.fixed,
        elevation: 10,
      ),
    );
  }
}
