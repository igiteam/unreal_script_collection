class EvilBurningVolume extends PhysicsVolume
    hidecategories(Navigation,Object,Movement,Display);

defaultproperties
{
    bPainCausing=true
    DamagePerSec=10.0000000
    DamageType=Class'EvilDmgType_Fire'
    // Reference: BrushComponent'Default__EvilBurningVolume.BrushComponent0'
    begin object name=BrushComponent0
        ReplacementPrimitive=none
    end object
    BrushComponent=BrushComponent0
    Components[0]=BrushComponent0
    CollisionComponent=BrushComponent0
}