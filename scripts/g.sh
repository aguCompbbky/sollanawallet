#!/bin/bash

echo "🚀 Freezed & JsonSerializable build başlatılıyor..."

flutter pub get
flutter pub run build_runner build --delete-conflicting-outputs

echo "✅ build_runner tamamlandı!"