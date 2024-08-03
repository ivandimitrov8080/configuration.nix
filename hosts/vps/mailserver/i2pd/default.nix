{
  services.i2pd = {
    enable = true;
    inTunnels = {
      idimitrov = {
        enable = true;
        keys = "idimitrov-keys.dat";
        inPort = 80;
        destination = "127.0.0.1";
        port = 3000;
      };
    };
  };
}
