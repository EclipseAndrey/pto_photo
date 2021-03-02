import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pto_photo/utils/connection_status_singleton.dart';
import 'package:pto_photo/utils/snack_bar.dart';



const EdgeInsets HAS_CONNECTION_PADDING = EdgeInsets.all(0.0);
const EdgeInsets NO_CONNECTION_PADDING = EdgeInsets.only(bottom: 45.0);

class ConnectionProvider extends StatefulWidget {
  final Widget child;

  const ConnectionProvider({
    @required this.child,
  }) : assert(child != null);

  @override
  _ConnectionProviderState createState() => _ConnectionProviderState();
}

class _ConnectionProviderState extends State<ConnectionProvider> {
  bool _fallbackViewOn;
  ConnectionStatusSingleton _connectionStatus;

  @override
  void initState() {
    print("Init connection");
    _fallbackViewOn = false;

    _connectionStatus = ConnectionStatusSingleton.getInstance();
    _connectionStatus.connectionChange.listen(_updateConnectivity);
    _connectionStatus.initialize();
    super.initState();
  }

  void _updateConnectivity(dynamic hasConnection) {
    print('<<<<<<<<<< hasConnection $hasConnection');
    if (!hasConnection) {
      print('show snackbar');

      if (!_fallbackViewOn) {
        SnackBarService().show(SnackBarType.NO_CONNECTION);
        setState(() {
          _fallbackViewOn = true;
        });
      }
    } else {
      if (_fallbackViewOn) {
        SnackBarService().show(SnackBarType.BACK_CONNECTION);

        setState(() {
          _fallbackViewOn = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _connectionStatus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xFF26292E),
      child: StreamBuilder<bool>(
        initialData: false,
        stream: SnackBarService().statusChange,
        builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
          bool hasPadding = false;
          if (snapshot.hasData) {
            hasPadding = !snapshot.data;
          }
          return AnimatedPadding(
            padding: hasPadding ? HAS_CONNECTION_PADDING : NO_CONNECTION_PADDING,
            duration: Duration(milliseconds: 200),
            child: widget.child,
          );
        },
      ),
    );
  }
}
