import { https } from "firebase-functions";
import { storageBucket } from "./globals";

// manually set metadata of example data
export const updateStorage = https.onRequest(async (req, res) => {
  const requests = [];

  requests.push(
    storageBucket
      .file("9jJgSgk2eVQF35Pa3GkvpH5RoU03/covers/mBXkgfEmb4phulWGgTrz.jpg")
      .setMetadata({
        metadata: {
          owner: "9jJgSgk2eVQF35Pa3GkvpH5RoU03",
          ypVCXwADSWSToxsRpyspWWAHNfJ2: "allowRead",
          dMxDgggEyDTYgkcDW8O6MMOPNiD2: "allowRead",
        },
      })
  );
  requests.push(
    storageBucket
      .file("dMxDgggEyDTYgkcDW8O6MMOPNiD2/covers/TdJyipldM6RrD3kzN74z.jpg")
      .setMetadata({
        metadata: {
          owner: "dMxDgggEyDTYgkcDW8O6MMOPNiD2",
          "9jJgSgk2eVQF35Pa3GkvpH5RoU03": "allowRead",
        },
      })
  );
  requests.push(
    storageBucket
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
