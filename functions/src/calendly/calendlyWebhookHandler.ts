// functions/src/calendly/calendlyWebhookHandler.ts
import * as functions from "firebase-functions";
import * as admin from "firebase-admin";
import express from "express";

// Initialize Firebase Admin SDK
admin.initializeApp();
const db = admin.firestore();

// Express app to capture raw JSON payload
const app = express();
// eslint-disable-next-line object-curly-spacing
app.use(express.raw({ type: "application/json" }));

app.post("/", async (req, res) => {
  // 1️⃣ Bypass signature for now (insecure)

  // 2️⃣ Capture raw JSON string from bodyParser verify
  const body = req.body;

  // Directly save the request body to the scheduled_calls collection
  try {
    // eslint-disable-next-line object-curly-spacing
    const { payload: p } = body;
    const email = p.email;

    const callData = {
      mentorUri: p.scheduled_event.uri,
      reschedule_url: p.reschedule_url,
      cancel_url: p.cancel_url,
      eventType: p.scheduled_event.name,
      inviteeName: p.name,
      inviteeEmail: p.email,
      startTime: p.scheduled_event.start_time,
      endTime: p.scheduled_event.end_time,
      calendlyEventUri: p.scheduled_event.uri,
      timezone: p.timezone,
      status: p.status,
      rescheduled: p.rescheduled,
      payment: p.payment,
      no_show: p.no_show,
      reconfirmation: p.reconfirmation,
      createdAt: admin.firestore.FieldValue.serverTimestamp(),
    };

    try {
      // Find the user by email
      const userSnapshot = await db
        .collection("users")
        .where("email", "==", email)
        .limit(1)
        .get();

      if (userSnapshot.empty) {
        // eslint-disable-next-line object-curly-spacing
        functions.logger.warn("No user found for email", { email });
        res.status(404).send("User not found");
        return;
      }

      const userId = userSnapshot.docs[0].id;

      // Save the call data to the user's scheduled_calls subcollection
      await db
        .collection("users")
        .doc(userId)
        .collection("scheduled_calls")
        .add(callData);

      // eslint-disable-next-line object-curly-spacing
      functions.logger.debug("Call data saved to scheduled_calls", { userId });
      res.status(200).send("Call logged");
      return;
    } catch (err) {
      functions.logger.error("Failed to save call data", err);
      res.status(500).send("Failed to save call data");
      return;
    }
  } catch (err) {
    functions.logger.error("Failed to process webhook body", err);
    res.status(500).send("Failed to process webhook body");
    return;
  }

  // 4️⃣ Respond immediately
  res.status(200).send("Webhook received");
});

// Export as v1 HTTPS function to allow express.raw()
export const calendlyWebhookHandler = functions.https.onRequest(app);
