# Habit Tracker App

## Overview

The Habit Tracker App is a simple yet powerful tool to help users track their daily habits. It features a heatmap visualization, allowing users to see their progress over time. Users can add, edit, and delete habits, and they also have the option to switch between light and dark modes.

## Features

1. **Habit Management:**
   - Add new habits with customizable names.
   - Edit existing habits (including changing their names or descriptions).
   - Delete habits when they are no longer relevant.

2. **Heatmap Visualization:**
   - The heatmap provides an intuitive view of habit completion over days or weeks.
   - Each cell in the heatmap represents a day, and its color intensity reflects the habit's completion status (e.g., darker green for more task completed - think of the github ).

3. **Light and Dark Modes:**
   - Users can toggle between light mode (for daytime) and dark mode (for night time or low-light conditions).

## Technologies Used

- **Isar:** The local database for storing habit data.
- **Slideable:** For smooth swipe actions (e.g., edit & delete buttons).
- **Heatmap Calendar:** To create the heatmap visualization.
- **Provider:** For efficient state management of habits.

## Getting Started

1. **Clone the Repository:**

   ```
   git clone https://github.com/damooola/habit-tracker-app.git
   ```

2. **Install Dependencies:**

   ```
   cd habit-tracker
   flutter pub get
   ```

3. **Run the App:**

   ```
   flutter run
   ```

## Contributing

Contributions are welcome! Feel free to open an issue or submit a pull request if you find any errors and have suggestions. Happy coding! 🚀
