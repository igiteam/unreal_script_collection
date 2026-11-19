class WindPointSource extends Info
    placeable
    hidecategories(lighting,Movement,Collision);

var() const editconst export editinline WindPointSourceComponent Component;

simulated function OnR6SetWindModulateSource(SeqAct_R6SetWindModulateSource Action)
{
    local Actor pSource;

    pSource = none;
    // End:0x53
    if(Action.VariableLinks[1].LinkedVariables.Length > 0)
    {
        pSource = Actor(SeqVar_Object(Action.VariableLinks[1].LinkedVariables[0]).ObjValue);
    }
    // End:0xE2
    if(Action.InputLinks[0].bHasImpulse && pSource != none)
    {
        Component.m_pActorToFollowToModulateStrength = pSource;
        Component.m_fDistanceMax = Action.m_fDistanceMax;
        Component.m_fDistanceMin = Action.m_fDistanceMin;
        Action.OutputLinks[0].bHasImpulse = true;        
    }
    else
    {
        Component.m_pActorToFollowToModulateStrength = none;
        Component.m_fDistanceMax = 0.0000000;
        Component.m_fDistanceMin = 0.0000000;
        Action.OutputLinks[1].bHasImpulse = false;
    }
    return;
}

simulated function OnToggle(SeqAct_Toggle Action)
{
    // End:0x2D
    if(Action.InputLinks[0].bHasImpulse)
    {
        Component.m_bActivate = true;        
    }
    else
    {
        // End:0x5A
        if(Action.InputLinks[1].bHasImpulse)
        {
            Component.m_bActivate = false;            
        }
        else
        {
            // End:0x95
            if(Action.InputLinks[2].bHasImpulse)
            {
                Component.m_bActivate = !Component.m_bActivate;
            }
        }
    }
    return;
}

defaultproperties
{
    // Reference: WindPointSourceComponent'Default__WindPointSource.WindPointSourceComponent0'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    begin object name="WindPointSourceComponent0" class=Class'WindPointSourceComponent'
    end object
    Component=WindPointSourceComponent0
    bStatic=true
    // Reference: SpriteComponent'Default__WindPointSource.Sprite'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    // Archetype: SpriteComponent'Default__Info.Sprite'
    begin object name="Sprite"
    end object
    Components[0]=Sprite
    Components[1]=WindPointSourceComponent0
}