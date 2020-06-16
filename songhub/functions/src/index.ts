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
    const newStageName = newVal.stageName;
    console.log(
      `detected rename of stageName from ${oldVal.stageName} to ${newStageName}`
    );
    const userId = context.params.userId;
    const userSongDocuments = await db
      .collection("users")
      .doc(userId)
      .collection("songs")
      .listDocuments();
    console.log({ userSongDocuments });
    const songUpdateResult = await Promise.all(
      userSongDocuments.map((songDoc) =>
        songDoc.update({ artist: newStageName })
      )
    );

    return songUpdateResult;
  });

// manually set metadata of example data
export const updateStorage = functions.https.onRequest(async (req, res) => {
  const storage = admin.storage(app);
  const requests = [];

  // requests.push(storage
  //   .bucket("song-hub-7d14a.appspot.com")
  //   .file("9jJgSgk2eVQF35Pa3GkvpH5RoU03/covers/mBXkgfEmb4phulWGgTrz.jpg")
  //   .setMetadata({
  //     metadata: {
  //       owner: "9jJgSgk2eVQF35Pa3GkvpH5RoU03",
  //       ypVCXwADSWSToxsRpyspWWAHNfJ2: "allowRead",
  //       dMxDgggEyDTYgkcDW8O6MMOPNiD2: "allowRead",
  //     },
  //   }));
  requests.push(
    storage
      .bucket("song-hub-7d14a.appspot.com")
      .file("dMxDgggEyDTYgkcDW8O6MMOPNiD2/covers/TdJyipldM6RrD3kzN74z.jpg")
      .setMetadata({
        metadata: {
          owner: "dMxDgggEyDTYgkcDW8O6MMOPNiD2",
          "9jJgSgk2eVQF35Pa3GkvpH5RoU03": "allowRead",
        },
      })
  );
  requests.push(
    storage
      .bucket("song-hub-7d14a.appspot.com")
      .file("ypVCXwADSWSToxsRpyspWWAHNfJ2/covers/RCpg9NEGLSZ4rGRM9iHH.jpg")
      .setMetadata({
        metadata: {
          owner: "ypVCXwADSWSToxsRpyspWWAHNfJ2",
          dMxDgggEyDTYgkcDW8O6MMOPNiD2: "allowRead",
        },
      })
  );

  try {
    await Promise.all(requests);
    res.status(200).send("ok");
  } catch (err) {
    console.error(err);
    res.status(400).send("Failed to set metadata");
  }
});
