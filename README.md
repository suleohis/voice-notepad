# 🎤 Voice Notepad

A simple and intuitive web-based voice notepad application that allows users to record spoken notes and convert them into text. All notes are saved locally in your browser's storage, providing a convenient way to keep track of your thoughts, ideas, or to-do lists without typing.

---

## ✨ Features

* **🎙️ Voice-to-Text Transcription:** Utilizes the Web Speech API to accurately convert your spoken words into written text.
* **💾 Local Storage Persistence:** All your notes are automatically saved in your browser's local storage, meaning they will be available even after closing and reopening the browser.
* **📝 Note Listing:** View a clear list of all your saved voice notes.
* **🗑️ Delete Notes:** Easily remove individual notes you no longer need.
* **🔄 Responsive Design:** Adapts to various screen sizes, ensuring a good experience on both desktop and mobile devices.

---

## 🚀 Technologies Used

* **HTML5:** For structuring the content of the web pages.
* **CSS3:** For styling the application, making it visually appealing and responsive.
* **JavaScript (ES6+):** For all interactive functionalities, including voice recognition, local storage management, and dynamic UI updates.
* **Web Speech API:** Specifically the Speech Recognition interface, for handling the voice-to-text conversion.

---

## 📄 Project Structure and Page Explanation

The Voice Notepad application is built as a Single Page Application (SPA) with a clear separation of concerns in its core files:

* `index.html`: This is the main and only HTML file for the application. It provides the basic structure for the voice input area and the display area for saved notes.
* `style.css`: Contains all the CSS rules that define the look and feel of the application, ensuring it's user-friendly and aesthetically pleasing across different devices.
* `script.js`: Houses the core JavaScript logic. This file handles:
    * Initializing and managing the Web Speech API.
    * Capturing voice input and transcribing it.
    * Saving, loading, and deleting notes from `localStorage`.
    * Dynamically updating the UI to display notes and provide user feedback.

### Main Application View

This is the primary interface where users can record new voice notes and see a list of their previously saved notes.

**What this page does:**

* **Record New Note:** Features a prominent "Start Recording" button. When clicked, the application listens to your voice and transcribes it in real-time.
* **Display Transcription:** As you speak, the transcribed text appears in a dedicated area, allowing you to see the conversion happening live.
* **Save/Clear Actions:** After recording, buttons appear to either "Save Note" (which adds it to your local storage) or "Clear" (to discard the current transcription).
* **List Existing Notes:** Below the recording area, a section displays all previously saved notes. Each note typically shows a snippet of its content and a "Delete" button.

## ⚙️ Setup and Running Locally

To get a local copy up and running, follow these simple steps:

1.  **Clone the repository:**
    ```bash
    git clone [https://github.com/suleohis/voice-notepad.git](https://github.com/suleohis/voice-notepad.git)
    ```
2.  **Navigate into the project directory:**
    ```bash
    cd voice-notepad
    ```
3.  **Open `index.html`:**
    Simply open the `index.html` file in your preferred web browser. No server setup is required as it's a client-side application.

    *Note: For voice recognition to work, you may need to grant microphone access to the page in your browser.*

---

## 🧑‍💻 Usage

1.  **Start Recording:** Click the "Start Recording" button. Your browser will likely ask for microphone permission if you haven't granted it before.
2.  **Speak Clearly:** Begin speaking your note. The transcribed text will appear as you speak.
3.  **Stop Recording:** Click the "Stop Recording" button when you are finished.
4.  **Save or Clear:**
    * Click "Save Note" to store your note permanently in your browser's local storage.
    * Click "Clear" to discard the current transcription and start over.
5.  **View Notes:** All saved notes will be listed below the recording section.
6.  **Delete a Note:** Click the "Delete" button next to any note to remove it from your list.

---

## 📥 Accessing the Application

This application is a web-based tool and does not require a traditional "download" or installation. You can access it directly through your web browser.

* **Online Access:** If hosted online, simply navigate to the URL of the application.
* **Local Access:** Follow the "Setup and Running Locally" instructions above to open it directly from your computer.

### Adding to Home Screen (Mobile Devices)

For a more app-like experience on mobile devices, you can usually add the Voice Notepad to your home screen:

* **On Android:** Open the app in Chrome, tap the three-dot menu, and select "Add to Home screen."
* **On iOS:** Open the app in Safari, tap the Share icon (square with an arrow pointing up), and select "Add to Home Screen."

### Direct Download of Project Files

You can download the latest Android application package (APK) directly from Google Drive:

* [**Download Vote Notepad APK**](https://drive.google.com/file/d/1Nc6uiUb7RemZrPouK087Xeq73iVaId_0/view?usp=sharing)

---

## 🤝 Contributing

Contributions are always welcome! If you have suggestions for improvements, new features, or bug fixes, feel free to:

1.  Fork the repository.
2.  Create your feature branch (`git checkout -b feature/AmazingFeature`).
3.  Commit your changes (`git commit -m 'Add some AmazingFeature'`).
4.  Push to the branch (`git push origin feature/AmazingFeature`).
5.  Open a Pull Request.

---

## 📄 License

Distributed under the MIT License. See `LICENSE` for more information (if applicable, or simply state "MIT License" if the license file is not present).