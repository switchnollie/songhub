import * as functions from "firebase-functions";
import * as admin from "firebase-admin";

const app = admin.initializeApp();
const db = app.firestore();

export const updateArtist = functions.firestore
  .document("users/{userId}")
  .onUpdate(async (change, context) => {
    const newVal = change.after.data();
    const oldVal = change.before.data();
    if (newVal?.stageName === oldVal?.stageName) return null;
    const newStageName = newVal!.stageName;
    console.log(`detected rename of stageName from ${oldVal!.stageName} to ${newStageName}`);
    const userId = context.params.userId;
    const userSongsDoc = db.doc(`songs/${userId}`)
    const usersSongsSnapshot = await userSongsDoc.get();
    const usersSongs = usersSongsSnapshot.data();
    if (usersSongs) {
      let batchUpdateSongs: Promise<FirebaseFirestore.WriteResult>[] = [];
      for (let [songId, songObj] of Object.entries(usersSongs)) {
        const updatedSong = {...songObj};
        updatedSong.artist = newStageName;
        console.log(`Updating artist field in ${songId}`);
        console.log({updatedSong});
        batchUpdateSongs.push(userSongsDoc.update({[songId]: updatedSong}));
      }
      return Promise.all(batchUpdateSongs);
    }
    console.log(`${newStageName} does not own any songs`);
    return null;
  });
