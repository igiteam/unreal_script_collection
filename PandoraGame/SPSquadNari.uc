class SPSquadNari extends SPSquad
    native;

var SPNariAIController m_squadLeader;
var Pawn m_squadEnemy;
var Vector m_vAttackRunLocation;

function bool AddSquadMember(Controller newMember)
{
    // End:0x42
    if(super.AddSquadMember(newMember))
    {
        // End:0x40
        if(m_squadLeader == none)
        {
            m_vAttackRunLocation = vect(0.0000000, 0.0000000, 0.0000000);
            SetSquadLeader(SPNariAIController(newMember));
        }
        return true;
    }
    return false;
    //return ReturnValue;    
}

function bool RemoveSquadMember(Controller removeMember, optional bool bNoReferenceCheck)
{
    // End:0x17
    if(m_squadLeader == removeMember)
    {
        m_squadLeader = none;
    }
    return super.RemoveSquadMember(removeMember, bNoReferenceCheck);
    //return ReturnValue;    
}

// Export USPSquadNari::execSetSquadLeader(FFrame&, void* const)
native function SetSquadLeader(SPNariAIController C);

function bool AllowedToAttackEnemy(Actor targ, SPNariAIController C)
{
    return true;
    //return ReturnValue;    
}
