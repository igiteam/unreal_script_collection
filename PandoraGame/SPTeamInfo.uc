class SPTeamInfo extends TeamInfo
    native;

var array<Controller> m_teamMembers;
var array<SPSquad> m_squads;
var class<SPSquad> m_squadType;
var class<SPSquad> m_defaultSquadType;
var float m_squadUpdateRate;
var array<TeamInfo> m_FriendlyTeams;
var LinearColor m_TeamMPColor;

// Export USPTeamInfo::execSPAILog(FFrame&, void* const)
native final function SPAILog(name logCategory, string LogText);

// Export USPTeamInfo::execIsAFriendlyTeam(FFrame&, void* const)
native final function bool IsAFriendlyTeam(TeamInfo checkedTeam);

// Export USPTeamInfo::execAddAFriendlyTeam(FFrame&, void* const)
native final function bool AddAFriendlyTeam(TeamInfo checkedTeam);

// Export USPTeamInfo::execRemoveAFriendlyTeam(FFrame&, void* const)
native final function bool RemoveAFriendlyTeam(TeamInfo checkedTeam);

// Export USPTeamInfo::execClearFriendlyTeams(FFrame&, void* const)
native final function bool ClearFriendlyTeams();

simulated function Destroyed()
{
    local int Idx;
    local SPSquad SPSquad;
    local array<SPSquad> deleteSquad;

    deleteSquad.Length = m_squads.Length;
    Idx = 0;
    J0x14:

    // End:0x45 [Loop If]
    if(Idx < m_squads.Length)
    {
        deleteSquad[Idx] = m_squads[Idx];
        Idx++;
        // [Loop Continue]
        goto J0x14;
    }
    Idx = 0;
    J0x4C:

    // End:0xA6 [Loop If]
    if(Idx < deleteSquad.Length)
    {
        SPSquad = deleteSquad[Idx];
        // End:0x9C
        if((SPSquad != none) && !SPSquad.bDeleteMe)
        {
            SPSquad.Destroy();
        }
        Idx++;
        // [Loop Continue]
        goto J0x4C;
    }
    super.Destroyed();
    //return;    
}

event name GetPreDefinedSquadName(int Idx)
{
    return 'Default';
    //return ReturnValue;    
}

function RemoveSquad(SPSquad squadToRemove, optional bool bForced)
{
    local SPSquad newSquad;
    local int tempIdx, squadIdx;
    local PandoraPlayerController PC;

    // End:0x11E
    if(squadToRemove != none)
    {
        squadIdx = GetSquadIndex(squadToRemove.m_squadName);
        // End:0x11E
        if(squadIdx >= 0)
        {
            // End:0x95
            if(!bForced)
            {
                newSquad = GetSquadByName('Default', tempIdx, true);
                // End:0x95
                if((newSquad != none) && tempIdx != squadIdx)
                {
                    squadToRemove.MoveSquadMembersToNewSquad(newSquad);
                }
            }
            // End:0xEB
            foreach LocalPlayerControllers(Class'PandoraPlayerController', PC)
            {
                // End:0xEA
                if(PC.m_squad == squadToRemove)
                {
                    PC.m_squad = GetSquadByName('Default', tempIdx, true);
                }                
            }            
            // End:0x112
            if(squadToRemove.m_team == self)
            {
                squadToRemove.m_team = none;
            }
            m_squads.Remove(squadIdx, 1);
        }
    }
    //return;    
}

event SPSquad GetSquadByNameNoDefaults(name squadName, optional bool bNoSquadCreate)
{
    return GetSquadByName(squadName,, bNoSquadCreate);
    //return ReturnValue;    
}

