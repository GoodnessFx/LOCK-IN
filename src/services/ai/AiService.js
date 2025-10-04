// Lightweight, swappable AI service. Uses OpenAI if OPENAI_API_KEY exists; otherwise falls back to local heuristics.
// Non-invasive: pure functions and a single exported instance.

import axios from 'axios';

const DEFAULT_MODEL = 'gpt-4o-mini';

class AiService {
  constructor(config) {
    this.apiKey = config?.openAIApiKey || process?.env?.OPENAI_API_KEY || '';
    this.baseURL = config?.openAIBaseUrl || process?.env?.OPENAI_BASE_URL || 'https://api.openai.com/v1';
    this.model = config?.model || process?.env?.OPENAI_MODEL || DEFAULT_MODEL;
  }

  get isConfigured() {
    return Boolean(this.apiKey);
  }

  // Summarize a finished focus session and propose next steps
  async summarizeSession({ durationMinutes, tasks = [], notes = '', context = {} }) {
    if (!this.isConfigured) {
      return this._fallbackSummary({ durationMinutes, tasks, notes });
    }

    const prompt = [
      'You are a concise learning coach. Based on the session data, summarize progress in 3-5 bullets,',
      'then propose 3 micro-tasks for the next session. Keep tone motivating and specific.',
      `Duration: ${durationMinutes} min`,
      `Tasks: ${tasks.join(', ') || 'N/A'}`,
      `Notes: ${notes || 'N/A'}`,
    ].join('\n');

    const content = await this._chat(prompt, context);
    return { summary: content, suggestions: this._extractSuggestions(content) };
  }

  // Generate catch-up suggestions for inactivity
  async suggestCatchUp({ lastActiveDays, preferredTopics = [] }) {
    if (!this.isConfigured) {
      return [
        'Do a 15-min review of your last notes.',
        'Rebuild one small component from memory.',
        'Skim a short article on your niche topic.',
      ];
    }

    const prompt = [
      'User has been inactive. Suggest 3 quick catch-up actions, each under 15 minutes.',
      `Days inactive: ${lastActiveDays}`,
      `Preferred topics: ${preferredTopics.join(', ') || 'N/A'}`,
    ].join('\n');

    const content = await this._chat(prompt);
    return this._extractSuggestions(content);
  }

  async _chat(prompt, context = {}) {
    try {
      const response = await axios.post(
        `${this.baseURL}/chat/completions`,
        {
          model: this.model,
          messages: [
            { role: 'system', content: 'You are a supportive, concise personal growth coach.' },
            ...(context?.messages || []).map((m) => ({ role: m.role, content: m.content })),
            { role: 'user', content: prompt },
          ],
          temperature: 0.7,
        },
        {
          headers: {
            Authorization: `Bearer ${this.apiKey}`,
            'Content-Type': 'application/json',
          },
          timeout: 20000,
        },
      );
      const content = response?.data?.choices?.[0]?.message?.content || '';
      return content;
    } catch (error) {
      // Fallback to local heuristic if API fails
      return this._fallbackSummary({});
    }
  }

  _fallbackSummary({ durationMinutes = 25, tasks = [], notes = '' }) {
    const summary = `Session complete: ${durationMinutes} min. Focused on ${
      tasks[0] || 'your core skill'
    }. ${notes ? `Notes: ${notes}` : ''}`;
    const suggestions = [
      'Do a 10-min recap of today’s key idea.',
      'Create one micro-example or flashcard.',
      'Plan the first 5 minutes of your next session.',
    ];
    return { summary, suggestions };
  }

  _extractSuggestions(text) {
    const lines = text.split('\n').map((l) => l.trim()).filter(Boolean);
    const candidates = lines.filter((l) => /^[\-\*\d]/.test(l));
    return candidates.slice(-5).map((l) => l.replace(/^[-*\d\.\s]+/, ''));
  }
}

const aiService = new AiService();
export default aiService;


