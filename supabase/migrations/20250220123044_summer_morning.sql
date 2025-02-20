/*
  # Initial Schema Setup for ShowTrack Platform

  1. New Tables
    - `profiles`
      - Extended user profile information
      - Linked to auth.users
    - `shows`
      - TV shows and movies information
    - `user_shows`
      - User's show tracking status
    - `episodes`
      - Episode information for TV shows
    - `soundtracks`
      - Music tracks for shows/episodes
    - `franchises`
      - Franchise information (e.g., Marvel, DC)
    - `show_franchises`
      - Links shows to their franchises
    - `comments`
      - User comments on shows/episodes
    - `achievements`
      - User achievements and badges

  2. Security
    - RLS enabled on all tables
    - Policies for authenticated users
*/

-- Create tables
CREATE TABLE IF NOT EXISTS profiles (
  id uuid PRIMARY KEY REFERENCES auth.users(id),
  username text UNIQUE NOT NULL,
  avatar_url text,
  bio text,
  created_at timestamptz DEFAULT now(),
  updated_at timestamptz DEFAULT now()
);

CREATE TABLE IF NOT EXISTS shows (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  title text NOT NULL,
  type text NOT NULL CHECK (type IN ('movie', 'tv_show')),
  overview text,
  poster_url text,
  release_date date,
  rating numeric(3,1) CHECK (rating >= 0 AND rating <= 10),
  created_at timestamptz DEFAULT now()
);

CREATE TABLE IF NOT EXISTS user_shows (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id uuid REFERENCES profiles(id),
  show_id uuid REFERENCES shows(id),
  status text CHECK (status IN ('watching', 'completed', 'plan_to_watch')),
  rating numeric(3,1) CHECK (rating >= 0 AND rating <= 10),
  created_at timestamptz DEFAULT now(),
  updated_at timestamptz DEFAULT now(),
  UNIQUE(user_id, show_id)
);

CREATE TABLE IF NOT EXISTS episodes (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  show_id uuid REFERENCES shows(id),
  title text NOT NULL,
  episode_number integer NOT NULL,
  season_number integer NOT NULL,
  air_date date,
  overview text,
  created_at timestamptz DEFAULT now()
);

CREATE TABLE IF NOT EXISTS soundtracks (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  show_id uuid REFERENCES shows(id),
  episode_id uuid REFERENCES episodes(id),
  title text NOT NULL,
  artist text NOT NULL,
  spotify_url text,
  apple_music_url text,
  created_at timestamptz DEFAULT now()
);

CREATE TABLE IF NOT EXISTS franchises (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  name text NOT NULL UNIQUE,
  description text,
  created_at timestamptz DEFAULT now()
);

CREATE TABLE IF NOT EXISTS show_franchises (
  show_id uuid REFERENCES shows(id),
  franchise_id uuid REFERENCES franchises(id),
  chronological_order integer,
  PRIMARY KEY (show_id, franchise_id)
);

CREATE TABLE IF NOT EXISTS comments (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id uuid REFERENCES profiles(id),
  show_id uuid REFERENCES shows(id),
  episode_id uuid REFERENCES episodes(id),
  content text NOT NULL,
  created_at timestamptz DEFAULT now(),
  updated_at timestamptz DEFAULT now()
);

CREATE TABLE IF NOT EXISTS achievements (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id uuid REFERENCES profiles(id),
  type text NOT NULL,
  title text NOT NULL,
  description text,
  awarded_at timestamptz DEFAULT now()
);

-- Enable RLS
ALTER TABLE profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE shows ENABLE ROW LEVEL SECURITY;
ALTER TABLE user_shows ENABLE ROW LEVEL SECURITY;
ALTER TABLE episodes ENABLE ROW LEVEL SECURITY;
ALTER TABLE soundtracks ENABLE ROW LEVEL SECURITY;
ALTER TABLE franchises ENABLE ROW LEVEL SECURITY;
ALTER TABLE show_franchises ENABLE ROW LEVEL SECURITY;
ALTER TABLE comments ENABLE ROW LEVEL SECURITY;
ALTER TABLE achievements ENABLE ROW LEVEL SECURITY;

-- Create policies
CREATE POLICY "Public profiles are viewable by everyone" ON profiles
  FOR SELECT USING (true);

CREATE POLICY "Users can update own profile" ON profiles
  FOR UPDATE USING (auth.uid() = id);

CREATE POLICY "Shows are viewable by everyone" ON shows
  FOR SELECT USING (true);

CREATE POLICY "User show status viewable by everyone" ON user_shows
  FOR SELECT USING (true);

CREATE POLICY "Users can manage their show status" ON user_shows
  FOR ALL USING (auth.uid() = user_id);

CREATE POLICY "Episodes are viewable by everyone" ON episodes
  FOR SELECT USING (true);

CREATE POLICY "Soundtracks are viewable by everyone" ON soundtracks
  FOR SELECT USING (true);

CREATE POLICY "Franchises are viewable by everyone" ON franchises
  FOR SELECT USING (true);

CREATE POLICY "Show franchises are viewable by everyone" ON show_franchises
  FOR SELECT USING (true);

CREATE POLICY "Comments are viewable by everyone" ON comments
  FOR SELECT USING (true);

CREATE POLICY "Users can manage their comments" ON comments
  FOR ALL USING (auth.uid() = user_id);

CREATE POLICY "Achievements are viewable by everyone" ON achievements
  FOR SELECT USING (true);