-- ==========================================
-- TABLE DEFINITIONS
-- ==========================================

-- 1. Users Table
CREATE TABLE users (
  id UUID REFERENCES auth.users NOT NULL PRIMARY KEY,
  email TEXT NOT NULL,
  name TEXT,
  username TEXT,
  image TEXT,
  weight INTEGER,
  height INTEGER,
  goalscount INTEGER DEFAULT 0,
  achievementscount INTEGER DEFAULT 0,
  birthday DATE,
  progressmonitors TEXT[] DEFAULT '{}',
  activeworkouts JSONB DEFAULT '{}',
  streakstart TIMESTAMPTZ,
  streaklatest TIMESTAMPTZ,
  trial_start TIMESTAMPTZ,
  should_reload_data BOOLEAN DEFAULT FALSE,
  is_developer BOOLEAN DEFAULT FALSE,
  free_forever_override BOOLEAN DEFAULT FALSE,
  has_purchased BOOLEAN DEFAULT FALSE,
  last_login TIMESTAMPTZ,
  last_os TEXT,
  last_os_version TEXT,
  login_count INTEGER DEFAULT 0,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- 2. Activities Table
-- Note: 'is_global' replaces setting the 'owner' to 'global' in Firestore
CREATE TABLE activities (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  owner UUID REFERENCES users(id) ON DELETE CASCADE,
  is_global BOOLEAN DEFAULT FALSE,
  name TEXT NOT NULL,
  name_de TEXT,
  description TEXT,
  description_de TEXT,
  image TEXT,
  recommendedreps INTEGER,
  recommendedsets INTEGER,
  type TEXT,
  musclegroups TEXT[],
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- 3. Workouts Table
CREATE TABLE workouts (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  owner UUID REFERENCES users(id) ON DELETE CASCADE,
  name TEXT NOT NULL,
  description TEXT,
  image TEXT,
  period INTEGER DEFAULT 1,
  repeating BOOLEAN DEFAULT FALSE,
  startdate TIMESTAMPTZ,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- 4. Workout Activities Table
-- Note: Relational junction table mapping workouts and their activities
CREATE TABLE workout_activities (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  workout_id UUID REFERENCES workouts(id) ON DELETE CASCADE,
  activity_id UUID REFERENCES activities(id) ON DELETE CASCADE,
  weekday INTEGER NOT NULL,
  activity_order INTEGER NOT NULL,
  UNIQUE(workout_id, activity_id, weekday)
);

-- 5. Goals Table
CREATE TABLE goals (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  owner UUID REFERENCES users(id) ON DELETE CASCADE,
  activity_id UUID REFERENCES activities(id) ON DELETE CASCADE,
  title TEXT NOT NULL,
  image TEXT,
  unit TEXT,
  startstate NUMERIC,
  endstate NUMERIC,
  currentstate NUMERIC,
  startdate TIMESTAMPTZ,
  enddate TIMESTAMPTZ,
  iscompleted BOOLEAN DEFAULT FALSE,
  isdeleted BOOLEAN DEFAULT FALSE,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- 6. Sets Table
CREATE TABLE sets (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  owner UUID REFERENCES users(id) ON DELETE CASCADE,
  activity_id UUID REFERENCES activities(id) ON DELETE CASCADE,
  reps INTEGER NOT NULL,
  weight NUMERIC NOT NULL,
  timestamp TIMESTAMPTZ NOT NULL,
  created_at TIMESTAMPTZ DEFAULT NOW()
);


-- ==========================================
-- ROW LEVEL SECURITY (RLS) POLICIES
-- ==========================================

ALTER TABLE users ENABLE ROW LEVEL SECURITY;
ALTER TABLE activities ENABLE ROW LEVEL SECURITY;
ALTER TABLE workouts ENABLE ROW LEVEL SECURITY;
ALTER TABLE workout_activities ENABLE ROW LEVEL SECURITY;
ALTER TABLE goals ENABLE ROW LEVEL SECURITY;
ALTER TABLE sets ENABLE ROW LEVEL SECURITY;

-- Users
CREATE POLICY "Users can only see their own row" ON users FOR SELECT USING (auth.uid() = id);
CREATE POLICY "Users can only update their own row" ON users FOR UPDATE USING (auth.uid() = id);
CREATE POLICY "Users can insert their own row" ON users FOR INSERT WITH CHECK (auth.uid() = id);

-- Activities
-- Allow users to see their own activities, or any global activities
CREATE POLICY "Users can view own or global activities" ON activities FOR SELECT USING (owner = auth.uid() OR is_global = TRUE);
CREATE POLICY "Users can insert own activities" ON activities FOR INSERT WITH CHECK (owner = auth.uid());
CREATE POLICY "Users can update own activities" ON activities FOR UPDATE USING (owner = auth.uid());
CREATE POLICY "Users can delete own activities" ON activities FOR DELETE USING (owner = auth.uid());

-- Workouts
CREATE POLICY "Users can access own workouts" ON workouts FOR SELECT USING (owner = auth.uid());
CREATE POLICY "Users can insert own workouts" ON workouts FOR INSERT WITH CHECK (owner = auth.uid());
CREATE POLICY "Users can update own workouts" ON workouts FOR UPDATE USING (owner = auth.uid());
CREATE POLICY "Users can delete own workouts" ON workouts FOR DELETE USING (owner = auth.uid());

-- Workout Activities
-- Users can manage workout activities if they own the parent workout
CREATE POLICY "Users can manage workout activities" ON workout_activities FOR ALL USING (
  EXISTS (SELECT 1 FROM workouts WHERE id = workout_activities.workout_id AND owner = auth.uid())
);

-- Goals
CREATE POLICY "Users can access own goals" ON goals FOR SELECT USING (owner = auth.uid());
CREATE POLICY "Users can insert own goals" ON goals FOR INSERT WITH CHECK (owner = auth.uid());
CREATE POLICY "Users can update own goals" ON goals FOR UPDATE USING (owner = auth.uid());
CREATE POLICY "Users can delete own goals" ON goals FOR DELETE USING (owner = auth.uid());

-- Sets
CREATE POLICY "Users can access own sets" ON sets FOR SELECT USING (owner = auth.uid());
CREATE POLICY "Users can insert own sets" ON sets FOR INSERT WITH CHECK (owner = auth.uid());
CREATE POLICY "Users can update own sets" ON sets FOR UPDATE USING (owner = auth.uid());
CREATE POLICY "Users can delete own sets" ON sets FOR DELETE USING (owner = auth.uid());


-- ==========================================
-- REALTIME SUBSCRIPTIONS
-- ==========================================
-- Optional: Enable if you plan to use Supabase Realtime subscriptions
ALTER PUBLICATION supabase_realtime ADD TABLE users, activities, workouts, workout_activities, goals, sets;
