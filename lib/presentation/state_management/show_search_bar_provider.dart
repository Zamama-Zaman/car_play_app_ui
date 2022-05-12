import 'package:flutter/cupertino.dart';

class ShowSearchBarProvider with ChangeNotifier {
  bool _isShowSearchBar = false;

  bool get isShow => _isShowSearchBar;

  void showSearchBar(bool _isShow) async {
    _isShowSearchBar = _isShow;
    await Future.delayed(const Duration(milliseconds: 0));
    notifyListeners();
  }
}
