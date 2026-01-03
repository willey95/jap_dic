export interface Vocabulary {
  id: string;
  kanji: string;
  furigana: string;
  romaji: string;
  meaning_ko: string;
  meaning_en?: string;
  jlpt_level: 'N5' | 'N4' | 'N3' | 'N2' | 'N1';
  category?: string;
  part_of_speech?: string;
  example_sentence?: string;
  example_translation?: string;
  audio_url?: string;
  created_at: string;
  updated_at: string;
}

export interface VocabularyWithLinks extends Vocabulary {
  youtube_url: string;
  google_url: string;
}

export interface Kanji {
  id: string;
  character: string;
  meaning_ko: string;
  meaning_en?: string;
  onyomi: string[];
  kunyomi: string[];
  strokes: number;
  radical?: string;
  radical_meaning?: string;
  jlpt_level?: string;
  frequency_rank?: number;
  stroke_order?: Record<string, unknown>;
  created_at: string;
}

export interface UserProgress {
  id: string;
  user_id: string;
  item_type: 'vocabulary' | 'kanji';
  item_id: string;
  mastery_level: number;
  correct_count: number;
  incorrect_count: number;
  last_reviewed?: string;
  next_review?: string;
  review_interval: number;
  created_at: string;
  updated_at: string;
}

export interface UserFavorite {
  id: string;
  user_id: string;
  item_type: 'vocabulary' | 'kanji';
  item_id: string;
  created_at: string;
}

export interface Profile {
  id: string;
  username: string;
  email: string;
  display_name?: string;
  level: string;
  target_level: string;
  study_streak: number;
  last_active?: string;
  preferences: Record<string, unknown>;
  created_at: string;
  updated_at: string;
}
