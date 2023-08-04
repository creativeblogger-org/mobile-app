import 'package:creative_blogger_app/components/custom_button.dart';
import 'package:creative_blogger_app/screens/components/custom_error_while_loading.dart';
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
  List<Short>? shorts = [];
  bool areShortsLoading = true;
  bool isShowMoreLoading = false;

  Future<void> _getShorts({int limit = 20}) async {
    var receivedShorts = await getShorts(limit: limit);
    setState(
      () {
        shorts = receivedShorts;
        areShortsLoading = false;
      },
    );
  }

  @override
  void initState() {
    super.initState();
    _getShorts();
  }

  @override
  Widget build(BuildContext context) {
    bool showButton = shorts != null &&
        !areShortsLoading &&
        shorts!.isNotEmpty &&
        shorts!.length % 20 == 0;

    return RefreshIndicator(
        onRefresh: () {
          setState(() => areShortsLoading = true);
          return _getShorts(
              limit: (shorts ?? []).length < 20 ? 20 : (shorts ?? []).length);
        },
        child: areShortsLoading
            ? const Center(
                child: SpinKitSpinningLines(
                  color: Colors.blue,
                  size: 100,
                  duration: Duration(milliseconds: 1500),
                ),
              )
            : shorts == null || shorts!.isEmpty
                ? CustomErrorWhileLoadingComponent(
                    message: shorts == null
                        ? AppLocalizations.of(context)!
                            .an_error_occured_while_loading_shorts
                        : AppLocalizations.of(context)!.no_short_for_the_moment,
                  )
                : Column(
                    children: [
                      Expanded(
                        child: ListView.builder(
                          padding: const EdgeInsets.all(16),
                          itemCount:
                              showButton ? shorts!.length + 1 : shorts!.length,
                          itemBuilder: (context, index) {
                            if (index < shorts!.length) {
                              return ShortTile(
                                short: shorts![index],
                                reload: () {
                                  setState(() => areShortsLoading = true);
                                  _getShorts(limit: shorts!.length);
                                },
                              );
                            }
                            return CustomButton(
                              onPressed: isShowMoreLoading
                                  ? null
                                  : () {
                                      setState(() => isShowMoreLoading = true);
                                      getShorts(page: shorts!.length ~/ 20)
                                          .then(
                                        (receivedShorts) {
                                          if (receivedShorts == null) {
                                            setState(() =>
                                                isShowMoreLoading = false);
                                            return;
                                          }
                                          shorts!.addAll(receivedShorts);
                                          setState(
                                              () => isShowMoreLoading = false);
                                        },
                                      );
                                    },
                              child: isShowMoreLoading
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
                        ),
                      ),
                    ],
                  ));
  }
}
