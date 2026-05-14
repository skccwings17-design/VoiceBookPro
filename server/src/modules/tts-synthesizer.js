const textToSpeech = require('@google-cloud/text-to-speech');
const config = require('../config');
const { buildSsml } = require('./ssml-builder');

const client = new textToSpeech.TextToSpeechClient();

/**
 * Synthesize speech using either a standard voice or a custom cloning key.
 */
async function synthesize(ssml, voiceConfig, customVoiceKey = null) {
  const request = {
    input: { ssml: ssml },
    voice: customVoiceKey 
      ? { customVoiceKey: customVoiceKey } // Chirp 3 Instant Custom Voice
      : { languageCode: voiceConfig.languageCode, name: voiceConfig.name },
    audioConfig: {
      audioEncoding: 'LINEAR16',
      sampleRateHertz: config.tts.audioSampleRate
    },
  };

  try {
    const [response] = await client.synthesizeSpeech(request);
    let data = response.audioContent;
    
    // Strip WAV header if present (Cloud TTS LINEAR16 sometimes includes it)
    if (data.length > 44 && data.toString('utf8', 0, 4) === 'RIFF') {
      data = data.slice(44);
    }
    return data;
  } catch (error) {
    console.error('TTS Synthesis Error:', error.message);
    throw error;
  }
}

async function synthesizeBilingualStory(storyData, voiceProfile) {
  const buffers = [];
  const sampleRate = config.tts.audioSampleRate;

  const createSilence = (ms) => {
    const size = Math.floor((ms / 1000) * sampleRate * 2);
    return Buffer.alloc(size % 2 === 0 ? size : size + 1, 0);
  };

  const shortBreak = createSilence(800);
  const longBreak = createSilence(1200);

  for (let i = 0; i < storyData.length; i++) {
    const item = storyData[i];
    
    const enSsml = buildSsml(item.en, 'en-US', item.emphasis);
    const koSsml = buildSsml(item.ko, 'ko-KR', item.emphasis);

    // If using custom voice, apply it to both (Chirp 3 supports multiple languages usually,
    // or we fall back to base for Korean if needed). 
    // For now, we assume the custom voice or selected profile applies to the persona.
    const [enBuffer, koBuffer] = await Promise.all([
      synthesize(enSsml, config.tts.en, voiceProfile?.customVoiceKey),
      synthesize(koSsml, config.tts.ko, voiceProfile?.customVoiceKey)
    ]);

    if (i > 0) buffers.push(longBreak);
    buffers.push(enBuffer);
    buffers.push(shortBreak);
    buffers.push(koBuffer);
  }

  return buffers;
}

module.exports = { synthesizeBilingualStory };
