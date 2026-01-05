# 🌟 Aurora Image Viewer

A premium Flutter application that fetches random images from an API and displays them with an immersive blur background effect.

![Flutter Version](https://img.shields.io/badge/Flutter-3.10%2B-blue)
![Dart Version](https://img.shields.io/badge/Dart-3.0%2B-blue)
![License](https://img.shields.io/badge/License-MIT-green)

## 📹 Demo

[Watch the demo video](./demo/app_demo.mp4)

*Or view on YouTube: [Link]*

## ✨ Features

- 🎨 **Dynamic Blur Background**: Automatic blurred background for each image
- 🌈 **Color Extraction**: Extracts dominant color from images
- 💫 **Smooth Animations**: Fade-in/out effects on image transitions
- ⚡ **Shimmer Loading**: Premium gold shimmer loading placeholder
- 🎯 **MVVM Architecture**: Clean architecture with Provider state management
- 🌓 **Dark/Light Mode**: Full support for both themes
- ♿ **Accessibility**: Semantics labels and proper touch targets
- 🚀 **Image Caching**: Performance optimization with Cached Network Image

## 📱 Screenshots

| Loading State | Image Display | Dark Mode |
|---------------|---------------|-----------|
| ![Loading](./screenshots/loading.png) | ![Display](./screenshots/display.png) | ![Dark](./screenshots/dark.png) |

## 🏗️ Architecture

This project follows **MVVM (Model-View-ViewModel)** architecture:

```
lib/
├── main.dart                    # App entry point
├── core/
│   └── theme/
│       └── app_theme.dart       # Premium theme definitions
├── models/
│   └── image_model.dart         # Image data model
├── services/
│   └── image_service.dart       # API integration service
├── viewmodels/
│   └── image_viewmodel.dart     # Business logic & state management
└── views/
    ├── home_view.dart           # Main screen
    └── widgets/
        ├── image_card.dart      # Image card widget
        ├── shimmer_placeholder.dart  # Loading placeholder
        └── another_button.dart  # Premium button widget
```

## 🔧 Tech Stack

| Technology | Purpose |
|------------|---------|
| **Flutter 3.10+** | UI Framework |
| **Provider** | State Management |
| **http** | API Calls |
| **cached_network_image** | Image Caching |
| **palette_generator** | Color Extraction |
| **shimmer** | Loading Animation |

## 🚀 Getting Started

### Prerequisites

- Flutter SDK (3.10 or higher)
- Dart SDK (3.0 or higher)
- iOS Simulator or Android Emulator

### Installation

1. **Clone the repository:**
```bash
git clone https://github.com/tunckankilic/AuroraAssignment.git
cd aurora
```

2. **Install dependencies:**
```bash
flutter pub get
```

3. **Run the app:**
```bash
flutter run
```

## 🌐 API

The app uses the following API endpoint:

```
GET https://november7-730026606190.europe-west1.run.app/image/
```

**Response:**
```json
{
  "url": "https://images.unsplash.com/photo-..."
}
```

## 📝 Usage

1. App opens and automatically loads the first image
2. Premium gold shimmer loading is displayed while fetching
3. Image appears with fade-in effect
4. Background automatically shows blurred version of the image
5. Tap "Another" button to load a new random image
6. Smooth transition animations update both image and background

## 🎨 Design System

Aurora embraces a premium and minimal design philosophy:

**Color Palette:**
| Color | Hex | Usage |
|-------|-----|-------|
| Primary Dark | `#0A0A0A` | Background |
| Accent Gold | `#D4AF37` | Buttons, Highlights |
| Surface | `#1A1A1A` | Cards, Surfaces |

**Typography:** Clean and minimal sans-serif

**Animations:** 500-800ms smooth transitions

**Shadows:** Subtle depth-creating shadows

## ⚡ Performance Optimizations

- ✅ Image caching minimizes network usage
- ✅ Lazy loading and on-demand image fetching
- ✅ Efficient state management with Provider
- ✅ Optimized blur effects using BackdropFilter
- ✅ Smooth animations without frame drops

## 🐛 Error Handling

The app gracefully handles the following error scenarios:

| Error Type | User Feedback |
|------------|---------------|
| Network connection errors | Error message + Retry button |
| API timeout errors | Error message + Retry button |
| Image loading errors | Placeholder + Retry option |
| Color extraction errors | Falls back to default color |

## 📱 Platform Support

- ✅ iOS
- ✅ Android
- ✅ Web
- ✅ macOS
- ✅ Linux
- ✅ Windows

## 🧪 Testing

Run widget tests:
```bash
flutter test
```

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 👤 Author

**Ismail Tunc Kankilic**
- LinkedIn: [linkedin.com/in/ismail-tunc-kankilic](https://linkedin.com/in/ismail-tunc-kankilic)
- GitHub: [github.com/tunckankilic](https://github.com/tunckankilic)

## 🙏 Acknowledgments

- [Unsplash](https://unsplash.com) - For the beautiful images
- [Flutter Team](https://flutter.dev) - For the amazing framework
- [Aurora](https://joinaurora.co) - For the design inspiration

---

Built with ❤️ for Aurora Engineering Assessment