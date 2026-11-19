class SPSquadHuman extends SPSquad
    native;

var float m_nextGrenadeThrowTime;
var int m_maxMembersThatCanUseHighAggression;
var array<SPGrenadePersistent> m_grenadesWeveYelledAbout;

// Export USPSquadHuman::execSquadMemberJustThrewGrenade(FFrame&, void* const)
native final function SquadMemberJustThrewGrenade(SPSoldierAIController pThrower);

function bool IsSafeToDelete()
{
    // End:0x11
    if(m_maxMembersThatCanUseHighAggression != default.m_maxMembersThatCanUseHighAggression)
    {
        return false;
    }
    return super.IsSafeToDelete();
    //return ReturnValue;    
}

event ClearSquadCommands(optional bool bRemoveAllMembers = false)
{
    m_maxMembersThatCanUseHighAggression = default.m_maxMembersThatCanUseHighAggression;
    super.ClearSquadCommands(bRemoveAllMembers);
    //return;    
}

function SetMaxAggressiveUnitsInSquad(int maxAggressiveUnit, bool bUseGameplayDataDefaultValue)
{
    // End:0x17
    if(bUseGameplayDataDefaultValue)
    {
        m_maxMembersThatCanUseHighAggression = default.m_maxMembersThatCanUseHighAggression;        
    }
    else
    {
        m_maxMembersThatCanUseHighAggression = maxAggressiveUnit;
    }
    //return;    
}

function bool CanDefendGenericActor()
{
    return true;
    //return ReturnValue;    
}

function bool ShouldDoGrenadeYell(SPGrenadePersistent theGrenade)
{
    local int I;

    I = 0;
    J0x07:

    // End:0x38 [Loop If]
    if(I < m_grenadesWeveYelledAbout.Length)
    {
        // End:0x2E
        if(m_grenadesWeveYelledAbout[I] == theGrenade)
        {
            return false;
        }
        I++;
        // [Loop Continue]
        goto J0x07;
    }
    return true;
    //return ReturnValue;    
}

function PreventGrenadeYell(SPGrenadePersistent theGrenade)
{
    local int I;

    I = 0;
    J0x07:

    // End:0x78 [Loop If]
    if(I < m_grenadesWeveYelledAbout.Length)
    {
        // End:0x31
        if(m_grenadesWeveYelledAbout[I] == theGrenade)
        {
            return;
            // [Explicit Continue]
            goto J0x6E;
        }
        // End:0x6E
        if((m_grenadesWeveYelledAbout[I] == none) || m_grenadesWeveYelledAbout[I].IsPendingKill())
        {
            m_grenadesWeveYelledAbout[I] = theGrenade;
        }
        J0x6E:

        I++;
        // [Loop Continue]
        goto J0x07;
    }
    m_grenadesWeveYelledAbout.Length = m_grenadesWeveYelledAbout.Length + 1;
    m_grenadesWeveYelledAbout[m_grenadesWeveYelledAbout.Length - 1] = theGrenade;
    //return;    
}
