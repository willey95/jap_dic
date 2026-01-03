-- Enable UUID extension
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- =====================
-- PROFILES
-- =====================
CREATE TABLE profiles (
  id uuid references auth.users PRIMARY KEY,
  username text UNIQUE NOT NULL,
  email text UNIQUE NOT NULL,
  display_name text,
  level text DEFAULT 'beginner',
  target_level text DEFAULT 'N5',
  study_streak integer DEFAULT 0,
  last_active timestamp with time zone,
  preferences jsonb DEFAULT '{}',
  created_at timestamp with time zone DEFAULT now(),
  updated_at timestamp with time zone DEFAULT now()
);

-- Enable RLS
ALTER TABLE profiles ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users can view own profile" ON profiles
  FOR SELECT USING (auth.uid() = id);

CREATE POLICY "Users can update own profile" ON profiles
  FOR UPDATE USING (auth.uid() = id);

-- =====================
-- VOCABULARY
-- =====================
CREATE TABLE vocabulary (
  id uuid PRIMARY KEY DEFAULT uuid_generate_v4(),
  kanji text NOT NULL,
  furigana text NOT NULL,
  romaji text NOT NULL,
  meaning_ko text NOT NULL,
  meaning_en text,
  jlpt_level text CHECK (jlpt_level IN ('N5', 'N4', 'N3', 'N2', 'N1')),
  category text,
  part_of_speech text,
  example_sentence text,
  example_translation text,
  audio_url text,
  created_at timestamp with time zone DEFAULT now(),
  updated_at timestamp with time zone DEFAULT now()
);

CREATE INDEX idx_vocabulary_kanji ON vocabulary(kanji);
CREATE INDEX idx_vocabulary_jlpt_level ON vocabulary(jlpt_level);
CREATE INDEX idx_vocabulary_category ON vocabulary(category);

-- Enable RLS
ALTER TABLE vocabulary ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Anyone can read vocabulary" ON vocabulary
  FOR SELECT USING (true);

-- =====================
-- KANJI
-- =====================
CREATE TABLE kanji (
  id uuid PRIMARY KEY DEFAULT uuid_generate_v4(),
  character text UNIQUE NOT NULL,
  meaning_ko text NOT NULL,
  meaning_en text,
  onyomi text[],
  kunyomi text[],
  strokes integer NOT NULL,
  radical text,
  radical_meaning text,
  jlpt_level text,
  frequency_rank integer,
  stroke_order jsonb,
  created_at timestamp with time zone DEFAULT now()
);

CREATE INDEX idx_kanji_character ON kanji(character);
CREATE INDEX idx_kanji_jlpt_level ON kanji(jlpt_level);

-- Enable RLS
ALTER TABLE kanji ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Anyone can read kanji" ON kanji
  FOR SELECT USING (true);

-- =====================
-- KANJI COMPONENTS
-- =====================
CREATE TABLE kanji_components (
  id uuid PRIMARY KEY DEFAULT uuid_generate_v4(),
  kanji_id uuid references kanji(id) ON DELETE CASCADE,
  component text NOT NULL,
  meaning text,
  position text
);

-- Enable RLS
ALTER TABLE kanji_components ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Anyone can read kanji_components" ON kanji_components
  FOR SELECT USING (true);

-- =====================
-- KANJI EXAMPLES
-- =====================
CREATE TABLE kanji_examples (
  id uuid PRIMARY KEY DEFAULT uuid_generate_v4(),
  kanji_id uuid references kanji(id) ON DELETE CASCADE,
  word text NOT NULL,
  reading text NOT NULL,
  meaning text NOT NULL
);

-- Enable RLS
ALTER TABLE kanji_examples ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Anyone can read kanji_examples" ON kanji_examples
  FOR SELECT USING (true);

-- =====================
-- USER PROGRESS
-- =====================
CREATE TABLE user_progress (
  id uuid PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id uuid references profiles(id) ON DELETE CASCADE,
  item_type text CHECK (item_type IN ('vocabulary', 'kanji')),
  item_id uuid NOT NULL,
  mastery_level integer DEFAULT 0 CHECK (mastery_level BETWEEN 0 AND 5),
  correct_count integer DEFAULT 0,
  incorrect_count integer DEFAULT 0,
  last_reviewed timestamp with time zone,
  next_review timestamp with time zone,
  review_interval integer DEFAULT 1,
  created_at timestamp with time zone DEFAULT now(),
  updated_at timestamp with time zone DEFAULT now(),
  UNIQUE(user_id, item_type, item_id)
);

CREATE INDEX idx_user_progress_user_id ON user_progress(user_id);
CREATE INDEX idx_user_progress_next_review ON user_progress(next_review);

-- Enable RLS
ALTER TABLE user_progress ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users can view own progress" ON user_progress
  FOR SELECT USING (auth.uid() = user_id);

CREATE POLICY "Users can insert own progress" ON user_progress
  FOR INSERT WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update own progress" ON user_progress
  FOR UPDATE USING (auth.uid() = user_id);

