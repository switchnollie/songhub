# README #

This repository contains all files created for our project in *App Development* (summer semester 2020). There are following directories included in this repository:

### Content

##### /prototyping

Containing all files created during prototyping. All assets were downloaded from [Unsplash](https://unsplash.com/) and are copyright free. We used [Adobe XD](https://www.adobe.com/de/products/xd.html?sdid=88X75SKP&mv=search&ef_id=EAIaIQobChMI182Z_6e76gIV2-vtCh3WjQufEAAYASAAEgLvkvD_BwE:G:s&s_kwcid=AL!3085!3!340667133503!e!!) and [Sketch](https://www.sketch.com/) as prototyping and wireframing tools.

##### /reports

Containing all four sprint reports as markdown files.

##### /research

Containing files created while brainstorming project ideas and research competitors. One can find user stories as well as possible use cases too.

##### /songhub

Containing our application created with Flutter. To open this application one needs to navigate to this directory and execute `flutter run` or run it from a flutter capable editor like [Visual Studio Code](https://code.visualstudio.com/). Reminder: One needs a emulator (Android or iOS) to display the app.

### Setup App ###

To run our application one needs to clone this repository:

```
cd /path/to/desicred/location
git clone git@bitbucket.org:roberhau/20s-ad-teamf.git
cd 20s-ad-teamf.git/
```

Make sure you are allowed to execute desired files:

```
sudo chmod +x /path/to/file
```

Executing depends on the respective file. As an example for running our app (in Visual Studio Code see [here](https://flutter.dev/docs/development/tools/vs-code)): 

1. Checkout version

```
flutter --version
```

2. Run doctor

```
flutter doctor
```

3. Get dependencies

```
flutter pub get
```

You need to install the following dependencies (one can find these also here: '20s-ad-teamf\songhub\see pubspec.yaml'):

```
firebase_core: ^0.4.0+9
cloud_firestore: ^0.13.5
firebase_auth: ^0.16.0
firebase_storage: ^3.1.6
provider: ^4.1.2
rxdart: ^0.24.1
flutter_spinkit: "^4.1.2"
# The following adds the Cupertino Icons font to your application.
# Use with the CupertinoIcons class for iOS style icons.
cupertino_icons: ^0.1.3
image_picker: ^0.6.7
file_picker: ^1.11.0
image: ^2.1.12
path: 1.6.4
intl: ^0.16.1
uuid: ^2.1.0
path_provider: ^1.6.11
flutter_typeahead: ^1.8.5
video_player: ^0.10.11+2
device_info: ^0.4.2+4
```

4. Start app

```
flutter run
```

### Setup Backend

Since our complete backend functionality is hosted and run on [Google Firebase](https://firebase.google.com/), there are no additional local backend instances to start.

**To access cloud resources deployed at Firebase you need to contact us and provide an registered e-mail address. We can then invite you as a participant to our project. You should afterwards be able to view all of our used resources:**

* Authentication
* Database
* Storage
* Security Rules
* Functions

### Built with

* [Dart](https://dart.dev/)

* [Flutter](https://flutter.dev/?gclid=EAIaIQobChMIlpqYjbC76gIViu3tCh0F-gqYEAAYASAAEgLkzPD_BwE&gclsrc=aw.ds)
* [Firebase](https://firebase.google.com/)

### Project members ###

* [Tim Weise (Admin)](tim.weise@studmail.htw-aalen.de) - MIN student
* [Pascal Schlaak](pascal.schlaak@studmail.htw-aalen.de) - MLD student
