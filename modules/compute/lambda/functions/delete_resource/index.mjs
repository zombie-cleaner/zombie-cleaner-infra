import {
  success,
  badRequest,
  forbidden,
  handleApiError,
} from "/opt/nodejs/helper.mjs";
import { deleteResource } from "./resource_deleter.mjs";

export const handler = async (event) => {
  try {
    const { detail, "detail-type": detailType } = event;
    const authCreds = detail?.["auth-creds"];
    const validationError = validator(detail, detailType, authCreds);
    log.error("There is validation error : ", validationError);
    if (validationError) return validationError;

    const result = await deleteResource(
      detail.resourceType,
      detail.resourceIdentifier,
      authCreds,
      detail.options,
    );

    return result;
  } catch (error) {
    return handleApiError(error, "in handler");
  }
};

function validator(detail, detailType, authCreds) {
  if (detailType !== "DELETE_RESOURCE") {
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

  return null;
}
