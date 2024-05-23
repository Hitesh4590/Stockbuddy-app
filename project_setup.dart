// ignore_for_file: avoid_print
import 'dart:core';
import 'dart:io';

/// Name of the folder holding a ready folder!
const outDirectory = 'OUT';

/// Package name of boilerplate
const boilerplatePackageName = '"com.stockbuddy.app"';

/// Bundle id of boilerplate
const boilerPlateBundleId = '"com.stockbuddy.app"';

/// Project name of boilerplate
const boilerplateProjectName = 'stockbuddy_flutter_app';

/// Description of boilerplate project
const boilerplateDescription = 'Boilerplate for all the flutter apps!';

/// Files/Folders mentioned in this array will not be copied to the
/// newly created project!
const excludedFromCopy = <String>[
  'project_setup.dart',
  outDirectory,
  'build',
  '.plugin_symlinks',
  'setup',
  '.git',
  'Generated.xcconfig',
  'Flutter-Generated.xcconfig',
  'flutter_export_environment.sh',
  'Pods',
];

void main(List<String> arguments) {
  final projectName = arguments[0];
  final packageName = arguments[1];

  print('*****************************');
  print('Before proceeding, please confirm below details:');
  print('Project name is: $projectName');
  print('Package name is: $packageName');
  print('Enter `y` to continue and `n` to abort!');

  final input = stdin.readLineSync();
  if (input != null && input.toLowerCase() == 'y') {
    print('Continuing...');

    // Create OUT directory
    final newFolder = Directory(outDirectory);
    if (newFolder.existsSync()) {
      newFolder.deleteSync(recursive: true);
    }
    newFolder.createSync();

    // Create a directory for $projectName
    final newDirectory = Directory('$outDirectory/$projectName');

    // Copy over the entire project to new directory!
    copyDirectorySync(Directory.current, newDirectory.path);

    // Copy ReadMe file!
    copyReadMe(newDirectory.path);

    // Point to new directory
    final targetDirectoryPath = '${newDirectory.path}/';

    // Replace the Android package name
    replaceAndroidPackageName(
        newDirectory, boilerplatePackageName, packageName);

    // Move the native android files like MainActivity.kt from the boilerplate's
    // package name folder structure to the new package name's folder structure
    reArrangeNativeAndroidFiles(targetDirectoryPath, packageName);

    // Replace iOS bundle id
    replaceIOSBundleId(newDirectory, boilerPlateBundleId, packageName);

    // Replace iOS Display name
    replaceIOSDisplayName(newDirectory, boilerplateProjectName, projectName);

    // Finally, replace the flutter project name, everywhere!
    replaceFlutterProjectName(
        newDirectory, boilerplateProjectName, projectName);

    // Replace description of the project
    replaceProjectDescription(
        newDirectory, boilerplateDescription, 'New flutter app!');

    print(
        'Finished. Your project is ready in the `OUT` directory! Grab the `$projectName` folder!');
  } else {
    print('Aborted.');
  }
}

void copyReadMe(String targetDirectory) {
  final readMePath = '${Directory.current.path}/setup/';

  copyDirectorySync(Directory(readMePath), targetDirectory);
}

void replaceAndroidPackageName(
    Directory directory, String existingPackageName, String newPackageName) {
// Get a list of files and directories in the current directory
  final contents = directory.listSync();

  // Iterate over each entity in the current directory
  for (var entity in contents) {
    // If the entity is a directory, recursively traverse it
    if (entity is Directory) {
      replaceAndroidPackageName(entity, existingPackageName, newPackageName);
    } else if (entity is File) {
      // If the entity is a file, process it
      final path = entity.path;
      if (path.endsWith('.txt') ||
          path.endsWith('.dart') ||
          path.endsWith('.java') ||
          path.endsWith('.kt') ||
          path.endsWith('.gradle')) {
        replaceTextInFile(entity, existingPackageName, newPackageName);
      }
    }
  }
}

void reArrangeNativeAndroidFiles(
    String targetDirectoryPath, String newPackageName) {
  final mainAndroidEntryPoint =
      '${targetDirectoryPath}android/app/src/main/kotlin/';

  final existingPackageDirectory =
      '$mainAndroidEntryPoint${getPathStructureFromAndroidPackage(boilerplatePackageName)}/';
  final newPackagePath =
      '$mainAndroidEntryPoint${getPathStructureFromAndroidPackage(newPackageName)}/';

  final sourceDirectory = Directory(existingPackageDirectory);
  copyDirectorySync(sourceDirectory, newPackagePath);

  // Delete the old package structure
  Directory('$mainAndroidEntryPoint${boilerplatePackageName.split('.').first}')
      .deleteSync(recursive: true);
}

