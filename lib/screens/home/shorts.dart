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
  List<Short>? _shorts = [];
  bool _areShortsLoading = true;
  bool _isShowMoreLoading = false;

  Future<void> _getShorts({int limit = 20}) async {
    setState(() => _areShortsLoading = true);
    var shorts = await getShorts(limit: limit);
    setState(
      () {
        _shorts = shorts;
        _areShortsLoading = false;
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
    bool showButton = _shorts != null &&
        !_areShortsLoading &&
        _shorts!.isNotEmpty &&
        _shorts!.length % 20 == 0;

    return RefreshIndicator(
      onRefresh: () =>
          _getShorts(limit: (_shorts ?? []).length < 20 ? 20 : _shorts!.length),
      child: _areShortsLoading
          ? Center(
              child: SpinKitSpinningLines(
                color: Theme.of(context).colorScheme.primary,
                size: 100,
                duration: const Duration(milliseconds: 1500),
              ),
            )
          : _shorts == null || _shorts!.isEmpty
              ? CustomErrorWhileLoadingComponent(
                  message: _shorts == null
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
                            showButton ? _shorts!.length + 1 : _shorts!.length,
                        itemBuilder: (context, index) {
                          if (index < _shorts!.length) {
                            return ShortTile(
                              short: _shorts![index],
                              reload: () => _getShorts(limit: _shorts!.length),
                            );
                          }
                          return CustomButton(
                            onPressed: _isShowMoreLoading
                                ? null
                                : () {
                                    setState(() => _isShowMoreLoading = true);
                                    getShorts(page: _shorts!.length ~/ 20).then(
                                      (receivedShorts) {
                                        if (receivedShorts == null) {
                                          setState(
                                              () => _isShowMoreLoading = false);
                                          return;
                                        }
                                        _shorts!.addAll(receivedShorts);
                                        setState(
                                            () => _isShowMoreLoading = false);
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
                                : Text(AppLocalizations.of(context)!.show_more),
                          );
                        },
                      ),
                    ),
                  ],
                ),
    );
  }
}
