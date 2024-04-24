# GrinSync
This the repository for the front-end of the GrinSync app

## Repository Layout
- *test*: The folder where the test files for our frontend testing are. 
- *lib > pages*: The folder where all the files for the pages of our app are. 
- *lib > api*: The folder where all the files that handle API calls to the backend are. 

## How to build and run our project

To run the app, you will first need to install Flutter: https://docs.flutter.dev/get-started/install
Follow the installation for mobile development.
You will also need to follow the Android Studio installation to use an emulator, even if you are working in VSCode.
This can be done here: https://docs.flutter.dev/get-started/install/windows/mobile#configure-android-development

Once you have Flutter and Android Studio installed, you can run the command 'flutter doctor, or if you are in VSCode, you can go to View -> Command Palette and select Flutter: Run Flutter Doctor.
This will confirm you have everything set up correctly. If you are missing any required packages or steps, follow the steps provided to resolve the issues. 

Once you have everything installed on your computer, you download this repository locally onto your computer.
Once it is downloaded, open the project in VSCode, and select View -> Command Palette and select Flutter: Launch Emulator.
Then select Run -> Run without debugging in VSCode, and select the emulator from the list of emulators displayed. Once selected the app will run on the desired emulator (it takes a minute to run on the emulator the first time the emulator is ran). You can now interact with the application on the emulator!

## How to test our project

To test the app, once you have followed the steps above to download and build the project, you can open a terminal window in VSCode and run the command
```shell
flutter test
```
This will run the test suite and confirm the app is working as expected.

## Operational Use Cases (so far) ## 

## Operational Use Cases (so far) ## 
- Register a new student user with email confirmation
- Forgot password?
- Log in after registration
- Create a new event (with repeating event options)
- Edit an event you created
- Delete an event
- Like an event
- Search for events
- View events on comprehensive calendar (in various time views: monthly, weekly, daily) with new arrows to navigate (can see event details in calendar)
- Log out
