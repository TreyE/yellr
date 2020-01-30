import { Socket } from "phoenix"

function setupChangeElementListener() {
  var changeElement = document.getElementById("yellr_branch_update_listener");
  if (changeElement != null) {
    let socket = new Socket("/socket", {});
    socket.connect();
    let channel = socket.channel("branch_updates");
    channel.join();
    channel.on("branches_updated", function(msg) {
      window.location.reload();
    });
  }
}

document.addEventListener("DOMContentLoaded", function(event) { 
  setupChangeElementListener();
});