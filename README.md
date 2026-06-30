# flutter_starter_app

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

### Локальный запуск

Для локального запуска приложения выполните следующие шаги:

1. Установите зависимости:
   ```bash
   flutter pub get
   ```

2. Запустите проект:
   ```bash
   flutter run
   ```
3. Сборка (APK и App Bundle)
   Поскольку в приложении используются динамические категории с настраиваемыми иконками, сборку релизного релиза необходимо выполнять с флагом `--no-tree-shake-icons`:

   Для сборки APK:
   ```bash
   flutter build apk --release --no-tree-shake-icons
   ```

   Для сборки App Bundle (для Google Play):
   ```bash
   flutter build appbundle --release --no-tree-shake-icons
   ```

Путь, где будет находиться готовый apk - `"build/app/outputs/flutter-apk/app-release.apk"`

> [!NOTE]
> Перед запуском убедитесь, что у вас запущен эмулятор/симулятор или подключено реальное устройство. Список доступных устройств можно посмотреть с помощью команды `flutter devices`.

A few resources to get you started if this is your first Flutter project:

- [Learn Flutter](https://docs.flutter.dev/get-started/learn-flutter)
- [Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Flutter learning resources](https://docs.flutter.dev/reference/learning-resources)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
