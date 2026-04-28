import { makeResponse } from "opt/nodejs/helper.mjs";
import { deleteResource } from "./resource_deleter.mjs";
export const handler = async (event) => {
  try {
    const { detail, "detail-type": detailType } = event;

    if (detailType !== "DELETE_RESOURCE") {
      console.warn("⚠️ Received unsupported event type:", detailType);
      return makeResponse(400, { message: "Unsupported event type" });
    }

    await deleteResource(
      detail?.resourceType,
      detail?.resourceId,
      detail?.options,
    );
    return makeResponse(200, { message: "Resource deleted successfully" });
  } catch (error) {
    console.error("🔴 Error deleting resource:", error);
    return makeResponse(500, { message: "Internal Server Error" });
  }
};

const identifyResource = (detail) => {
  // Implement logic to identify the resource to delete based on event details
  return detail.resourceId; // Example: assuming the resource ID is provided in the event detail
};

const deleteResource = async (resourceId) => {
  // Implement logic to delete the resource, e.g., call an API or perform database operations
  console.log(`Deleting resource with ID: ${resourceId}`);
  // Simulate deletion logic here
};

const getAuthorized = async (event) => {
  // Implement logic to check if the request is authorized, e.g., validate tokens or permissions
  return true; // Example: assuming all requests are authorized for simplicity
};
