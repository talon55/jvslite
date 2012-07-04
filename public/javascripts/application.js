// Custom JS for JVSlite

$(document).ready(function(){
$(".mail").click(openExternal);
});

// functions

function openExternal()
{
  window.open(this.href, "ext");
  return false;
}
