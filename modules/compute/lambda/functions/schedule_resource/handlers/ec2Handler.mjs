import {
  EC2Client,
  StartInstancesCommand,
  StopInstancesCommand,
} from "@aws-sdk/client-ec2";
import { success, handleApiError } from "/opt/nodejs/helper.mjs";
import { log } from "/opt/nodejs/logger.mjs";

export const scheduleEC2 = async (
  resourceIdentifier,
  action,
  credentials,
  options = {},
) => {
  try {
    const client = new EC2Client({
      credentials,
      region: process.env.REGION || process.env.AWS_REGION,
    });

    if (action === "shutdown" || action === "stop") {
      log.info(`Stopping EC2 instance ${resourceIdentifier}`);
      await client.send(
        new StopInstancesCommand({ InstanceIds: [resourceIdentifier] }),
      );
      log.success(`EC2 instance ${resourceIdentifier} stopped successfully`);
      return success({
        message: `EC2 instance ${resourceIdentifier} stopped successfully`,
      });
    } else if (action === "wake" || action === "start") {
      log.info(`Starting EC2 instance ${resourceIdentifier}`);
      await client.send(
        new StartInstancesCommand({ InstanceIds: [resourceIdentifier] }),
      );
      log.success(`EC2 instance ${resourceIdentifier} started successfully`);
      return success({
        message: `EC2 instance ${resourceIdentifier} started successfully`,
      });
    } else {
      throw new Error(`Unsupported EC2 action: ${action}`);
    }
  } catch (error) {
    return handleApiError(
      error,
      `scheduling EC2 instance ${resourceIdentifier} action ${action}`,
    );
  }
};
