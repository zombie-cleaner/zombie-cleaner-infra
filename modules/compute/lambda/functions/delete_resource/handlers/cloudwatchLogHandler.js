const {
  CloudWatchLogsClient,
  DeleteLogGroupCommand,
} = require("@aws-sdk/client-cloudwatch-logs");
const client = new CloudWatchLogsClient({});

module.exports = {
  async delete(logGroupName) {
    await client.send(new DeleteLogGroupCommand({ logGroupName }));
  },
};
