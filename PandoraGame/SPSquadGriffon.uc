class SPSquadGriffon extends SPSquad
    native;

enum EGriffonAttackState
{
    egasNone,                       // 0
    egasGroundAttack,               // 1
    egasDiveBombAttack,             // 2
    egasDropObjectAttack,           // 3
    egasSpecialCopterAttack,        // 4
    EGriffonAttackState_MAX         // 5
};

var SPSquadGriffon.EGriffonAttackState m_nextCopterAttackType;
var SPGriffonAIController m_lastCopterAttacker;
var bool m_bAllowGroundAttack;
var bool m_bAllowAirAttack;

function bool AddSquadMember(Controller newMember)
{
    // End:0x31
    if(super.AddSquadMember(newMember))
    {
        SPGriffonAIController(newMember).SetGriffonAttackType(m_bAllowGroundAttack, m_bAllowAirAttack);
        return true;
    }
    return false;
    //return ReturnValue;    
}

function bool IsSquadMemberPerformingAttackOnTarget(Actor targ, SPGriffonAIController C, SPSquadGriffon.EGriffonAttackState attacktype)
{
    local int Idx;
    local SPGriffonAIController squadMember;

    Idx = 0;
    J0x07:

    // End:0x72 [Loop If]
    if(Idx < m_members.Length)
    {
        squadMember = SPGriffonAIController(m_members[Idx]);
        // End:0x68
        if((squadMember != none) && squadMember != C)
        {
            // End:0x68
            if(int(squadMember.m_AttackState) == int(attacktype))
            {
                return true;
            }
        }
        Idx++;
        // [Loop Continue]
        goto J0x07;
    }
    return false;
    //return ReturnValue;    
}

function SPSquadGriffon.EGriffonAttackState GetNextCopterAttackType(Actor targ)
{
    m_nextCopterAttackType = 4;
    return m_nextCopterAttackType;
    //return ReturnValue;    
}

function bool AllowedToAttackEnemy(Actor targ, SPGriffonAIController C, SPSquadGriffon.EGriffonAttackState desiredAttack)
{
    switch(desiredAttack)
    {
        // End:0x0D
        case 3:
        // End:0x12
        case 0:
        // End:0x19
        case 1:
            return true;
        // End:0x37
        case 2:
            return !IsSquadMemberPerformingAttackOnTarget(targ, C, 2);
        // End:0x90
        case 4:
            // End:0x5A
            if(IsSquadMemberPerformingAttackOnTarget(targ, C, 4))
            {
                return false;                
            }
            else
            {
                // End:0x8E
                if(IsControllerCopterBestAttackCandidate(targ, C, desiredAttack))
                {
                    m_nextCopterAttackType = 0;
                    m_lastCopterAttacker = C;
                    return true;                    
                }
                else
                {
                    return false;
                }
            }
        // End:0xFFFF
        default:
            return true;
            break;
    }
    //return ReturnValue;    
}

function bool IsControllerCopterBestAttackCandidate(Actor targ, SPGriffonAIController C, SPSquadGriffon.EGriffonAttackState desiredAttack)
{
    return IsControllerCopterBestSwipeAttackCandidate(targ, C);
    //return ReturnValue;    
}

function bool IsControllerCopterBestRamAttackCandidate(Actor targ, SPGriffonAIController C)
{
    return false;
    //return ReturnValue;    
}

function bool IsControllerCopterBestSwipeAttackCandidate(Actor targ, SPGriffonAIController C)
{
    return false;
    //return ReturnValue;    
}

function OnSetGriffonAttackType(SeqAct_SetGriffonAttackType Action)
{
    local int Idx;
    local SPGriffonAIController squadMember;

    m_bAllowAirAttack = Action.m_allowAirAttack;
    m_bAllowGroundAttack = Action.m_allowGroundAttack;
    Idx = 0;
    J0x35:

    // End:0x89 [Loop If]
    if(Idx < m_members.Length)
    {
        squadMember = SPGriffonAIController(m_members[Idx]);
        // End:0x7F
        if(squadMember != none)
        {
            squadMember.OnSetGriffonAttackType(Action);
        }
        Idx++;
        // [Loop Continue]
        goto J0x35;
    }
    //return;    
}
