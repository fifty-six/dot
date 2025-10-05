{ pkgs, ... }:
with builtins;
let
  isDerivation = v: hasAttr "type" v && v.type == "derivation";
  lib = pkgs.lib;
in
{
  inherit isDerivation;

  toJSON = attrs: (pkgs.formats.json { }).generate "derivation.json" attrs;

  toFileTree =
    attrs:
    lib.mkMerge (
      lib.mapAttrsToListRecursiveCond (
        path: val:
        let
          vals = attrValues val;
        in
        # Be an attribute set, have all _children_ be attribute sets
        # and finally don't have an attribute be a derivation,
        # as we don't want x.source = drv; to be eaten
        isAttrs val && all isAttrs vals && !any isDerivation vals
      ) (path: val: { ${lib.concatStringsSep "/" path} = val; }) attrs
    );
}
