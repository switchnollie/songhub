import { firestore } from "firebase-functions";
import { db, storageBucket } from "./globals";
import { deleteFilesPromisified } from "./utils";

/**
 * Delete recordings, cover images, profile picture and reference in participants on user delete
 */
export const cascadeOnUserDelete = firestore
  .document("users/{userId}")
  .onDelete(async (_, context) => {
    const userId = context.params.userId;

    console.log(`Deleting private files from ${userId}`);
    await deleteFilesPromisified(storageBucket, { prefix: `${userId}/` });

    console.log(`Deleting profile image of ${userId}`);
    await storageBucket.file(`public/profileImgs/${userId}.jpg`);

    console.log(
      `Deleting all references to ${userId} in songs (participants arrays)`
    );
    const userSongDocumentsSnapshot = await db
      .collectionGroup("song")
      .where("participants", "array-contains", userId)
      .get();
    const songUpdateRequests = userSongDocumentsSnapshot.docs.map(
      async (songDoc) => {
        const beforeDocument = await songDoc.ref.get();
        const beforeParticipants = beforeDocument.get("participants");
        return songDoc.ref.update(
          "participants",
          beforeParticipants.filter((id: string) => id !== userId)
        );
      }
    );
    return await Promise.all(songUpdateRequests);
  });

/**
 * delete all recordings on song delete
 */
export const cascadeOnSongDelete = firestore
  .document("users/{userId}/songs/{songId}")
  .onDelete(async (_, context) => {
    const { userId, songId } = context.params;
    console.log(`Deleting all recordings of song ${songId} by user ${userId}`);
    console.log(`Storage path is: ${userId}/recordings/${songId}/`);
    try {
      await deleteFilesPromisified(storageBucket, {
        prefix: `${userId}/recordings/${songId}/`,
      });
    } catch (err) {
      console.log(err);
    }
    return null;
  });
