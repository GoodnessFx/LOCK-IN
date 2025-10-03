// Lightweight global store for sessions, user prefs, and AI suggestions.

import create from 'zustand';

export const useAppStore = create((set, get) => ({
  user: {
    name: 'Alex Chen',
    niche: 'Flutter Development',
  },
  session: {
    isActive: false,
    startedAt: null,
    durationMinutes: 25,
    phase: 'work',
  },
  ai: {
    lastSummary: null,
    suggestions: [],
  },
  setUser: (user) => set({ user }),
  startSession: (durationMinutes = 25) =>
    set({ session: { isActive: true, startedAt: Date.now(), durationMinutes, phase: 'work' } }),
  endSession: () => set({ session: { ...get().session, isActive: false } }),
  setSessionPhase: (phase) => set({ session: { ...get().session, phase } }),
  setAiResults: ({ summary, suggestions }) => set({ ai: { lastSummary: summary, suggestions: suggestions || [] } }),
}));

export default useAppStore;


