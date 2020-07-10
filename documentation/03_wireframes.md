# Wireframes

As a high fidelity wireframing tool we used [Adobe XD](https://www.adobe.com/de/products/xd.html?sdid=88X75SKP&mv=search&ef_id=EAIaIQobChMI182Z_6e76gIV2-vtCh3WjQufEAAYASAAEgLvkvD_BwE:G:s&s_kwcid=AL!3085!3!340667133503!e!!). This is a free to use UI- and UX-tool, which allows us to create app wireframes of various devices. Individual components can be defined and reused. In a prototyping environment the individual screens can be connected, animations can be defined and tested in a kind of simulator. We used [Sketch](https://www.sketch.com/) to design documentation elements and to create our architecture and personas.

**Disclaimer**: All image assets were downloaded from [Unsplash](https://unsplash.com/) and are copyright free. Everyone can find our used design guidelines and icons at [Google Material](https://material.io/) and [Apple Human Interface Guidelines](https://developer.apple.com/design/human-interface-guidelines/) too.

In general, we have tried to keep everything relatively minimalistic in the UI and UX. The app should be intuitive to use and contain common conventions. Our design language is more in line with Apple's guidelines, whereby we have tried to adapt the material components.

We try to keep our app as responsive as possible, as our use case could cover a wide range of devices. But since we see the most potential in smartphones, we have designed our app, especially in the wireframe, for this group of devices. Smartphones offer the most potential in our use case, because you can quickly capture ideas without forgetting them on the way to your computer or tablet.

### Sign Up, Sign In and Setup Profile

| ![Open screen](.\imgs\wireframe\setup\Open screen.png) | ![Sign up – 1](.\imgs\wireframe\setup\Sign up – 1.png) | ![Login](.\imgs\wireframe\setup\Login.png) | ![Profile](.\imgs\wireframe\setup\Profile.png) |
| ------------------------------------------------------ | ------------------------------------------------------ | ------------------------------------------ | ---------------------------------------------- |
|                                                        |                                                        |                                            |                                                |

After starting the app, the user is first shown our Sign In mask, unless the user had already logged in before and is not opening the app for the first time. Only username and password are required in the Sign In screen. If a user has not yet registered, he can be redirected to the Sign Up screen via a route below. In the Sign Up-Screen the user will be asked to create a username, email and password, which must also be confirmed. After successful validation of the entered data, the user is redirected to his profile page, where he can or must enter further information about himself. Once a user has successfully logged in and set up his profile, he can navigate to the first tab of the app.

### Project Overview

| ![Song overview](.\imgs\wireframe\Song overview.png) | ![Add song](.\imgs\wireframe\Add song.png) |
| ---------------------------------------------------- | ------------------------------------------ |
|                                                      |                                            |

The first tab of the application contains a list of all existing song projects. These are self-created projects as well as projects in which he was invited as a member. These song projects are displayed as list entries/rows and contain general information to identify the project. An entry consists of a cover image, title, artist and participating members. As used to other lists on mobile devices, selecting a list entry allows navigation to the respective details. In the header of the view there is a button for adding new song projects next to a title for orientation. To create a song project, the user is presented with a mask in which he can enter and select information about the new project. Adding is confirmed by pressing a button. The user is then redirected to the project overview.

### Project Details

| ![Song details](.\imgs\wireframe\Song details.png) | ![Edit song](.\imgs\wireframe\Edit song.png) |
| -------------------------------------------------- | -------------------------------------------- |
|                                                    |                                              |

The previously mentioned detail view should also display general information of the project, provide a possibility to edit it and contain the central features in the body. The header contains the same information as in the song overview to maintain data consistency. An edit icon routes the user to the mask already known from adding song projects. Here already entered data is displayed. These can also be changed and saved.

### Recordings feature

| ![Song details](.\imgs\wireframe\Song details.png) | ![Add recording](.\imgs\wireframe\Add recording.png) | ![Edit recording](.\imgs\wireframe\Edit recording.png) |
| -------------------------------------------------- | ---------------------------------------------------- | ------------------------------------------------------ |
|                                                    |                                                      |                                                        |

The body of the details view rendered by default the recording tab. Here all recording files of the project are displayed in a grid. We decided to use a grid to show more details. It shows the date of creation, a label to classify the file and a short description of the content or intention. A picture of the creator should show who uploaded the file. Every playable file also has a playback function, so that the file can be played.

The first entry in the grid shows a button, which should allow the addition of files. When pressed, the user is forwarded to a mask for uploading. Here the user can select a file on his device and set the respective details.

For the sake of consistency, the user is also forwarded to this mask when an existing file is pressed. However, this mask is already filled out with existing data which can be changed as desired.

### Discussion feature

| ![Discussion](C:\Users\schla\OneDrive - bwedu\mld\semester_1\app_development\project\20s-ad-teamf\documentation\imgs\wireframe\Discussion.png) | ![Write message](C:\Users\schla\OneDrive - bwedu\mld\semester_1\app_development\project\20s-ad-teamf\documentation\imgs\wireframe\Write message.png) |
| ------------------------------------------------------------ | ------------------------------------------------------------ |
|                                                              |                                                              |

The second tab of the tabs of the detail view contains the discussion feature. Here members can exchange information on song level. For this purpose, a kind of chat should be displayed, with outgoing messages on the right and incoming messages from other members on the left. This convention was also adopted from existing messengers. In order to be able to reference a certain file, for example, the possibility of linking files or messages would also be useful. You could also implement an audio player within the chat. All messages are ordered by date.