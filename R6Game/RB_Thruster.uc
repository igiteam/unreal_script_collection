class RB_Thruster extends Actor
    native
    placeable
    hidecategories(lighting);

var() bool bThrustEnabled;
var() interp float ThrustStrength;

simulated function OnToggle(SeqAct_Toggle Action)
{
    // End:0x24
    if(Action.InputLinks[0].bHasImpulse)
    {
        bThrustEnabled = true;        
    }
    else
    {
        // End:0x48
        if(Action.InputLinks[1].bHasImpulse)
        {
            bThrustEnabled = false;            
        }
        else
        {
            // End:0x71
            if(Action.InputLinks[2].bHasImpulse)
            {
                bThrustEnabled = !bThrustEnabled;
            }
        }
    }
    return;
}

defaultproperties
{
    ThrustStrength=100.0000000
    bHardAttach=true
    bEdShouldSnap=true
    // Reference: SpriteComponent'Default__RB_Thruster.Sprite'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    // Archetype: SpriteComponent'Default__Actor.Sprite'
    begin object name="Sprite"
        Sprite=Texture2D'EngineResources.S_Thruster'
    end object
    Components[0]=Sprite
    // Reference: ArrowComponent'Default__RB_Thruster.ArrowComponent0'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    begin object name="ArrowComponent0" class=Class'ArrowComponent'
        ArrowColor=(R=255,G=180,B=0,A=255)
        ArrowSize=1.7000000
    end object
    Components[1]=ArrowComponent0
}