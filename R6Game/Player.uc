class Player extends Object
    transient
    native
    config(Engine);

var private native const noexport Pointer VfTable_FExec;
var const transient PlayerController Actor;
var const int CurrentNetSpeed;
var globalconfig int ConfiguredInternetSpeed;
var globalconfig int ConfiguredLanSpeed;

defaultproperties
{
    ConfiguredInternetSpeed=10000
    ConfiguredLanSpeed=20000
}