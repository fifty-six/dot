{lib, ...}: {
  toFileTree = with builtins; v:
    lib.mkMerge (
      lib.mapAttrsToListRecursiveCond
      (path: val: isAttrs val && all isAttrs (attrValues val))
      (path: val: {${lib.concatStringsSep "/" path} = val;})
      v
    );
}
