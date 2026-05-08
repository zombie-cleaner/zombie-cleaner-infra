// resourceDeleter.js
import { STSClient, AssumeRoleCommand } from "@aws-sdk/client-sts";
import { deleteResource as cloudWatchDeleter } from "./handlers/cloudwatchLogHandler.mjs";

const handlers = {
  "cloudwatch-log": cloudWatchDeleter,
  //   "s3-bucket": require("./handlers/s3BucketHandler"),
};

const region = process.env.REGION;

export const deleteResource = async (
  resourceType,
  resourceIdentifier,
  authCreds,
  options = {},
) => {
  const handler = handlers[resourceType];

  if (!handler) {
    throw new Error(
      `Unknown resource type: "${resourceType}". Supported: ${Object.keys(handlers).join(", ")}`,
    );
  }

  console.log(`Deleting [${resourceType}]: ${resourceIdentifier}`);
  const credentials = await getCredentials(authCreds);
  await handler.delete(resourceIdentifier, credentials, options);
  console.log(`Successfully deleted [${resourceType}]: ${resourceIdentifier}`);
};

async function getCredentials(authCreds) {
  const sts = new STSClient({ region: region });

  const assumeRoleResponse = await sts.send(
    new AssumeRoleCommand({
      RoleArn: authCreds?.roleArn,
      RoleSessionName: "idlezero-session",
      ExternalId: authCreds?.externalId,
    }),
  );

  const credentials = assumeRoleResponse.Credentials;
  return {
    accessKeyId: credentials.AccessKeyId,
    secretAccessKey: credentials.SecretAccessKey,
    sessionToken: credentials.SessionToken,
  };
}
