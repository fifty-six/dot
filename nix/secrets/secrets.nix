let
  personal = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAII85IEKCkcbjGJYk2gPlagxZM5qUmd7wlds4ct+DRAlY";
  server = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICOLQM68ZSE63+lVnN7PLceKW1rx1bL4i/YU5THohKeY";
  server-interactive = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJ4E8SKPK1CPoN1eLVjexJRanbxOPF+GCsa5ZyNTYyaT";
  keys = [personal server server-interactive];
in {
  "frpc.age" = {
    publicKeys = keys;
    armor = true;
  };
}
