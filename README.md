# AIM - Artificial Intelligence for Music

## What's our App for?

"AIM" (Artificial Intelligence for Music) is a pioneering software application designed to harness the therapeutic potential of music for health and well-being. This cutting-edge platform is meticulously crafted to cater to individuals seeking solace and healing through music. Here's an in-depth look at AIM's standout features:

### Personalized User Profiles with Medical Insights
 At its core, AIM emphasizes personalization. Users can create comprehensive profiles that include not just basic demographic information, but also detailed medical conditions and specific wellness goals. This feature allows AIM to understand its users at a deeper level, tailoring its music recommendations to align perfectly with each individual's health needs and preferences.

### Intuitive Homepage with Smart Recommendations
The homepage serves as a welcoming interface, showcasing a blend of recently played tracks and personalized playlist recommendations. This feature is powered by an advanced algorithm that learns from the user's listening habits and health profile, ensuring that every piece of music aligns with their therapeutic needs. Whether it's soothing melodies for stress relief or stimulating tunes for cognitive enhancement, AIM's homepage becomes a gateway to a healing musical journey.

### Dynamic Recommendation Page for Discovering New Music
AIM's recommendation page is a treasure trove of musical gems. Here, users are introduced to a curated list of songs, each selected based on their unique profile. This page is constantly updated, reflecting the evolving tastes and health requirements of the user. It's an exploratory space where one can discover new artists, genres, and compositions that resonate with their soul and aid in their healing process.

### Conversational Music Generation with AI Chatbot
Perhaps the most innovative feature of AIM is its ability to generate custom music based on interactions with an AI chatbot. This chatbot, equipped with empathetic listening skills, engages in meaningful conversations with the user. Based on the mood, themes, and preferences expressed during these interactions, AIM composes original music pieces in real-time. This feature not only provides a highly personalized musical experience but also adds an element of surprise and creativity, as users witness the birth of music that's a direct reflection of their thoughts and emotions.

In summary, AIM stands as a testament to the harmonious blend of technology and art, aiming to provide solace, healing, and emotional enrichment through the power of music. It's not just a software; it's a companion on the journey towards holistic well-being.

## Project Structure

This App is written in Dart with the Flutter Framework: [Flutter Official Website](https://flutter.dev/).

**Root Directory (lib)**: This is the main library directory containing all the Dart files and folders. It includes main.dart, the entry point of your Flutter application.

**component Directory**: This folder contains reusable UI components that can be utilized throughout your application. Examples include BottomMusicBar.dart for a music player interface and SideBar.dart for a navigation sidebar.

**model Directory**: Here, you define the data models for your application. This includes classes like Music.dart, User.dart, and MusicSheet.dart, which likely represent the structure of music tracks, user profiles, and music sheets, respectively.

**service Directory**: This folder is dedicated to the service layer of your application, handling the business logic. Files like MusicService.dart and MusicSheetService.dart suggest services for managing music and music sheets.

**view Directory**: This directory contains the UI layer of your Flutter application. It includes various Dart files for different pages like HomePage.dart, MusicDetailPage.dart, and GeneratePage.dart, each responsible for the layout and functionality of a specific screen in your app.
