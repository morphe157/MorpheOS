echo "## Keymaps" > ./keymaps.md
keymaps=$(nix-instantiate --strict --json --eval ../configs/neovim/keymaps.nix | jq -r '.keymaps[] | [.options.desc, .key, .mode] | @sh')

echo "\n| Description | Key | Mode |" >> ./keymaps.md
echo "| --- | --- | --- |" >> ./keymaps.md
echo $keymaps | xargs printf '| %s | %s | %s |\n' | sed "s/</\\\</g" >> ./keymaps.md
