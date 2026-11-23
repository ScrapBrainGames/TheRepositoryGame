components {
  id: "dynamite"
  component: "/main/dynamite.script"
}
components {
  id: "fuse"
  component: "/particles/fuse.particlefx"
  position {
    x: 7.0
    y: 8.0
  }
  rotation {
    z: -0.37460658
    w: 0.92718387
  }
}
embedded_components {
  id: "sprite"
  type: "sprite"
  data: "default_animation: \"dynamite\"\n"
  "material: \"/builtins/materials/sprite.material\"\n"
  "textures {\n"
  "  sampler: \"texture_sampler\"\n"
  "  texture: \"/assets/weapons/weapons.atlas\"\n"
  "}\n"
  ""
  position {
    x: -43.0
    y: -7.0
  }
}
embedded_components {
  id: "factory"
  type: "factory"
  data: "prototype: \"/main/explosion.go\"\n"
  ""
}
embedded_components {
  id: "collisionobject"
  type: "collisionobject"
  data: "type: COLLISION_OBJECT_TYPE_TRIGGER\n"
  "mass: 0.0\n"
  "friction: 0.0\n"
  "restitution: 0.0\n"
  "group: \"trigger\"\n"
  "mask: \"trigger\"\n"
  "embedded_collision_shape {\n"
  "  shapes {\n"
  "    shape_type: TYPE_SPHERE\n"
  "    position {\n"
  "    }\n"
  "    rotation {\n"
  "    }\n"
  "    index: 0\n"
  "    count: 1\n"
  "    id: \"ouitline\"\n"
  "  }\n"
  "  data: 10.0\n"
  "}\n"
  ""
}
