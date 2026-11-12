components {
  id: "character"
  component: "/main/character.script"
}
embedded_components {
  id: "body"
  type: "sprite"
  data: "default_animation: \"body\"\n"
  "material: \"/builtins/materials/sprite.material\"\n"
  "textures {\n"
  "  sampler: \"texture_sampler\"\n"
  "  texture: \"/assets/characters/clint/clint_walk.tilesource\"\n"
  "}\n"
  ""
  position {
    y: 12.0
  }
}
embedded_components {
  id: "factory"
  type: "factory"
  data: "prototype: \"/main/bullet.go\"\n"
  ""
}
embedded_components {
  id: "collisionobject"
  type: "collisionobject"
  data: "type: COLLISION_OBJECT_TYPE_DYNAMIC\n"
  "mass: 0.1\n"
  "friction: 0.0\n"
  "restitution: 0.0\n"
  "group: \"player\"\n"
  "mask: \"level\"\n"
  "mask: \"player\"\n"
  "mask: \"bullets\"\n"
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
  "linear_damping: 0.9999\n"
  "locked_rotation: true\n"
  ""
}
embedded_components {
  id: "hand"
  type: "sprite"
  data: "default_animation: \"hand\"\n"
  "material: \"/builtins/materials/sprite.material\"\n"
  "textures {\n"
  "  sampler: \"texture_sampler\"\n"
  "  texture: \"/assets/characters/clint/clint_walk.tilesource\"\n"
  "}\n"
  ""
  position {
    y: 12.0
  }
}
embedded_components {
  id: "gun"
  type: "sprite"
  data: "default_animation: \"gun\"\n"
  "material: \"/builtins/materials/sprite.material\"\n"
  "textures {\n"
  "  sampler: \"texture_sampler\"\n"
  "  texture: \"/assets/characters/clint/clint_walk.tilesource\"\n"
  "}\n"
  ""
  position {
    y: 12.0
  }
}
embedded_components {
  id: "hat"
  type: "sprite"
  data: "default_animation: \"hat\"\n"
  "material: \"/builtins/materials/sprite.material\"\n"
  "textures {\n"
  "  sampler: \"texture_sampler\"\n"
  "  texture: \"/assets/characters/clint/clint_walk.tilesource\"\n"
  "}\n"
  ""
  position {
    y: 12.0
    z: 1.0
  }
}
embedded_components {
  id: "health"
  type: "sprite"
  data: "default_animation: \"square_sharp_32\"\n"
  "material: \"/builtins/materials/sprite.material\"\n"
  "textures {\n"
  "  sampler: \"texture_sampler\"\n"
  "  texture: \"/assets/character.atlas\"\n"
  "}\n"
  ""
  position {
    y: 48.0
  }
  scale {
    y: 0.25
  }
}
embedded_components {
  id: "shotgun"
  type: "factory"
  data: "prototype: \"/main/pellet.go\"\n"
  ""
}
