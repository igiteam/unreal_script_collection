class SkySkelControl_FootPlacementProfiles extends SkySkelControl_FootPlacement
    native;

struct native FootPlacementProfile
{
    var() Vector Floor;
    var() float FloorHeight;
    var() float FootVelThreshold;
    var() bool bInvertFootUpAxis;

    structdefaultproperties
    {
        Floor=(X=0.0000000,Y=0.0000000,Z=0.0000000)
        FloorHeight=0.0000000
        FootVelThreshold=0.0000000
        bInvertFootUpAxis=false
    }
};

var() int CurrentProfile;
var() array<FootPlacementProfile> Profiles;

event SetProfile(int NewProfile)
{
    // End:0x8F
    if((NewProfile >= 0) && Profiles.Length > NewProfile)
    {
        Floor = Profiles[NewProfile].Floor;
        FloorHeight = Profiles[NewProfile].FloorHeight;
        FootVelThreshold = Profiles[NewProfile].FootVelThreshold;
        bInvertFootUpAxis = Profiles[NewProfile].bInvertFootUpAxis;
    }
    //return;    
}
