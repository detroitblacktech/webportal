  function hideContactForm() {
    $("#contact-form").fadeOut();
    $('#contact-thankyou').fadeIn();
  }

  /* set action handlers */
  function setHandlers() {
    /*_form handler */
    $form = $('#contact-form');
    $form.submit(function (e) {
      e.preventDefault();
      url = "/email";

      // get all the inputs into an array.
      var $inputs = $form.find('input, textarea');

      console.log("getting values");
      var values = {};
      jQuery.each($inputs.serializeArray(), function(i, kv) {
        if (values.hasOwnProperty(kv.name)) {
          values[kv.name] = $.makeArray(values[kv.name]);
          values[kv.name].push(kv.value);
        }
        else {
          values[kv.name] = kv.value;
        }
      });

      values['name'] = $('input#name.form-control').val()
      values['email'] = $('input#email.form-control').val()
      values['purpose'] = $('select#purpose.form-control').val()
      values['message'] = $('textarea#message.form-control').val()

      values = JSON.stringify(values);

      var settings = {
        "async": true,
        "url": url,
        "method": "POST",
        "dataType": "json",
        "contentType": "application/json",
        "data": values,
        "headers": {
          "accept": "application/json; charset=utf-8",
          "Access-Control-Allow-Origin": "*"
        },
        "success": function (response, textStatus, jqXhr) {
          console.log("request success");
        },
        "error": function (response, textStatus, jqXhr) {
          console.log("request failure");
        }
      };

      $.ajax(settings).done(function (response) {
        console.log(response);
        hideContactForm();
      });
    });
  }

  $(document).ready(function() {
    setHandlers();
    $('#contact-thankyou').fadeOut();
  });
