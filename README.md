very much wip

# TODO
1. set up tmux.nix
2. confirm cuda support from desktop for ollama. 
3. set up wake on lan or similar for atlas.
4. merge common configurations to /hosts/home.nix and /hosts/default.nix and just have the differences / device speciifcs in hosts/hostname/default.nix hosts/hostname/home.nix
6. set up codellama for neovim plugin
7. set up impermenance

5. set up nixos kubernetes cluster on proxmox to host the following:
pihole # dns and dhcp
wireguard # vpn
nginx # proxy
openweb-ui # local ai interface
