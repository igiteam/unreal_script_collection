class R6AmbianceEmmiter extends Actor
    native
    notplaceable
    hidecategories(lighting);

var bool IsClosestZone;
var bool IsPlaying;
var export editinline AudioComponent CurrentAmbience;
var float CurrentVolume;
var float CurrentDistanceZone;
