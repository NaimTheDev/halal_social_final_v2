import {onRequest} from "firebase-functions/v2/https";
import axios, {isAxiosError} from "axios";
import * as admin from "firebase-admin";


if (!admin.apps.length) {
  admin.initializeApp();
}

const CALENDLY_CLIENT_ID = process.env.CALENDLY_CLIENT_ID;
const CALENDLY_CLIENT_SECRET = process.env.CALENDLY_CLIENT_SECRET;

export const calendlyOAuthRedirect = onRequest(async (req, res) => {
  const code = req.query.code;

  if (!code) {
    res.status(400).send("Missing code parameter");
    return;
  }

  try {
    const response = await axios.post("https://auth.calendly.com/oauth/token", {
      grant_type: "authorization_code",
      client_id: CALENDLY_CLIENT_ID,
      client_secret: CALENDLY_CLIENT_SECRET,
      code,
      redirect_uri: "https://us-central1-halal-social-prod.cloudfunctions.net/calendlyOAuthRedirect",
    });

    const {accessToken, refreshToken, organization, owner} = response.data;

    await admin.firestore().collection("calendly_tokens").doc(owner).set({
      accessToken: accessToken,
      refreshToken: refreshToken,
      organization,
      created_at: admin.firestore.FieldValue.serverTimestamp(),
    });

    res.send("Calendly successfully connected. You may close this tab.");
  } catch (error) {
    if (isAxiosError(error)) {
      console.error("OAuth error", error.response?.data || error.message);
    } else {
      console.error("Unexpected error", error);
    }
    res.status(500).send("Error exchanging Calendly token.");
  }
});
