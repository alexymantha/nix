{...}: {
  xdg.configFile."tuicr/config.toml".text = ''
    theme = "ayu-mirage"
    q_quits = true

    comment_types = [
      { id = "issue", definition = "problems to fix", color = "red" },
      { id = "suggestion", definition = "possible improvements", color = "yellow" },
      { id = "note", label = "question", definition = "ask for clarification" },
      { id = "praise", definition = "positive feedback", color = "green" },
    ]
  '';
}
