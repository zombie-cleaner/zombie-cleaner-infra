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
      detail?.resourceIdentifier,
      detail?.options,
    );
    return makeResponse(200, { message: "Resource deleted successfully" });
  } catch (error) {
    console.error("🔴 Error deleting resource:", error);
    return makeResponse(500, { message: "Internal Server Error" });
  }
};
