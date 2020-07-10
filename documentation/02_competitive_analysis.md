# Competitive Analysis

## Sketch Grid für Screenshots von Auddly und Songspace erstellen.

This competition analysis should clarify which competitors we have to consider in our use case and how they operate in the market. Our goal is to identify market gaps and integrate them into our app. Finally, we want to show what the unique selling points of our app are.

During our extensive research we have identified the following competitors. One should note. It should be noted that this mark still has few offers.

* Auddly
* Songspace
* Synchtank
* Soundgizmo

### Competitors

In this section we want to give a short but detailed overview of each competitor. Every competitor will have a screenshot of its app with the most similar features displayed compared to our approach.

#### Auddly

[Auddly](https://auddly.com/) is a data hub to store songs, control its content and rights. A user can add songs, recordings, memos and lyrics in the app. He can also invite members and split shares. A user can add and update songs by adding different progresses and write song specific comments.

| ![auddly_1](.\imgs\competitive_analysis\auddly_1.png) | ![auddly_2](.\imgs\competitive_analysis\auddly_2.png) | ![auddly_3](.\imgs\competitive_analysis\auddly_3.png) |
| ----------------------------------------------------- | ----------------------------------------------------- | ----------------------------------------------------- |
|                                                       |                                                       |                                                       |

However, a user cannot set recording specific descriptions. Therefore he cannot tell the members what his thoughts were when he created the recording. Comments can be written to the respective Recordings. There is no possibility to communicate on song level. This app also focuses on the commercial aspects of music creation. The primary goal is to manage the data and to define split shares. The app's user interface is very well done and very up-to-date. All functions are intuitive to use.

#### Songspace

[Songspace](https://songspace.com/) is a data hub to store music, lyrics, collaborations and information around ones music. Like Auddly, one can keep track of ideas and songs. One can import voice memos and write lyrics.

| ![auddly_1](.\imgs\competitive_analysis\songspace_1.png) | ![auddly_2](.\imgs\competitive_analysis\songspace_2.png) | ![songspace_3](.\imgs\competitive_analysis\songspace_3.png) |
| -------------------------------------------------------- | -------------------------------------------------------- | ----------------------------------------------------------- |
|                                                          |                                                          |                                                             |

In contrast to Auddly, songs are included in projects. There is the possibility to play songs. But there is no feature that allows the upload of different versions or parts of a song. Songs can be shared with other users, which allows them to be displayed to the respective person. In our opinion the user interface is less successful and more conservative than Auddly. At certain points features are not intuitive enough and therefore actions are difficult to understand too. This app focuses on the management of song projects on a central platform.

#### Synchtank

[Synchtank](https://www.synchtank.com/) is data hub for managing entertainment assets, metadata and royalties in a centralized location.

![synchtank](.\imgs\competitive_analysis\synchtank.png)

Like Songspace, Synchtank focuses on the management of entertainment assets on a central platform. Assets can be uploaded and further information can be added. A playback of the assets is also possible. The user interface is also successful in our opinion. It concentrates the attention of the user on the essential things. Synchtank does not have a native app, but can be displayed responsive in a browser. The handling of the app is also good.

#### Soundgizmo

[Soundgizmo](https://www.soundgizmo.com/#madeByMusicPeople) is an service where an artist can manage his assets catalog', in-depth pitching & licensing tools, monitor opens, streams & downloads.

![soundgizmo](.\imgs\competitive_analysis\soundgizmo.png)

Soundgizmo is a subsidiary of Synchtank and focuses on the analysis of media assets. The service can only be used upon request. The user interface of the app looks very outdated. Functionality is still understandable. Soundgizmo doesn't ship a native app ether. It can only be reached via web browser.

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

We have found that all applications deal with the commercial side of music creation. Be it split shares or the analysis of song streams. We have decided to support the creative side of music creation. Besides features like adding songs and inviting members, which are essential for the management of music data, we would like to optimize the following features or include them if new (see red markers in feature table above).

#### Recording feature

A user should have the possibility to upload and manage different stands or parts of his song in the form of recordings. He has the option to keep previous stands and to reuse them if necessary. By adding a short description and a label, the user, as well as other members, should be able to better understand the author's intention when creating the file.

#### Discussion feature

A user should be able to exchange information with other members of the project. In Auddly this aspect was already addressed by a comment function, but in our opinion it was not well solved. A chat feature should allow members to exchange ideas, rate current files and progress, and plan how to proceed. This way all members can be kept up to date on the current state of affairs. Questions and explanations of ideas become possible. In our opinion, an extended exchange of ideas can significantly improve the experience of music creation.

