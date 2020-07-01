# Beta Sprint

### Date

10.06.2020 - 02.07.2020

### Members

* Pascal Schlaak (MLD)
* Tim Weise (MIN)

## What did we accomplish? 

We decided to refactor our Firestore database model again due to improvement opportunities. We generally added error handling especially for features where we initiate connections to Firebase. Integrated snackbars can now show status in many features.

### Backlog general tasks

| **Task**                                                     | **Status** |
| ------------------------------------------------------------ | ---------- |
| Refactor database model                                      | Done       |
| Refactor user authentication                                 | Done       |
| Error handling of firebase functionality with snackbar status | Done       |
| Cloud functions to handle database entry updates and recursive deletion | Done       |

We refactored user access to display only granted information. Added user settings feature in Account view to add and update user data.

### Backlog users feature

| **Task**                                                     | **Status** |
| ------------------------------------------------------------ | ---------- |
| Refactor user authentication and restrict access by security rules | Done       |
| Add user settings modal                                      | Done       |
| Add database functionality to add and update user data       | Done       |
| Complete users feature                                       | Done       |

Complete refactoring of app architecture to allow easy upscaling if required later. Refactored backend service APIs based on new view models.

### Backlog app architecture

| **Task**                                                     | **Status** |
| ------------------------------------------------------------ | ---------- |
| Restructure app directories                                  | Done       |
| Refactor backend service APIs for Authentication, Database, Storage | Done       |
| Add view models layer for models                             | Done       |
| Refactored app architecture for easy upscaling               | Done       |

Refactored song modals to get functionality back working with ne app structure. Added image processing to uploading image. Added validation of song modal forms. Currently implementing participant invitation feature we decided to integrate if we have time as a team of only two members.

### Backlog songs/project feature

| **Task**                                      | **Status**  |
| --------------------------------------------- | ----------- |
| Add database functionality to song modals     | Done        |
| Add image processing to image upload          | Done        |
| Add form validation                           | Done        |
| Add participants form to invite collaborators | In progress |
| Complete songs feature                        | In progress |

Refactored recording feature. Made recording tab fully responsive to display on different devices. Created real time data stream to view and update files. Implemented file picker to read files from device and upload to storage. Added more information to recording like 'updatedAt' timestamp. Implemented add and edit modals for adding and updating recording entries. Redesigned recording items to be fully responsive too. Added simple audio playback in recording item by pressing icon.

### Backlog recording feature

| **Task**                                                     | **Status** |
| ------------------------------------------------------------ | ---------- |
| Refactor recording feature grid to be responsive             | Done       |
| Refactor recording item tab to be responsive and redesign    | Done       |
| Create real time data stream                                 | Done       |
| Complete file picker functionality                           | Done       |
| Refactor data structure recording collection                 | Done       |
| Add recording modals for add and edit functionality          | Done       |
| Add database push and update functionality for recording modals | Done       |
| Refactor and redesign recording modals                       | Done       |
| Add simple audio playback of recording file in cloud storage | Done       |
| Complete recording feature                                   | Done       |

Refactored and redesigned components of discussion features (message container, message input, tab view). Feature is no fully responsive too. Defined data structure for messages in Firestore. Messages will be aligned in canvas depending on user. Added functionality to push message to cloud database. Defined security rules to restrict access to feature.

### Backlog discussion feature

| **Task**                                                 | **Status** |
| -------------------------------------------------------- | ---------- |
| Refactor and redesign discussion components              | Done       |
| Refactor discussion feature tab to be responsive         | Done       |
| Create real time data stream                             | Done       |
| Define data structure messages collection                | Done       |
| Render messages depending on user and order by timestamp | Done       |
| Add push functionality for message input form            | Done       |
| Add security rules for discussion feature                | Done       |
| Complete message feature                                 | Done       |



## What hinderances/risks did/do we face?

* Due to our team constellation, we had much afford to realize full feature functionality 
* Poor Flutter Firebase documentation for specific features
* Difficult to extend app architecture without suiting Firebase guidelines


## What do we plan to tackle in the next sprint?

- Create documentation
- Testing and debugging features
- Polish app including UI
- Prepare for certification and submission

#### Questions

* Do we need to create tests and what are your requirements therefore?