void replaceIOSBundleId(
    Directory directory, String existingPackageName, String newPackageName) {
  // Get a list of files and directories in the current directory
  final contents = directory.listSync();

  // Iterate over each entity in the current directory
  for (var entity in contents) {
    // If the entity is a directory, recursively traverse it
    if (entity is Directory) {
      replaceIOSBundleId(entity, existingPackageName, newPackageName);
    } else if (entity is File) {
      // If the entity is a file, process it
      final path = entity.path;
      if (path.endsWith('.pbxproj') || path.endsWith('.xcconfig')) {
        replaceTextInFile(entity, existingPackageName, newPackageName);
      }
    }
  }
}

void replaceIOSDisplayName(
    Directory directory, String existingProjectName, String newProjectName) {
  final existingDisplayName =
      getIOSDisplayNameFromFlutterAppName(existingProjectName);
  final newDisplayName = getIOSDisplayNameFromFlutterAppName(newProjectName);

  // Get a list of files and directories in the current directory
  final contents = directory.listSync();

  // Iterate over each entity in the current directory
  for (var entity in contents) {
    // If the entity is a directory, recursively traverse it
    if (entity is Directory) {
      replaceIOSDisplayName(entity, existingDisplayName, newDisplayName);
    } else if (entity is File) {
      // If the entity is a file, process it
      final path = entity.path;
      if (path.endsWith('.plist')) {
        replaceTextInFile(entity, existingDisplayName, newDisplayName);
      }
    }
  }
}

void replaceFlutterProjectName(
    Directory directory, String existingPackageName, String newPackageName) {
  // Get a list of files and directories in the current directory
  final contents = directory.listSync();

  // Iterate over each entity in the current directory
  for (var entity in contents) {
    // If the entity is a directory, recursively traverse it
    if (entity is Directory) {
      replaceFlutterProjectName(entity, existingPackageName, newPackageName);
    } else if (entity is File) {
      // If the entity is a file, process it
      replaceTextInFile(entity, existingPackageName, newPackageName);
    }
  }
}

void replaceProjectDescription(
    Directory directory, String existingDescription, String newDescription) {
  // Get a list of files and directories in the current directory
  final contents = directory.listSync();

  // Iterate over each entity in the current directory
  for (var entity in contents) {
    // If the entity is a directory, recursively traverse it
    if (entity is Directory) {
      replaceProjectDescription(entity, existingDescription, newDescription);
    } else if (entity is File) {
      // If the entity is a file, process it
      replaceTextInFile(entity, existingDescription, newDescription);
    }
  }
}

/// START: Utility functions
void copyDirectorySync(Directory source, String destination) {
  // Create the destination directory if it doesn't exist
  Directory(destination).createSync(recursive: true);

  // Get a list of files and directories in the source directory
  final contents = source.listSync();

  // Copy each file/directory to the destination directory
  for (var entity in contents) {
    // Construct the new path for the entity in the destination directory

    var path = entity.uri.path;

    // Check if it is a directory
    if (path.endsWith('/')) {
      // Remove the last '/'
      path = path.substring(0, path.length - 1);
    }

    final fileOrFolderName = Uri.parse(path).pathSegments.last;

    if (excludedFromCopy.contains(fileOrFolderName)) {
      continue;
    }

    final newPath = '$destination/$fileOrFolderName';

    // Copy the entity to the new path
    if (entity is File) {
      entity.copySync(newPath);
    } else if (entity is Directory) {
      copyDirectorySync(entity, newPath);
    }
  }
}

void replaceTextInFile(File file, String oldWord, String newWord) {
  try {
    // Read the contents of the file
    var contents = file.readAsStringSync();

    // Replace "com.example" with "com.awesome"
    contents = contents.replaceAll(oldWord, newWord);

    // Write the modified contents back to the file
    file.writeAsStringSync(contents);
  } catch (_) {}
}

/// Returns `com/example` path from `com.example` package
String getPathStructureFromAndroidPackage(String packageName) {
  final split = packageName.split('.');
  return split.join('/');
}

String getIOSDisplayNameFromFlutterAppName(String flutterAppName) {
  final split = flutterAppName.split('_');
  final newList = <String>[];

  split.forEach((element) {
    final upperCase = element[0].toUpperCase();
    final copy = upperCase + element.substring(1);
    newList.add(copy);
  });

  return newList.join(' ');
}
