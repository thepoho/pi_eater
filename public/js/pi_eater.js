PiEater = {
  startup: function(){
    $("a.reload").click(function(event){
      event.preventDefault();
      PiEater.loadPinData();
    });
    $("select.direction").change(function(){
      var val = $(this).val();
      if(val != ""){
        $(this).children("option[value='']").remove();
        var pin = $(this).parent().attr("data-pin");
        if(val == "in"){
          $("td.state.pin_"+pin+" select").hide();
          $("td.state.pin_"+pin+" span").show();
        }else{
          $("td.state.pin_"+pin+" select").show();
          $("td.state.pin_"+pin+" span").hide();
        }
      
        PiEater.setPinDirection(pin, val);
      }
    });

    $("select.state").change(function(){
      var val = $(this).val();
      var pin = $(this).parent().attr("data-pin");
      PiEater.setPinState(pin, val);
    });
  },
  setPinDirection: function(pin, direction){
    $.get("/set_pin_direction/"+pin+"/"+direction, function(data){
      //nothing here yet on purpose
    });
  },
  setPinState: function(pin, state){
    $.get("/set_output_pin/"+pin+"/"+state, function(data){
      //nothing here yet on purpose
    });
  },
  loadPinData: function(){
    $.get("/pin_states", function(data){
      $.each(data, function(k,v){
        if(v['direction'] == "in"){
          var element = $("td.state.pin_"+k+ " span");
          element.html(v['state']);
          if(v['state'] == "0"){
            element.addClass("state-off");
            element.removeClass("state-on");
          }else{
            element.addClass("state-on");
            element.removeClass("state-off");
          }
        }
      });
    });
  }
}
