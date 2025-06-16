import {onRequest} from "firebase-functions/v2/https";
import * as admin from "firebase-admin";
import * as crypto from "crypto";


if (!admin.apps.length) {
  admin.initializeApp();
}

const CALENDLY_SIGNING_KEY = process.env.CALENDLY_SIGNING_KEY;

export const calendlyWebhookHandler = onRequest(async (req, res) => {
  const signature = req.headers["calendly-webhook-signature"] as string;

  const expectedSignature = crypto
    // eslint-disable-next-line @typescript-eslint/no-non-null-assertion
    .createHmac("sha256", CALENDLY_SIGNING_KEY!)
    .update(JSON.stringify(req.body))
    .digest("hex");

  if (signature !== expectedSignature) {
    console.warn("Invalid signature.");
    res.status(401).send("Unauthorized");
    return;
  }

  const event = req.body;

  if (event.event === "invitee.created") {
    const payload = event.payload;

    await admin.firestore().collection("scheduled_calls").add({
      email: payload.invitee.email,
      name: payload.invitee.name,
      event_type: payload.event_type.name,
      start_time: payload.event.start_time,
      end_time: payload.event.end_time,
      uri: payload.event.uri,
      created_at: admin.firestore.FieldValue.serverTimestamp(),
    });
  }

  res.status(200).send("Webhook received.");
});
