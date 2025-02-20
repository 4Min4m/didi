import React from 'react';
import { TrendingUp, Star, Clock } from 'lucide-react';

const Home = () => {
  return (
    <div className="space-y-8">
      <section className="text-center py-12 bg-gradient-to-r from-indigo-600 to-purple-600 rounded-xl text-white">
        <h1 className="text-4xl font-bold mb-4">Track Your Favorite Shows</h1>
        <p className="text-xl mb-8">Keep up with TV shows, movies, and discover new content</p>
      </section>

      <section className="grid md:grid-cols-3 gap-8">
        <div className="bg-white p-6 rounded-xl shadow-md">
          <TrendingUp className="h-12 w-12 text-indigo-600 mb-4" />
          <h2 className="text-xl font-bold mb-2">Trending Now</h2>
          <p className="text-gray-600">Discover what's popular in the community</p>
        </div>

        <div className="bg-white p-6 rounded-xl shadow-md">
          <Star className="h-12 w-12 text-indigo-600 mb-4" />
          <h2 className="text-xl font-bold mb-2">Top Rated</h2>
          <p className="text-gray-600">See the highest rated shows and movies</p>
        </div>

        <div className="bg-white p-6 rounded-xl shadow-md">
          <Clock className="h-12 w-12 text-indigo-600 mb-4" />
          <h2 className="text-xl font-bold mb-2">Coming Soon</h2>
          <p className="text-gray-600">Stay updated with upcoming releases</p>
        </div>
      </section>

      <section className="bg-white rounded-xl shadow-md p-6">
        <h2 className="text-2xl font-bold mb-4">Featured Shows</h2>
        <div className="grid md:grid-cols-4 gap-4">
          {/* Placeholder for featured shows */}
          {[1, 2, 3, 4].map((i) => (
            <div key={i} className="aspect-[2/3] bg-gray-200 rounded-lg animate-pulse" />
          ))}
        </div>
      </section>
    </div>
  );
};

export default Home;