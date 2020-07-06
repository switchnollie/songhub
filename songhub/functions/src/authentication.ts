import { auth } from "firebase-functions";
import { db } from "./globals";

export const addUserDocumentOnSignUp = auth
  .user()
  .onCreate(async (user, context) => {
    const { uid, email, metadata } = user;
    const { timestamp } = context;
    console.log(`adding user ${uid} with email ${email} to firestore document`);
    const documentRef = await db.collection("users").add({
      id: uid,
      email: email,
      createdAt: timestamp,
    });
    return documentRef;
  });
