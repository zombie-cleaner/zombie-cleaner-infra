export const handler = async (event) => {
  console.log("Event received:", JSON.stringify(event, null, 2));

  try {
    
  } catch (error) {
    console.error("🔴 Error occurred:", error);
  }
}