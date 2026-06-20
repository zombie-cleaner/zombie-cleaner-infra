import {
  RDSClient,
  StartDBInstanceCommand,
  StopDBInstanceCommand,
  StartDBClusterCommand,
  StopDBClusterCommand,
} from "@aws-sdk/client-rds";
import { success, handleApiError } from "/opt/nodejs/helper.mjs";
import { log } from "/opt/nodejs/logger.mjs";

export const scheduleRDS = async (
  resourceIdentifier,
  action,
  credentials,
  options = {},
) => {
  try {
    const client = new RDSClient({
      credentials,
      region: process.env.REGION || process.env.AWS_REGION,
    });

    const isCluster = options.isCluster === true || options.resourceType === "rds-cluster";

    if (action === "shutdown" || action === "stop") {
      if (isCluster) {
        log.info(`Stopping RDS DB Cluster ${resourceIdentifier}`);
        await client.send(
          new StopDBClusterCommand({ DBClusterIdentifier: resourceIdentifier }),
        );
        log.success(`RDS DB Cluster ${resourceIdentifier} stopped successfully`);
        return success({
          message: `RDS DB Cluster ${resourceIdentifier} stopped successfully`,
        });
      } else {
        log.info(`Stopping RDS DB Instance ${resourceIdentifier}`);
        await client.send(
          new StopDBInstanceCommand({ DBInstanceIdentifier: resourceIdentifier }),
        );
        log.success(`RDS DB Instance ${resourceIdentifier} stopped successfully`);
        return success({
          message: `RDS DB Instance ${resourceIdentifier} stopped successfully`,
        });
      }
    } else if (action === "wake" || action === "start") {
      if (isCluster) {
        log.info(`Starting RDS DB Cluster ${resourceIdentifier}`);
        await client.send(
          new StartDBClusterCommand({ DBClusterIdentifier: resourceIdentifier }),
        );
        log.success(`RDS DB Cluster ${resourceIdentifier} started successfully`);
        return success({
          message: `RDS DB Cluster ${resourceIdentifier} started successfully`,
        });
      } else {
        log.info(`Starting RDS DB Instance ${resourceIdentifier}`);
        await client.send(
          new StartDBInstanceCommand({ DBInstanceIdentifier: resourceIdentifier }),
        );
        log.success(`RDS DB Instance ${resourceIdentifier} started successfully`);
        return success({
          message: `RDS DB Instance ${resourceIdentifier} started successfully`,
        });
      }
    } else {
      throw new Error(`Unsupported RDS action: ${action}`);
    }
  } catch (error) {
    return handleApiError(
      error,
      `scheduling RDS resource ${resourceIdentifier} action ${action}`,
    );
  }
};
