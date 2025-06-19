import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart' as intl;

/// A custom implementation for Nyankole localizations by extending DefaultMaterialLocalizations
class NynMaterialLocalizations extends DefaultMaterialLocalizations {
  const NynMaterialLocalizations();

  static const LocalizationsDelegate<MaterialLocalizations> delegate =
      _NynMaterialLocalizationsDelegate();

  // Override strings with Nyankole translations
  @override
  String get openAppDrawerTooltip => 'Shuuruurayo menu';

  @override
  String get backButtonTooltip => 'Garuka';

  @override
  String get closeButtonTooltip => 'Kinga';

  @override
  String get deleteButtonTooltip => 'Shanyura';

  @override
  String get moreButtonTooltip => 'Ebindi';

  @override
  String get nextMonthTooltip => 'Okwezi okurikuza';

  @override
  String get previousMonthTooltip => 'Okwezi okuhingwire';

  @override
  String get nextPageTooltip => 'Orupapura orurikuza';

  @override
  String get previousPageTooltip => 'Orupapura oruhingwire';

  @override
  String get showMenuTooltip => 'Yooreka menu';

  @override
  String aboutListTileTitle(String applicationName) =>
      'Ebikwatiraine na $applicationName';

  @override
  String get licensesPageTitle => 'Layisensi';

  @override
  String pageRowsInfoTitle(
      int firstRow, int lastRow, int rowCount, bool rowCountIsApproximate) {
    return rowCountIsApproximate
        ? '$firstRow-$lastRow omu $rowCount eziri haihi'
        : '$firstRow-$lastRow omu $rowCount';
  }

  @override
  String get rowsPerPageTitle => 'Emiringo ahari rupapura:';

  @override
  String tabLabel({required int tabIndex, required int tabCount}) =>
      'Tab $tabIndex omu $tabCount';

  @override
  String selectedRowCountTitle(int selectedRowCount) {
    return intl.Intl.pluralLogic(
      selectedRowCount,
      zero: 'Tihariho ekirikuhurwa',
      one: '1 ehurirwe',
      other: '$selectedRowCount zihurirwe',
    );
  }

  @override
  String get cancelButtonLabel => 'Siba';

  @override
  String get closeButtonLabel => 'Kinga';

  @override
  String get continueButtonLabel => 'Gyenda omu maisho';

  @override
  String get copyButtonLabel => 'Koopa';

  @override
  String get cutButtonLabel => 'Tema';

  @override
  String get okButtonLabel => 'OK';

  @override
  String get pasteButtonLabel => 'Paste';

  @override
  String get selectAllButtonLabel => 'Hura Byona';

  @override
  String get viewLicensesButtonLabel => 'Reba Layisensi';

  @override
  String get timePickerHourModeAnnouncement => 'Hura Shaaha';

  @override
  String get timePickerMinuteModeAnnouncement => 'Hura Edakiika';

  @override
  String get modalBarrierDismissLabel => 'Bikyire';

  @override
  String get datePickerHelpText => 'HURA EBIRO';

  @override
  String get firstPageTooltip => 'Orupapura rwakubanza';

  @override
  String get lastPageTooltip => 'Orupapura rwohamuheru';

  // Add more overrides as needed for specific translations
}

class _NynMaterialLocalizationsDelegate
    extends LocalizationsDelegate<MaterialLocalizations> {
  const _NynMaterialLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return locale.languageCode == 'nyn';
  }

  @override
  Future<MaterialLocalizations> load(Locale locale) async {
    // Initialize date formatting for Nyankole
    await initializeDateFormatting(locale.languageCode, null);
    
    return SynchronousFuture<MaterialLocalizations>(
      const NynMaterialLocalizations(),
    );
  }

  @override
  bool shouldReload(_NynMaterialLocalizationsDelegate old) => false;
}