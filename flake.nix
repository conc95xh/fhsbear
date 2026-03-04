{
  description = "FHS environment for Broadcom BDK and Bear";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs-cmake.url = "github:NixOS/nixpkgs/e6f23dc08d3624daab7094b701aa3954923c6bbb";
  };

  outputs = { self, nixpkgs,nixpkgs-cmake }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs { inherit system; };
      pkgs-cmake = nixpkgs-cmake.legacyPackages.${system};
    in
    {
      devShells.${system}.default = (pkgs.buildFHSEnv {
        name = "broadcom-fhs";
        targetPkgs = pkgs: with pkgs; [
          pkgs-cmake.cmake
          gettext
          popt
          flex
          libtool
          gnutar
          libuuid.dev
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
          openssl.dev
          automake
          bison
          bear
          gnumake
          bash
          glibc
          gcc.cc.lib
          zlib.dev
          ncurses.dev
          ncurses
          util-linux
          hostname
          which
          perl
          python313
          python313Packages.packaging # Add it as a standalone package

        ];
        
        # This is the magic part:
        # It sets up the environment variables inside the FHS shell
        profile = ''
          export PYTHONPATH="${pkgs.python313Packages.packaging}/lib/python3.13/site-packages:$PYTHONPATH"
        '';

        runScript = "bash";
      }).env;
    };
}