-- =====================
-- LISTENING EXERCISES
-- =====================
CREATE TABLE listening_exercises (
  id uuid PRIMARY KEY DEFAULT uuid_generate_v4(),
  title text NOT NULL,
  content text NOT NULL,
  audio_url text NOT NULL,
  transcript text NOT NULL,
  difficulty text CHECK (difficulty IN ('beginner', 'intermediate', 'advanced')),
  duration integer,
  category text,
  created_at timestamp with time zone DEFAULT now()
);

-- Enable RLS
ALTER TABLE listening_exercises ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Anyone can read listening_exercises" ON listening_exercises
  FOR SELECT USING (true);

-- =====================
-- SPEAKING EXERCISES
-- =====================
CREATE TABLE speaking_exercises (
  id uuid PRIMARY KEY DEFAULT uuid_generate_v4(),
  prompt text NOT NULL,
  target_sentence text NOT NULL,
  furigana text NOT NULL,
  difficulty text CHECK (difficulty IN ('beginner', 'intermediate', 'advanced')),
  category text,
  tips text,
  created_at timestamp with time zone DEFAULT now()
);

-- Enable RLS
ALTER TABLE speaking_exercises ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Anyone can read speaking_exercises" ON speaking_exercises
  FOR SELECT USING (true);

-- =====================
-- USER RECORDINGS
-- =====================
CREATE TABLE user_recordings (
  id uuid PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id uuid references profiles(id) ON DELETE CASCADE,
  exercise_id uuid references speaking_exercises(id) ON DELETE CASCADE,
  audio_url text NOT NULL,
  transcription text,
  score integer,
  feedback jsonb,
  created_at timestamp with time zone DEFAULT now()
);

-- Enable RLS
ALTER TABLE user_recordings ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users can view own recordings" ON user_recordings
  FOR SELECT USING (auth.uid() = user_id);

CREATE POLICY "Users can insert own recordings" ON user_recordings
  FOR INSERT WITH CHECK (auth.uid() = user_id);

-- =====================
-- WRITING EXERCISES
-- =====================
CREATE TABLE writing_exercises (
  id uuid PRIMARY KEY DEFAULT uuid_generate_v4(),
  kanji_id uuid references kanji(id) ON DELETE CASCADE,
  instructions text,
  difficulty text CHECK (difficulty IN ('beginner', 'intermediate', 'advanced')),
  created_at timestamp with time zone DEFAULT now()
);

-- Enable RLS
ALTER TABLE writing_exercises ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Anyone can read writing_exercises" ON writing_exercises
  FOR SELECT USING (true);

-- =====================
-- USER FAVORITES
-- =====================
CREATE TABLE user_favorites (
  id uuid PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id uuid references profiles(id) ON DELETE CASCADE,
  item_type text CHECK (item_type IN ('vocabulary', 'kanji')),
  item_id uuid NOT NULL,
  created_at timestamp with time zone DEFAULT now(),
  UNIQUE(user_id, item_type, item_id)
);

-- Enable RLS
ALTER TABLE user_favorites ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users can view own favorites" ON user_favorites
  FOR SELECT USING (auth.uid() = user_id);

CREATE POLICY "Users can insert own favorites" ON user_favorites
  FOR INSERT WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can delete own favorites" ON user_favorites
  FOR DELETE USING (auth.uid() = user_id);

-- =====================
-- CONTEXT EXAMPLES
-- =====================
CREATE TABLE context_examples (
  id uuid PRIMARY KEY DEFAULT uuid_generate_v4(),
  word text NOT NULL,
  context_type text NOT NULL,
  situation text NOT NULL,
  example_sentence text NOT NULL,
  translation text NOT NULL,
  explanation text,
  cultural_note text,
  created_at timestamp with time zone DEFAULT now()
);

-- Enable RLS
ALTER TABLE context_examples ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Anyone can read context_examples" ON context_examples
  FOR SELECT USING (true);

-- =====================
-- FUNCTIONS
-- =====================

-- Function to handle new user signup
CREATE OR REPLACE FUNCTION public.handle_new_user()
RETURNS trigger AS $$
BEGIN
  INSERT INTO public.profiles (id, username, email)
  VALUES (
    new.id,
    COALESCE(new.raw_user_meta_data->>'username', split_part(new.email, '@', 1)),
    new.email
  );
  RETURN new;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Trigger for new user signup
CREATE OR REPLACE TRIGGER on_auth_user_created
  AFTER INSERT ON auth.users
  FOR EACH ROW EXECUTE FUNCTION public.handle_new_user();

-- Function to update updated_at timestamp
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = now();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Triggers for updated_at
CREATE TRIGGER update_profiles_updated_at
  BEFORE UPDATE ON profiles
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_vocabulary_updated_at
  BEFORE UPDATE ON vocabulary
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_user_progress_updated_at
  BEFORE UPDATE ON user_progress
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
