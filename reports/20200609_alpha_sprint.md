# Alpha Sprint

### Date

27.05.2020- 10.06.2020

### Members

* Pascal Schlaak (MLD)
* Tim Weise (MIN)

## What did we accomplish?

We integrated user authentication to later allow multi user collaborations. Songs are now mapped to a user/owner. We added security rules in Firestore and Storage to restrict access.  A user can now register or sign in to the app by email and password. A user can now add new song projects and edit existing songs projects.  While editing a song a user can enter required files and add an cover image from device gallery. We also refactored the general data stream to fetch song objects. Details of a song now contain files, which are also fetched from dummy data in Firestore. Several front end components for the discussion feature were added too. 

### Backlog tasks

| Task                                            | Status      |
| ----------------------------------------------- | ----------- |
| Integrate multi user authentication             | Done        |
| Add "Sign In" and "Sign Out" screen             | Done        |
| Refactored Firestore and Storage schema         | Done        |
| Add user access rules for Firestore and Storage | Done        |
| Add more dummy data                             | Done        |
| Refined "Add Song" screen                       | Done        |
| Created "Edit Song" screen                      | Done        |
| Refactored Firestore stream                     | Done        |
| Create "Records" feature in "Song Details"      | In progress |
| Create "Discussion" feature in "Song Details"   | In progress |


### Wireframes

Improved UI experience by reducing visual elements and refining user-flow.

### Integrate main technologies

Our main features exist of user authentication, data streams and song details.

## What hinderances/risks did/do we face?

* Database schema required multi stream concatenation &rightarrow; Refactored Firestore and Storage schema 
* Exceeding Storage free plan every afternoon due to too high data exchange


## What do we plan to tackle in the next sprint?

Feature complete:

- Implement all features (mostly backend services)
- Finish "Add Song" and "Edit Song"
- Integrate file picker and upload
- Integrate message upload and fetch
- Optional: Integrate multi user collaboration
