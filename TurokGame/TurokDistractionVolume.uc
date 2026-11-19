class TurokDistractionVolume extends Volume
    nativereplication
    hidecategories(Navigation,Object,Movement,Display);

enum eDistractionType
{
    eDistSmell,                     // 0
    eDistWater,                     // 1
    eDistFire,                      // 2
    eDistractionType_MAX            // 3
};

var(Distraction) int mLevel;
var(Distraction) byte mType;

simulated function int GetDistractionLevel()
{
    return mLevel;
    //return ReturnValue;    
}

simulated function byte GetDistractionType()
{
    return mType;
    //return ReturnValue;    
}

defaultproperties
{
    mLevel=1
    // Reference: BrushComponent'Default__TurokDistractionVolume.BrushComponent0'
    begin object name=BrushComponent0
        BlockZeroExtent=true
    end object
    BrushComponent=BrushComponent0
    Components[0]=BrushComponent0
    CollisionComponent=BrushComponent0
}