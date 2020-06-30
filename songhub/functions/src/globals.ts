import { storage, initializeApp } from "firebase-admin";

export const app = initializeApp();
export const storageService = storage(app);
export const db = app.firestore();

export const storageBucket = storageService.bucket();
