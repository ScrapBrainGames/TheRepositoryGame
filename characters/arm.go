components {
  id: "blast"
  component: "/effects/blast.particlefx"
  position {
    x: 52.0
  }
  rotation {
    z: -0.70710677
    w: 0.70710677
  }
}
embedded_components {
  id: "hand"
  type: "sprite"
  data: "default_animation: \"mookHandSheet\"\n"
  "material: \"/builtins/materials/sprite.material\"\n"
  "textures {\n"
  "  sampler: \"texture_sampler\"\n"
  "  texture: \"/characters/hands.atlas\"\n"
  "}\n"
  ""
  position {
    z: 4.0
  }
}
embedded_components {
  id: "gun"
  type: "sprite"
  data: "default_animation: \"sixgun\"\n"
  "material: \"/builtins/materials/sprite.material\"\n"
  "textures {\n"
  "  sampler: \"texture_sampler\"\n"
  "  texture: \"/weapons/weapons.atlas\"\n"
  "}\n"
  ""
  position {
    z: 3.0
  }
}
