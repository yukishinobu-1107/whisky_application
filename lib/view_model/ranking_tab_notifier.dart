import 'package:flutter_riverpod/flutter_riverpod.dart';

final rankingTabNotifierProvider =
    StateNotifierProvider<RankingTabNotifier, int>((ref) {
  return RankingTabNotifier();
});

class RankingTabNotifier extends StateNotifier<int> {
  RankingTabNotifier() : super(0);

  void setTab(int index) {
    state = index;
  }
}
