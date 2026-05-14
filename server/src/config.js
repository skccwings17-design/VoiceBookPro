require('dotenv').config();
const path = require('path');
const fs = require('fs');

const config = {
  geminiApiKey: process.env.GEMINI_API_KEY,
  gcpProjectId: process.env.GCP_PROJECT_ID || 'voicebook-flutter-pro',
  port: process.env.PORT || 8080, // Cloud Run uses 8080 by default

  // Default TTS settings for Children Storytelling Persona
  tts: {
    en: {
      name: process.env.EN_VOICE_NAME || 'en-US-Neural2-F',
      languageCode: process.env.EN_LANGUAGE_CODE || 'en-US',
    },
    ko: {
      name: process.env.KO_VOICE_NAME || 'ko-KR-Neural2-A',
      languageCode: process.env.KO_LANGUAGE_CODE || 'ko-KR',
    },
    audioSampleRate: parseInt(process.env.AUDIO_SAMPLE_RATE || '24000', 10),
    speakingRate: parseFloat(process.env.SPEAKING_RATE || '0.85'), // Fixed slow rate for kids
    pitchSemitones: process.env.PITCH_SEMITONES || '+1st',
  },

  directories: {
    output: path.join(__dirname, '..', 'output'),
  }
};

// Ensure output directory exists
if (!fs.existsSync(config.directories.output)) {
  fs.mkdirSync(config.directories.output, { recursive: true });
}

module.exports = config;
