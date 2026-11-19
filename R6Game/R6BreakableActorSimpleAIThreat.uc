class R6BreakableActorSimpleAIThreat extends R6BreakableActor
    native
    notplaceable
    hidecategories(Material);

var(AIThreat) float m_fSafetyDistance;
var int m_iThreat;
var(AIThreat) bool m_bIsTerroristTarget;
var(AIThreat) bool m_bIsRainbowTarget;
var bool m_bOriginalTerroristTarget;
var bool m_bOriginalRainbowTarget;
var int m_iShowSelfLastTick;

function OnR6ToggleTerroTarget(SeqAct_R6ToggleTerroTarget Action)
{
    // End:0x24
    if(Action.InputLinks[0].bHasImpulse)
    {
        m_bIsTerroristTarget = true;        
    }
    else
    {
        // End:0x45
        if(Action.InputLinks[1].bHasImpulse)
        {
            m_bIsTerroristTarget = false;
        }
    }
    return;
}

function OnR6ToggleRainbowTarget(SeqAct_R6ToggleRainbowTarget Action)
{
    // End:0x24
    if(Action.InputLinks[0].bHasImpulse)
    {
        m_bIsRainbowTarget = true;        
    }
    else
    {
        // End:0x45
        if(Action.InputLinks[1].bHasImpulse)
        {
            m_bIsRainbowTarget = false;
        }
    }
    return;
}

defaultproperties
{
    m_iThreat=134221824
}