// eslint-disable-next-line object-curly-spacing

// Start writing functions
// https://firebase.google.com/docs/functions/typescript

// export const helloWorld = onRequest((request, response) => {
//   // eslint-disable-next-line object-curly-spacing
//   logger.info("Hello logs!", { structuredData: true });
//   response.send("Hello from Firebase!");
// });

// eslint-disable-next-line object-curly-spacing
export { calendlyWebhookHandler } from "./calendly/calendlyWebhookHandler.js";
// eslint-disable-next-line object-curly-spacing
export { onCalendlyPATAdded } from "./calendly/onCalendlyPATAdded.js";
// eslint-disable-next-line object-curly-spacing
