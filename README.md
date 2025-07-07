# crow-nest.rfc
Submissions repository for `ASOC5` - Lost and Found Mobile App

> [!NOTE]
All discussions regarding `ASOC5: Lost and Found Mobile App` shall take place in https://github.com/orgs/acm-avv/discussions/13.

https://github.com/acm-avv/crow-nest.rfc

## Overview
In-order to be eligible to work on this project as **Request for Code** under the banner of **Amrita Summer of Code, 2025**, you are required to form a team of size 1-4 and have all the members register at [amsoc.vercel.app](https://amsoc.vercel.app)

## Project Manager Details
```json
"Name": "Revanth Singothu",
"Year": "4th",
"Roll": "CB.EN.U4CSE22149",
"GitHub": "@rev-sin",
```

## How to Apply
Type out a message in https://github.com/orgs/acm-avv/discussions/13 with the following details:
1. Team Name
2. Team Members' Names, Roll-Numbers and respective GitHub usernames
3. Tag the project manager as **@username**

## Guidelines
1. Keep all discussions limited to this discussion channel by tagging the project manager via **@username**
2. Do not try to contact the project manager personally unless they are open to it.
4. Maintain decorum and avoid any misbehavior with the project manager. This can be subjected to disqualification.
5. Send us an update every week with regards to your progress for your respective project. If we do not receive an update for more than 10 days then your team will be disqualified automatically.

---
## Project Description

A **Lost and Found Mobile App** will be developed to simplify the process of reporting and claiming lost items within an educational institution (e.g., a university or school). It will feature a Flutter-based mobile application and a supporting backend, accessible to students and teachers via Microsoft OAuth.

* **Overall Goal:** To create a simple, easy-to-use, and deployable lost and found system for mobile (Android and iOS) within the current semester.

* **Repository 1: Mobile Application (Flutter)**
    * **Platform:** Flutter (supports both Android and iOS).
    * **User Access:** Students and teachers can log in via Microsoft OAuth.
    * **Functionality for All Users (Students & Teachers):**
        * View lists of "lost items" reported by various blocks (Academics, Canteen, Library, etc.).
        * Claim their lost articles.
    * **Functionality for Admins Only:**
        * Upload pictures of lost items.
        * Add detailed information on "How to claim" an item.

* **Repository 2: Backend System**
    * **Purpose:** To support the mobile application's functionalities.
    * **Key Responsibilities:**
        * Manages the listing and categorization of lost items from different blocks.
        * Handles user authentication via Microsoft OAuth.
        * Stores item details, including pictures and claiming instructions.
        * Manages the claiming process.
        * Ensures data security and role-based access control.
