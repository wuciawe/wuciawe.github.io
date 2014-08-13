/**
 * Created by jwhu on 14-8-13.
 */

$(document.links).filter(function () {
    return this.hostname != window.location.hostname;
}).attr('target', '_blank');
