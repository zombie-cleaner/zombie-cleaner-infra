import {
  CloudWatchLogsClient,
  DeleteLogGroupCommand,
} from "@aws-sdk/client-cloudwatch-logs";

export const deleteResource = async (
  resourceIdentifier,
  credentials,
  options = {},
) => {
  const client = new CloudWatchLogsClient({
    credentials,
  });
  await client.send(
    new DeleteLogGroupCommand({ logGroupName: resourceIdentifier }),
  );
};
