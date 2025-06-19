import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

class CustomCupertinoLocalizations extends DefaultCupertinoLocalizations {
  const CustomCupertinoLocalizations();

  static const LocalizationsDelegate<CupertinoLocalizations> delegate =
      _CustomCupertinoLocalizationsDelegate();

  // Simplified versions for custom languages
  @override
  String get alertDialogLabel => 'Alert';

  @override
  String get copyButtonLabel => 'Copy';

  @override
  String get cutButtonLabel => 'Cut';

  @override
  String get pasteButtonLabel => 'Paste';

  @override
  String get selectAllButtonLabel => 'Select All';

  @override
  String get todayLabel => 'Today';
}

// Swahili Cupertino Localizations
class SwCupertinoLocalizations extends CustomCupertinoLocalizations {
  const SwCupertinoLocalizations();

  @override
  String get alertDialogLabel => 'Tahadhari';

  @override
  String get copyButtonLabel => 'Nakili';

  @override
  String get cutButtonLabel => 'Kata';

  @override
  String get pasteButtonLabel => 'Bandika';

  @override
  String get selectAllButtonLabel => 'Chagua Yote';

  @override
  String get todayLabel => 'Leo';
}

// Luganda Cupertino Localizations
class LgCupertinoLocalizations extends CustomCupertinoLocalizations {
  const LgCupertinoLocalizations();

  @override
  String get alertDialogLabel => 'Kulabula';

  @override
  String get copyButtonLabel => 'Koppa';

  @override
  String get cutButtonLabel => 'Sala';

  @override
  String get pasteButtonLabel => 'Paasta';

  @override
  String get selectAllButtonLabel => 'Londa Byonna';

  @override
  String get todayLabel => 'Leero';
}

// Nyankole Cupertino Localizations
class NynCupertinoLocalizations extends CustomCupertinoLocalizations {
  const NynCupertinoLocalizations();

  @override
  String get alertDialogLabel => 'Okumanyisibwa';

  @override
  String get copyButtonLabel => 'Koopa';

  @override
  String get cutButtonLabel => 'Tema';

  @override
  String get pasteButtonLabel => 'Paste';

  @override
  String get selectAllButtonLabel => 'Hitamu Byona';

  @override
  String get todayLabel => 'Erizooba';
}

// Acholi Cupertino Localizations
class AchCupertinoLocalizations extends CustomCupertinoLocalizations {
  const AchCupertinoLocalizations();

  @override
  String get alertDialogLabel => 'Tangula';

  @override
  String get copyButtonLabel => 'Lok';

  @override
  String get cutButtonLabel => 'Ngol';

  @override
  String get pasteButtonLabel => 'Mwon';

  @override
  String get selectAllButtonLabel => 'Yer Weng';

  @override
  String get todayLabel => 'Tin';
}

// Delegate that handles loading the appropriate localizations
class _CustomCupertinoLocalizationsDelegate
    extends LocalizationsDelegate<CupertinoLocalizations> {
  const _CustomCupertinoLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return ['en', 'sw', 'lg', 'nyn', 'ach'].contains(locale.languageCode);
  }

  @override
  Future<CupertinoLocalizations> load(Locale locale) {
    return SynchronousFuture<CupertinoLocalizations>(_loadLocalizations(locale));
  }

  CupertinoLocalizations _loadLocalizations(Locale locale) {
    switch (locale.languageCode) {
      case 'sw':
        return const SwCupertinoLocalizations();
      case 'lg':
        return const LgCupertinoLocalizations();
      case 'nyn':
        return const NynCupertinoLocalizations();
      case 'ach':
        return const AchCupertinoLocalizations();
      default:
        return const CustomCupertinoLocalizations();
    }
  }

  @override
  bool shouldReload(_CustomCupertinoLocalizationsDelegate old) => false;
}