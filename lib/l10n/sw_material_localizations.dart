import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart' as intl;

/// A custom implementation for Swahili localizations by extending DefaultMaterialLocalizations
class SwMaterialLocalizations extends DefaultMaterialLocalizations {
  const SwMaterialLocalizations();

  static const LocalizationsDelegate<MaterialLocalizations> delegate =
      _SwMaterialLocalizationsDelegate();

  // Override strings with Swahili translations
  @override
  String get openAppDrawerTooltip => 'Fungua menu';

  @override
  String get backButtonTooltip => 'Rudi nyuma';

  @override
  String get closeButtonTooltip => 'Funga';

  @override
  String get deleteButtonTooltip => 'Futa';

  @override
  String get moreButtonTooltip => 'Zaidi';

  @override
  String get nextMonthTooltip => 'Mwezi ujao';

  @override
  String get previousMonthTooltip => 'Mwezi uliopita';

  @override
  String get nextPageTooltip => 'Ukurasa ujao';

  @override
  String get previousPageTooltip => 'Ukurasa uliopita';

  @override
  String get showMenuTooltip => 'Onyesha menu';

  @override
  String aboutListTileTitle(String applicationName) =>
      'Kuhusu $applicationName';

  @override
  String get licensesPageTitle => 'Leseni';

  @override
  String pageRowsInfoTitle(
      int firstRow, int lastRow, int rowCount, bool rowCountIsApproximate) {
    return rowCountIsApproximate
        ? '$firstRow-$lastRow kati ya $rowCount takribani'
        : '$firstRow-$lastRow kati ya $rowCount';
  }

  @override
  String get rowsPerPageTitle => 'Safu kwa ukurasa:';

  @override
  String tabLabel({required int tabIndex, required int tabCount}) =>
      'Kichupo $tabIndex kati ya $tabCount';

  @override
  String selectedRowCountTitle(int selectedRowCount) {
    return intl.Intl.pluralLogic(
      selectedRowCount,
      zero: 'Hakuna kilichochaguliwa',
      one: 'Kipengee 1 kimechaguliwa',
      other: 'Vipengee $selectedRowCount vimechaguliwa',
    );
  }

  @override
  String get cancelButtonLabel => 'Ghairi';

  @override
  String get closeButtonLabel => 'Funga';

  @override
  String get continueButtonLabel => 'Endelea';

  @override
  String get copyButtonLabel => 'Nakili';

  @override
  String get cutButtonLabel => 'Kata';

  @override
  String get okButtonLabel => 'Sawa';

  @override
  String get pasteButtonLabel => 'Bandika';

  @override
  String get selectAllButtonLabel => 'Chagua Zote';

  @override
  String get viewLicensesButtonLabel => 'Ona Leseni';

  @override
  String get timePickerHourModeAnnouncement => 'Chagua Saa';

  @override
  String get timePickerMinuteModeAnnouncement => 'Chagua Dakika';

  @override
  String get modalBarrierDismissLabel => 'Ondoa';

  @override
  String get datePickerHelpText => 'CHAGUA TAREHE';

  @override
  String get firstPageTooltip => 'Ukurasa wa kwanza';

  @override
  String get lastPageTooltip => 'Ukurasa wa mwisho';

  // Add more overrides as needed for specific translations
}

class _SwMaterialLocalizationsDelegate
    extends LocalizationsDelegate<MaterialLocalizations> {
  const _SwMaterialLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return locale.languageCode == 'sw';
  }

  @override
  Future<MaterialLocalizations> load(Locale locale) async {
    // Initialize date formatting for Swahili
    await initializeDateFormatting(locale.languageCode, null);
    
    return SynchronousFuture<MaterialLocalizations>(
      const SwMaterialLocalizations(),
    );
  }

  @override
  bool shouldReload(_SwMaterialLocalizationsDelegate old) => false;
}