require("./styles/main.scss");

document.addEventListener("DOMContentLoaded", () => {
  const Elm = require("../elm/Main");
  Elm.Main.embed(document.getElementById("main"));
});
