import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart' as intl;

/// A custom implementation for Acholi localizations by extending DefaultMaterialLocalizations
class AchMaterialLocalizations extends DefaultMaterialLocalizations {
  const AchMaterialLocalizations();

  static const LocalizationsDelegate<MaterialLocalizations> delegate =
      _AchMaterialLocalizationsDelegate();

  // Override strings with Acholi translations
  @override
  String get openAppDrawerTooltip => 'Yab menu';

  @override
  String get backButtonTooltip => 'Dok cen';

  @override
  String get closeButtonTooltip => 'Lor';

  @override
  String get deleteButtonTooltip => 'Kwany';

  @override
  String get moreButtonTooltip => 'Mapol';

  @override
  String get nextMonthTooltip => 'Dwe malubo';

  @override
  String get previousMonthTooltip => 'Dwe mukato';

  @override
  String get nextPageTooltip => 'Pot buk malubo';

  @override
  String get previousPageTooltip => 'Pot buk mukato';

  @override
  String get showMenuTooltip => 'Nyut menu';

  @override
  String aboutListTileTitle(String applicationName) =>
      'Lok ikom $applicationName';

  @override
  String get licensesPageTitle => 'Layicen';

  @override
  String pageRowsInfoTitle(
      int firstRow, int lastRow, int rowCount, bool rowCountIsApproximate) {
    return rowCountIsApproximate
        ? '$firstRow-$lastRow i kin $rowCount macuk'
        : '$firstRow-$lastRow i kin $rowCount';
  }

  @override
  String get rowsPerPageTitle => 'Rek i pot buk:';

  @override
  String tabLabel({required int tabIndex, required int tabCount}) =>
      'Tab $tabIndex i kin $tabCount';

  @override
  String selectedRowCountTitle(int selectedRowCount) {
    return intl.Intl.pluralLogic(
      selectedRowCount,
      zero: 'Pe giyero mo',
      one: '1 kiyero',
      other: '$selectedRowCount kiyero',
    );
  }

  @override
  String get cancelButtonLabel => 'Juk';

  @override
  String get closeButtonLabel => 'Lor';

  @override
  String get continueButtonLabel => 'Mede';

  @override
  String get copyButtonLabel => 'Loki';

  @override
  String get cutButtonLabel => 'Ngol';

  @override
  String get okButtonLabel => 'OK';

  @override
  String get pasteButtonLabel => 'Mwon';

  @override
  String get selectAllButtonLabel => 'Yer weng';

  @override
  String get viewLicensesButtonLabel => 'Nen layicen';

  @override
  String get timePickerHourModeAnnouncement => 'Yer cawa';

  @override
  String get timePickerMinuteModeAnnouncement => 'Yer dakika';

  @override
  String get modalBarrierDismissLabel => 'Kwany';

  @override
  String get datePickerHelpText => 'YER NINO';

  @override
  String get firstPageTooltip => 'Pot buk mukwongo';

  @override
  String get lastPageTooltip => 'Pot buk magiko';

  // Add more overrides as needed for specific translations
}

class _AchMaterialLocalizationsDelegate
    extends LocalizationsDelegate<MaterialLocalizations> {
  const _AchMaterialLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return locale.languageCode == 'ach';
  }

  @override
  Future<MaterialLocalizations> load(Locale locale) async {
    // Initialize date formatting for Acholi
    await initializeDateFormatting(locale.languageCode, null);
    
    return SynchronousFuture<MaterialLocalizations>(
      const AchMaterialLocalizations(),
    );
  }

  @override
  bool shouldReload(_AchMaterialLocalizationsDelegate old) => false;
}