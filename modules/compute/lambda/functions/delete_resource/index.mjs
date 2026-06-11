import { 
  success, 
  badRequest, 
  forbidden, 
  handleApiError 
} from "/opt/nodejs/helper.mjs";
import { deleteResource } from "./resource_deleter.mjs";

export const handler = async (event) => {
  try {
    const {
      detail,
      "detail-type": detailType,
      "auth-creds": authCreds,
    } = event;

    const validationError = validator(detail, detailType, authCreds);
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
    return badRequest(`Unsupported event type: ${detailType}`);
  }

  if (!authCreds?.roleArn || !authCreds?.externalId) {
    return forbidden("Missing or invalid authentication credentials");
  }

  if (!detail?.resourceIdentifier || !detail?.resourceType) {
    return badRequest("Missing resource identifier or type");
  }

  return null;
}
