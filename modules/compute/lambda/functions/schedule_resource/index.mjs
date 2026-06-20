import {
  success,
  badRequest,
  forbidden,
  handleApiError,
} from "/opt/nodejs/helper.mjs";
import { log } from "/opt/nodejs/logger.mjs";
import { scheduleResource } from "./resource_scheduler.mjs";

export const handler = async (event) => {
  try {
    const { detail, "detail-type": detailType } = event;
    const authCreds = detail?.["auth-creds"];
    const validationError = validator(detail, detailType, authCreds);
    if (validationError) {
      log.error("Validation error:", validationError.body);
      return validationError;
    }

    const result = await scheduleResource(
      detail.resourceType,
      detail.resourceIdentifier,
      detail.action,
      authCreds,
      detail.options,
    );

    return result;
  } catch (error) {
    return handleApiError(error, "in handler");
  }
};

function validator(detail, detailType, authCreds) {
  if (detailType !== "SCHEDULE_RESOURCE") {
    log.error(`Unsupported event type: ${detailType}`);
    return badRequest(`Unsupported event type: ${detailType}`);
  }

  if (!authCreds?.roleArn || !authCreds?.externalId) {
    log.error("Missing or invalid authentication credentials");
    return forbidden("Missing or invalid authentication credentials");
  }

  if (!detail?.resourceIdentifier || !detail?.resourceType) {
    log.error("Missing resource identifier or type");
    return badRequest("Missing resource identifier or type");
  }

  if (!detail?.action) {
    log.error("Missing action");
    return badRequest("Missing action (shutdown or wake)");
  }

  const normalizedAction = detail.action.toLowerCase();
  if (
    normalizedAction !== "shutdown" &&
    normalizedAction !== "wake" &&
    normalizedAction !== "stop" &&
    normalizedAction !== "start"
  ) {
    log.error(`Unsupported action: ${detail.action}`);
    return badRequest(
      `Unsupported action: ${detail.action}. Supported: shutdown, wake, stop, start`,
    );
  }

  return null;
}
