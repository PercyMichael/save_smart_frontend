import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
// ignore: unused_import
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart' as intl;

/// A simpler approach to implementing Luganda localizations by extending DefaultMaterialLocalizations
/// This is much more maintainable than implementing GlobalMaterialLocalizations directly
class LgMaterialLocalizations extends DefaultMaterialLocalizations {
  const LgMaterialLocalizations();

  static const LocalizationsDelegate<MaterialLocalizations> delegate =
      _LgMaterialLocalizationsDelegate();

  // Only override the strings you need to translate to Luganda
  // All other strings will use the default implementation (English)

  @override
  String get openAppDrawerTooltip => 'Ggulawo menu';

  @override
  String get backButtonTooltip => 'Ddayo';

  @override
  String get closeButtonTooltip => 'Ggalawo';

  @override
  String get deleteButtonTooltip => 'Gyawo';

  @override
  String get moreButtonTooltip => 'Ebisingawo';

  @override
  String get nextMonthTooltip => 'Omwezi oguddako';

  @override
  String get previousMonthTooltip => 'Omwezi oguyise';

  @override
  String get nextPageTooltip => 'Olupapula oluddako';

  @override
  String get previousPageTooltip => 'Olupapula oluyise';

  @override
  String get showMenuTooltip => 'Laga menu';

  @override
  String aboutListTileTitle(String applicationName) =>
      'Ebikwata ku $applicationName';

  @override
  String get licensesPageTitle => 'Layisensi';

  @override
  String pageRowsInfoTitle(
      int firstRow, int lastRow, int rowCount, bool rowCountIsApproximate) {
    return rowCountIsApproximate
        ? '$firstRow-$lastRow mu namba $rowCount eziri kumpi'
        : '$firstRow-$lastRow mu $rowCount';
  }

  @override
  String get rowsPerPageTitle => 'Ennyiriri ku lupapula:';

  @override
  String tabLabel({required int tabIndex, required int tabCount}) =>
      'Tab $tabIndex mu $tabCount';

  @override
  String selectedRowCountTitle(int selectedRowCount) {
    return intl.Intl.pluralLogic(
      selectedRowCount,
      zero: 'Tewali birondeddwa',
      one: '1 kirondeddwa',
      other: '$selectedRowCount birondeddwa',
    );
  }

  @override
  String get cancelButtonLabel => 'Sazaamu';

  @override
  String get closeButtonLabel => 'Ggalawo';

  @override
  String get continueButtonLabel => 'Weyongereyo';

  @override
  String get copyButtonLabel => 'Koppa';

  @override
  String get cutButtonLabel => 'Salawo';

  @override
  String get okButtonLabel => 'OK';

  @override
  String get pasteButtonLabel => 'Paste';

  @override
  String get selectAllButtonLabel => 'Londa Byonna';

  @override
  String get viewLicensesButtonLabel => 'Laba Layisensi';

  @override
  String get timePickerHourModeAnnouncement => 'Londa Essawa';

  @override
  String get timePickerMinuteModeAnnouncement => 'Londa Edakiika';

  @override
  String get modalBarrierDismissLabel => 'Ggyawo';

  @override
  String get datePickerHelpText => 'LONDA ENNAKU';

  @override
  // ignore: override_on_non_overriding_member
  String get todayLabel => 'Leero';

  @override
  String get firstPageTooltip => 'Olupapula olusooka';

  @override
  String get lastPageTooltip => 'Olupapula olusembayo';

  // Add more overrides as needed for specific translations
  // There's no need to implement every single method from GlobalMaterialLocalizations
}

class _LgMaterialLocalizationsDelegate
    extends LocalizationsDelegate<MaterialLocalizations> {
  const _LgMaterialLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return locale.languageCode == 'lg';
  }

  @override
  Future<MaterialLocalizations> load(Locale locale) async {
    // Initialize date formatting for Luganda
    await initializeDateFormatting(locale.languageCode, null);
    
    return SynchronousFuture<MaterialLocalizations>(
      const LgMaterialLocalizations(),
    );
  }

  @override
  bool shouldReload(_LgMaterialLocalizationsDelegate old) => false;
}