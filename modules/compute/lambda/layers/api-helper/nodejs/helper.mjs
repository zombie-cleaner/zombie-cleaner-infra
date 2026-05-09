export const makeResponse = (statusCode, body = null) => {
  return {
    statusCode,
    body:
      body === null
        ? ""
        : typeof body === "object"
          ? JSON.stringify(body)
          : String(body),
  };
};
