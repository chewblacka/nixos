# btrfs/disko-config.nix

{ disks ? [ "/dev/vda" ], ... }: 
let 
  number_of_disks = if (builtins.length disks < 3) 
                    then builtins.length disks 
                    else throw "Error. Too many disks passed to disko.";
in
{
  disko.devices = {
    disk = {
      vda = {
        type = "disk";
        device = builtins.elemAt disks 0;
        content = {
          type = "gpt";
          partitions = {
            ESP = {
              # name = "ESP";
              start = "1MiB";
              end = "1G";
              type = "EF00";
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
              };
            };
            swap = {
              # name = "swap";
              start = "1G";
              end = "9G";
              content = {
                type = "swap";
                randomEncryption = true;
              };
            };
            root = {
              # name = "root";
              start = "9G";
              end = "100%";
              content = {
                type = "btrfs";
                extraArgs = [ "-f" ]; # Override existing partition
                subvolumes = 
                  if (number_of_disks == 1) then 
                    { 
                      "@" = { };
                      "@/root" = {
                        mountpoint = "/";
                        mountOptions = [ "compress=zstd" "noatime" ];
                      };
                      "@/home" = {
                        mountpoint = "/home";
                        mountOptions = [ "compress=zstd" ];
                      };
                      "@/nix" = {
                        mountpoint = "/nix";
                        mountOptions = [ "compress=zstd" "noatime" ];
                      };
                      "@/persist" = {
                        mountpoint = "/persist";
                        mountOptions = [ "compress=zstd" "noatime" ];
                      };
                      "@/log" = {
                        mountpoint = "/var/log";
                        mountOptions = [ "compress=zstd" "noatime" ];
                      };
                      "@/machines" = {
                        mountpoint = "/var/lib/machines";
                        mountOptions = [ "compress=zstd" "noatime" ];
                      };
                      "@/portables" = {
                        mountpoint = "/var/lib/portables";
                        mountOptions = [ "compress=zstd" "noatime" ];
                      };
                    }
                  else
                    {
                      "@" = { };
                      "@/root" = {
                        mountpoint = "/";
                        mountOptions = [ "compress=zstd" "noatime" ];
                      };
                      "@/nix" = {
                        mountpoint = "/nix";
                        mountOptions = [ "compress=zstd" "noatime" ];
                      };
                      "@/persist" = {
                        mountpoint = "/persist";
                        mountOptions = [ "compress=zstd" "noatime" ];
                      };
                      "@/log" = {
                        mountpoint = "/var/log";
                        mountOptions = [ "compress=zstd" "noatime" ];
                      };
                      "@/machines" = {
                        mountpoint = "/var/lib/machines";
                        mountOptions = [ "compress=zstd" "noatime" ];
                      };
                      "@/portables" = {
                        mountpoint = "/var/lib/portables";
                        mountOptions = [ "compress=zstd" "noatime" ];
                      };
                    };
              };
            };
          };
        };
      };

      vdb = if (number_of_disks == 1) then {}
      else
      {
        type = "disk";
        device = builtins.elemAt disks 1;
        content = {
          type = "gpt";
          partitions = {
            DATA = {
              # name = "DATA";
              start = "1MiB";
              end = "100%";
              content = {
                type = "btrfs";
                extraArgs = [ "-f" ]; # Override existing partition
                subvolumes = {
                  "@" = { 
                    mountpoint = "/DATA";
                    mountOptions = [ "compress=zstd" "noatime" ];
                  };
                  "@/home" = {
                    mountpoint = "/home";
                    mountOptions = [ "compress=zstd" ];
                  };
                  "@/persist" = {
                    # mountpoint = "/mnt/persist";
                    mountOptions = [ "compress=zstd" "noatime" ];
                  };
                };
              };
            };
          };
        };
      };
    };
  };
}

