class PlayerStart extends NavigationPoint
    native
    notplaceable
    hidecategories(lighting,lighting,LightColor,Force);

var() bool bEnabled;
var() bool bPrimaryStart;
var() bool bAlternateLocationStart;

simulated function OnToggle(SeqAct_Toggle Action)
{
    // End:0x24
    if(Action.InputLinks[0].bHasImpulse)
    {
        bEnabled = true;        
    }
    else
    {
        // End:0x48
        if(Action.InputLinks[1].bHasImpulse)
        {
            bEnabled = false;            
        }
        else
        {
            // End:0x71
            if(Action.InputLinks[2].bHasImpulse)
            {
                bEnabled = !bEnabled;
            }
        }
    }
    return;
}

defaultproperties
{
    bEnabled=true
    bPrimaryStart=true
    // Reference: CylinderComponent'Default__PlayerStart.CollisionCylinder'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    // Archetype: CylinderComponent'Default__NavigationPoint.CollisionCylinder'
    begin object name="CollisionCylinder"
        CollisionHeight=80.0000000
        CollisionRadius=40.0000000
    end object
    CylinderComponent=CollisionCylinder
    // Reference: SpriteComponent'Default__PlayerStart.Sprite'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    // Archetype: SpriteComponent'Default__NavigationPoint.Sprite'
    begin object name="Sprite"
        Sprite=Texture2D'EngineResources.S_Player'
    end object
    Components[0]=Sprite
    Components[1]=CollisionCylinder
    // Reference: PathRenderingComponent'Default__PlayerStart.PathRenderer'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    // Archetype: PathRenderingComponent'Default__NavigationPoint.PathRenderer'
    begin object name="PathRenderer"
    end object
    Components[2]=PathRenderer
    // Reference: ArrowComponent'Default__PlayerStart.ArrowComponent0'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    begin object name="ArrowComponent0" class=Class'ArrowComponent'
    end object
    Components[3]=ArrowComponent0
    CollisionComponent=CollisionCylinder
}