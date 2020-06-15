import * as functions from "firebase-functions";
import * as admin from "firebase-admin";

const app = admin.initializeApp();
// const db = app.firestore();

// TODO: adapt to new schema
// export const updateArtist = functions.firestore
//   .document("users/{userId}")
//   .onUpdate(async (change, context) => {
//     const newVal = change.after.data();
//     const oldVal = change.before.data();
//     if (newVal?.stageName === oldVal?.stageName) return null;
//     const newStageName = newVal!.stageName;
//     console.log(
//       `detected rename of stageName from ${
//         oldVal!.stageName
//       } to ${newStageName}`
//     );
//     const userId = context.params.userId;
//     const userSongsDoc = db.doc(`songs/${userId}`);
//     const usersSongsSnapshot = await userSongsDoc.get();
//     const usersSongs = usersSongsSnapshot.data();
//     if (usersSongs) {
//       let batchUpdateSongs: Promise<FirebaseFirestore.WriteResult>[] = [];
//       for (let [songId, songObj] of Object.entries(usersSongs)) {
//         const updatedSong = { ...songObj };
//         updatedSong.artist = newStageName;
//         console.log(`Updating artist field in ${songId}`);
//         console.log({ updatedSong });
//         batchUpdateSongs.push(userSongsDoc.update({ [songId]: updatedSong }));
//       }
//       return Promise.all(batchUpdateSongs);
//     }
//     console.log(`${newStageName} does not own any songs`);
//     return null;
//   });

export const testOnImageUpload = functions.storage
  .object()
  .onFinalize(async (object) => {
    console.log("image uploaded to", object.bucket);
    const storageRef = admin.storage().bucket(object.bucket);

    var metadata = {
      metadata: {
        test: "1234",
      },
    };

    try {
      const setFileMetadataResponse = await storageRef
        .file(object.name!)
        .setMetadata(metadata);
      console.log("Success");
      console.log(setFileMetadataResponse[0]);
      return null;
    } catch (error) {
      console.log(error);
      return null;
    }
  });

// manually set metadata of example data
export const updateStorage = functions.https.onRequest(async (req, res) => {
  const storage = admin.storage(app);

  const fileQuery1 = await storage
    .bucket("song-hub-7d14a.appspot.com")
    .getFiles({
      directory: "9jJgSgk2eVQF35Pa3GkvpH5RoU03/covers",
    });
  await fileQuery1[0][0].setMetadata({
    metadata: {
      owner: "9jJgSgk2eVQF35Pa3GkvpH5RoU03",
      ypVCXwADSWSToxsRpyspWWAHNfJ2: "allowRead",
      dMxDgggEyDTYgkcDW8O6MMOPNiD2: "allowRead",
    },
  });
  const fileQuery2 = await storage
    .bucket("song-hub-7d14a.appspot.com")
    .getFiles({ directory: "dMxDgggEyDTYgkcDW8O6MMOPNiD2/covers" });
  await fileQuery2[0][0].setMetadata({
    metadata: {
      owner: "dMxDgggEyDTYgkcDW8O6MMOPNiD2",
      "9jJgSgk2eVQF35Pa3GkvpH5RoU03": "allowRead",
    },
  });
  const fileQuery3 = await storage
    .bucket("song-hub-7d14a.appspot.com")
    .getFiles({
      directory: "ypVCXwADSWSToxsRpyspWWAHNfJ2/covers",
    });
  await fileQuery3[0][0].setMetadata({
    metadata: {
      owner: "ypVCXwADSWSToxsRpyspWWAHNfJ2",
      dMxDgggEyDTYgkcDW8O6MMOPNiD2: "allowRead",
    },
  });
});
