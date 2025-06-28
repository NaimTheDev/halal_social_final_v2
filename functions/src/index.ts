// eslint-disable-next-line object-curly-spacing
import { onRequest } from "firebase-functions/v2/https";
import * as logger from "firebase-functions/logger";

// Start writing functions
// https://firebase.google.com/docs/functions/typescript

export const helloWorld = onRequest((request, response) => {
  // eslint-disable-next-line object-curly-spacing
  logger.info("Hello logs!", { structuredData: true });
  response.send("Hello from Firebase!");
});

// eslint-disable-next-line object-curly-spacing
export { calendlyWebhookHandler } from "./calendly/calendlyWebhookHandler";
// eslint-disable-next-line object-curly-spacing
export { onCalendlyPATAdded } from "./calendly/onCalendlyPATAdded";
// eslint-disable-next-line object-curly-spacing
