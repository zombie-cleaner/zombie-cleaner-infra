import { getCrossAccountCredentials, badRequest } from "/opt/nodejs/helper.mjs";
import { log } from "/opt/nodejs/logger.mjs";
import { scheduleEC2 } from "./handlers/ec2Handler.mjs";
import { scheduleRDS } from "./handlers/rdsHandler.mjs";

const handlers = {
  "ec2": scheduleEC2,
  "rds": scheduleRDS,
};

export const scheduleResource = async (
  resourceType,
  resourceIdentifier,
  action,
  authCreds,
  options = {},
) => {
  const handler = handlers[resourceType];

  if (!handler) {
    const msg = `Unknown resource type: "${resourceType}". Supported: ${Object.keys(handlers).join(", ")}`;
    log.error(msg);
    return badRequest(msg);
  }

  const normalizedAction = action.toLowerCase();
  log.info(`Scheduling resource [${resourceType}]: ${resourceIdentifier} for ${normalizedAction}`);

  // Retrieve temporary credentials for cross-account operations
  const credentials = await getCrossAccountCredentials(authCreds);

  return await handler(resourceIdentifier, normalizedAction, credentials, options);
};
