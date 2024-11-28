# Define the output zip file
output_zip="berserk.love"

# Find and zip the files
find . -type f \( -name "*.lua" -o -name "*.png" -o -name "*.mp3" \) -print | zip -@ "$output_zip"

bunx love.js berserk.love berserk -c

scp -r berserk hackclub.app:/home/kierank/berserk

rm -rf berserk.love berserk