function SPSquad GetSquadByName(name squadName, optional out int outIdx, optional bool bNoSquadCreate)
{
    local int Idx;
    local SPSquad SPSquad, tempSquad;

    SPSquad = none;
    outIdx = -1;
    // End:0x36
    if(squadName == 'None')
    {
        squadName = 'Default';
    }
    // End:0x98
    if((m_squads.Length == 0) && !bNoSquadCreate)
    {
        tempSquad = Spawn(m_defaultSquadType);
        tempSquad.Initialize('Default', self);
        m_squads[m_squads.Length] = tempSquad;
    }
    Idx = 0;
    J0x9F:

    // End:0xEC [Loop If]
    if(Idx < m_squads.Length)
    {
        // End:0xE2
        if(m_squads[Idx].m_squadName == squadName)
        {
            SPSquad = m_squads[Idx];
            // [Explicit Break]
            goto J0xEC;
        }
        Idx++;
        // [Loop Continue]
        goto J0x9F;
    }
    J0xEC:

    // End:0x108
    if(SPSquad != none)
    {
        outIdx = Idx;
        return SPSquad;
    }
    // End:0x113
    if(bNoSquadCreate)
    {
        return none;
    }
    SPSquad = Spawn(m_squadType);
    // End:0x172
    if(SPSquad != none)
    {
        SPSquad.Initialize(squadName, self);
        outIdx = m_squads.Length;
        m_squads[m_squads.Length] = SPSquad;        
    }
    return SPSquad;
    //return ReturnValue;    
}

function int GetSquadIndex(name squadName)
{
    local int squadIdx;

    GetSquadByName(squadName, squadIdx);
    return squadIdx;
    //return ReturnValue;    
}

function SPSquad GetMemberSquad(Controller chkMember, optional out int MemberIdx, optional out int squadIdx)
{
    local int Idx, memIdx;
    local SPSquad SPSquad;
    local SPAIController spAI;

    spAI = SPAIController(chkMember);
    // End:0xB5
    if(((spAI != none) && spAI.m_squad != none) && spAI.GetTeam() == self)
    {
        SPSquad = spAI.m_squad;
        // End:0xB2
        if(SPSquad.IsAMember(chkMember, memIdx))
        {
            MemberIdx = memIdx;
            squadIdx = GetSquadIndex(SPSquad.m_squadName);
            return SPSquad;
        }        
    }
    else
    {
        Idx = 0;
        J0xBC:

        // End:0x124 [Loop If]
        if(Idx < m_squads.Length)
        {
            SPSquad = m_squads[Idx];
            // End:0x11A
            if(SPSquad.IsAMember(chkMember, memIdx))
            {
                MemberIdx = memIdx;
                squadIdx = Idx;
                return SPSquad;
            }
            Idx++;
            // [Loop Continue]
            goto J0xBC;
        }
    }
    MemberIdx = -1;
    squadIdx = -1;
    return none;
    //return ReturnValue;    
}

function bool HasSquadMembers(name squadName, Controller chkPlayer)
{
    local SPSquad SPSquad;

    // End:0x48
    if(squadName != 'None')
    {
        SPSquad = GetSquadByName(squadName);
        // End:0x48
        if(SPSquad.HasSquadMembers(chkPlayer))
        {
            return true;
        }
    }
    return false;
    //return ReturnValue;    
}

function bool GetSquadMembers(name squadName, out array<Controller> squadMembers)
{
    local SPSquad SPSquad;

    squadMembers.Length = 0;
    // End:0x4B
    if(squadName != 'None')
    {
        SPSquad = GetSquadByName(squadName);
        SPSquad.GetSquadMembers(squadMembers);
    }
    return squadMembers.Length != 0;
    //return ReturnValue;    
}

function AddToSquad(Controller newMember, name squadName)
{
    local SPSquad SPSquad;

    SPSquad = GetSquadByName(squadName);
    SPSquad.AddSquadMember(newMember);
    // End:0x62
    if(!IsTimerActive('UpdateSquads'))
    {
        UpdateSquads();
        SetTimer(m_squadUpdateRate, true, 'UpdateSquads');
    }
    //return;    
}

function RemoveFromSquad(Controller oldMember)
{
    local SPSquad SPSquad;

    SPSquad = GetMemberSquad(oldMember);
    // End:0x3C
    if(SPSquad != none)
    {
        SPSquad.RemoveSquadMember(oldMember);
    }
    //return;    
}

