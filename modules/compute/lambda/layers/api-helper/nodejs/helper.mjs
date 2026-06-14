import { STSClient, AssumeRoleCommand } from "@aws-sdk/client-sts";
import { log } from "./logger.mjs";

export const makeResponse = (statusCode, body = null) => {
  return {
    statusCode,
    headers: {
      "Content-Type": "application/json",
    },
    body:
      body === null
        ? ""
        : typeof body === "object"
          ? JSON.stringify(body)
          : String(body),
  };
};

export const success = (body = { message: "Success" }) => makeResponse(200, body);
export const badRequest = (message = "Bad Request") => makeResponse(400, { message });
export const forbidden = (message = "Forbidden") => makeResponse(403, { message });
export const notFound = (message = "Not Found") => makeResponse(404, { message });
export const internalError = (message = "Internal Server Error") => makeResponse(500, { message });

export const handleApiError = (error, context = "") => {
  log.error(`Error ${context}:`, error);

  const name = error?.name || error?.code;
  const message = error?.message || "An unexpected error occurred";

  switch (name) {
    case "ResourceNotFoundException":
    case "NoSuchEntity":
    case "NotFound":
      return notFound(message);
    case "AccessDenied":
    case "AccessDeniedException":
    case "UnauthorizedOperation":
      return forbidden(message);
    case "ValidationError":
    case "InvalidParameter":
    case "InvalidParameterValue":
      return badRequest(message);
    default:
      return internalError(message);
  }
};

export const getCrossAccountCredentials = async (authCreds, region = process.env.AWS_REGION) => {
  const sts = new STSClient({ region });

  const assumeRoleResponse = await sts.send(
    new AssumeRoleCommand({
      RoleArn: authCreds?.roleArn,
      RoleSessionName: "zombie-cleaner-session",
      ExternalId: authCreds?.externalId,
    }),
  );

  const credentials = assumeRoleResponse.Credentials;
  return {
    accessKeyId: credentials.AccessKeyId,
    secretAccessKey: credentials.SecretAccessKey,
    sessionToken: credentials.SessionToken,
  };
};
