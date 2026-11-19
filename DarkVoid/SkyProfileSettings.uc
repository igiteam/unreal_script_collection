class SkyProfileSettings extends OnlineProfileSettings
    native;

var bool bDirty;
var bool bReadFailed;

event SetToDefaults(optional bool bFailedRead = false)
{
    bReadFailed = bFailedRead;
    super.SetToDefaults(bFailedRead);
    //return;    
}
