let
  personal = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAII85IEKCkcbjGJYk2gPlagxZM5qUmd7wlds4ct+DRAlY";
  server = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINrxYtv4LWDKn0zDz+vFRH/I/k51tPvZpNKbMBAJscWv";
  server-interactive = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJ4E8SKPK1CPoN1eLVjexJRanbxOPF+GCsa5ZyNTYyaT";
  keys = [
    personal
    server
    server-interactive
  ];
in
{
  "frpc.age" = {
    publicKeys = keys;
    armor = true;
  };

  "restic.age" = {
    publicKeys = keys;
    armor = true;
  };

  "restic_remote.age" = {
    publicKeys = keys;
    armor = true;
  };

  "restic_remote_auth.age" = {
    publicKeys = keys;
    armor = true;
  };
}
