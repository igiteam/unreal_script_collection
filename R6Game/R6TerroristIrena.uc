class R6TerroristIrena extends R6TerroristPawn
    native
    config(Character)
    hidecategories(lighting);

var() bool m_bCanBeAttacked;

replication
{
    // Pos:0x000
    if((int(Role) == int(ROLE_Authority)) && bNetDirty)
        m_bCanBeAttacked;
}

// Export UR6TerroristIrena::execIsIrena(FFrame&, void* const)
native function bool IsIrena();

// Export UR6TerroristIrena::execModifiedCanBeAttacked(FFrame&, void* const)
native function ModifiedCanBeAttacked();

function OnR6ToggleIrena(SeqAct_R6ToggleIrena Action)
{
    local bool bOldCanBeAttacked;

    bOldCanBeAttacked = m_bCanBeAttacked;
    // End:0x73
    if(Action.InputLinks[0].bHasImpulse)
    {
        // End:0x40
        if(Action.m_bToggleAttackable)
        {
            m_bCanBeAttacked = true;
        }
        // End:0x70
        if(Action.m_bToggleGodMode && Controller != none)
        {
            Controller.bGodMode = false;
        }        
    }
    else
    {
        // End:0xD9
        if(Action.InputLinks[1].bHasImpulse)
        {
            // End:0xA6
            if(Action.m_bToggleAttackable)
            {
                m_bCanBeAttacked = false;
            }
            // End:0xD6
            if(Action.m_bToggleGodMode && Controller != none)
            {
                Controller.bGodMode = true;
            }            
        }
        else
        {
            // End:0x14B
            if(Action.InputLinks[2].bHasImpulse)
            {
                // End:0x114
                if(Action.m_bToggleAttackable)
                {
                    m_bCanBeAttacked = !m_bCanBeAttacked;
                }
                // End:0x14B
                if(Action.m_bToggleGodMode && Controller != none)
                {
                    Controller.bGodMode = !m_bCanBeAttacked;
                }
            }
        }
    }
    // End:0x163
    if(bOldCanBeAttacked != m_bCanBeAttacked)
    {
        ModifiedCanBeAttacked();
    }
    return;
}

defaultproperties
{
    m_bCanBeAttacked=true
}