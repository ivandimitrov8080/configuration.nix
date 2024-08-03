{
  services.tor = {
    enable = true;
    client.enable = true;
    relay = {
      enable = true;
      role = "relay";
      onionServices = {
        idimitrov = {
          map = [{
            port = 80;
            target = {
              addr = "127.0.0.1";
              port = 3000;
            };
          }];
        };
      };
    };
  };
}
