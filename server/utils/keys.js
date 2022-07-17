const googleCredentials = JSON.parse(process.env.GOOGLE_CREDENTIALS.toString());

const dialogflowCredentials = {
  projectId: googleCredentials.project_id,
  sessionLanguageCode: "vi-VN",
  clientEmail: googleCredentials.client_email,
  privateKey: googleCredentials.private_key,
};

module.exports = dialogflowCredentials;
