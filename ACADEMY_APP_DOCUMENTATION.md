# 📱 Academy App - Complete Architecture & Implementation Guide

> **CodeCanyon LMS App** - Learning Management System for Flutter  
> **Backend:** <https://www.tafawoq.net/>  
> **Last Updated:** January 19, 2026

---

## 📑 Table of Contents

1. [Overview](#overview)
2. [Project Structure](#project-structure)
3. [Core Configuration](#core-configuration)
4. [Architecture Pattern](#architecture-pattern)
5. [Authentication Flow](#authentication-flow)
6. [Screen Structure](#screen-structure)
7. [Database (SQLite)](#database-sqlite)
8. [API Endpoints](#api-endpoints)
9. [Data Models](#data-models)
10. [Video Player System](#video-player-system)
11. [Monetization Features](#monetization-features)
12. [How to Edit](#how-to-edit-common-features)
13. [Common Issues](#common-issues--fixes)
14. [Data Flow Examples](#data-flow-examples)

---

## 🎯 Overview

This is a **Learning Management System (LMS)** Flutter mobile app that provides:

- ✅ Course browsing & enrollment
- ✅ Video playback (YouTube, Vimeo, Direct URLs)
- ✅ Offline course downloads
- ✅ Course forums/Q&A
- ✅ Course bundles
- ✅ Wishlist functionality
- ✅ Progress tracking
- ✅ User authentication

**Technology Stack:**

- Flutter 3.38.7+
- Provider for state management
- SQLite for offline storage
- HTTP for API communication
- Multiple video players (YouTube, Vimeo, Network)

---

## 📂 Project Structure

```
academy_app/
├── android/                    # Android native code
│   ├── app/
│   │   ├── build.gradle       # App-level Gradle config
│   │   └── src/
│   ├── build.gradle           # Project-level Gradle
│   ├── settings.gradle        # Gradle plugins & versions
│   ├── key.properties         # Signing configuration
│   └── gradle/wrapper/        # Gradle wrapper
│
├── ios/                       # iOS native code
│   ├── Runner/
│   └── Podfile
│
├── lib/                       # Main Flutter code
│   ├── main.dart             # ⭐ App entry point
│   ├── constants.dart        # ⭐ Configuration & colors
│   │
│   ├── models/               # Data models (21 files)
│   │   ├── course.dart       # Course data structure
│   │   ├── user.dart         # User data structure
│   │   ├── bundle.dart       # Bundle data structure
│   │   ├── lesson.dart       # Lesson data structure
│   │   ├── section.dart      # Section data structure
│   │   └── *_db_model.dart   # Database models
│   │
│   ├── providers/            # State management (11 files)
│   │   ├── auth.dart         # ⭐ Authentication provider
│   │   ├── courses.dart      # Course catalog provider
│   │   ├── my_courses.dart   # User's courses provider
│   │   ├── categories.dart   # Categories provider
│   │   ├── bundles.dart      # Bundles provider
│   │   ├── course_forum.dart # Forum provider
│   │   ├── database_helper.dart  # SQLite helper
│   │   └── shared_pref_helper.dart  # Local storage
│   │
│   ├── screens/              # UI screens (38 files)
│   │   ├── splash_screen.dart        # Initial screen
│   │   ├── tabs_screen.dart          # ⭐ Main navigation
│   │   ├── home_screen.dart          # Home/catalog
│   │   ├── auth_screen.dart          # Login
│   │   ├── signup_screen.dart        # Registration
│   │   ├── course_detail_screen.dart # Course details
│   │   ├── my_course_detail_screen.dart  # Enrolled course
│   │   ├── courses_screen.dart       # Course list
│   │   ├── my_courses_screen.dart    # My courses
│   │   ├── my_wishlist_screen.dart   # Saved courses
│   │   ├── account_screen.dart       # User profile
│   │   ├── bundle_*.dart             # Bundle screens
│   │   ├── forum_*.dart              # Forum screens
│   │   └── download_*.dart           # Offline downloads
│   │
│   └── widgets/              # Reusable components (40 files)
│       ├── course_grid.dart          # Course card
│       ├── course_list_item.dart     # Course list item
│       ├── new_youtube_player.dart   # YouTube player
│       ├── from_vimeo_player.dart    # Vimeo player
│       ├── from_network.dart         # Video player
│       └── category_list_item.dart   # Category card
│
├── assets/                   # Images, fonts, icons
│   ├── images/              # App images
│   └── fonts/               # Custom fonts
│
├── pubspec.yaml             # ⭐ Dependencies & config
├── README.md                # Basic readme
└── test/                    # Unit tests

```

**Key File Counts:**

- 38 Screens
- 40+ Widgets
- 21 Models
- 11 Providers

---

## 🔑 Core Configuration

### 1. API Base URL

**File:** `lib/constants.dart` (Line 4)

```dart
const BASE_URL = 'https://www.tafawoq.net/';
```

**To change backend:**

1. Replace URL with your server
2. Ensure API endpoints match (see [API Endpoints](#api-endpoints))
3. Test authentication endpoints first

---

### 2. App Colors & Theme

**File:** `lib/constants.dart` (Lines 6-35)

```dart
// Primary colors
const kBackgroundColor = Color(0xFFF5F9FA);  // Light blue-gray
const kPrimaryColor = Color(0xFF754FFE);      // Purple
const kDarkButtonBg = Color(0xFF273546);      // Dark blue

// Status colors
const kRedColor = Color(0xFFEC5252);          // Error
const kGreenColor = Color(0xFF43CB65);        // Success
const kBlueColor = Color(0xFF68B0FF);         // Info

// Course-specific colors
const kStarColor = Color(0xFFEFD358);         // Rating stars
const kTimeColor = Color(0xFF366cc6);         // Duration
const kLessonBackColor = Color(0xFFf8e5d2);   // Lesson background
```

**To customize:**

- Change color hex values
- Update in one place, reflects everywhere
- Consider brand guidelines

---

### 3. Dependencies

**File:** `pubspec.yaml` (Lines 31-64)

**Main Dependencies:**

```yaml
dependencies:
  flutter:
    sdk: flutter
  
  # State Management
  provider: ^6.0.3
  
  # Networking
  http: ^1.1.0
  connectivity_plus: ^5.0.2
  
  # Storage
  shared_preferences: ^2.0.15
  sqflite: ^2.0.3
  path_provider: ^2.0.11
  
  # Video Players
  youtube_player_flutter: ^9.1.1
  vimeo_embed_player: ^1.0.2
  pod_player: ^0.2.0
  video_player: ^2.9.2
  webview_flutter: ^4.0.6
  
  # UI Components
  cached_network_image: ^3.2.1
  percent_indicator: ^4.2.2
  material_design_icons_flutter: ^7.0.7296
  
  # Utilities
  fluttertoast: ^8.0.9
  image_picker: ^1.1.2
  url_launcher: ^6.1.5
  share_plus: ^10.1.1
  intl: ^0.20.1
```

---

## 🏗️ Architecture Pattern

### State Management: Provider Pattern

**File:** `lib/main.dart` (Lines 48-90)

The app uses **Provider** with 8 main state providers:

```dart
MultiProvider(
  providers: [
    // Authentication
    ChangeNotifierProvider(create: (ctx) => Auth()),
    
    // Categories
    ChangeNotifierProvider(create: (ctx) => Categories()),
    
    // Courses (depends on Auth)
    ChangeNotifierProxyProvider<Auth, Courses>(...),
    
    // My Courses (depends on Auth)
    ChangeNotifierProxyProvider<Auth, MyCourses>(...),
    
    // Languages
    ChangeNotifierProvider(create: (ctx) => Languages()),
    
    // Bundles
    ChangeNotifierProvider(create: (ctx) => Bundles()),
    ChangeNotifierProvider(create: (ctx) => MyBundles()),
    
    // Forum
    ChangeNotifierProvider(create: (ctx) => CourseForum()),
  ],
)
```

---

### Provider Details

#### 1. Auth Provider (`lib/providers/auth.dart`)

**Purpose:** Manage user authentication & session

**Key Properties:**

```dart
String? _token;        // Auth token
String? _userId;       // User ID
User _user;           // User object
```

**Key Methods:**

```dart
Future<void> login(String email, String password)
Future<void> signup(...)
Future<void> updateUserData(...)
Future<void> logout()
bool get isAuth  // Check if user is logged in
```

**Usage Example:**

```dart
final authProvider = Provider.of<Auth>(context, listen: false);
await authProvider.login(email, password);
```

---

#### 2. Courses Provider (`lib/providers/courses.dart`)

**Purpose:** Manage course catalog

**Key Methods:**

```dart
fetchTopCourses()                      // GET /api/top_courses
fetchCoursesByCategory(categoryId)     // GET /api/category_wise_course
fetchCoursesBySearchQuery(query)       // GET /api/courses_by_search_string
fetchCourseDetailById(courseId)        // GET /api/course_details_by_id
filterCourses(category, price, level)  // GET /api/courses_by_filter
toggleWishlist(courseId, token)        // Toggle wishlist
```

---

#### 3. MyCourses Provider (`lib/providers/my_courses.dart`)

**Purpose:** Manage user's enrolled courses

**Key Methods:**

```dart
fetchMyCourses(token)               // GET /api/my_courses
fetchMyCourse(courseId, token)      // GET /api/course_object_by_id
toggleLessonCompleted(lessonId)     // Mark lesson complete/incomplete
```

---

#### 4. Categories Provider (`lib/providers/categories.dart`)

**Key Methods:**

```dart
fetchCategories()              // GET /api/categories
fetchSubCategories(catId)      // GET /api/sub_categories/{id}
fetchAllCategories()           // GET /api/all_categories
```

---

#### 5. Bundles Provider (`lib/providers/bundles.dart`)

**Key Methods:**

```dart
fetchBundles()                 // GET /api/bundles
fetchBundleDetail(bundleId)    // GET /api/bundle_details_by_id
```

---

#### 6. MyBundles Provider (`lib/providers/my_bundles.dart`)

**Key Methods:**

```dart
fetchMyBundles(token)          // GET /api/my_bundles
```

---

#### 7. CourseForum Provider (`lib/providers/course_forum.dart`)

**Key Methods:**

```dart
fetchQuestions(token, courseId, page)  // GET /api/forum_questions
searchQuestions(token, courseId, keyword)
addQuestion(courseId, title, description, token)
addReply(questionId, reply, token)
voteQuestion(questionId, token)
```

---

## 🔐 Authentication Flow

### User Journey

**File:** `lib/screens/splash_screen.dart`

```
┌─────────────────┐
│  Splash Screen  │
└────────┬────────┘
         │
         ├── Check system_settings API
         │   GET /api/system_settings
         │
         ├── course_accessibility == "publicly"
         │   └──> TabsScreen (Home, no login needed)
         │
         └── course_accessibility == "private"
             └──> AuthScreenPrivate (Login required)
```

---

### Login Process

**File:** `lib/providers/auth.dart` (Lines 35-100)

```dart
Future<void> login(String email, String password) async {
  // 1. API Call
  var url = '$BASE_URL/api/login?email=$email&password=$password';
  final response = await http.get(Uri.parse(url));
  final responseData = json.decode(response.body);
  
  // 2. Check validity
  if (responseData['validity'] == 0) {
    // Invalid credentials or unverified email
    _user.validity = responseData['validity'];
    _user.deviceVerification = responseData['device_verification'];
  } else {
    // 3. Store user data
    _user.userId = responseData['user_id'];
    _user.firstName = responseData['first_name'];
    _user.token = responseData['token'];
    _token = responseData['token'];
    
    // 4. Save to SharedPreferences
    await SharedPreferenceHelper().setAuthToken(token);
    
    // 5. Navigate to home
  }
}
```

**Response Example:**

```json
{
  "validity": 1,
  "user_id": "123",
  "first_name": "John",
  "last_name": "Doe",
  "email": "john@example.com",
  "role": "student",
  "token": "abc123xyz",
  "device_verification": "enabled"
}
```

---

### Token Storage

**File:** `lib/providers/shared_pref_helper.dart`

```dart
// Save token
await SharedPreferenceHelper().setAuthToken(token);

// Get token
String? token = await SharedPreferenceHelper().getAuthToken();

// Clear token (logout)
await SharedPreferenceHelper().clearAuthToken();
```

**Storage Location:** SharedPreferences (persistent local storage)

---

### Device Verification

If `device_verification` is enabled, user must verify new devices:

**Flow:**

```
Login → Check device_verification
  └── If "enabled" and new device
      └── Show DeviceVerificationScreen
          └── Enter code sent to email
          └── POST /api/new_login_confirmation/submit
```

---

## 📱 Screen Structure

### Main Navigation

**File:** `lib/screens/tabs_screen.dart`

**Bottom Navigation Bar (4 tabs):**

```dart
┌─────────────────────────────────────┐
│  🏠 Home  |  📚 My Courses  |  ❤️ Wishlist  |  👤 Account  │
└─────────────────────────────────────┘
```

**Tab Screens:**

1. **Home** (`home_screen.dart`) - Course catalog, categories, top courses
2. **My Courses** (`my_courses_screen.dart`) - Enrolled courses (requires auth)
3. **Wishlist** (`my_wishlist_screen.dart`) - Saved courses (requires auth)
4. **Account** (`account_screen.dart`) - Profile & settings (requires auth)

**Dynamic Tab Loading:**

```dart
// If not authenticated
_pages = [HomeScreen(), LoginScreen(), LoginScreen(), LoginScreen()];

// If authenticated
_pages = [HomeScreen(), MyCoursesScreen(), MyWishlistScreen(), AccountScreen()];
```

---

### All Screens (38 Total)

#### Authentication Screens

- `splash_screen.dart` - App initialization
- `auth_screen.dart` - Login screen (public access)
- `auth_screen_private.dart` - Login screen (private mode)
- `login_screen.dart` - Login form
- `signup_screen.dart` - Registration
- `forgot_password_screen.dart` - Password reset
- `verification_screen.dart` - Email verification
- `device_verifcation.dart` - Device verification

#### Course Discovery

- `home_screen.dart` - Main catalog
- `courses_screen.dart` - Course list (category/search/filter)
- `course_detail_screen.dart` - Course details (not enrolled)
- `sub_category_screen.dart` - Subcategory courses

#### My Courses

- `my_courses_screen.dart` - Enrolled courses list
- `my_course_detail_screen.dart` - Enrolled course details
- `mcbd_one.dart` - Course details tab 1
- `mcbd_two.dart` - Course details tab 2
- `mcbd_three.dart` - Course details tab 3

#### Bundles

- `bundle_list_screen.dart` - All bundles
- `bundle_details_screen.dart` - Bundle details
- `my_bundle_courses_list_screen.dart` - My bundle courses
- `my_bundle_course_detail_screen.dart` - Bundle course details

#### Offline Downloads

- `downloaded_course_list.dart` - Downloaded courses
- `download_list_screen.dart` - Download manager

#### Forum

- `forum_reply_screen.dart` - Q&A replies
- `search_forum.dart` - Search forum

#### Account

- `account_screen.dart` - User profile
- `edit_profile_screen.dart` - Edit profile
- `edit_password_screen.dart` - Change password
- `account_remove_screen.dart` - Delete account
- `my_wishlist_screen.dart` - Wishlist

#### Utilities

- `tabs_screen.dart` - Main navigation
- `webview_screen.dart` - In-app browser
- `webview_screen_iframe.dart` - Iframe viewer
- `vimeo_iframe.dart` - Vimeo embed
- `file_data_screen.dart` - File viewer
- `meeting_screen.dart` - Live classes
- `join_screen.dart` - Join meeting

---

### Screen Navigation Flow

```
Splash
  ├── Public Mode → TabsScreen (Home visible)
  └── Private Mode → AuthScreenPrivate → Login → TabsScreen

Home
  ├── Category → CoursesScreen → CourseDetailScreen
  ├── Search → CoursesScreen (search results)
  ├── Top Courses → CourseDetailScreen
  └── Bundles → BundleListScreen → BundleDetailsScreen

CourseDetailScreen
  ├── Free Course → Enroll → MyCoursesScreen
  └── Paid Course → Payment WebView → MyCoursesScreen

MyCoursesScreen
  └── Select Course → MyCourseDetailScreen
      ├── Video Lesson → Video Player
      ├── Quiz → WebView (quiz)
      ├── Forum → ForumReplyScreen
      └── Download → DownloadListScreen
```

---

## 🗄️ Database (SQLite)

**File:** `lib/providers/database_helper.dart`

### Database Schema

**Database Name:** `offline.db`

#### Table 1: video_list

```sql
CREATE TABLE video_list(
  id INTEGER PRIMARY KEY,
  title TEXT,
  path TEXT,              -- Local file path
  lesson_id INTEGER,
  course_id INTEGER,
  section_id INTEGER,
  course_title TEXT,
  section_title TEXT,
  thumbnail TEXT,
  download_id TEXT        -- Download task ID
)
```

#### Table 2: course_list

```sql
CREATE TABLE course_list(
  id INTEGER PRIMARY KEY,
  course_id INTEGER,
  course_title TEXT,
  thumbnail TEXT
)
```

#### Table 3: section_list

```sql
CREATE TABLE section_list(
  id INTEGER PRIMARY KEY,
  section_id INTEGER,
  title TEXT,
  course_id INTEGER
)
```

---

### Database Operations

```dart
// Insert downloaded video
await DatabaseHelper.instance.addVideo(videoModel);

// Get downloaded videos for course
List<Video> videos = await DatabaseHelper.instance.getVideosByCourse(courseId);

// Get all downloaded courses
List<Course> courses = await DatabaseHelper.instance.getDownloadedCourses();

// Delete video
await DatabaseHelper.instance.deleteVideo(videoId);

// Delete entire course
await DatabaseHelper.instance.deleteCourse(courseId);
```

---

### Offline Download Flow

```
MyCourseDetailScreen
  ├── Click Download icon
  ├── Check storage permission
  ├── Download video file
  ├── Save to local storage
  ├── Insert into SQLite (video_list)
  └── Show in DownloadedCourseList
```

**Downloaded File Location:**

```
/storage/emulated/0/Android/data/com.example.academy_app/files/
```

---

## 🌐 API Endpoints

**Base URL:** `https://www.tafawoq.net/api/`

### Authentication

| Method | Endpoint | Parameters | Response |
|--------|----------|------------|----------|
| GET | `/login` | `email`, `password` | User object + token |
| POST | `/signup` | User data | Success/Error |
| POST | `/forgot_password` | `email` | Success message |
| POST | `/verify_email_address` | `verification_code`, `email` | Success |
| POST | `/resend_verification_code` | `email` | Success |

---

### Courses

| Method | Endpoint | Auth | Description |
|--------|----------|------|-------------|
| GET | `/top_courses` | No | Featured courses |
| GET | `/category_wise_course?category_id={id}` | No | Courses by category |
| GET | `/courses_by_search_string?search_string={query}` | No | Search courses |
| GET | `/course_details_by_id/{id}` | No | Course details |
| GET | `/courses_by_filter` | No | Filter courses |
| GET | `/courses_by_subcategory/{id}` | No | Subcategory courses |

**Filter Parameters:**

```
category_id, price (free/paid/all), level (beginner/intermediate/advanced), 
language_id, rating (1-5)
```

---

### My Courses (Authenticated)

| Endpoint | Description |
|----------|-------------|
| `/my_courses?auth_token={token}` | User's enrolled courses |
| `/my_all_courses?auth_token={token}` | All user courses with details |
| `/course_object_by_id/{courseId}/{token}` | Enrolled course with sections |
| `/enroll_free_course` | Enroll in free course |
| `/web_redirect_to_buy_course/{token}/{courseId}/academybycreativeitem` | Purchase redirect |

---

### Categories

| Endpoint | Description |
|----------|-------------|
| `/categories` | All parent categories |
| `/sub_categories/{categoryId}` | Subcategories |
| `/all_categories` | Flat list of all categories |

---

### Bundles

| Endpoint | Description |
|----------|-------------|
| `/bundles` | All bundles |
| `/bundle_details_by_id?id={bundleId}` | Bundle details with courses |
| `/my_bundles?auth_token={token}` | User's purchased bundles |
| `/bundle_courses_by_id?id={bundleId}` | Courses in bundle |
| `/web_redirect_to_buy_bundle/{token}/{bundleId}/academybycreativeitem` | Purchase redirect |

---

### Wishlist (Authenticated)

| Endpoint | Description |
|----------|-------------|
| `/my_wishlist?auth_token={token}` | User's wishlist |
| `/toggle_wishlist_items/{courseId}/{token}` | Add/remove from wishlist |
| `/remove_from_wishlist/{courseId}/{token}` | Remove from wishlist |

---

### Forum (Authenticated)

| Endpoint | Description |
|----------|-------------|
| `/forum_questions/{token}/{courseId}/{page}` | Get questions (paginated) |
| `/search_forum_questions/{token}/{courseId}?search={keyword}` | Search questions |
| `/forum_add_questions/{courseId}` | Add question |
| `/forum_child_questions/{questionId}` | Get replies |
| `/forum_question_vote/{questionId}/{token}` | Upvote question |

---

### User Profile (Authenticated)

| Endpoint | Description |
|----------|-------------|
| `/userdata?auth_token={token}` | User profile data |
| `/update_userdata` | Update profile |
| `/update_password` | Change password |

---

### System

| Endpoint | Description |
|----------|-------------|
| `/system_settings` | App settings (accessibility mode, etc.) |
| `/addon_status?unique_identifier={addon}` | Check addon enabled |
| `/app_logo` | Get app logo URL |

---

### Video Tracking

| Method | Endpoint | Body | Description |
|--------|----------|------|-------------|
| POST | `/update_watch_history/{token}` | `lesson_id`, `course_id`, `current_duration`, `total_duration` | Track video progress |

---

### Live Classes

| Endpoint | Description |
|----------|-------------|
| `/live_class` | Get upcoming live classes |
| `/zoom_live_class` | Zoom meeting details |

---

## 📊 Data Models

### Course Model

**File:** `lib/models/course.dart`

```dart
class Course {
  int? id;
  String? title;
  String? thumbnail;
  String? price;                  // "Free" or "$99"
  String? isFreeCourse;           // "1" or "0"
  String? instructor;             // Instructor name
  String? instructorImage;        // Profile pic URL
  int? rating;                    // 0-5
  int? totalNumberRating;         // Number of ratings
  int? numberOfEnrollment;        // Students enrolled
  String? shareableLink;          // Deep link
  String? courseOverviewProvider; // "youtube", "vimeo", "html5"
  String? courseOverviewUrl;      // Preview video URL
  String? vimeoVideoId;           // Vimeo video ID
}
```

---

### MyCourse Model

**File:** `lib/models/my_course.dart`

Extends Course with:

```dart
class MyCourse extends Course {
  String? courseCompletion;           // "75%" - Progress
  int? totalNumberOfLessons;          // Total lessons
  int? totalNumberOfCompletedLessons; // Completed count
  bool? enableDripContent;            // Time-locked lessons
}
```

---

### Lesson Model

**File:** `lib/models/lesson.dart`

```dart
class Lesson {
  int? id;
  int? sectionId;
  int? courseId;
  String? title;
  String? duration;           // "10:30" - mm:ss
  String? lessonType;         // "video", "quiz", "text", "other"
  String? videoUrl;           // Video source URL
  String? videoTypeWeb;       // "youtube", "vimeo", "html5", "document_type"
  String? vimeoVideoId;       // For Vimeo videos
  bool? isCompleted;          // Completion status
  String? attachmentType;     // "file", "url", "none"
  String? attachment;         // File URL or link
  bool? isFree;               // Preview lesson (free to watch)
  String? videoUrlWeb;        // Web video URL
  String? summary;            // Lesson description
}
```

---

### Section Model

**File:** `lib/models/section.dart`

```dart
class Section {
  int? id;
  int? numberOfCompletedLessons;
  String? title;
  String? totalDuration;      // "1:30:00" - hh:mm:ss
  int? lessonCounterEnds;     // Last lesson number
  int? lessonCounterStarts;   // First lesson number
  List<Lesson>? mLesson;      // Lessons in this section
}
```

---

### User Model

**File:** `lib/models/user.dart`

```dart
class User {
  String? userId;
  String? firstName;
  String? lastName;
  String? email;
  String? role;                   // "student", "instructor", "admin"
  dynamic validity;               // Login validity status
  String? deviceVerification;     // "enabled", "disabled"
  String? token;                  // Auth token
  String? biography;              // User bio
  String? facebook;               // Social links
  String? twitter;
  String? linkedin;
}
```

---

### Bundle Model

**File:** `lib/models/bundle.dart`

```dart
class Bundle {
  int? id;
  String? userId;
  String? title;
  String? banner;             // Banner image URL
  String? courseIds;          // Comma-separated course IDs
  String? subscriptionLimit;  // Max subscribers
  String? price;
  String? bundleDetails;      // Description
  String? status;             // "active", "inactive"
  String? dateAdded;          // Timestamp
  String? lastModified;       // Timestamp
  double? averageRating;      // 0.0-5.0
  int? numberOfRatings;       // Rating count
}
```

---

### CourseDetail Model

**File:** `lib/models/course_detail.dart`

```dart
class CourseDetail {
  int? courseId;
  List<dynamic>? courseIncludes;      // What's included
  List<dynamic>? courseRequirements;  // Prerequisites
  List<dynamic>? courseOutcomes;      // Learning outcomes
  bool? isWishlisted;
  bool? isPurchased;
  List<Section>? mSection;            // Course sections with lessons
}
```

---

## 🎬 Video Player System

The app supports **5 video sources** with automatic player selection:

### Video Type Detection

**File:** `lib/screens/my_course_detail_screen.dart`

```dart
String lessonType = lesson.videoTypeWeb;  // "youtube", "vimeo", "html5"

if (lessonType == "youtube") {
  // Use YouTube Player
} else if (lessonType == "vimeo") {
  // Use Vimeo Player
} else if (lessonType == "html5") {
  // Use Network Player
}
```

---

### Player Widgets

#### 1. YouTube Player

**File:** `lib/widgets/new_youtube_player.dart`

```dart
NewYoutubePlayer(
  url: lesson.videoUrl,  // YouTube URL
  courseId: widget.courseId,
  lessonId: lesson.id,
)
```

**Package:** `youtube_player_flutter: ^9.1.1`

---

#### 2. Vimeo Player

**File:** `lib/widgets/from_vimeo_player.dart`

```dart
VimeoPlayer(
  videoId: lesson.vimeoVideoId,  // Vimeo ID
  courseId: courseId,
  lessonId: lessonId,
)
```

**Package:** `vimeo_embed_player: ^1.0.2`

---

#### 3. Network/Downloaded Video Player

**File:** `lib/widgets/from_network.dart`

```dart
PlayVideoFromNetwork(
  courseId: courseId,
  lessonId: lessonId,
  videoUrl: lesson.videoUrl,  // Direct MP4/M3U8 URL or local path
  isDownloaded: false,        // true for offline videos
)
```

**Package:** `video_player: ^2.9.2`

---

#### 4. Vimeo Iframe

**File:** `lib/screens/vimeo_iframe.dart`

Used as fallback for Vimeo videos

---

### Video Progress Tracking

**Automatic tracking** while playing:

```dart
// Called every 5 seconds during playback
Future<void> updateWatchHistory() async {
  var url = "$BASE_URL/api/update_watch_history/$token";
  
  await http.post(Uri.parse(url), body: {
    'lesson_id': lessonId.toString(),
    'course_id': courseId.toString(),
    'current_duration': currentPosition.toString(),  // In seconds
    'total_duration': totalDuration.toString(),
  });
}
```

**Completion Criteria:**

- Video watched >= 90% → Mark lesson as completed
- Updates course progress percentage

---

## 💰 Monetization Features

### 1. Free vs Paid Courses

**Course Types:**

```dart
course.isFreeCourse == "1"  // Free course
course.isFreeCourse == "0"  // Paid course
```

**Enrollment Logic:**

```dart
if (course.isFreeCourse == "1") {
  // Direct enrollment
  POST /api/enroll_free_course
  body: { course_id, user_id }
} else {
  // Redirect to payment gateway
  Navigator.push(WebViewScreen(
    url: '$BASE_URL/api/web_redirect_to_buy_course/$token/$courseId/academybycreativeitem'
  ));
}
```

---

### 2. Bundle System

**Check if bundles enabled:**

```dart
var url = '$BASE_URL/api/addon_status?unique_identifier=course_bundle';
final response = await http.get(Uri.parse(url));
int bundleStatus = json.decode(response.body)['status'];

if (bundleStatus == 1) {
  // Show bundle section
}
```

**Bundle Purchase:**

```dart
// Redirect to bundle payment
Navigator.push(WebViewScreen(
  url: '$BASE_URL/api/web_redirect_to_buy_bundle/$token/$bundleId/academybycreativeitem'
));
```

---

### 3. Course Accessibility Modes

**System Setting:** `course_accessibility`

```dart
GET /api/system_settings
Response: { 
  "course_accessibility": "publicly"  // or "private"
}
```

**Modes:**

- **publicly**: Anyone can browse & view course info (no login required)
- **private**: Must login to see courses

---

### 4. Payment Integration

**Payment Gateway:** External web-based checkout

**Flow:**

```
1. User clicks "Buy Now"
2. Open WebView with payment URL
3. User completes payment on web
4. Backend updates enrollment
5. Return to app → Course appears in "My Courses"
```

**Payment URL Pattern:**

```
https://www.tafawoq.net/api/web_redirect_to_buy_course/{token}/{courseId}/academybycreativeitem
```

---

## 🔧 How to Edit Common Features

### 1. Change Backend Server

**File:** `lib/constants.dart`

```dart
// Change from:
const BASE_URL = 'https://www.tafawoq.net/';

// To:
const BASE_URL = 'https://yourdomain.com/';
```

**Required:**

- Ensure your backend has matching API endpoints
- Test authentication first
- Update payment gateway URLs if needed

---

### 2. Customize App Branding

#### App Name

**Android:** `android/app/src/main/AndroidManifest.xml`

```xml
<application
    android:label="Your App Name"
```

**iOS:** `ios/Runner/Info.plist`

```xml
<key>CFBundleName</key>
<string>Your App Name</string>
```

#### App Icon

Replace files in:

- Android: `android/app/src/main/res/mipmap-*/ic_launcher.png`
- iOS: `ios/Runner/Assets.xcassets/AppIcon.appiconset/`

Use: [Flutter App Icon Generator](https://pub.dev/packages/flutter_launcher_icons)

---

### 3. Change Colors/Theme

**File:** `lib/constants.dart`

```dart
// Primary color
const kPrimaryColor = Color(0xFF754FFE);  // Change hex code

// Button background
const kDarkButtonBg = Color(0xFF273546);

// Background
const kBackgroundColor = Color(0xFFF5F9FA);
```

**Theme in main.dart:**

```dart
theme: ThemeData(
  fontFamily: 'your_custom_font',  // Change font
  colorScheme: const ColorScheme.light(primary: kPrimaryColor),
),
```

---

### 4. Add Custom Fonts

**Step 1:** Add fonts to `assets/fonts/`

**Step 2:** Update `pubspec.yaml`

```yaml
flutter:
  fonts:
    - family: MyCustomFont
      fonts:
        - asset: assets/fonts/MyFont-Regular.ttf
        - asset: assets/fonts/MyFont-Bold.ttf
          weight: 700
```

**Step 3:** Use in theme

```dart
theme: ThemeData(
  fontFamily: 'MyCustomFont',
)
```

---

### 5. Add New Screen

**Step 1:** Create screen file

```dart
// lib/screens/my_new_screen.dart
class MyNewScreen extends StatefulWidget {
  static const routeName = '/my-new-screen';
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('My New Screen')),
      body: Center(child: Text('Hello!')),
    );
  }
}
```

**Step 2:** Add route in `main.dart`

```dart
routes: {
  MyNewScreen.routeName: (ctx) => MyNewScreen(),
  // ... other routes
}
```

**Step 3:** Navigate to it

```dart
Navigator.pushNamed(context, MyNewScreen.routeName);
```

---

### 6. Modify Course Card Design

**File:** `lib/widgets/course_grid.dart`

Edit the `Container` and `Card` widgets to change:

- Image size/shape
- Text styles
- Spacing
- Colors

---

### 7. Change Bottom Navigation Icons

**File:** `lib/screens/tabs_screen.dart` (Line ~105)

```dart
BottomNavigationBarItem(
  backgroundColor: kPrimaryColor,
  icon: Icon(Icons.home),  // Change icon
  label: 'Home',           // Change label
),
```

---

### 8. Enable/Disable Features

#### Disable Bundles

**File:** `lib/screens/home_screen.dart`

```dart
// Force disable bundles
bundleStatus = 0;  // Instead of API call
```

#### Disable Forum

**File:** `lib/screens/my_course_detail_screen.dart`

```dart
// Comment out forum tab
// tabs: [Details, Lessons, Forum, Live]
tabs: [Details, Lessons, Live]  // Remove Forum
```

---

### 9. Change Splash Screen

**File:** `lib/screens/splash_screen.dart`

```dart
Image.asset(
  'assets/images/splash.png',  // Replace this image
  fit: BoxFit.cover,
)
```

Replace `assets/images/splash.png` with your logo

**Delay before navigation:**

```dart
Future.delayed(const Duration(seconds: 3), () {
  // Change to 5 seconds
  Future.delayed(const Duration(seconds: 5), () {
```

---

### 10. Customize Toast Messages

**File:** Using throughout app with `fluttertoast`

```dart
Fluttertoast.showToast(
  msg: "Your custom message",
  toastLength: Toast.LENGTH_SHORT,
  backgroundColor: Colors.green,  // Change color
  textColor: Colors.white,
);
```

---

## 🐛 Common Issues & Fixes

### 1. ✅ FIXED: "Cannot convert URL to file" Error

**Error:**

```
Cannot convert URL 'C:/Users/user/upload-keystore.jks' to a file
```

**Cause:** Invalid Windows keystore path in `android/key.properties`

**Fix Applied:**

```properties
# android/key.properties
storePassword=123456
keyPassword=123456
keyAlias=upload
#storeFile=C:/Users/user/upload-keystore.jks  # Commented out
```

---

### 2. ✅ FIXED: Gradle Version Error

**Error:**

```
Minimum supported Gradle version is 8.9. Current version is 8.7
```

**Fix Applied:**

```properties
# android/gradle/wrapper/gradle-wrapper.properties
distributionUrl=https\://services.gradle.org/distributions/gradle-8.9-all.zip
```

---

### 3. ✅ FIXED: Kotlin Version Warning

**Warning:**

```
Kotlin version (1.8.22) will soon be dropped. Please upgrade to 2.1.0
```

**Fix Applied:**

```gradle
// android/settings.gradle
plugins {
    id "org.jetbrains.kotlin.android" version "2.1.0" apply false
}
```

---

### 4. ✅ FIXED: @required Deprecated Error

**Error:**

```
The parameter '@required' is deprecated and shouldn't be used
```

**Fix Applied:**

```bash
# Replaced all @required with required
find lib -name "*.dart" -exec sed -i '' 's/@required /required /g' {} +
```

---

### 5. Login Returns Empty Response

**Possible Causes:**

- Wrong API endpoint
- CORS issues
- Server down

**Debug Steps:**

```dart
// Add logging in auth.dart
print('Login URL: $url');
print('Response: ${response.body}');
print('Status Code: ${response.statusCode}');
```

---

### 6. Videos Not Playing

**Troubleshooting:**

**YouTube Videos:**

- Check `lesson.videoUrl` format: `https://youtube.com/watch?v=xxx`
- Ensure YouTube package is installed

**Vimeo Videos:**

- Check `lesson.vimeoVideoId` is valid
- Test video ID in browser: `https://player.vimeo.com/video/{id}`

**Network Videos:**

- Verify URL is accessible (test in browser)
- Check file format (MP4, M3U8)
- Ensure HTTPS (not HTTP)

---

### 7. Offline Downloads Not Working

**Check:**

1. Storage permission granted
2. Sufficient storage space
3. Video URL is downloadable (not streaming-only)
4. Database permissions

**Verify:**

```dart
// Check database
final videos = await DatabaseHelper.instance.getAllVideos();
print('Downloaded videos: ${videos.length}');
```

---

### 8. App Crashes on Startup

**Common Causes:**

- Missing SharedPreferences data
- Network error on splash screen
- Corrupted local database

**Fix:**

```dart
// Clear app data
await SharedPreferences.getInstance().then((prefs) => prefs.clear());
await DatabaseHelper.instance.deleteDatabase();
```

---

### 9. "No Internet Connection" Always Shows

**Check:**

```dart
// Test connectivity
import 'package:connectivity_plus/connectivity_plus.dart';

final result = await Connectivity().checkConnectivity();
print('Connectivity: $result');  // Should not be ConnectivityResult.none
```

---

### 10. Build Fails with "Dart Compiler Exited Unexpectedly"

**Solutions:**

1. **Upgrade Flutter:**

   ```bash
   flutter upgrade
   ```

2. **Clean build:**

   ```bash
   flutter clean
   flutter pub get
   ```

3. **Restart IDE & rebuild**

---

## 📈 Data Flow Examples

### Example 1: User Enrolls in Free Course

```
1. User on CourseDetailScreen
   └── Taps "Enroll Now" button
   
2. CourseDetailScreen checks course type
   └── If course.isFreeCourse == "1"
   
3. Call API
   └── POST /api/enroll_free_course
   └── body: { course_id: 123, user_id: 456 }
   
4. Backend enrolls user
   └── Returns success response
   
5. App updates UI
   └── Button changes to "Go to Course"
   └── Course added to My Courses
   
6. Navigate to MyCourseDetailScreen
   └── Fetch course sections & lessons
   └── GET /api/course_object_by_id/123/token
   
7. Display course content
   └── Show sections with lessons
   └── User can start learning
```

---

### Example 2: User Watches Video Lesson

```
1. User on MyCourseDetailScreen
   └── Selects a lesson
   
2. App checks lesson type
   └── lesson.videoTypeWeb = "youtube"
   
3. Navigate to video player
   └── NewYoutubePlayer widget
   
4. Player initializes
   └── Load YouTube video
   └── Start playback
   
5. Every 5 seconds during playback
   └── POST /api/update_watch_history/token
   └── body: {
        lesson_id: 789,
        course_id: 123,
        current_duration: 120,  // 2 minutes
        total_duration: 600     // 10 minutes total
      }
   
6. Backend tracks progress
   └── Updates completion percentage
   
7. When video reaches 90%
   └── Mark lesson as completed
   └── Update UI (checkmark on lesson)
   └── Update course progress bar
```

---

### Example 3: User Downloads Course for Offline

```
1. User on MyCourseDetailScreen
   └── Taps download icon next to lesson
   
2. Request storage permission
   └── If not granted → show permission dialog
   
3. Start download
   └── Download video file from lesson.videoUrl
   └── Save to app's private storage
   
4. Save to database
   └── INSERT INTO video_list (
        lesson_id, course_id, section_id,
        path, title, thumbnail
      )
   
5. Update UI
   └── Show download progress
   └── Change icon to "downloaded"
   
6. User goes to DownloadedCourseList
   └── Query: SELECT * FROM video_list
   └── Display all downloaded videos
   
7. User plays offline video
   └── PlayVideoFromNetwork(isDownloaded: true)
   └── Load from local path instead of URL
```

---

### Example 4: User Searches Courses

```
1. User on HomeScreen
   └── Taps search bar
   
2. Enter search query
   └── e.g., "Flutter Tutorial"
   
3. Navigate to CoursesScreen
   └── Pass search query as parameter
   
4. CoursesScreen calls provider
   └── Provider.of<Courses>(context).fetchCoursesBySearchQuery('Flutter Tutorial')
   
5. Provider makes API call
   └── GET /api/courses_by_search_string?search_string=Flutter Tutorial
   
6. Backend searches courses
   └── Returns matching courses array
   
7. Provider updates state
   └── _items = buildCourseList(response)
   └── notifyListeners()
   
8. UI rebuilds automatically
   └── Display search results in grid
   └── User can tap to see details
```

---

### Example 5: User Adds Question to Forum

```
1. User on MyCourseDetailScreen → Forum tab
   └── Taps "Ask Question" button
   
2. Show dialog/bottom sheet
   └── Input: Question title
   └── Input: Question description
   
3. User submits question
   └── Validate inputs (not empty)
   
4. Call forum provider
   └── CourseForum.addQuestion(
        courseId: 123,
        title: 'How to...',
        description: 'I need help with...',
        token: userToken
      )
   
5. Provider makes API call
   └── POST /api/forum_add_questions/123
   └── body: { title, description, auth_token }
   
6. Backend creates question
   └── Returns question object with ID
   
7. Update UI
   └── Add new question to list
   └── Show success toast
   └── Close dialog
   
8. Other users see the question
   └── Refresh forum questions list
   └── Can reply or vote
```

---

## 🎓 Key Takeaways

### Architecture Strengths

✅ Clean separation of concerns (Models, Views, Providers)  
✅ Reusable widgets for consistent UI  
✅ Offline-first approach with SQLite  
✅ Multiple video player support  
✅ Proper state management with Provider  

### Customization Points

🎨 Colors & theme in `constants.dart`  
🔧 API endpoint in `constants.dart`  
📱 Screens are modular and easy to modify  
🖼️ Assets can be replaced in `assets/` folder  
💳 Payment gateway can be swapped  

### Best Practices Used

📦 Dependency injection via Provider  
🔄 Async/await for API calls  
💾 Local caching with SharedPreferences  
🎬 Adaptive video player selection  
📊 Progress tracking and analytics  

---

## 📚 Resources

### Flutter Documentation

- [Flutter Docs](https://docs.flutter.dev/)
- [Provider Package](https://pub.dev/packages/provider)
- [Video Player](https://pub.dev/packages/video_player)

### App-Specific

- **Backend API:** <https://www.tafawoq.net/api/>
- **Payment Gateway:** Web-based (configured in backend)
- **Video Hosting:** YouTube, Vimeo, or direct hosting

### Development Tools

- **Flutter DevTools:** `flutter pub global activate devtools`
- **API Testing:** Postman or Insomnia
- **Database Viewer:** DB Browser for SQLite

---

## 🔄 Version History

| Version | Date | Changes |
|---------|------|---------|
| 1.0.0 | Jan 19, 2026 | Initial investigation & documentation |
| - | - | Fixed Gradle 8.9 requirement |
| - | - | Updated Kotlin to 2.1.0 |
| - | - | Fixed keystore path issue |
| - | - | Replaced @required with required |

---

## 📞 Support & Contact

**For Backend/API Issues:**

- Check with CodeCanyon support or original developer

**For Flutter Issues:**

- Flutter community: <https://flutter.dev/community>
- Stack Overflow: [flutter] tag

**For This Documentation:**

- Review code in respective files
- Check inline comments
- Test features in the app

---

**End of Documentation**

*Last Updated: January 19, 2026*
*Created by: AI Assistant*
*App: Academy LMS Mobile App*
