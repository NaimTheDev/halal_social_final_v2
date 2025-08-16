import * as functions from "firebase-functions/v2/firestore";
import admin from "firebase-admin";
import axios from "axios";

if (!admin.apps.length) admin.initializeApp();

export const onCalendlyPATAdded = functions.onDocumentWritten(
  {
    document: "mentors/{userId}",
  },
  async (event) => {
    const before = event.data?.before?.data();
    const after = event.data?.after?.data();

    // Exit if no calendlyPAT was added
    if (before?.calendlyPAT || !after?.calendlyPAT) {
      return;
    }

    const userId = event.params.userId;
    const pat = after.calendlyPAT;
    const calendlyUserUri = after.calendlyUserUri;
    const calendlyOrgId = after.calendlyOrgId;

    if (!calendlyUserUri || !calendlyOrgId) {
      console.warn(`❌ Missing Calendly metadata for user ${userId}`);
      return;
    }

    try {
      const webhookUrl =
        "https://us-central1-halal-social-prod.cloudfunctions.net/calendlyWebhookHandler";

      const res = await axios.post(
        "https://api.calendly.com/webhook_subscriptions",
        {
          url: webhookUrl,
          events: ["invitee.created"],
          organization: `https://api.calendly.com/organizations/${calendlyOrgId}`,
          scope: "user",
          user: calendlyUserUri,
        },
        {
          headers: {
            // eslint-disable-next-line quote-props
            Authorization: `Bearer ${pat}`,
            "Content-Type": "application/json",
          },
        }
      );

      console.log(`✅ Webhook registered for ${userId}:`, res.data);
    } catch (err: any) {
      console.error(
        `❌ Error registering webhook for ${userId}:`,
        err?.response?.data || err.message
      );
    }
  }
);
