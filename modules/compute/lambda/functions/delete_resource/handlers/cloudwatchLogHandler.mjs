import {
  CloudWatchLogsClient,
  DeleteLogGroupCommand,
} from "@aws-sdk/client-cloudwatch-logs";
import { success, handleApiError } from "/opt/nodejs/helper.mjs";

export const deleteResource = async (
  resourceIdentifier,
  credentials,
  options = {},
) => {
  try {
    const client = new CloudWatchLogsClient({
      credentials,
      region: process.env.REGION || process.env.AWS_REGION
    });

    await client.send(
      new DeleteLogGroupCommand({ logGroupName: resourceIdentifier }),
    );

    return success({
      message: `Log group ${resourceIdentifier} deleted successfully`,
    });
  } catch (error) {
    return handleApiError(error, `deleting cloudwatch-log ${resourceIdentifier}`);
  }
};
