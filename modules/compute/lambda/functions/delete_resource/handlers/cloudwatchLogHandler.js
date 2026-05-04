const {
  CloudWatchLogsClient,
  DeleteLogGroupCommand,
} = require("@aws-sdk/client-cloudwatch-logs");

const deleteResource = async (
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

module.exports = { delete: deleteResource };
