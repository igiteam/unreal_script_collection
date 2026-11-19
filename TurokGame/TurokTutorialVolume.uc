class TurokTutorialVolume extends TurokActionVolume
    native
    hidecategories(Navigation,Object,Movement,Display)
    autoexpandcategories(Multiplayer,ActionVolume);

var(Tutorial) class<Class> mTutorialType;
var bool mTutorialActionPerformed;

// Export UTurokTutorialVolume::execGetActionObject(FFrame&, void* const)
native function @NULL GetActionObject(@NULL Controller);

defaultproperties
{
    mTutorialType=Class'TurokTutorialJump'
    // Reference: DrawSphereComponent'Default__TurokTutorialVolume.LookDirMarker'
    begin object name=LookDirMarker
    end object
    mLookDirMarker=LookDirMarker
    mLookDirPoint=(X=0.0000000,Y=64.0000000,Z=0.0000000)
    mMaxAllowedLookDirOffset=45.0000000
    // Reference: BrushComponent'Default__TurokTutorialVolume.BrushComponent0'
    begin object name=BrushComponent0
    end object
    BrushComponent=BrushComponent0
    Components[0]=BrushComponent0
    Components[1]=LookDirMarker
    CollisionComponent=BrushComponent0
}