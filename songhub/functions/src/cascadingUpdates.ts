import { firestore } from "firebase-functions";
import { db } from "./globals";

export const updateArtist = firestore
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
    const songUpdateResult = await Promise.all(
      userSongDocuments.map((songDoc) =>
        songDoc.update({ artist: newStageName })
      )
    );

    return songUpdateResult;
  });