function bool AddToTeam(Controller Other)
{
    local Controller P;
    local bool bSuccess;
    local SPPlayerReplicationInfo PRI;
    local SPHud theHud;
    local PandoraPlayerController thePandoraPlayerController;

    // End:0x2F6
    if(Other != none)
    {
        Size++;
        Other.PlayerReplicationInfo.Team = self;
        Other.PlayerReplicationInfo.SetNetUpdateTime(WorldInfo.TimeSeconds - float(1));
        bSuccess = false;
        // End:0x107
        if(Other.IsA('PlayerController'))
        {
            Other.PlayerReplicationInfo.TeamID = 0;
            // End:0x104
            if(int(WorldInfo.NetMode) == int(NM_ListenServer))
            {
                thePandoraPlayerController = PandoraPlayerController(Other);
                // End:0x104
                if(thePandoraPlayerController != none)
                {
                    theHud = SPHud(thePandoraPlayerController.myHUD);
                    // End:0x104
                    if(theHud != none)
                    {
                        theHud.UpdateHUDTeamColor();
                    }
                }
            }            
        }
        else
        {
            Other.PlayerReplicationInfo.TeamID = 1;
        }
        J0x122:

        // End:0x24E [Loop If]
        if(!bSuccess)
        {
            bSuccess = true;
            // End:0x209
            foreach WorldInfo.AllControllers(Class'Engine.Controller', P)
            {
                // End:0x16A
                if(P.PlayerReplicationInfo == none)
                {
                    // End:0x208
                    continue;
                }
                // End:0x208
                if(((P.bIsPlayer && P != Other) && P.PlayerReplicationInfo.Team == Other.PlayerReplicationInfo.Team) && P.PlayerReplicationInfo.TeamID == Other.PlayerReplicationInfo.TeamID)
                {
                    bSuccess = false;
                }                
            }            
            // End:0x24B
            if(!bSuccess)
            {
                Other.PlayerReplicationInfo.TeamID = Other.PlayerReplicationInfo.TeamID + 1;
            }
            // [Loop Continue]
            goto J0x122;
        }
        m_teamMembers[m_teamMembers.Length] = Other;
        PRI = SPPlayerReplicationInfo(Other.PlayerReplicationInfo);
        // End:0x2C5
        if((PRI != none) && PRI.SquadNameAssignment != 'None')
        {
            AddToSquad(Other, PRI.SquadNameAssignment);            
        }
        else
        {
            AddToSquad(Other, 'Default');
            PRI.SquadNameAssignment = 'Default';
        }
    }
    return bSuccess;
    //return ReturnValue;    
}

function RemoveFromTeam(Controller Other)
{
    local int Idx;

    Size--;
    Idx = 0;
    J0x0E:

    // End:0x5B [Loop If]
    if(Idx < m_teamMembers.Length)
    {
        // End:0x51
        if(m_teamMembers[Idx] == Other)
        {
            RemoveFromSquad(Other);
            m_teamMembers.Remove(Idx, 1);
            // [Explicit Break]
            goto J0x5B;
        }
        Idx++;
        // [Loop Continue]
        goto J0x0E;
    }
    J0x5B:

    //return;    
}

function UpdateSquads()
{
    local int squadIdx;
    local SPSquad SPSquad;
    local array<SPSquad> deleteSquad;
    local SPSquad defaultSquad;

    defaultSquad = GetSquadByName('Default', squadIdx, true);
    squadIdx = 0;
    J0x26:

    // End:0xBE [Loop If]
    if(squadIdx < m_squads.Length)
    {
        SPSquad = m_squads[squadIdx];
        // End:0x9B
        if((!SPSquad.bDeleteMe && SPSquad != defaultSquad) && SPSquad.IsSafeToDelete())
        {
            deleteSquad[deleteSquad.Length] = SPSquad;
            // [Explicit Continue]
            goto J0xB4;
        }
        SPSquad.Update(m_squadUpdateRate);
        J0xB4:

        squadIdx++;
        // [Loop Continue]
        goto J0x26;
    }
    squadIdx = 0;
    J0xC5:

    // End:0x11F [Loop If]
    if(squadIdx < deleteSquad.Length)
    {
        SPSquad = deleteSquad[squadIdx];
        // End:0x115
        if((SPSquad != none) && !SPSquad.bDeleteMe)
        {
            SPSquad.Destroy();
        }
        squadIdx++;
        // [Loop Continue]
        goto J0xC5;
    }
    //return;    
}

