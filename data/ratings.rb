#!/usr//bin/ruby
require 'json'
require 'aws-sdk-dynamodb'

dynamodb = Aws::DynamoDB::Client.new

ratings_json = JSON.parse(File.read("source_data/forbes_rating.json"))
ratings = ratings_json["forbes_ratings"]

ratings.each { |c| 
    episode_id = c['episode_id']
    puts "working on = #{episode_id}"

    item = {
        'episode_id' => episode_id,
        'sk' => "meta_#{episode_id}",
        'rating' => c['rating'], 
        'rating_description' => c['rating_description']
    }        

    
    dynamodb.put_item({ table_name: 'got_episodes', item: item })
}
