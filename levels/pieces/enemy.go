components {
  id: "script"
  component: "/levels/pieces/enemy.script"
  properties {
    id: "enemy"
    value: "mook"
    type: PROPERTY_TYPE_TEXT
  }
}
embedded_components {
  id: "factory"
  type: "factory"
  data: "prototype: \"/characters/character.go\"\n"
  ""
}
