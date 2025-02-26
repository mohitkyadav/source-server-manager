[2025-02-24]
- Installed flutter 2.2.3 from https://docs.flutter.dev/release/archive

[2025-02-25]
- Needed to change packages/flutter_tools/bin/podhelper.rb, replaced 
```diff
-return [] unless File.exists? file_path
+return [] unless File.exist? file_path
```
