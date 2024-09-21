{ inputs, outputs, ... }: {
    security.pki.certificateFiles = [ "/etc/ssl/certs/all_trusted_certs.pem" ];
}
