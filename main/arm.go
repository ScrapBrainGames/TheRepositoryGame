components {
  id: "blast"
  component: "/particles/blast.particlefx"
  position {
    x: 24.0
    y: -13.0
  }
  rotation {
    z: -0.70710677
    w: 0.70710677
  }
}
embedded_components {
  id: "hand"
  type: "sprite"
  data: "default_animation: \"clintHandSheet\"\n"
  "material: \"/builtins/materials/sprite.material\"\n"
  "textures {\n"
  "  sampler: \"texture_sampler\"\n"
  "  texture: \"/assets/characters/clint/hand.atlas\"\n"
  "}\n"
  ""
  position {
    z: 2.0
  }
}
embedded_components {
  id: "gun"
  type: "sprite"
  data: "default_animation: \"singlegun\"\n"
  "material: \"/builtins/materials/sprite.material\"\n"
  "textures {\n"
  "  sampler: \"texture_sampler\"\n"
  "  texture: \"/assets/weapons/weapons.atlas\"\n"
  "}\n"
  ""
  position {
    z: 3.0
  }
}
