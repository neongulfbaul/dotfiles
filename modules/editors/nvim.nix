# modules/editors/nvim.nix
{ pkgs, lib, config, ... }:
let
  user = config.user.name;
  
  # Pre-compile all treesitter grammars via Nix
  treesitterGrammars = pkgs.symlinkJoin {
    name = "nvim-treesitter-grammars";
    paths = pkgs.vimPlugins.nvim-treesitter.withAllGrammars.dependencies;
  };
in {
  options.modules.editors.neovim.enable = lib.mkEnableOption "neovim";
  
  config = lib.mkIf config.modules.editors.neovim.enable {
    environment.sessionVariables = {
      EDITOR = "nvim";
      VISUAL = "nvim";
    };
    
    home-manager.users.${user} = {
      programs.neovim = {
        enable = true;
        defaultEditor = true;
        viAlias = true;
        vimAlias = true;
        
        extraPackages = with pkgs; [
          git curl
          ripgrep fd
          xclip
          
          # LSP servers
          lua-language-server
          nil
          nixd
          
          # Formatters
          black
          nixfmt-rfc-style
          nodePackages.prettier
          biome
          shfmt
          stylelint
          stylua
        ];
        
        # Add this Lua snippet to make Nix grammars available
        extraLuaConfig = ''
          -- Make Nix-compiled treesitter grammars available
          vim.opt.runtimepath:append("${pkgs.vimPlugins.nvim-treesitter}")
          vim.opt.runtimepath:append("${treesitterGrammars}")
        '';
      };
      
      xdg.configFile."nvim" = {
        source = ../../config/nvim;
        recursive = true;
      };
    };
  };
}
