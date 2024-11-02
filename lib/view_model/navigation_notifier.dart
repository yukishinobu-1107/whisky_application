import 'package:flutter_riverpod/flutter_riverpod.dart';

class NavigationState extends StateNotifier<int> {
  NavigationState() : super(0);

  void setIndex(int index) {
    state = index;
  }
}

final navigationProvider = StateNotifierProvider<NavigationState, int>((ref) {
  return NavigationState();
});
