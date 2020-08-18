#!/usr//bin/ruby
require 'json'
require 'aws-sdk-dynamodb'

dynamodb = Aws::DynamoDB::Client.new

def to_character_id(characterName)
    id = characterName.downcase.gsub( /\s|#|'/, '_')
end

characters_json = JSON.parse(File.read("source_data/characters.json"))
characters = characters_json["characters"]

characters.each { |c| 
    character_id = to_character_id(c['characterName'])
    puts "working on #{c['characterName']}, id = #{character_id}"

    item = {
        'character_id' => character_id,
        'characterName' => c['characterName']
    }        

    ["characterImageThumb", "characterImageFull", "characterLink", "actorName", "actorLink", "houseName", "killed" ].each { |a|
        item[a] = c[a] if c[a]
    }

    dynamodb.put_item({ table_name: 'got_characters2', item: item })
}
