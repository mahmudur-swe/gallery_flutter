# 📷 Gallery Flutter App

#### A cross-functional, cleanly architected Flutter photo gallery application that features optimized native thumbnail loading, custom in-memory and disk caching, image selection with blur effects, and secure local photo saving functionality.
---

### 🚀 Features

- Load photos from device gallery using native platform channels
- Dual resolution thumbnails (low-res first, then high-res)
- Progressive image loading with shimmer placeholder
- Selectable photos with visual tick and blur effect
- Save selected images to device gallery
- Custom in-memory and disk caching
- Works across Android & iOS
- BLoC + Clean Architecture

---

### 🛠 Tech Stack

- **Flutter**: 3.29.3 (stable)
- **Dart**: 3.7.2
- **Architecture**: Clean Architecture
- **State Management**: BLoC & Cubit
- **Navigation**: go_router
- **Testing**: flutter_test, mocktail
- **Image Handling**: Custom in-memory LRU and disk caching with native thumbnail support
- **Thumbnail Optimization**: Dual resolution support (Low & High)
- **Permissions**: permission_handler
- **UI Toolkit**: Material Design + Shimmer + Custom Theming

---

## 📈 Run Tests with Coverage

To run all unit tests and generate a coverage report:

```bash
flutter test --coverage
```
#### Mac 
```bash
brew install lcov
genhtml coverage/lcov.info -o coverage/html
open coverage/html/index.html
```
#### Windows 
```bash
choco install lcov
genhtml coverage/lcov.info -o coverage/html
start coverage/html/index.html
```

#### App link
https://drive.google.com/drive/folders/1RVg5J6iexK38YCNd50iO1cVBHtHgnzjp?usp=sharing
