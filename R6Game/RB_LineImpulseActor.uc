class RB_LineImpulseActor extends Actor
    native
    placeable
    hidecategories(lighting);

var() float ImpulseStrength;
var() float ImpulseRange;
var() bool bVelChange;
var() bool bStopAtFirstHit;
var export editinline ArrowComponent Arrow;

// Export URB_LineImpulseActor::execFireLineImpulse(FFrame&, void* const)
native final function FireLineImpulse();

simulated function OnToggle(SeqAct_Toggle inAction)
{
    // End:0x1F
    if(inAction.InputLinks[0].bHasImpulse)
    {
        FireLineImpulse();
    }
    return;
}

defaultproperties
{
    ImpulseStrength=900.0000000
    ImpulseRange=200.0000000
    // Reference: ArrowComponent'Default__RB_LineImpulseActor.ArrowComponent0'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    begin object name="ArrowComponent0" class=Class'ArrowComponent'
        ArrowSize=4.1666700
    end object
    Arrow=ArrowComponent0
    bEdShouldSnap=true
    // Reference: SpriteComponent'Default__RB_LineImpulseActor.Sprite'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    // Archetype: SpriteComponent'Default__Actor.Sprite'
    begin object name="Sprite"
        Sprite=Texture2D'EngineResources.S_LineImpulse'
    end object
    Components[0]=Sprite
    Components[1]=ArrowComponent0
}