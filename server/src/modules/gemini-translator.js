const { GoogleGenAI } = require('@google/genai');
const config = require('../config');

const ai = new GoogleGenAI({ apiKey: config.geminiApiKey });

async function translateStory(texts, sourceLanguage = 'en') {
  if (!texts || texts.length === 0) return [];

  const systemInstruction = `
You are a bilingual (English-Korean) children's book translator.
Translate the provided text list into natural, child-friendly Korean (5-7 year old level).
Use expressive paraphrasing (의역) to make it sound like a storyteller.

RULES:
1. Maintain the order of the input list.
2. Korean translation should be warm and polite (해요체).
3. Identify sentences that need emphasis (onomatopoeia, emotion) and set emphasis: true.
`;

  const responseSchema = {
    type: "ARRAY",
    items: {
      type: "OBJECT",
      properties: {
        en: { type: "STRING" },
        ko: { type: "STRING" },
        emphasis: { type: "BOOLEAN" }
      },
      required: ["en", "ko", "emphasis"]
    }
  };

  try {
    const model = ai.getGenerativeModel({
      model: 'gemini-1.5-flash',
      systemInstruction: systemInstruction,
    });

    const prompt = `Translate this list of sentences from a storybook:\n${JSON.stringify(texts)}`;

    const result = await model.generateContent({
      contents: [{ role: 'user', parts: [{ text: prompt }] }],
      generationConfig: {
        responseMimeType: "application/json",
        responseSchema: responseSchema,
      }
    });

    return JSON.parse(result.response.text());
  } catch (error) {
    console.error('Gemini Translation Error:', error);
    throw new Error('Failed to translate text: ' + error.message);
  }
}

module.exports = { translateStory };
