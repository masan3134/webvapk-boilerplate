#!/bin/bash

### ✅ WebVAPK: MVP WebView'den APK Derleyici v1.0
### 🔐 GitHub SSH bağlantılı, sıfır hata yapılı, full otomatik betik

set -e

### 🌐 Web adresini al
read -p $'\n🌐 Lütfen WebView adresini girin (https ile): ' WEB_URL
if [[ -z "$WEB_URL" || "$WEB_URL" != https* ]]; then
  echo -e "\n❌ Geçersiz adres! Lütfen 'https://' ile başlayan geçerli bir adres girin."
  exit 1
fi

### 📁 Geçici proje dizini ve APK çıktısı
PROJECT_DIR="$HOME/.webvapk_temp"
APK_OUTPUT="$HOME/Downloads/WebAPK.apk"

rm -rf "$PROJECT_DIR"
mkdir -p "$PROJECT_DIR"
cd "$PROJECT_DIR"

### 🔐 SSH ile GitHub'dan proje çekiliyor
echo -e "\n📦 SSH ile template proje klonlanıyor..."
git clone git@github.com:masan3134/webvapk-boilerplate.git . || {
  echo -e "\n❌ SSH klonlama başarısız. Anahtar veya repo adı kontrol edilmeli."
  exit 1
}

### ⚙️ WebView adresini Java koduna entegre et
MAIN_JAVA="app/src/main/java/com/example/webview/MainActivity.java"
if [[ ! -f "$MAIN_JAVA" ]]; then
  echo -e "\n❌ HATA: $MAIN_JAVA bulunamadı."
  exit 1
fi

sed -i "s|https://example.com|$WEB_URL|g" "$MAIN_JAVA"

### 🛠️ APK derleniyor...
echo -e "\n🔧 APK derleniyor... (lütfen bekleyin)"
chmod +x ./gradlew
./gradlew assembleRelease || {
  echo -e "\n❌ Derleme BAŞARISIZ. Lütfen sistem kaynaklarını ve klasör izinlerini kontrol edin."
  exit 1
}

### 📤 APK taşınıyor
FINAL_APK_PATH="app/build/outputs/apk/release/app-release.apk"
if [[ -f "$FINAL_APK_PATH" ]]; then
  cp "$FINAL_APK_PATH" "$APK_OUTPUT"
  echo -e "\n✅ WebAPK başarıyla oluşturuldu: $APK_OUTPUT"
else
  echo -e "\n❌ APK dosyası bulunamadı. Derleme başarısız olabilir."
  exit 1
fi
