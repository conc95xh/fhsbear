{
  description = "FHS environment for Broadcom BDK and Bear";

  inputs = {
    #nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs.url = "github:NixOS/nixpkgs/e6f23dc08d3624daab7094b701aa3954923c6bbb";
    #nixpkgs-gcc.url = "github:NixOS/nixpkgs/057f9aecfb71c4437d2b27d3323df7f93c010b7e"; # Pin a legacy branch
  };

  outputs = { self, nixpkgs}:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs { inherit system; };
      pythonEnv = pkgs.python313.withPackages (ps: with ps; [ 
        packaging 
        # add other modules here if needed
      ]);
    in
    {
      devShells.${system}.default = (pkgs.buildFHSEnv {
        name = "broadcom-fhs";
        extraOutputsToInstall = [ "dev" "static" ];
        targetPkgs = pkgs: with pkgs; [
          cmake
          gcc
          glibc
          gettext
          popt
          flex
          libtool
          gnutar
          libuuid
          lzo
          pkg-config
          autoconf
          automake
          xxd
          gnused
          gawk
          coreutils
          m4
          tmux
          lzop
          re2c
          unzip
          bzip2
          rsync
          git
          openssl
          automake
          bison
          bear
          gnumake
          bash
          zlib
          file
          libxcrypt
          ncurses
          util-linux
          hostname
          which
          perl
	  pythonEnv
          binutils
          git
          # --- Modern System Utilities ---
          bat       # modern 'cat'
          eza       # modern 'ls'
          fd        # modern 'find'
          ripgrep   # modern 'grep'
          zoxide    # modern 'cd'
          btop      # system monitor
          dust   # disk usage (dust)
          jq        # JSON processor
            
          # --- Connectivity & Editing ---
          curl
          wget
        ];
        
        # This is the magic part:
        # It sets up the environment variables inside the FHS shell
        #profile = ''
        #  export PYTHONPATH="${pkgs.python313Packages.packaging}/lib/python3.13/site-packages:$PYTHONPATH"
        #'';
        profile = ''
          export PKG_CONFIG_PATH="/usr/lib/pkgconfig:/usr/share/pkgconfig:$PKG_CONFIG_PATH"
        '';

        runScript = "bash";
      }).env;
    };
}
