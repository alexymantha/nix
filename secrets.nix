let
  amantha = "age1eg3lc0wd9cfnyduaq92wc8jp6d4f3gc7q0snlvj68x5vlpyteu3spckulw";
in {
  "secrets/kubeconfig.age".publicKeys = [ amantha ];
}
