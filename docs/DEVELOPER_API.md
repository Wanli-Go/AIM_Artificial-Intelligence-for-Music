# AIM Developer API Reference

> Version: 1.0 – generated automatically

This document is an **overview of all public-facing Dart APIs** exposed by the AIM Flutter client.  It is intended for contributors who want to extend, integrate or simply understand the internal architecture.

---

## Table of contents

1. Getting started
2. Data Models (`lib/main/model`)
3. Service Layer (`lib/main/service` & `lib/login/utils`)
4. UI Components (`lib/login/components`, `lib/main/component`)
5. Utility Classes
6. Example workflow

---

## 1. Getting started

```
flutter pub get   # install dependencies
flutter run       # launch on the default device/emulator
```

All code lives under `lib/`.  Simply import the corresponding file to start using an API, e.g.

```dart
import 'package:music_therapy/main/service/MusicService.dart';
```

---

## 2. Data Models  <a id="models"></a>

### 2.1 `Music`
File : `lib/main/model/Music.dart`

Purpose: represents a single track and its meta-data.

| Field | Type | Meaning |
|-------|------|---------|
| `musicId` | `String` | Server-side unique id |
| `name` | `String` | Track title |
| `singer` | `String` | Artist name |
| `duration` | `int` | Length in **seconds** |
| `image` | `String` | Album-art URL |
| `file` | `String` | Relative file path on the server |
| `isLike` | `bool` | _true_ if the current user likes the track |
| `tags` | `Map<String,double>?` | Tag-to-score mapping used by the recommender |

Factory constructor `Music.fromJson(Map json)` converts the backend payload to a strongly-typed object.

```dart
final json = await http.get(...);
final track = Music.fromJson(jsonDecode(json.body));
```

Static helpers

* `Music.example` – dummy offline placeholder
* `Music.generatedMusicExample` – placeholder for AI generated track
* `Music.fakeMusicList` – list of mock tracks used when the backend is unreachable
* `Music.recentPlayedList` – tracks played in this session (in-memory)

---

### 2.2 `User`
File : `lib/main/model/User.dart`

| Field | Type | Notes |
|-------|------|-------|
| `userId` | `String` | Primary key |
| `userName` | `String` |
| `image` | `String?` | Avatar URL |
| `userAccount` | `String` | Phone / login id |
| `userIdentity` | `int` | 0 = regular, 1 = VIP |
| `ill` | `String?` | Medical condition (used for personalised therapy) |

```dart
User me = User.fromJson(serverJson);
print(me.userName);
```

---

### 2.3 `GlobalMusic`
File : `lib/main/model/GlobalMusic.dart`

A singleton-style holder for the **currently playing track** and a single global `AudioPlayer` instance.

Key members

* `static Music music` – getter/setter.  Setting this property automatically:
  * updates global audio source
  * starts playback
  * pushes the track to `Music.recentPlayedList`
* `static List<Music> musicList` – active playlist
* `static void nextSong()` / `previousSong()` – navigate the playlist

---

## 3. Service layer  <a id="services"></a>

### 3.1 `LoginService`
File : `lib/login/utils/login_service.dart`

| Method | Signature | Description |
|--------|-----------|-------------|
| `login` | `Future<String> login(String account, String password)` | Authenticate the user. Returns `'1'` on success or *error message* otherwise.  On success, fills `UserData` singleton. |
| `register` | `Future<String> register(String username, String account, String password)` | Create a new user. Same result contract as `login()`. |

#### Usage
```dart
final result = await LoginService.login('13800010001', 'P@ssw0rd');
if(result == '1') {
  Navigator.pushReplacementNamed(context, '/home');
}
```

---

### 3.2 `MusicService`
File : `lib/main/service/MusicService.dart`

| Method | Return type | Parameters | Purpose |
|--------|-------------|------------|---------|
| `getRecent` | `Future<List<Music>>` | `userId` | Last-played tracks – **home page carousel** |
| `getLiked` | `Future<List<Music>>` | `userId`, `page`, `pageSize` | Paginated list of favourites |
| `getGenerated` | `Future<Music>` | `userId`, `description` | Trigger AI generation and return the newly created track (≈ 30 s preview) |
| `likeMusic` | `Future<bool>` | `userId`, `musicId` | Toggle _like_ flag |
| `addRecent` | `Future<bool>` | `userId`, `musicId` | Report that the track was played |
| `getMusicDetail` | `Future<Music>` | `musicId` | Retrieve full meta-data |

```dart
final list = await MusicService().getLiked(myId, 1, 20);
setState(() => likedSongs = list);
```

_Note:_ All network failures fall back to `Music.fakeMusicList` enabling offline debugging.

---

### 3.3 `ChatService`
File : `lib/main/service/chat_service.dart`

| Method | Signature | Description |
|--------|-----------|-------------|
| `sendMessage` | `Future<Message> sendMessage(String userId, String content, bool isFirst)` | Send a prompt to the therapeutic AI.  Prefixed with `*` when it is the first turn (special backend token).  Returns the assistant reply wrapped in a `Message` model. |

```dart
final response = await ChatService.sendMessage(myId, 'I feel stressed', true);
print(response.content);
```

---

## 4. UI Components <a id="components"></a>

| Widget | File | Purpose |
|--------|------|---------|
| `AppTextFormField` | `lib/login/components/app_text_form_field.dart` | Opinionated `TextFormField` with built-in spacing and styles for login screens. |
| `GradientBackground` | `lib/login/components/gradient_background.dart` | Re-usable colourful gradient wrapper. |
| `BottomMusicBar` | `lib/main/component/BottomMusicBar.dart` | Persistent bottom player control (shows title, artist, play/pause). |
| `Disc` | `lib/main/component/Disc.dart` | Animated rotating record vinyl used in player & home page. |
| `GenericMusicList` | `lib/main/component/GenericMusicList.dart` | Scrollable card list of `Music` objects. |

### Example – embedding BottomMusicBar
```dart
Scaffold(
  body: HomePage(),
  bottomNavigationBar: const BottomMusicBar(),
);
```

---

## 5. Utility Classes

| Class | File | Notes |
|-------|------|-------|
| `AppRegex` | `lib/login/utils/login_regex.dart` | Validation patterns – Chinese phone number / password strength |
| `LoginThemes` | `lib/login/utils/login_themes.dart` | Centralised colours/fonts for login pages |
| `app_theme.dart` | `lib/app_theme.dart` | Global colour scheme used across the app |

---

## 6. Typical end-to-end flow <a id="flow"></a>

1. **Authenticate**
   ```dart
   final ok = await LoginService.login(phone, pwd);
   if (ok == '1') { /* navigate to Home */ }
   ```
2. **Fetch home content**
   ```dart
   final recent = await MusicService().getRecent(UserData.userId);
   final liked  = await MusicService().getLiked(UserData.userId, 1, 10);
   ```
3. **Play a song**
   ```dart
   GlobalMusic.music = recent.first;
   // BottomMusicBar automatically updates & starts playback
   ```
4. **Chat with AI & generate music**
   ```dart
   final reply = await ChatService.sendMessage(UserData.userId, 'I need something relaxing', true);
   final generated = await MusicService().getGenerated(UserData.userId, reply.content);
   GlobalMusic.musicList.insert(0, generated);
   ```

---

## Contributing

* Run `dart analyze` before committing.
* UI components should be placed in the appropriate **component** folder and exported in an index file for easy imports.
* Write unit tests in `test/` when adding business logic.

_Enjoy hacking on AIM!_