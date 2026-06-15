import { getCrossAccountCredentials, badRequest } from "/opt/nodejs/helper.mjs";
import { log } from "/opt/nodejs/logger.mjs";
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
    const msg = `Unknown resource type: "${resourceType}". Supported: ${Object.keys(handlers).join(", ")}`;
    log.error(msg);
    return badRequest(msg);
  }

  log.info(`Deleting [${resourceType}]: ${resourceIdentifier}`);

  // Note: credentials retrieval is moved to helper layer
  const credentials = await getCrossAccountCredentials(authCreds);

  return await handler(resourceIdentifier, credentials, options);
};
