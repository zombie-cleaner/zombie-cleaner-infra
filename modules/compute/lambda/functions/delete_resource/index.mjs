import { makeResponse } from "/opt/nodejs/helper.mjs";
import { deleteResource } from "./resource_deleter.mjs";

export const handler = async (event) => {
  try {
    const {
      detail,
      "detail-type": detailType,
      "auth-creds": authCreds,
    } = event;

    const validationError = validator(detail, detailType, authCreds);

    if (validationError) {
      return validationError;
    }

    await deleteResource(
      detail.resourceType,
      detail.resourceIdentifier,
      authCreds,
      detail.options,
    );

    return makeResponse(200, {
      message: "Resource deleted successfully",
    });
  } catch (error) {
    console.error("🔴 Error deleting resource:", error);

    return makeResponse(500, {
      message: "Internal Server Error",
    });
  }
};

function validator(detail, detailType, authCreds) {
  if (detailType !== "DELETE_RESOURCE") {
    console.warn("⚠️ Received unsupported event type:", detailType);

    return makeResponse(400, {
      message: "Unsupported event type",
    });
  }

  if (!authCreds?.roleArn || !authCreds?.externalId) {
    console.warn("⚠️ Invalid authentication");

    return makeResponse(403, {
      message: "Invalid authentication",
    });
  }

  if (!detail?.resourceIdentifier || !detail?.resourceType) {
    console.warn("⚠️ Invalid resource details");

    return makeResponse(400, {
      message: "Invalid resource details",
    });
  }

  return null;
}
