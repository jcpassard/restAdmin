$(document).ready(function () {
    var startStop = function (evt) {
        var attrs = evt.currentTarget.attributes;

        $.ajax({
            url : attrs['ajax-url'].value,
            type : attrs['ajax-method'].value,
            data : {
                action : attrs['ajax-param-action'].value
            },
            success: function () {
                location.reload();
            }
        });
    };
    $("#btn-start-vm").button().click(startStop);
    $("#btn-stop-vm").button().click(startStop);
});