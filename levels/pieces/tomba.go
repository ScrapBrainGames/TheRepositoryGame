components {
  id: "script"
  component: "/levels/pieces/destructible.script"
  properties {
    id: "threshold"
    value: "10.0"
    type: PROPERTY_TYPE_NUMBER
  }
}
embedded_components {
  id: "sprite"
  type: "sprite"
  data: "default_animation: \"idle\"\n"
  "material: \"/builtins/materials/sprite.material\"\n"
  "textures {\n"
  "  sampler: \"texture_sampler\"\n"
  "  texture: \"/assets/objects/tomb1.tilesource\"\n"
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
  "mask: \"player\"\n"
  "mask: \"pellets\"\n"
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
  "  data: 24.0\n"
  "}\n"
  "locked_rotation: true\n"
  ""
}
