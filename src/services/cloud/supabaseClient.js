// Supabase client setup; safe no-op if not configured.

import { createClient } from '@supabase/supabase-js';
import { getEnv } from '../../utils/env';

const url = getEnv('SUPABASE_URL', '');
const anon = getEnv('SUPABASE_ANON_KEY', '');

export const supabase = url && anon ? createClient(url, anon) : null;

export default supabase;


