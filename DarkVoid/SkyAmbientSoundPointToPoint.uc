class SkyAmbientSoundPointToPoint extends Keypoint
    native;

var(Audio) editconst export editinline AudioComponent Sound;
var(Position) Vector StartPoint;
var(Position) Vector EndPoint;
var export editinline SkyAmbientSoundRenderComponent RenderComp;
var transient Vector LevelLocation;
var transient Vector StartingStartPoint;
var transient Vector StartingEndPoint;
var transient Rotator LevelRotation;
var transient bool bMovingLevelInitialized;
