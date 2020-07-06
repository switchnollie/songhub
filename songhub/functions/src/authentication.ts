import { auth } from "firebase-functions";
import { db } from "./globals";

export const addTimestampToUserDocumentOnSignUp = auth
  .user()
  .onCreate(async (_, context) => {
    const { timestamp } = context;
    const documentRef = await db.collection("users").add({
      createdAt: timestamp,
    });
    return documentRef;
  });
