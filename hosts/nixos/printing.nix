{pkgs, ...}: {
  services.printing = {
    enable = true;
    drivers = [pkgs.foomatic-db-ppds];
  };

  hardware.printers = {
    ensureDefaultPrinter = "Samsung_SCX-5935FN";
    ensurePrinters = [
      {
        name = "Samsung_SCX-5935FN";
        description = "Samsung SCX-5935FN";
        deviceUri = "usb://Samsung/SCX-5835_5935%20Series?serial=Z2P3BJFF4000RRD";
        model = "foomatic-db-ppds/Samsung-SCX-5835_5935-Postscript-Samsung.ppd.gz";
      }
    ];
  };

  # The xerox_mfp backend in sane-backends supports this model over USB.
  hardware.sane.enable = true;

  users.users.amantha.extraGroups = [
    "lp"
    "scanner"
  ];

  environment.systemPackages = [pkgs.kdePackages.skanpage];
}
