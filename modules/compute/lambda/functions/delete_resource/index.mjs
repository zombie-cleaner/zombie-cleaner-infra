export const handler = async (event) => {
  console.log("Event received:", JSON.stringify(event, null, 2));

  try {
    console.log("🟢 Processing delete resource event...");
  } catch (error) {
    console.error("🔴 Error occurred:", error);
  }
};
