# document_file_save
Save bytes data into Download folder (Android), or show save dialog (iOS). You can save any file types (Ex. .txt, .png, .jpg, .pdf, etc)

## Install plugin
add this line into pubspec.yaml
```
document_file_save: ^1.0.2
```

## Permission
### Android
if your project set android target >= Android Q, you don't have to add any permission.
Otherwise, Add the following statement in `AndroidManifest.xml`:
```
<uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE" />
```

### iOS
No permission needed.

## Function description
```
// call function 'saveFile' if you 1 file to save.
void saveFile(Uint8List data, String fileName, String mimeType)

// call function 'saveMultipleFiles' if you have mutiple files to save. iOS will show save dialog only once
void saveMultipleFiles(List<Uint8List> dataList, List<String> fileNameList, List<String> mimeTypeList)
```

## Example usage
```
import 'package:document_file_save/document_file_save.dart';

//Save text file into Download folder.
List<int> textBytes = utf8.encode("Some data");
DocumentFileSave.saveFile(textBytes, "my_sample_file.txt", "text/plain");

//Save pdf file into Download folder.
DocumentFileSave.saveFile(pdfBytes, "my_sample_file.pdf", "appliation/pdf");

//Save image file into Download folder.
DocumentFileSave.saveFile(imageJPGBytes, "my_sample_file.jpg", "image/jpeg");

//Save multiple files
DocumentFileSave.saveMultipleFiles([pdfBytes, textBytes], ["my_sample_file.pdf", "my_sample_file.txt"], ["appliation/pdf", "text/plain"]);
```



