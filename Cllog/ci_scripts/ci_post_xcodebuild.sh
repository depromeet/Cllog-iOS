# firebase dsym upload
if [ "$CI_XCODE_SCHEME" = "Prod" ];
then
  ~/Library/Developer/Xcode/DerivedData/Cllog/SourcePackages/artifacts/FirebaseCrashlytics/upload-symbols -gsp ../{root}/Firebase/GoogleService-Info.plist -p ios $CI_ARCHIVE_PATH/dSYMs
fi
