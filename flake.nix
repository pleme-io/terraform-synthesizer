{
  description = "terraform-synthesizer";

  inputs.nixpkgs.url = github:NixOS/nixpkgs;
  inputs.ruby-flake-utils.url = github:t3rro/ruby-flake-utils;

  outputs = { ruby-flake-utils, nixpkgs, ... }:
    ruby-flake-utils.lib.mkGemSystems {
      inherit nixpkgs;
      name = "terraform-synthesizer";
      lockfile = ./Gemfile.lock;
      gemfile = ./Gemfile;
      gemset = ./gemset.nix;
      strategy = "lib";
      src = ./.;
    };
}
