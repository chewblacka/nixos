# myparams.nix

{ lib, ... }:
with lib;
{
  options = {
    myParams = mkOption {
      type = types.attrs; # Should probably be submodule?
      description = "My config attrs";
    };
  };
  config = {
    myParams = {
      myusername = "user";
      myhostname = "nixos";
      mysshkey = "";
      mydesktop = "kde";
    };
  };
}
