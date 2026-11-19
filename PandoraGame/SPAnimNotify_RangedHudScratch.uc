class SPAnimNotify_RangedHudScratch extends SPAnimNotify_HudScratch
    native
    editinlinenew
    collapsecategories;

/** DamageAmount overrides standard damage if set to non-zero */
var() float DamageAmount;
/** The distance for which to apply damage */
var() float DamageRange;
/** The class of actors that you want the damage to affect (i.e. PlayerPawn) */
var() Class DamageableClass;
/** The damage type class to use when inflicting damage */
var() class<DamageType> DamageTypeClass;
/** The magnitude of the impulse applied when damage is taken */
var() float Magnitude;
/** the magnitude to apply to the Z axis (arc of push back) */
var() float ZMagnitude;
/** Don't process keys in the event the class playing the animation is a pawn */
var() bool bNoPawns;

defaultproperties
{
    DamageRange=100.0000000
    DamageableClass=Class'PlayerPawn'
    DamageTypeClass=Class'SPDamageTypeHuman'
    Magnitude=100.0000000
    ZMagnitude=20.0000000
}