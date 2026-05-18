# Little Moments Journal - Provider + HTTP

A beautiful Flutter journal app that allows users to save meaningful quotes and moments using **Provider** state management and **HTTP** package.

## Features

-  **READ** - Fetch inspiring quotes from DummyJSON API
-  **CREATE** - Add custom quotes to your journal
-  **UPDATE** - Edit personal notes and mark favorites
-  **DELETE** - Remove quotes from journal with swipe
-  Loading states with beautiful animations
-  Error handling with retry option
-  Favorite quotes collection
-  Personal notes for each quote

## 🛠️ Tech Stack

- Flutter SDK
- Provider (State Management)
- HTTP (Network Requests)
- DummyJSON API



### API Used
DummyJSON Quotes API
Endpoint: https://dummyjson.com/quotes
Method: GET
Returns: List of quotes with id, quote, author


##  Getting Started

### Prerequisites

- Flutter SDK (>=3.0.0)
- Dart (>=3.0.0)

### Installation

1. Clone the repository
```bash
git clone https://github.com/YOUR_USERNAME/little_moments_journal.git
cd little_moments_journal
flutter pub get
flutter run
