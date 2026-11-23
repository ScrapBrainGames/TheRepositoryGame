components {
  id: "dynamite"
  component: "/main/dynamite.script"
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
