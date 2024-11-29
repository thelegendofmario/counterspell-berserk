# Find and zip the files
nix-shell -p zip --run 'find . -type f \( -name "*.lua" -o -name "*.png" -o -name "*.mp3" \) -print | zip -@ berserk.love'

bunx love.js berserk.love berserk -c

scp -r berserk/* hackclub.app:/home/kierank/berserk/

ssh nest.hackclub.app "systemctl --user restart caddy"

rm -rf berserk.love berserk