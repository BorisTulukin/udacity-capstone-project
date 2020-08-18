# Data

## please make sure you have jq installed
jq  .characters[].characterName source_data/characters.json | uniq -d
jq  .characters[].characterName source_data/characters.json | wc -l
