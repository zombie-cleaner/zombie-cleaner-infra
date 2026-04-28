// resourceDeleter.js
const handlers = {
  "cloudwatch-log": require("./handlers/cloudwatchLogHandler"),
  //   "s3-bucket": require("./handlers/s3BucketHandler"),
  //   "ec2-instance": require("./handlers/ec2InstanceHandler"),
  //   "rds-instance": require("./handlers/rdsInstanceHandler"),
  // Add new types here — nothing else changes
};

async function deleteResource(resourceType, resourceId, options = {}) {
  const handler = handlers[resourceType];

  if (!handler) {
    throw new Error(
      `Unknown resource type: "${resourceType}". Supported: ${Object.keys(handlers).join(", ")}`,
    );
  }

  console.log(`Deleting [${resourceType}]: ${resourceId}`);
  await handler.delete(resourceId, options);
  console.log(`Successfully deleted [${resourceType}]: ${resourceId}`);
}

module.exports = { deleteResource };
