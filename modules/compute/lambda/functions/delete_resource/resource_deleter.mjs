import { getCrossAccountCredentials, badRequest } from "/opt/nodejs/helper.mjs";
import { deleteResource as cloudWatchDeleter } from "./handlers/cloudwatchLogHandler.mjs";

const handlers = {
  "cloudwatch-log": cloudWatchDeleter,
  // "s3-bucket": s3Deleter,
};

export const deleteResource = async (
  resourceType,
  resourceIdentifier,
  authCreds,
  options = {},
) => {
  const handler = handlers[resourceType];

  if (!handler) {
    return badRequest(`Unknown resource type: "${resourceType}". Supported: ${Object.keys(handlers).join(", ")}`);
  }

  console.log(`Deleting [${resourceType}]: ${resourceIdentifier}`);
  
  // Note: credentials retrieval is moved to helper layer
  const credentials = await getCrossAccountCredentials(authCreds);
  
  return await handler(resourceIdentifier, credentials, options);
};
