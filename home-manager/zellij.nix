{
  pkgs,
  ...
}: {
  programs.zellij = {
    enable = true;
    enableZshIntegration = true;
  };

  home.file.".config/zellij/config.kdl" = {
    text = ''
ui {
  pane_frames {
    hide_session_name true
  }
}

theme "catppuccin-macchiato"
default_mode "locked"

keybinds clear-defaults=true {
    locked {
        bind "Ctrl g" { SwitchToMode "normal"; }
    }
    pane {
        bind "left" { MoveFocus "left"; }
        bind "down" { MoveFocus "down"; }
        bind "up" { MoveFocus "up"; }
        bind "right" { MoveFocus "right"; }
        bind "c" { SwitchToMode "renamepane"; PaneNameInput 0; }
        bind "d" { NewPane "down"; SwitchToMode "locked"; }
        bind "e" { TogglePaneEmbedOrFloating; SwitchToMode "locked"; }
        bind "f" { ToggleFocusFullscreen; SwitchToMode "locked"; }
        bind "h" { MoveFocus "left"; }
        bind "j" { MoveFocus "down"; }
        bind "k" { MoveFocus "up"; }
        bind "l" { MoveFocus "right"; }
        bind "n" { NewPane; SwitchToMode "locked"; }
        bind "p" { SwitchToMode "normal"; }
        bind "r" { NewPane "right"; SwitchToMode "locked"; }
        bind "w" { ToggleFloatingPanes; SwitchToMode "locked"; }
        bind "x" { CloseFocus; SwitchToMode "locked"; }
        bind "z" { TogglePaneFrames; SwitchToMode "locked"; }
        bind "tab" { SwitchFocus; }
    }
    tab {
        bind "left" { GoToPreviousTab; }
        bind "down" { GoToNextTab; }
        bind "up" { GoToPreviousTab; }
        bind "right" { GoToNextTab; }
        bind "1" { GoToTab 1; SwitchToMode "locked"; }
        bind "2" { GoToTab 2; SwitchToMode "locked"; }
        bind "3" { GoToTab 3; SwitchToMode "locked"; }
        bind "4" { GoToTab 4; SwitchToMode "locked"; }
        bind "5" { GoToTab 5; SwitchToMode "locked"; }
        bind "6" { GoToTab 6; SwitchToMode "locked"; }
        bind "7" { GoToTab 7; SwitchToMode "locked"; }
        bind "8" { GoToTab 8; SwitchToMode "locked"; }
        bind "9" { GoToTab 9; SwitchToMode "locked"; }
        bind "[" { BreakPaneLeft; SwitchToMode "locked"; }
        bind "]" { BreakPaneRight; SwitchToMode "locked"; }
        bind "b" { BreakPane; SwitchToMode "locked"; }
        bind "h" { GoToPreviousTab; }
        bind "j" { GoToNextTab; }
        bind "k" { GoToPreviousTab; }
        bind "l" { GoToNextTab; }
        bind "n" { NewTab; SwitchToMode "locked"; }
        bind "r" { SwitchToMode "renametab"; TabNameInput 0; }
        bind "s" { ToggleActiveSyncTab; SwitchToMode "locked"; }
        bind "t" { SwitchToMode "normal"; }
        bind "x" { CloseTab; SwitchToMode "locked"; }
        bind "tab" { ToggleTab; }
    }
    resize {
        bind "left" { Resize "Increase left"; }
        bind "down" { Resize "Increase down"; }
        bind "up" { Resize "Increase up"; }
        bind "right" { Resize "Increase right"; }
        bind "+" { Resize "Increase"; }
        bind "-" { Resize "Decrease"; }
        bind "=" { Resize "Increase"; }
        bind "H" { Resize "Decrease left"; }
        bind "J" { Resize "Decrease down"; }
        bind "K" { Resize "Decrease up"; }
        bind "L" { Resize "Decrease right"; }
        bind "h" { Resize "Increase left"; }
        bind "j" { Resize "Increase down"; }
        bind "k" { Resize "Increase up"; }
        bind "l" { Resize "Increase right"; }
        bind "r" { SwitchToMode "normal"; }
    }
    move {
        bind "left" { MovePane "left"; }
        bind "down" { MovePane "down"; }
        bind "up" { MovePane "up"; }
        bind "right" { MovePane "right"; }
        bind "h" { MovePane "left"; }
        bind "j" { MovePane "down"; }
        bind "k" { MovePane "up"; }
        bind "l" { MovePane "right"; }
        bind "m" { SwitchToMode "normal"; }
        bind "n" { MovePane; }
        bind "p" { MovePaneBackwards; }
        bind "tab" { MovePane; }
    }
    scroll {
        bind "Alt left" { MoveFocusOrTab "left"; SwitchToMode "locked"; }
        bind "Alt down" { MoveFocus "down"; SwitchToMode "locked"; }
        bind "Alt up" { MoveFocus "up"; SwitchToMode "locked"; }
        bind "Alt right" { MoveFocusOrTab "right"; SwitchToMode "locked"; }
        bind "e" { EditScrollback; SwitchToMode "locked"; }
        bind "f" { SwitchToMode "entersearch"; SearchInput 0; }
        bind "Alt h" { MoveFocusOrTab "left"; SwitchToMode "locked"; }
        bind "Alt j" { MoveFocus "down"; SwitchToMode "locked"; }
        bind "Alt k" { MoveFocus "up"; SwitchToMode "locked"; }
        bind "Alt l" { MoveFocusOrTab "right"; SwitchToMode "locked"; }
        bind "s" { SwitchToMode "normal"; }
    }
    search {
        bind "c" { SearchToggleOption "CaseSensitivity"; }
        bind "n" { Search "down"; }
        bind "o" { SearchToggleOption "WholeWord"; }
        bind "p" { Search "up"; }
        bind "w" { SearchToggleOption "Wrap"; }
    }
    session {
        bind "c" {
            LaunchOrFocusPlugin "configuration" {
                floating true
                move_to_focused_tab true
            }
            SwitchToMode "locked"
        }
        bind "d" { Detach; }
        bind "o" { SwitchToMode "normal"; }
        bind "p" {
            LaunchOrFocusPlugin "plugin-manager" {
                floating true
                move_to_focused_tab true
            }
            SwitchToMode "locked"
        }
        bind "w" {
            LaunchOrFocusPlugin "session-manager" {
                floating true
                move_to_focused_tab true
            }
            SwitchToMode "locked"
        }
    }
    shared_among "normal" "locked" {
        bind "Alt left" { MoveFocusOrTab "left"; }
        bind "Alt down" { MoveFocus "down"; }
        bind "Alt up" { MoveFocus "up"; }
        bind "Alt right" { MoveFocusOrTab "right"; }
        bind "Alt +" { Resize "Increase"; }
        bind "Alt -" { Resize "Decrease"; }
        bind "Alt =" { Resize "Increase"; }
        bind "Alt [" { PreviousSwapLayout; }
        bind "Alt ]" { NextSwapLayout; }
        bind "Alt f" { ToggleFloatingPanes; }
        bind "Alt h" { MoveFocusOrTab "left"; }
        bind "Alt i" { MoveTab "left"; }
        bind "Alt j" { MoveFocus "down"; }
        bind "Alt k" { MoveFocus "up"; }
        bind "Alt l" { MoveFocusOrTab "right"; }
        bind "Alt n" { NewPane; }
        bind "Alt o" { MoveTab "right"; }
    }
    shared_except "locked" "renametab" "renamepane" {
        bind "Ctrl g" { SwitchToMode "locked"; }
        bind "Ctrl q" { Quit; }
    }
    shared_except "locked" "entersearch" {
        bind "enter" { SwitchToMode "locked"; }
    }
    shared_except "locked" "entersearch" "renametab" "renamepane" {
        bind "esc" { SwitchToMode "locked"; }
    }
    shared_except "locked" "entersearch" "renametab" "renamepane" "move" {
        bind "m" { SwitchToMode "move"; }
    }
    shared_except "locked" "entersearch" "search" "renametab" "renamepane" "session" {
        bind "o" { SwitchToMode "session"; }
    }
    shared_except "locked" "tab" "entersearch" "renametab" "renamepane" {
        bind "t" { SwitchToMode "tab"; }
    }
    shared_except "locked" "tab" "scroll" "entersearch" "renametab" "renamepane" {
        bind "s" { SwitchToMode "scroll"; }
    }
    shared_among "normal" "resize" "tab" "scroll" "prompt" "tmux" {
        bind "p" { SwitchToMode "pane"; }
    }
    shared_except "locked" "resize" "pane" "tab" "entersearch" "renametab" "renamepane" {
        bind "r" { SwitchToMode "resize"; }
    }
    shared_among "scroll" "search" {
        bind "PageDown" { PageScrollDown; }
        bind "PageUp" { PageScrollUp; }
        bind "left" { PageScrollUp; }
        bind "down" { ScrollDown; }
        bind "up" { ScrollUp; }
        bind "right" { PageScrollDown; }
        bind "Ctrl b" { PageScrollUp; }
        bind "Ctrl c" { ScrollToBottom; SwitchToMode "locked"; }
        bind "d" { HalfPageScrollDown; }
        bind "Ctrl f" { PageScrollDown; }
        bind "h" { PageScrollUp; }
        bind "j" { ScrollDown; }
        bind "k" { ScrollUp; }
        bind "l" { PageScrollDown; }
        bind "u" { HalfPageScrollUp; }
    }
    entersearch {
        bind "Ctrl c" { SwitchToMode "scroll"; }
        bind "esc" { SwitchToMode "scroll"; }
        bind "enter" { SwitchToMode "search"; }
    }
    renametab {
        bind "esc" { UndoRenameTab; SwitchToMode "tab"; }
    }
    shared_among "renametab" "renamepane" {
        bind "Ctrl c" { SwitchToMode "locked"; }
    }
    renamepane {
        bind "esc" { UndoRenamePane; SwitchToMode "pane"; }
    }
}
    '';
  };

  home.file.".config/zellij/layouts/default.kdl" = {
    text = ''
layout {
    pane size=1 borderless=true {
        plugin location="file:/nix/store/0fh1fn1n05388zxl30h6afwlnhx3ls52-zjstatus-0.19.1/bin/zjstatus.wasm" {
          hide_frame_for_single_pane "false"

          format_left  "#[bg=$black]{tabs}"
          format_right "{command_kubectx}::{command_kubens}"
          format_space "#[bg=$black]"

          tab_normal               "#[fg=$black,bg=$cyan] #[fg=$black,bg=$cyan,bold]{name} {fullscreen_indicator}{sync_indicator}{floating_indicator}#[fg=$cyan,bg=$black]"
          tab_active               "#[fg=$black,bg=$green] #[fg=$black,bg=$green,bold]{name} {fullscreen_indicator}{sync_indicator}{floating_indicator}#[fg=$green,bg=$black]"
          tab_fullscreen_indicator "□ "
          tab_sync_indicator       "  "
          tab_floating_indicator   "󰉈 "

          command_kubectx_command  "kubectx -c"
          command_kubectx_format   "#[fg=$fg,bg=$black] {stdout}"
          command_kubectx_interval "30"

          command_kubens_command  "kubens -c"
          command_kubens_format   "#[fg=$fg,bg=$black]{stdout} "
          command_kubens_interval "30"

          color_bg "#5b6078" // Surface2
          color_fg "#cad3f5" // Text
          color_red "#ed8796"
          color_green "#a6da95"
          color_blue "#8aadf4"
          color_yellow "#eed49f"
          color_magenta "#f5bde6" // Pink
          color_orange "#f5a97f" // Peach
          color_cyan "#91d7e3" // Sky
          color_black "#1e2030" // Mantle
          color_white "#cad3f5" // Text
        }
    }
    pane
    pane size=1 borderless=true {
        plugin location="status-bar"
    }
}
'';
  };
}
