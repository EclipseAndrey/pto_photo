// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values

class S {
  S();
  
  static S current;
  
  static const AppLocalizationDelegate delegate =
    AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false) ? locale.languageCode : locale.toString();
    final localeName = Intl.canonicalizedLocale(name); 
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      S.current = S();
      
      return S.current;
    });
  } 

  static S of(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `PTO uploader`
  String get app_name {
    return Intl.message(
      'PTO uploader',
      name: 'app_name',
      desc: '',
      args: [],
    );
  }

  /// `No connection`
  String get snack_no_connection {
    return Intl.message(
      'No connection',
      name: 'snack_no_connection',
      desc: '',
      args: [],
    );
  }

  /// `online`
  String get snack_back_connection {
    return Intl.message(
      'online',
      name: 'snack_back_connection',
      desc: '',
      args: [],
    );
  }

  /// `Unstable_connection`
  String get snack_unstable_connection {
    return Intl.message(
      'Unstable_connection',
      name: 'snack_unstable_connection',
      desc: '',
      args: [],
    );
  }

  /// `Сегодня`
  String get today {
    return Intl.message(
      'Сегодня',
      name: 'today',
      desc: '',
      args: [],
    );
  }

  /// `Завтра`
  String get tomorrow {
    return Intl.message(
      'Завтра',
      name: 'tomorrow',
      desc: '',
      args: [],
    );
  }

  /// `Вчера`
  String get yesterday {
    return Intl.message(
      'Вчера',
      name: 'yesterday',
      desc: '',
      args: [],
    );
  }

  /// `Воскресенье`
  String get Sunday {
    return Intl.message(
      'Воскресенье',
      name: 'Sunday',
      desc: '',
      args: [],
    );
  }

  /// `Понедельник`
  String get Monday {
    return Intl.message(
      'Понедельник',
      name: 'Monday',
      desc: '',
      args: [],
    );
  }

  /// `Вторник`
  String get Tuesday {
    return Intl.message(
      'Вторник',
      name: 'Tuesday',
      desc: '',
      args: [],
    );
  }

  /// `Среда`
  String get Wednesday {
    return Intl.message(
      'Среда',
      name: 'Wednesday',
      desc: '',
      args: [],
    );
  }

  /// `Четверг`
  String get Thursday {
    return Intl.message(
      'Четверг',
      name: 'Thursday',
      desc: '',
      args: [],
    );
  }

  /// `Пятница`
  String get Friday {
    return Intl.message(
      'Пятница',
      name: 'Friday',
      desc: '',
      args: [],
    );
  }

  /// `Суббота`
  String get Saturday {
    return Intl.message(
      'Суббота',
      name: 'Saturday',
      desc: '',
      args: [],
    );
  }

  /// `Инфо`
  String get item_header {
    return Intl.message(
      'Инфо',
      name: 'item_header',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    if (locale != null) {
      for (var supportedLocale in supportedLocales) {
        if (supportedLocale.languageCode == locale.languageCode) {
          return true;
        }
      }
    }
    return false;
  }
}