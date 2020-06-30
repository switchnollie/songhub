import * as functions from "firebase-functions";
import { storageService, db, storageBucket } from "./globals";
import { Bucket, DeleteFilesOptions } from "@google-cloud/storage";

function deleteFilesPromisified(bucket: Bucket, options: DeleteFilesOptions) {
  return new Promise<void>((resolve, reject) => {
    bucket.deleteFiles(options, (err) => {
      if (err) {
        reject(err);
      } else {
        resolve();
      }
    });
  });
}

// Delete recordings, cover images, profile picture and reference in participants on user delete
export const cascadeOnUserDelete = functions.firestore
  .document("users/{userId}")
  .onDelete(async (_, context) => {
    const userId = context.params.userId;

    console.log(`Deleting private files from ${userId}`);
    const bucket = storageService.bucket(storageBucket);
    await deleteFilesPromisified(bucket, { prefix: `${userId}/` });

    console.log(`Deleting profile image of ${userId}`);
    await storageService
      .bucket(storageBucket)
      .file(`public/profileImgs/${userId}.jpg`);

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