event BroadcastNotifyEnemy(SPAIController notifier, Controller NewEnemy)
{
    local SPSquad SPSquad;

    SPSquad = GetMemberSquad(notifier);
    // End:0x40
    if(SPSquad != none)
    {
        SPSquad.BroadcastNotifyEnemy(notifier, NewEnemy);
    }
    //return;    
}

function BroadcastSquadAIEvent(SPAIController notifier, name squadEvent)
{
    local SPSquad SPSquad;

    SPSquad = GetMemberSquad(notifier);
    // End:0x40
    if(SPSquad != none)
    {
        SPSquad.BroadcastSquadAIEvent(notifier, squadEvent);
    }
    //return;    
}

function AdjustMorale(name squadName, float Adjustment)
{
    local SPSquad SPSquad;

    SPSquad = GetSquadByName(squadName);
    // End:0x3B
    if(SPSquad != none)
    {
        SPSquad.AdjustMorale(Adjustment);
    }
    //return;    
}

function NotifyKilled(Controller Killer, Controller Killed, Pawn KilledPawn)
{
    // End:0x3B
    if((Killed != none) && Killed.PlayerReplicationInfo.Team == self)
    {
        RemoveFromSquad(Killed);
    }
    //return;    
}

function NotifyTakeDamage(Controller Victim, Controller cInstigator)
{
    local SPSquad SPSquad;

    SPSquad = GetMemberSquad(Victim);
    // End:0x40
    if(SPSquad != none)
    {
        SPSquad.NotifyDamagedReceived(Victim, cInstigator);
    }
    SPSquad = GetMemberSquad(cInstigator);
    // End:0x80
    if(SPSquad != none)
    {
        SPSquad.NotifyDamageGiven(Victim, cInstigator);
    }
    //return;    
}

function bool CanIssueCommandsToSquad(name squadName)
{
    // End:0x15
    if(squadName == 'Default')
    {
        return false;
    }
    return true;
    //return ReturnValue;    
}

function ClearSquadCommand(name squadName)
{
    local SPSquad SPSquad;
    local int tmpIdx;

    // End:0x16
    if(!CanIssueCommandsToSquad(squadName))
    {
        return;
    }
    SPSquad = GetSquadByName(squadName, tmpIdx, true);
    // End:0x50
    if(SPSquad != none)
    {
        SPSquad.ClearSquadCommandToAllMembers();
    }
    //return;    
}

function IssueMaxAggressiveUnitsInSquad(name squadName, int maxAggressiveUnit, bool bUseGameplayDataDefaultValue)
{
    local SPSquad SPSquad;

    // End:0x16
    if(!CanIssueCommandsToSquad(squadName))
    {
        return;
    }
    SPSquad = GetSquadByName(squadName);
    // End:0x57
    if(SPSquad != none)
    {
        SPSquad.SetMaxAggressiveUnitsInSquad(maxAggressiveUnit, bUseGameplayDataDefaultValue);
    }
    //return;    
}

function IssueCommandDefendAreaToSquad(name squadName, SquadCommandDefendArea_Params Param)
{
    local SPSquad SPSquad;

    // End:0x16
    if(!CanIssueCommandsToSquad(squadName))
    {
        return;
    }
    SPSquad = GetSquadByName(squadName);
    // End:0x51
    if(SPSquad != none)
    {
        SPSquad.SetDefendAreaSquadCommand(Param);
    }
    //return;    
}
