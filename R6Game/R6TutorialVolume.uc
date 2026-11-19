class R6TutorialVolume extends Volume
    native
    hidecategories(lighting,Object,Movement,Display);

// Export UR6TutorialVolume::execTriggerTouched(FFrame&, void* const)
native final function TriggerTouched(Actor other, Vector HitLocation, Vector HitNormal);

// Export UR6TutorialVolume::execTriggerUnTouched(FFrame&, void* const)
native final function TriggerUnTouched(Actor other);

defaultproperties
{
    BrushColor=(R=100,G=255,B=255,A=255)
    bColored=true
    SupportedEvents=/* Array type was not detected. */
}