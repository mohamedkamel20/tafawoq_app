import json

# Read the ARB files
with open('lib/l10n/app_en.arb', 'r', encoding='utf-8') as f:
    en_data = json.load(f)

with open('lib/l10n/app_ar.arb', 'r', encoding='utf-8') as f:
    ar_data = json.load(f)

# Generate English class
en_class = "import 'app_localizations.dart';\n\n"
en_class += "/// The translations for English (`en`).\n"
en_class += "class AppLocalizationsEn extends AppLocalizations {\n"
en_class += "  AppLocalizationsEn([String locale = 'en']) : super(locale);\n\n"

# Generate Arabic class
ar_class = "import 'app_localizations.dart';\n\n"
ar_class += "/// The translations for Arabic (`ar`).\n"
ar_class += "class AppLocalizationsAr extends AppLocalizations {\n"
ar_class += "  AppLocalizationsAr([String locale = 'ar']) : super(locale);\n\n"

# Add all getters for English
for key, value in en_data.items():
    if not key.startswith('@@') and not key.startswith('@'):
        escaped_value = value.replace('\\', '\\\\').replace("'", "\\'")
        en_class += f"  @override\n  String get {key} => '{escaped_value}';\n\n"

# Add all getters for Arabic  
for key, value in ar_data.items():
    if not key.startswith('@@') and not key.startswith('@'):
        escaped_value = value.replace('\\', '\\\\').replace("'", "\\'")
        ar_class += f"  @override\n  String get {key} => '{escaped_value}';\n\n"

en_class += "}\n"
ar_class += "}\n"

# Write the files
with open('.dart_tool/flutter_gen/gen_l10n/app_localizations_en.dart', 'w', encoding='utf-8') as f:
    f.write(en_class)

with open('.dart_tool/flutter_gen/gen_l10n/app_localizations_ar.dart', 'w', encoding='utf-8') as f:
    f.write(ar_class)

print("Generated localization files successfully!")
print(f"English: {len([k for k in en_data.keys() if not k.startswith('@')])} strings")
print(f"Arabic: {len([k for k in ar_data.keys() if not k.startswith('@')])} strings")
