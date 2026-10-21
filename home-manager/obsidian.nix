{pkgs, ...}: let
  livesync = let
    version = "1.0.35";
    fetchAsset = name: hash:
      pkgs.fetchurl {
        url = "https://github.com/vrtmrz/obsidian-livesync/releases/download/${version}/${name}";
        inherit hash;
      };
  in
    # manifestId saves the obsidian module from reading manifest.json at eval time.
    pkgs.runCommand "obsidian-livesync-${version}" {passthru.manifestId = "obsidian-livesync";} ''
      mkdir $out
      cp ${fetchAsset "main.js" "sha256-dDiz8Yp+8hyTw6/8nqvSnbSyPAbMhhnXQCLcYHGTVLU="} $out/main.js
      cp ${fetchAsset "manifest.json" "sha256-wEJctd3AFVcpwKIHrYtOOQjz5aTNRDpIp59iIrF6r54="} $out/manifest.json
      cp ${fetchAsset "styles.css" "sha256-S6AL70F+6Y2aYt2f67eS3GVVlJz8no4GlFCtaZqyufA="} $out/styles.css
    '';
in {
  programs.obsidian = {
    enable = true;
    vaults.notes = {
      target = "notes";
      settings = {
        app = {
          vimMode = true;
          showLineNumber = true;
          alwaysUpdateLinks = true;
          newFileLocation = "folder";
          newFileFolderPath = "inbox";
          attachmentFolderPath = "attachments";
        };
        appearance = {
          theme = "obsidian";
        };
        corePlugins = [
          "backlink"
          "bookmarks"
          "canvas"
          "command-palette"
          "editor-status"
          "file-explorer"
          "file-recovery"
          "global-search"
          "graph"
          "outgoing-link"
          "outline"
          "page-preview"
          "properties"
          "switcher"
          "tag-pane"
          "word-count"
          {
            name = "daily-notes";
            settings = {
              folder = "daily";
              format = "YYYY-MM-DD";
            };
          }
          {
            name = "templates";
            settings.folder = "templates";
          }
        ];
        # Syncs to CouchDB in the homelab cluster (couchdb.home.mantha.org).
        # No settings here: the plugin keeps its server credentials in its
        # own data.json, which must stay writable and out of the Nix store.
        # Leave its Hidden File Sync and Customisation Sync off, since Nix
        # manages .obsidian.
        communityPlugins = [
          {pkg = livesync;}
        ];
      };
    };
  };
}
