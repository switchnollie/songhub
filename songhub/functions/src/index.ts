import * as functions from "firebase-functions";
// import * as admin from "firebase-admin";

// const db = admin.firestore();

export const helloWorld = functions.https.onRequest((_, response) => {
  response.send("Hello from Firebase!");
});

export const updateArtist = functions.firestore
  .document("users/{userId}")
  .onUpdate((change, context) => {
    const newVal = change.after.data();
    console.log({newVal, context, change});
  });
