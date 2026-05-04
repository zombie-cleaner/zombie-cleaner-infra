// resourceDeleter.js
import { stsClient, AssumeRoleCommand } from "@aws-sdk/client-sts";

const handlers = {
  "cloudwatch-log": require("./handlers/cloudwatchLogHandler"),
  //   "s3-bucket": require("./handlers/s3BucketHandler"),
  //   "ec2-instance": require("./handlers/ec2InstanceHandler"),
  //   "rds-instance": require("./handlers/rdsInstanceHandler"),
  // Add new types here — nothing else changes
};

async function deleteResource(resourceType, resourceIdentifier, options = {}) {
  const handler = handlers[resourceType];

  if (!handler) {
    throw new Error(
      `Unknown resource type: "${resourceType}". Supported: ${Object.keys(handlers).join(", ")}`,
    );
  }

  console.log(`Deleting [${resourceType}]: ${resourceIdentifier}`);
  const credentials = await getCredentials();
  await handler.delete(resourceIdentifier, credentials, options);
  console.log(`Successfully deleted [${resourceType}]: ${resourceIdentifier}`);
}

async function getCredentials() {
  const sts = new STSClient({ region: "us-east-1" });

  const assumeRoleResponse = await sts.send(
    new AssumeRoleCommand({
      RoleArn: roleArn,
      RoleSessionName: "idlezero-session",
      ExternalId: externalId,
    }),
  );

  const credentials = assumeRoleResponse.Credentials;
  return {
    accessKeyId: credentials.AccessKeyId,
    secretAccessKey: credentials.SecretAccessKey,
    sessionToken: credentials.SessionToken,
  };
}
module.exports = { deleteResource };
