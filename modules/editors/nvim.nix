# modules/editors/nvim.nix
{ pkgs, lib, config, ... }:
let
  user = config.user.name;
  cfg = config.modules.editors.neovim;
in {
  # 1. RESTORE THE OPTION DEFINITION
  options.modules.editors.neovim = {
    enable = lib.mkEnableOption "neovim";
  };

  config = lib.mkIf cfg.enable {
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

        # Let Nix manage the heavy-lifting plugins
        plugins = with pkgs.vimPlugins; [
          nvim-treesitter.withAllGrammars
        ];

        extraPackages = with pkgs; [
          # Binaries for LSPs and Tools
          lua-language-server
          #nil
          nixd
          zls # Added back for your Zig config
          
          # Tools
          git curl ripgrep fd xclip
          
          # Formatters
          black
          nixfmt
          nodePackages.prettier
          biome
          shfmt
          stylelint
          stylua
        ];

      # modules/editors/nvim.nix inside programs.neovim
#        initLua = ''
#          -- Force Neovim to prioritize Nix-managed grammars
#          vim.opt.runtimepath:prepend("${pkgs.vimPlugins.nvim-treesitter.withAllGrammars}")
#          
#          -- Optional: Explicitly point to the parser directory for plugins that check it
#          vim.opt.runtimepath:append("${pkgs.vimPlugins.nvim-treesitter.withAllGrammars}/parser")
#        '';
        # Tell Neovim where the Nix-managed grammars are
        # This replaces the old 'symlinkJoin' logic with the modern direct path
      };

      # Keep your existing Lua config folder linked
      xdg.configFile."nvim" = {
        source = ../../config/nvim;
        recursive = true;
      };
    };
  };
}
