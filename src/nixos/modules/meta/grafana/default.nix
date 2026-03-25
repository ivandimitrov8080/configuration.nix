{
  lib,
  config,
  ...
}:
let
  inherit (lib)
    mkIf
    mkOption
    mkEnableOption
    types
    ;
  cfg = config.meta.grafana;
in
{
  options.meta.grafana = {
    enable = mkEnableOption "enable grafana config";
    domain = mkOption {
      type = types.str;
      default = "example.com";
    };
    secretKey = mkOption {
      type = types.str;
      default = "SW2YcwTIb9zpOOhoPsMm";
    };
  };
  config = mkIf cfg.enable {
    services = {
      loki = {
        enable = true;
        configuration = {
          auth_enabled = false;
          server = {
            http_listen_address = "127.0.0.1";
            http_listen_port = 3100;
          };
          common = {
            path_prefix = "/var/lib/loki";
            storage = {
              filesystem = {
                chunks_directory = "/var/lib/loki/chunks";
                rules_directory = "/var/lib/loki/rules";
              };
            };
            replication_factor = 1;
            ring = {
              kvstore = {
                store = "inmemory";
              };
            };
          };
          schema_config = {
            configs = [
              {
                from = "2024-01-01";
                store = "tsdb";
                object_store = "filesystem";
                schema = "v13";
                index = {
                  prefix = "index_";
                  period = "24h";
                };
              }
            ];
          };
        };
      };
      grafana = {
        enable = true;
        settings = {
          server = {
            http_addr = "127.0.0.1";
            http_port = 34321;
            domain = cfg.domain;
            root_url = "https://${cfg.domain}/";
            serve_from_sub_path = false;
          };
          security.secret_key = cfg.secretKey;
        };
      };
      alloy.enable = true;
    };
    environment.etc."alloy/config.alloy".text = ''
      loki.write "local" {
        endpoint { url = "http://127.0.0.1:3100/loki/api/v1/push" }
      }

      loki.relabel "journal_labels" {
        forward_to = []

        rule {
          source_labels = ["__journal__systemd_unit"]
          target_label  = "unit"
        }

        rule {
          source_labels = ["__journal__systemd_unit"]
          regex         = "nginx\\.service"
          target_label  = "job"
          replacement   = "nginx-journal"
        }
      }

      loki.source.journal "journald_all" {
        forward_to    = [loki.write.local.receiver]
        relabel_rules = loki.relabel.journal_labels.rules

        labels = {
          job = "journald",
        }
      }
      loki.source.file "nginx_access" {
        targets = [
          {
            __path__   = "/var/log/nginx/access.json.log",
            job        = "nginx",
            log_source = "file",
            log_type   = "access",
          },
        ]

        forward_to = [loki.write.local.receiver]
      }
    '';
    systemd.services.alloy.serviceConfig.SupplementaryGroups = [ "nginx" ];
    users.users.loki.extraGroups = [ "systemd-journal" ];
  };
}
