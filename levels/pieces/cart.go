components {
  id: "cart"
  component: "/levels/pieces/cart.script"
}
embedded_components {
  id: "sprite"
  type: "sprite"
  data: "default_animation: \"square_sharp_32\"\n"
  "material: \"/builtins/materials/sprite.material\"\n"
  "textures {\n"
  "  sampler: \"texture_sampler\"\n"
  "  texture: \"/assets/character.atlas\"\n"
  "}\n"
  ""
  scale {
    x: 1.5
    y: 1.5
  }
}
embedded_components {
  id: "collisionobject"
  type: "collisionobject"
  data: "type: COLLISION_OBJECT_TYPE_DYNAMIC\n"
  "mass: 5.0\n"
  "friction: 0.1\n"
  "restitution: 0.0\n"
  "group: \"level\"\n"
  "mask: \"player\"\n"
  "mask: \"bullets\"\n"
  "embedded_collision_shape {\n"
  "  shapes {\n"
  "    shape_type: TYPE_BOX\n"
  "    position {\n"
  "    }\n"
  "    rotation {\n"
  "    }\n"
  "    index: 0\n"
  "    count: 3\n"
  "    id: \"outline\"\n"
  "  }\n"
  "  data: 24.0\n"
  "  data: 24.0\n"
  "  data: 10.0\n"
  "}\n"
  "linear_damping: 0.1\n"
  "locked_rotation: true\n"
  ""
}
