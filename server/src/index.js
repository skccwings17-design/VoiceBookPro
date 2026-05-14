const express = require('express');
const cors = require('cors');
const config = require('./config');

const translateRoute = require('./routes/translate');
const ttsRoute = require('./routes/tts');
const voiceProfileRoute = require('./routes/voice-profile');

const app = express();

app.use(cors());
app.use(express.json({ limit: '10mb' }));

// API routes
app.use('/api/translate', translateRoute);
app.use('/api/tts', ttsRoute);
app.use('/api/voice-profile', voiceProfileRoute);

// Health check
app.get('/health', (req, res) => {
  res.json({ status: 'ok', project: config.gcpProjectId });
});

// Start the server
const server = app.listen(config.port, () => {
  console.log(`VoiceBook Pro Server running on port ${config.port}`);
  console.log(`Target GCP Project: ${config.gcpProjectId}`);
});

// Cloud Run timeout settings
server.keepAliveTimeout = 620 * 1000;
server.headersTimeout = 630 * 1000;

// Trigger redeploy with fixed credentials
