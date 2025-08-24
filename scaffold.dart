import 'dart:io';

const _featureTpl = r'''
// GENERATED for feature: %FEATURE%
// TODO: implement
''';

Future<void> main(List<String> args) async {
  if (args.isEmpty) {
    stderr.writeln('Usage: dart tool/scaffold.dart <featureName>');
    exit(1);
  }

  final feature = args.first.toLowerCase();
  final libDir = Directory('lib');

  // Ensure lib exists
  if (!libDir.existsSync()) {
    libDir.createSync();
  }

  // 1. Create features directory
  final featuresDir = Directory('${libDir.path}/features');
  featuresDir.createSync(recursive: true);

  // 2. Create feature directory inside features
  final featureDir = Directory('${featuresDir.path}/$feature');
  featureDir.createSync(recursive: true);

  // 3. Create pages subdirectory
  final pagesDir = Directory('${featureDir.path}/pages');
  pagesDir.createSync();

  // 4. Create page files in pages folder
  for (var i = 1; i <= 3; i++) {
    final pageFile = File('${pagesDir.path}/${feature}_page$i.dart');
    pageFile.writeAsStringSync(_featureTpl.replaceAll('%FEATURE%', feature));
  }

  // 5. Create other files in feature directory (not pages folder)
  for (final suffix in ['controller', 'model', 'repository']) {
    final file = File('${featureDir.path}/${feature}_$suffix.dart');
    file.writeAsStringSync(_featureTpl.replaceAll('%FEATURE%', feature));
  }

  print('✅ Generated feature structure for "$feature"');
}