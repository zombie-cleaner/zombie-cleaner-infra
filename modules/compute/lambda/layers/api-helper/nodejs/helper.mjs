const defaultHeaders = {
  "Content-Type": "application/json",
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Credentials": true,
};

export const makeResponse = (statusCode, body = null, headers = {}) => {
  return {
    statusCode,
    body:
      body === null
        ? ""
        : typeof body === "object"
          ? JSON.stringify(body)
          : String(body),
    headers: { ...defaultHeaders, ...headers },
  };
};
