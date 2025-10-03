// Reusable Pomodoro timer hook with background-safety and optional vibration.
// Keeps API minimal and flexible for the existing screens.

import { useEffect, useRef, useState } from 'react';
import { AppState, Vibration } from 'react-native';

const minute = 60 * 1000;

export function usePomodoroTimer({
  workMinutes = 25,
  breakMinutes = 5,
  longBreakMinutes = 15,
  cyclesUntilLongBreak = 4,
  autoStartNext = true,
  enableHaptics = true,
  onPhaseChange,
  onComplete,
} = {}) {
  const [phase, setPhase] = useState('work'); // 'work' | 'break' | 'longBreak'
  const [cycle, setCycle] = useState(1);
  const [isRunning, setIsRunning] = useState(false);
  const [remainingMs, setRemainingMs] = useState(workMinutes * minute);
  const lastTickRef = useRef(Date.now());
  const appStateRef = useRef('active');

  const targetMsForPhase = () => {
    if (phase === 'work') return workMinutes * minute;
    if (phase === 'break') return breakMinutes * minute;
    return longBreakMinutes * minute;
  };

  const start = () => {
    lastTickRef.current = Date.now();
    setIsRunning(true);
  };

  const pause = () => setIsRunning(false);

  const reset = () => {
    setIsRunning(false);
    setPhase('work');
    setCycle(1);
    setRemainingMs(workMinutes * minute);
  };

  // Handle app state (rough background safety)
  useEffect(() => {
    const sub = AppState.addEventListener('change', (state) => {
      appStateRef.current = state;
      lastTickRef.current = Date.now();
    });
    return () => sub?.remove?.();
  }, []);

  // Ticker
  useEffect(() => {
    if (!isRunning) return;
    const id = setInterval(() => {
      const now = Date.now();
      const delta = now - lastTickRef.current;
      lastTickRef.current = now;
      setRemainingMs((prev) => Math.max(0, prev - delta));
    }, 250);
    return () => clearInterval(id);
  }, [isRunning]);

  // Phase completion
  useEffect(() => {
    if (remainingMs > 0) return;

    if (enableHaptics) {
      Vibration.vibrate(300);
    }

    // Move to next phase
    if (phase === 'work') {
      const nextCycle = cycle + 1;
      const isLong = cycle % cyclesUntilLongBreak === 0;
      const nextPhase = isLong ? 'longBreak' : 'break';
      setPhase(nextPhase);
      setRemainingMs(isLong ? longBreakMinutes * minute : breakMinutes * minute);
      setCycle(nextCycle);
      onPhaseChange && onPhaseChange(nextPhase, nextCycle);
      if (!autoStartNext) setIsRunning(false);
    } else {
      // Back to work
      setPhase('work');
      setRemainingMs(workMinutes * minute);
      onPhaseChange && onPhaseChange('work', cycle);
      if (!autoStartNext) setIsRunning(false);
    }

    // Call onComplete after a full cycle of work completes
    if (phase === 'work') onComplete && onComplete();
  }, [remainingMs]);

  const totalMs = targetMsForPhase();
  const progress = Math.max(0, Math.min(1, 1 - remainingMs / totalMs));

  return {
    phase,
    cycle,
    isRunning,
    remainingMs,
    totalMs,
    progress,
    start,
    pause,
    reset,
    setWorkMinutes: (m) => setRemainingMs(m * minute),
  };
}

export default usePomodoroTimer;


