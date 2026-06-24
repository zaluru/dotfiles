{
  pkgs,
  lib,
  config,
  inputs,
  ...
}:
let

  inherit (lib)
    mkEnableOption
    mkIf
    mkOption
    types
    ;
  inherit (lib.zaluru) mkOpt mkOpt_;
  cfg = config.mine.cli-tools.sops-nix;

  ssm_systemd_config = mkIf cfg.ageKeyFile.ageKeyInSSM.enable {
    Environment = "SOPS_AGE_KEY_FILE=${cfg.ageKeyFile.path}";
    ExecStartPre = ssm_systemd_script + "/bin/get-age-key-from-ssm";
  };
  ssm_systemd_script = pkgs.writeShellApplication {
    name = "get-age-key-from-ssm";
    runtimeInputs = with pkgs; [
      awscli2
      coreutils
      gnused
    ];
    text = ''
      AGE_KEY=$(aws ssm get-parameter --region ${cfg.ageKeyFile.ageKeyInSSM.region} --no-cli-pager --name ${cfg.ageKeyFile.ageKeyInSSM.paramName} --with-decryption --query "Parameter.Value" | sed 's/\"//g')
      echo "$AGE_KEY" > ${cfg.ageKeyFile.path}
    '';
  };

in
{
  options.mine.cli-tools.sops-nix = {
    enable = mkEnableOption "Enable sops";
    defaultSopsFile = lib.mkOption {
      description = "Default sops file used for all secrets.";
      type = lib.types.path;
      default =
        inputs.nixos-thurs.packages.${pkgs.stdenv.hostPlatform.system}.mySecrets
        + "/encrypted/secrets.yaml";
    };
    requires = lib.mkOption {
      default = { };
      description = "Things that are needed for SOPS";
      type = lib.types.submodule {
        options = {
          network = lib.mkEnableOption "Decrypt after network is started, for network required keys like KMS.";
          unlock = lib.mkEnableOption "Decrypt after logging, or ZFS volumes have been decrypted";
        };
      };
    };
    ageKeyFile = lib.mkOption {
      default = { };
      description = "ageKeyFile config";
      type = lib.types.submodule {
        options = {
          path = lib.mkOption {
            description = "Path to age key file used for sops decryption.";
            type = (lib.types.nullOr lib.types.path);
            default = null;
          };
          ageKeyInSSM = lib.mkOption {
            description = "If age.key is in SSM";
            default = { };
            type = lib.types.submodule {
              options = {
                enable = lib.mkEnableOption "Runs systemd service to pull key from SSM Parameter store";
                paramName = lib.mkOption {
                  description = "SSM Parameter name containing age key";
                  type = (lib.types.nullOr lib.types.path);
                  default = null;
                };
                region = lib.mkOption {
                  type = (
                    lib.types.enum [
                      "us-west-2"
                      "us-east-1"
                    ]
                  );
                  default = "us-east-1";
                  description = "AWS region for SSM parameter";
                };
              };
            };
          };
        };
      };
    };
  };

  imports = [
    inputs.sops-nix.nixosModules.sops
  ];

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      sops
    ];

    sops = {
      inherit (config.mine.cli-tools.sops-nix) defaultSopsFile;
      age.keyFile = config.mine.cli-tools.sops-nix.ageKeyFile.path;
      # TODO make this an option
      age.sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];
      age.generateKey = true;
    };

    systemd.services.decrypt-sops-after-network =
      mkIf (cfg.requires.network || cfg.ageKeyFile.ageKeyInSSM.enable)
        {
          description = "Decrypt SOPS secrets after network is established";
          wantedBy = [ "multi-user.target" ];
          after = [ "network-online.target" ];
          requires = [ "network-online.target" ];
          serviceConfig = ssm_systemd_config // {
            Type = "oneshot";
            RemainAfterExit = true;
            Restart = "on-failure";
            RestartSec = "3s";
          };
          script = config.system.activationScripts.setupSecrets.text;
        };

    systemd.services.decrypt-sops-after-login = mkIf cfg.requires.unlock {
      description = "Decrypt SOPS secrets after disk has been unlocked";
      wantedBy = [ "multi-user.target" ];
      after = [ "network-online.target" ];
      requires = [ "network-online.target" ];
      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = true;
        Restart = "on-failure";
        RestartSec = "3s";
      };
      script = config.system.activationScripts.setupSecrets.text;
    };
  };
}
