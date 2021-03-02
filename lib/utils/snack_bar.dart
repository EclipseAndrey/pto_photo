import 'dart:async';

import 'package:flutter/material.dart';
import 'package:pto_photo/generated/l10n.dart';
import 'package:pto_photo/utils/app_keys.dart';


enum SnackBarType { NO_CONNECTION, BACK_CONNECTION, BAD_CONNECTION }

class SnackBarService {
  static final SnackBarService _instance = SnackBarService._internal();

  factory SnackBarService() => _instance;
  SnackBarService._internal();

  StreamController<bool> _snackBarStatusController = StreamController.broadcast();

  Stream get statusChange => _snackBarStatusController.stream;
  SnackBarType _currentSnackBar;

  void _hide() {
    _snackBarStatusController.add(false);
    ScaffoldState scaffold = AppKeys.scaffoldKey.currentState;
    scaffold.hideCurrentSnackBar();
  }

  void show(SnackBarType type) {
    switch (type) {
      case SnackBarType.NO_CONNECTION:
        if (_currentSnackBar == SnackBarType.NO_CONNECTION) return;
        return _showNoConnectionSnackBar();
      case SnackBarType.BACK_CONNECTION:
        if (_currentSnackBar == SnackBarType.BACK_CONNECTION) return;
        return _showBackConnectionSnackBar();
      case SnackBarType.BAD_CONNECTION:
        if (_currentSnackBar == SnackBarType.BAD_CONNECTION) return;
        return _showBadConnectionSnackBar();
    }
  }

  void _showNoConnectionSnackBar() {
    final snackBar = SnackBar(
      padding: EdgeInsets.all(0.0),
      backgroundColor: Color(0xFFE5112B),
      content: _buildSnackBarContent(
        title: S.of(AppKeys.navigatorKey.currentContext).snack_no_connection
        // FlutterI18n.translate(
        //   AppKeys.navigatorKey.currentContext,
        //   "snack_bar.no_connection",
        // ),
      ),
      duration: Duration(days: 365),
      onVisible: () {
        _currentSnackBar = SnackBarType.NO_CONNECTION;
        _snackBarStatusController.add(true);
      },
    );

    ScaffoldState scaffold = AppKeys.scaffoldKey.currentState;

    _hide();
    scaffold.showSnackBar(snackBar).closed.then((reason) {
      if (reason == SnackBarClosedReason.swipe) {
        _showNoConnectionSnackBar();
      } else {
        _currentSnackBar = null;
        _snackBarStatusController.add(false);
      }
    });
  }

  void _showBackConnectionSnackBar() {
    final snackBar = SnackBar(
      padding: EdgeInsets.all(0.0),
      backgroundColor: Color(0xFF1ACA94),
      content: _buildSnackBarContent(
        title:S.of(AppKeys.navigatorKey.currentContext).snack_back_connection,
      ),
      duration: Duration(seconds: 2),
      onVisible: () {
        _currentSnackBar = SnackBarType.BACK_CONNECTION;
        _snackBarStatusController.add(true);
      },
    );

    ScaffoldState scaffold = AppKeys.scaffoldKey.currentState;

    _hide();
    scaffold.showSnackBar(snackBar).closed.then((_) {
      _currentSnackBar = null;
      _snackBarStatusController.add(false);
    });
  }

  void _showBadConnectionSnackBar() {
    final snackBar = SnackBar(
      padding: EdgeInsets.all(0.0),
      backgroundColor: Color(0xFFE09B15),
      content: _buildSnackBarContent(
        title: S.of(AppKeys.navigatorKey.currentContext).snack_unstable_connection,
      ),
      duration: Duration(seconds: 2),
      onVisible: () {
        _currentSnackBar = SnackBarType.BAD_CONNECTION;
        _snackBarStatusController.add(true);
      },
    );

    ScaffoldState scaffold = AppKeys.scaffoldKey.currentState;

    _hide();
    scaffold.showSnackBar(snackBar).closed.then((_) {
      _currentSnackBar = null;
      _snackBarStatusController.add(false);
    });
  }

  Widget _buildSnackBarContent({
    @required String title,
  }) {
    assert(title != null);

    return Container(
      height: 20,
      child: Center(
        child: Text(
          title,
          style: TextStyle(
            color: Color(0xFFFFFFFF),
            fontFamily: 'Roboto',
            fontWeight: FontWeight.w400,
            fontSize: 12.0,
          ),
        ),
      ),
    );

    // return GestureDetector(
    //   behavior: HitTestBehavior.opaque,
    //   onVerticalDragStart: (_) => {},
    //   child: Container(
    //     height: 50.0,
    //     child: Column(
    //       mainAxisAlignment: MainAxisAlignment.center,
    //       children: [
    //         SizedBox(height: 5),
    //         Text(
    //           title,
    //           style: TextStyle(
    //             color: Color(0xFFFFFFFF),
    //             fontFamily: 'Roboto',
    //             fontWeight: FontWeight.w400,
    //             fontSize: 12.0,
    //           ),
    //         ),
    //         SizedBox(height: 25),
    //       ],
    //     ),
    //   ),
    // );
  }

  void dispose() {
    _snackBarStatusController.close();
  }
}
