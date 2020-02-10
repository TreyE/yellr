function setupYellElementListener() {
  var yellement = document.getElementById("yellr_branch_audio_autoyell");
  if (yellement != null) {
    yellement.play();
  }
}

document.addEventListener("DOMContentLoaded", function(event) { 
  setupYellElementListener();
});