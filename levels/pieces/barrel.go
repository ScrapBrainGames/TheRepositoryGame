components {
  id: "script"
  component: "/levels/pieces/explosive.script"
}
embedded_components {
  id: "sprite"
  type: "sprite"
  data: "default_animation: \"idle\"\n"
  "material: \"/builtins/materials/sprite.material\"\n"
  "textures {\n"
  "  sampler: \"texture_sampler\"\n"
  "  texture: \"/assets/objects/barrel.tilesource\"\n"
  "}\n"
  ""
  position {
    x: 6.0
    y: 31.0
  }
}
embedded_components {
  id: "collisionobject"
  type: "collisionobject"
  data: "type: COLLISION_OBJECT_TYPE_STATIC\n"
  "mass: 0.0\n"
  "friction: 0.0\n"
  "restitution: 0.0\n"
  "group: \"level\"\n"
  "mask: \"bullets\"\n"
  "mask: \"pellets\"\n"
  "mask: \"player\"\n"
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
  "    id: \"outline\"\n"
  "  }\n"
  "  data: 26.0\n"
  "}\n"
  "locked_rotation: true\n"
  ""
}
embedded_components {
  id: "popper"
  type: "factory"
  data: "prototype: \"/main/pop.go\"\n"
  ""
}
embedded_components {
  id: "explosion"
  type: "factory"
  data: "prototype: \"/main/explosion.go\"\n"
  ""
}
