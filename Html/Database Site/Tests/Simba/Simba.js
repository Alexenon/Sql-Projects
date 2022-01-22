
// Get by Class Name and loop through it

document.getElementById("t-settings").addEventListener("click", function() {
    document.getElementById("t-modal").style.display = "block"; // Display the table
});


var T_details = document.getElementById("t-details");
var T_fields = document.getElementById("t-fields");
var T_permissions = document.getElementById("t-permissions");
var T_triggers = document.getElementById("t-triggers");




function openTab(event, tabName) {
    var i, x, tablinks;

    x = document.getElementsByClassName("tab-pane");
    for (i = 0; i < x.length; i++) {
      x[i].style.display = "none";
    }

    tablinks = document.getElementsByTagName("LI");
    for (i = 0; i < x.length; i++) {
        tablinks[i].style.backgroundColor = "red";
    }


    document.getElementById(tabName).style.display = "block";
    event.currentTarget.style.backgroundColor = "blue";
}






