import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:savesmart_app/provider/settings_provider.dart';
import 'package:savesmart_app/l10n/l10n.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class LanguageSelector extends StatelessWidget {
  // ignore: use_super_parameters
  const LanguageSelector({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final settingsProvider = Provider.of<SettingsProvider>(context);
    final currentLocale = settingsProvider.locale;
    final localizations = AppLocalizations.of(context);

    return ListTile(
      title: Text(localizations.language),
      subtitle: Text(L10n.getLanguageName(currentLocale.languageCode)),
      trailing: const Icon(Icons.arrow_forward_ios),
      onTap: () {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(localizations.language),
            content: SizedBox(
              width: double.maxFinite,
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: L10n.supportedLocales.length,
                itemBuilder: (context, index) {
                  final locale = L10n.supportedLocales[index];
                  final languageName = L10n.getLanguageName(locale.languageCode);

                  return ListTile(
                    title: Text(languageName),
                    trailing: currentLocale.languageCode == locale.languageCode
                        ? const Icon(Icons.check, color: Colors.green)
                        : null,
                    onTap: () {
                      settingsProvider.setLocale(locale);
                      Navigator.pop(context);
                    },
                  );
                },
              ),
            ),
            actions: [
              TextButton(
                child: Text(MaterialLocalizations.of(context).cancelButtonLabel),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
        );
      },
    );
  }
}