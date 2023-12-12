flake: { config, lib, pkgs, ... }:

let
  cfg = config.services.groundseg;
  inherit (flake.packages.${pkgs.stdenv.hostPlatform.system}) groundseg;
  inherit (lib) mkOption mkEnableOption types;
in
{
  options = {
    services.groundseg = {
      enable = mkEnableOption ''
        GroundSeg: The best way to run an Urbit ship
      '';

      package = mkOption {
        type = types.package;
        default = groundseg;
        description = ''
          The GroundSeg package to use with the service.
        '';
      };
    };
  };

  config = lib.mkIf cfg.enable {
    users.users.groundseg = {
      description = "GroundSeg daemon user";
      isSystemUser = true;
      group = "groundseg";
      extraGroups = [ "docker" ];
    };

    users.groups.groundseg = { };

    # TODO reduce this to just opening the necessary ports
    networking.firewall.enable = false;

    # Experiment: remove networkmanager to see how much it affects closure size
    # results, closure was 800mb smaller, probably due to excluding gtk4
    networking.networkmanager.enable = true;

    virtualisation.docker.enable = true;
    virtualisation.docker.package = pkgs.docker_24;

    systemd.services.groundseg = {
      description = "NativePlanet GroundSeg Controller";

      # Copied from nix-foundryvtt, consider changing
      after = [ "network-online.target" ];
      wantedBy = [ "multi-user.target" ];

      serviceConfig = {
        ## Service will run as root until bugs are fixed upstream
        #User = "groundseg";
        #Group = "groundseg";
        User = "root";
        Group = "root";
        Restart = "always";
        ExecStart = "${lib.getBin cfg.package}/bin/groundseg";
        StateDirectory = "groundseg";
        StateDirectoryMode = "0750";
        Type = "simple";
      };
    };
  };
}

# TODO get podman working
#virtualisation.podman = {
#  enable = true;
#  dockerCompat = true;
#  defaultNetwork.settings.dns_enabled = true;
#};
# Allow podman to listen on port 80.
#boot.kernel.sysctl."net.ipv4.ip_unprivileged_port_start" = 80;

