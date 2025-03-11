# Keep the JP2Decoder class
-keep class com.gemalto.jp2.JP2Decoder { *; }

# Keep classes from tom_roush.pdfbox package
-keep class com.tom_roush.pdfbox.** { *; }
-keep class org.apache.pdfbox.** { *; }

# Additional rules that may help with other PDFBox dependencies
-dontwarn com.tom_roush.pdfbox.**
-dontwarn org.apache.pdfbox.**
