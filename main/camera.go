components {
  id: "control"
  component: "/main/camera.script"
}
components {
  id: "weapon"
  component: "/main/weapon.gui"
}
embedded_components {
  id: "camera"
  type: "camera"
  data: "aspect_ratio: 1.0\n"
  "fov: 0.7854\n"
  "near_z: 0.1\n"
  "far_z: 1000.0\n"
  "orthographic_projection: 1\n"
  "orthographic_mode: ORTHO_MODE_AUTO_COVER\n"
  ""
}
