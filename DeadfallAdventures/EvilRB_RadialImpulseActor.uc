class EvilRB_RadialImpulseActor extends RB_RadialImpulseComponent
    native(Physics)
    hidecategories(Object);

var() bool bIgnorePawns;

// Export UEvilRB_RadialImpulseActor::execFireImpulse(FFrame&, void* const)
native function FireImpulse(Vector Origin);

defaultproperties
{
    bIgnorePawns=true
    ReplacementPrimitive=none
}