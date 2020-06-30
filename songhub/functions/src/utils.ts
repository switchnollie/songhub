import { Bucket, DeleteFilesOptions } from "@google-cloud/storage";

type ChangeVal = FirebaseFirestore.DocumentData | undefined;

export function shallowDiff(oldVal: ChangeVal, newVal: ChangeVal) {
  const diffObj: { [key: string]: any } = {};
  if (newVal && oldVal) {
    for (const [key, val] of Object.entries(newVal)) {
      if (oldVal[key] !== val) {
        diffObj[key] = val;
      }
    }
  }
  return diffObj;
}

export function deleteFilesPromisified(
  bucket: Bucket,
  options: DeleteFilesOptions
) {
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
