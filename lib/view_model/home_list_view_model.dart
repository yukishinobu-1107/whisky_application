import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../model/home_list_model.dart';
import '../repositories/home_list_repositories.dart';

part 'home_list_view_model.g.dart';

// 自動生成用アノテーションを追加
@riverpod
Stream<List<HomeListModel>> homeListViewModel(HomeListViewModelRef ref) {
  final homeRepository = HomeRepository();
  return homeRepository.getHomeListItems();
}
