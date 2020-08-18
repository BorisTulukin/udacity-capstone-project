#!/usr//bin/ruby
require 'json'
require 'aws-sdk-dynamodb'
require 'time'

class Episodes
    def initialize
        @dynamodb = Aws::DynamoDB::Client.new
        characters_json = JSON.parse(File.read("source_data/characters.json"))
        @characters = characters_json["characters"]
    end

    def characterThumb(characterName)
        @characters.each{ |c| 
            return c["characterImageThumb"] if c["characterName"] == characterName
        }
        nil
    end

    def to_character_id(characterName)
        id = characterName.downcase.gsub( /\s|#|'/, '_')
    end


    def process_episodes()

        episodes_json = JSON.parse(File.read("source_data/episodes.json"))
        episodes = episodes_json["episodes"]
        
        episodes.each { |c| 
            episode_id = "S#{c['seasonNum']}E#{c['episodeNum']}"
            puts "working id = #{episode_id}"

            item = {
                'episode_id' => episode_id,
                'sk' => "meta_ "+ episode_id
            }        

            ["episodeTitle", "episodeLink", "episodeAirDate", "episodeDescription" ].each { |a|
                item[a] = c[a] if c[a]
            }

            @dynamodb.put_item({ table_name: 'got_episodes2', item: item })

            # c['scenes'].each_with_index { |s, i|

            #     duration = (Time.parse( s["sceneEnd"]) - Time.parse( s["sceneStart"])).to_int

            #     scene_characters= s["characters"]
            #     scene_characters.each { |p|
            #         thumb = characterThumb( p["name"] )
            #         if thumb
            #             p["character_id"] =  to_character_id( p["name"] )
            #             p["character_thumb"] = thumb
            #         end
            #     }

            #     scene = {
            #         'episode_id' => episode_id,
            #         'sk' => "scene_#{episode_id}_#{i}",
            #         'duration' => duration, 
            #         'characters' => scene_characters,
            #         'number_characters' => scene_characters.length
            #     } 

            #     ["sceneStart", "sceneEnd", "location", "subLocation"].each { |a|
            #         scene[a] = s[a] if s[a]
            #     }

            #     puts scene
            #     @dynamodb.put_item({ table_name: 'got_episodes2', item: scene })
            # }
        }

    end
end

es = Episodes::new
es.process_episodes()