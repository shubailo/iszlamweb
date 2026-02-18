import 'dart:io';
import 'dart:convert';

void main() async {
  // Use relative path from root
  final inputFile = File('references/Kotatsu/app/src/main/res/values-hu/strings.xml');
  if (!await inputFile.exists()) {
    print('Error: Input file not found at ${inputFile.path}');
    exit(1);
  }

  // Output file
  final outputFile = File('iszlam_app/lib/core/i18n/kotatsu_strings.dart');
  
  // Read bytes
  final bytes = await inputFile.readAsBytes();
  // Decode
  final content = utf8.decode(bytes, allowMalformed: true);
  
  final regex = RegExp(r'<string name="([^"]+)">([^<]*)</string>');
  final matches = regex.allMatches(content);

  final buffer = StringBuffer();
  buffer.writeln('// Generated from Kotatsu strings.xml');
  buffer.writeln('// DO NOT EDIT MANUALLY');
  buffer.writeln('');
  buffer.writeln('const Map<String, String> kotatsuHungarianStrings = {');
  
  for (final match in matches) {
    final name = match.group(1);
    var value = match.group(2);
    
    if (name != null && value != null) {
      // 1. Decode XML entities if any (basic ones)
      value = value
          .replaceAll('&lt;', '<')
          .replaceAll('&gt;', '>')
          .replaceAll('&amp;', '&')
          .replaceAll('&apos;', "'")
          .replaceAll('&quot;', '"');

      // 2. Use JSON Encode to get a valid string literal (with quotes around it)
      // e.g. "Hello\nWorld"
      String jsonValue = jsonEncode(value);
      
      // 3. Escape $ because Dart uses it for interpolation, even in double quotes
      jsonValue = jsonValue.replaceAll(r'$', r'\$');
      
      // 4. Also unescape \\n if XML had literal \n vs newline char? 
      // Xml parser usually gives literal \n if it was in the file.
      // jsonEncode handles newlines (\n) by converting them to \n.
      
      buffer.writeln("  '$name': $jsonValue,");
    }
  }
  buffer.writeln('};');
  
  // Write (UTF-8)
  await outputFile.writeAsString(buffer.toString(), mode: FileMode.write, encoding: utf8);
  print('Successfully wrote ${matches.length} strings to ${outputFile.path}');
}
