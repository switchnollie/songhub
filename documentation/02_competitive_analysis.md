# Competitive Analysis

## Sketch Grid für Screenshots von Auddly und Songspace erstellen.

This competition analysis clarifies which competitors we had to consider in our use case and how they operate in the market. Our goal is to identify market gaps and integrate them into our app. As a result we want to show what the unique selling points of our app.

During our research we have identified only a few products from the following competitors:

* Auddly
* Songspace
* Synchtank
* Soundgizmo

### Competitors

In this section we want to give a short but detailed overview of each competitor. Every product is documented with app screenshots and the most used features will the be compared to our approach.

#### Auddly

[Auddly](https://auddly.com/) is a data hub to store songs, control its content and rights. A user can add songs, recordings, memos and lyrics in the app. Member invitations and split shares are also possible. A user can add and update songs by adding different progresses and write song specific comments.

| ![auddly_1](.\imgs\competitive_analysis\auddly_1.png) | ![auddly_2](.\imgs\competitive_analysis\auddly_2.png) | ![auddly_3](.\imgs\competitive_analysis\auddly_3.png) |
| ----------------------------------------------------- | ----------------------------------------------------- | ----------------------------------------------------- |
|                                                       |                                                       |                                                       |

However, a user can not set recording specific descriptions. Therefore users can't express to other members what his/her thoughts were while creating the recording. Comments can be written on the respective recordings. There is no possibility to communicate on song level. This app also focuses on the commercial aspects of music creation. The primary goal is to manage the data and to define split shares. The app's user interface is very well done, modern and up-to-date. All functions are intuitive to use.

#### Songspace

[Songspace](https://songspace.com/) is a data hub to store music, lyrics, collaborations and information around ones music. Like Auddly, users can keep track of ideas and songs. One can import voice memos and write lyrics.

| ![auddly_1](.\imgs\competitive_analysis\songspace_1.png) | ![auddly_2](.\imgs\competitive_analysis\songspace_2.png) | ![songspace_3](.\imgs\competitive_analysis\songspace_3.png) |
| -------------------------------------------------------- | -------------------------------------------------------- | ----------------------------------------------------------- |
|                                                          |                                                          |                                                             |

In contrast to Auddly, songs are included in projects. Playing and sharing songs is possible but there is no feature that allows the upload of different versions or parts of a song. In our opinion the user interface is less modern and more conservative than Auddly. At certain points features are not intuitive enough and therefore actions are difficult to understand, too. This app focuses on the management of song projects on a centralized platform.

#### Synchtank

[Synchtank](https://www.synchtank.com/) is a data hub for managing entertainment assets, metadata and royalties in a centralized location.

![synchtank](.\imgs\competitive_analysis\synchtank.png)

Like Songspace, Synchtank focuses on the management of entertainment assets on a centralized platform. Assets can be uploaded and further information can be added. A playback of the assets is also possible. The user interface is nicely layed out and guides the eye of the user on the essential things. Synchtank does not have a native app, but is designed as a responsiv browser application.

#### Soundgizmo

[Soundgizmo](https://www.soundgizmo.com/#madeByMusicPeople) is a service with which an artist can manage his assets catalog, monitor opens, streams and downloads and monetize his creations using in-depth pitching and licensing tools.

![soundgizmo](.\imgs\competitive_analysis\soundgizmo.png)

Soundgizmo is a subsidiary of Synchtank and focuses on the analysis of media assets. The service can only be used upon request. The user interface of the app looks outdated but the general functionality is still understandable. Soundgizmo doesn't ship with a native app either and can only be used as a web application in the browser.

### Uniqueness 

After this competitive analysis, in which we identified pain points in the creation of music, we tried to define and extend unique selling points of our app. 

The following table shows the competitors mentioned above, their features and our ideas. If an application has the specified feature, it is marked with an "X". Otherwise a "-" is noted.

| **Feature**                                    | **Songspace** | **Synchtank** | **Soundgizmo** | **Auddly** |
| :--------------------------------------------- | ------------- | ------------- | -------------- | ---------- |
| Song overview                                  | X             | X             | X              | X          |
| Song details                                   | X             | X             | X              | X          |
| Add/edit song                                  | X             | X             | X              | X          |
| File organizer                                 | X             | X             | X              | X          |
| <span style='color:red'>Comments</span>        | -             | -             | -              | X          |
| <span style='color:red'>Chat</span>            | -             | -             | -              | -          |
| Audio player                                   | X             | X             | -              | X          |
| <span style='color:red'>Version control</span> | X             | -             | -              | X          |

We have found that all applications deal with the commercial side of music creation. Be it split shares or the analysis of song streams. We have decided to concentrate on the creative side of music creation. Besides features like adding songs and inviting members, which are essential for the management of music data, we would like to optimize the following features or include them if new (_see red markers in feature table above_).

#### Recording feature

An artist should have the possibility to upload and manage different versions or parts of his song in the form of recordings. He has the option to keep previous versions and to reuse them if necessary. By adding a short description and a label, the user, as well as other members, should be able to better understand the author's intention when creating the file.

#### Discussion feature

A user should be able to exchange information with other members of the project. In Auddly this aspect has already been addressed by a comment function, but in our opinion the featurs is not well solved. A chat feature should allow members to exchange ideas, rate current files and progress and plan how to proceed. This way all members can be kept up to date on the current state of affairs. Questions and explanations of ideas become possible. In our opinion, an extended exchange of ideas can significantly improve the experience of music creation.

