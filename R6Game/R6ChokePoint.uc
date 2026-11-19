class R6ChokePoint extends R6InfoPoint
    native
    hidecategories(lighting,Object,Actor,Advanced,Attachment,Collision,Display,Fire,Heat,CubemapSample,Reticule,Region,R6Sound,R6SoundPropagation);

var() float m_fLength;
var() bool m_bIsZoneClusterDivider;

// Export UR6ChokePoint::execToggleChokeBlocked(FFrame&, void* const)
native final function ToggleChokeBlocked(bool bIsEnable);

function OnR6ToggleChokeBlocked(SeqAct_R6ToggleChokeBlocked Action)
{
    // End:0x23
    if(Action.InputLinks[0].bHasImpulse)
    {
        ToggleChokeBlocked(true);        
    }
    else
    {
        // End:0x43
        if(Action.InputLinks[1].bHasImpulse)
        {
            ToggleChokeBlocked(false);
        }
    }
    return;
}

defaultproperties
{
    m_fLength=200.0000000
    // Reference: SpriteComponent'Default__R6ChokePoint.Sprite'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    // Archetype: SpriteComponent'Engine.Default__R6InfoPoint.Sprite'
    begin object name="Sprite"
        Sprite=Texture2D'AIIcons.ChokePoint_Pic'
    end object
    Components[0]=Sprite
}