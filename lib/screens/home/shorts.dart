import 'package:creative_blogger_app/components/custom_button.dart';
import 'package:creative_blogger_app/screens/home/components/short_tile.dart';
import 'package:creative_blogger_app/utils/shorts.dart';
import 'package:creative_blogger_app/utils/structs/short.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

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
                        itemBuilder: (context, index) =>
                            ShortTile(short: shorts[index]),
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
