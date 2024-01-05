export DIR=$(pwd) && flutter build appbundle && cd build/app/intermediates/merged_native_libs/release/out/lib && zip -r symbols.zip . && mv symbols.zip $DIR && cd $DIR
