# Song Hub #

This repository contains all files created for our project in *App Development* (summer semester 2020). The following directories are included in this repository:

### Content

##### /bin

Contains binary files of our application.

##### /documentation

Contains our project documentation including:

* App Description
* Competitive Analysis
* Wireframes
* Personas
* Color scheme
* Font
* Architecture
* App principles
* Lessons learned
* Project log
* Author and Tasks

##### /logo

Contains our custom designed app logo.

##### /poster

Contains an A0 formatted poster as `ppt` and `pdf`.

##### /reports

Contains all four sprint reports as markdown files.

##### /research

Contains files created while brainstorming project ideas and research competitors. This also includes user stories as well as possible use cases.

##### /screenshots

Contains screenshots of our apps frontend and backend data of Firestore and Storage.

##### /songhub

Contains our application (source code) created with Flutter. To open this application, navigate to this directory and execute `flutter run` or run it from a flutter capable editor/IDE like [Visual Studio Code](https://code.visualstudio.com/). Reminder: An emulator (Android or iOS) is required to run the app.

##### /video

Contains a walkthrough of our app used on iOS and Android.

##### /wireframe

Contains all files created during the prototyping stage. All assets were downloaded from [Unsplash](https://unsplash.com/) and are copyright free. We used [Adobe XD](https://www.adobe.com/de/products/xd.html?sdid=88X75SKP&mv=search&ef_id=EAIaIQobChMI182Z_6e76gIV2-vtCh3WjQufEAAYASAAEgLvkvD_BwE:G:s&s_kwcid=AL!3085!3!340667133503!e!!) and [Sketch](https://www.sketch.com/) as prototyping and wireframing tools.



### Setup App ###

To run our application, clone this repository:

```bash
cd /path/to/desicred/location
git clone git@bitbucket.org:roberhau/20s-ad-teamf.git
cd 20s-ad-teamf/
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

2. Run doctor and if necessary install missing flutter dependencies

```
flutter doctor
```

3. Get all local project dependencies

```
flutter pub get
```

This installs the following dependencies (one can find these also here: `20s-ad-teamf\songhub\see pubspec.yaml`):

```yaml
firebase_core: ^0.4.0+9
cloud_firestore: ^0.13.5
firebase_auth: ^0.16.0
firebase_storage: ^3.1.6
provider: ^4.1.2
rxdart: ^0.24.1
flutter_spinkit: ^4.1.2
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

```bash
flutter run
```

### Setup Backend

Since our complete backend infrastructure is hosted as a Backend as a Service on [Google Firebase](https://firebase.google.com/), there are no additional local backend instances to start. Testing can be done using the [Firebase Emulator Suite](https://firebase.google.com/docs/emulator-suite).

**To access cloud resources deployed at Firebase you need to contact us and provide a registered e-mail address. We can then invite you as a participant to our project. You should then be able to get insides on all of our used production resources which are:**

* Firebase Authentication
* Database (Cloud Firestore)
* Firebase Storage
* Firebase Security Rules
* Firebase Functions

### Built with

* [Dart](https://dart.dev/)

* [Flutter](https://flutter.dev/?gclid=EAIaIQobChMIlpqYjbC76gIViu3tCh0F-gqYEAAYASAAEgLkzPD_BwE&gclsrc=aw.ds)
* [Firebase](https://firebase.google.com/)

### Project members ###

* [Tim Weise (Admin)](tim.weise@studmail.htw-aalen.de) - MIN student
* [Pascal Schlaak](pascal.schlaak@studmail.htw-aalen.de) - MLD student
