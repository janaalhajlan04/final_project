# Task Manager — Smart Productivity 

A modern task management application built with Flutter and powered by Supabase.

This project is not just a UI demo.  
It is a structured productivity system designed to:

- Track real deadlines
- Detect overdue tasks automatically
- Separate completed work from remaining workload
- Maintain clean architecture between UI and backend
- Provide a smooth, minimal and intentional user experience


---

## Core Capabilities

- Create structured tasks (title, description, category, date & time)
- Update and edit tasks seamlessly
- Delete tasks with confirmation handling
- Mark tasks complete / incomplete
- Automatic overdue detection logic
- Live task counters (Completed / Remaining / Overdue)
- Category-based filtering
- Clean gradient-based UI system
- Backend persistence via Supabase

---

## 📂 Architecture Overview

This project follows a simple but intentional structure:
lib/
├── model/  → Data models
├── service/  → Supabase communication layer
├── screens/  → UI screens
├── widgets/  → Reusable UI components
└── main.dart

---

 ##📸 App Preview
  <p align="center">
<img width="260" alt="splash" src="https://github.com/user-attachments/assets/ca2b82c0-4dde-4068-b030-23b5886c3a65" />
<img width="260" alt="signup" src="https://github.com/user-attachments/assets/2462f7fe-19d5-4c9a-9f81-8ebb065d7c42" />
<img width="260" alt="login" src="https://github.com/user-attachments/assets/c7623b2b-d4d3-4d56-aab4-e0c698a6cc9b" />
<img width="260" alt="home" src="https://github.com/user-attachments/assets/4bba0217-a1fe-40ea-a3e6-811a2ab2b17c" />
<img width="260" alt="create" src="https://github.com/user-attachments/assets/12fd9186-291d-42c4-97ef-e62b8958b459" />
<img width="260" alt="alerts" src="https://github.com/user-attachments/assets/c5d64103-7421-48d9-8ab3-425197200679" />
<img width="260" alt="edit" src="https://github.com/user-attachments/assets/f358491f-fcc7-41fb-9249-e542a4629692" />
</p>

---

## Technical Stack

- Flutter
- Dart
- Supabase
- Material Design System

---

## Task Status Logic
Status is computed dynamically using:

- Deadline comparison (`DateTime.now()`)
- Completion flag
- Null safety handling

This ensures accurate task classification without redundant database fields.

The app automatically calculates task status:

- 🟢 Completed → If task is marked done
- 🔴 Overdue → If deadline passed and not completed
- 🟠 Pending → Upcoming and not completed

---

 ## 🗄 Database Table (Supabase)

The application uses a Supabase table named tasks.

### Table Structure Includes:

- id
- title
- description
- category
- created_at
- task_datetime
- is_completed

<p align="center">
<img width="300" alt="Screenshot 2026-02-22 211045" src="https://github.com/user-attachments/assets/0b080da3-c0c9-41d7-9361-de825aa82620" />
<img width="300" alt="Screenshot 2026-02-22 211108" src="https://github.com/user-attachments/assets/f6ab85cb-9594-4d37-8086-15667f490d35" />
</p>



