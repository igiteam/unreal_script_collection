class SPSquad extends ReplicationInfo
    native;

enum ESPSquadCommands
{
    ESPSC_SquadCommand_None,        // 0
    ESPSC_SquadCommand_DefendArea,  // 1
    ESPSC_SquadCommand_MAX          // 2
};

enum ESPSquadCommandPriority
{
    ESPCP_SquadCommandPriority_None,// 0
    ESPCP_SquadCommandPriority_Low, // 1
    ESPCP_SquadCommandPriority_Medium,// 2
    ESPCP_SquadCommandPriority_High,// 3
    ESPCP_SquadCommandPriority_MAX  // 4
};

enum ESPDefendAreaDestAssignment
{
    ESPSDDA_DefensivePositions,     // 0
    ESPSDDA_ForwardPositions,       // 1
    ESPSDDA_AnyPositions,           // 2
    ESPSDDA_MAX                     // 3
};

enum ESPDefendAreaZones
{
    ESPDAZ_Front,                   // 0
    ESPDAZ_Right,                   // 1
    ESPDAZ_Left,                    // 2
    ESPDAZ_Back,                    // 3
    ESPDAZ_Maximus,                 // 4
    ESPDAZ_MAX                      // 5
};

struct native SPNeighborhoodRating
{
    var int VertexGraphID;
    var float RatingValue;
    var bool bExcluded;

    structdefaultproperties
    {
        VertexGraphID=0
        RatingValue=0.0000000
        bExcluded=false
    }
};

struct SquadCommandDefendArea_Params
{
    var Volume defendAreaVolume;
    var Actor defendAreaTarget;
    var SPSquad.ESPSquadCommandPriority commandPriority;
    var SPSquad.ESPDefendAreaDestAssignment destAssignment;
    var float AttackDistWhileDefendingArea;
    var float attackHeightCheckWhileDefendingArea;

    structdefaultproperties
    {
        defendAreaVolume=none
        defendAreaTarget=none
        commandPriority=ESPCP_SquadCommandPriority_None
        destAssignment=ESPSDDA_DefensivePositions
        AttackDistWhileDefendingArea=0.0000000
        attackHeightCheckWhileDefendingArea=0.0000000
    }
};

struct native DefendAreaZoneInfo
{
    var SPSquad.ESPDefendAreaZones eZoneIdx;
    var int numOccupiedCover;
    var int numOccupiedNonCoverNodes;

    structdefaultproperties
    {
        eZoneIdx=ESPDAZ_Front
        numOccupiedCover=0
        numOccupiedNonCoverNodes=0
    }
};

struct native InvalidatedCoverEntry
{
    var SPCoverNode CoverNode;
    var float EndInvalidTime;

    structdefaultproperties
    {
        CoverNode=none
        EndInvalidTime=0.0000000
    }
};

struct native RoamingLocation
{
    var Vector Location;
    var SPAIController ClaimOwner;

    structdefaultproperties
    {
        Location=(X=0.0000000,Y=0.0000000,Z=0.0000000)
        ClaimOwner=none
    }
};

var name m_squadName;
var SPTeamInfo m_team;
var array<Controller> m_members;
var float m_morale;
var array<int> m_damageReceivedCount;
var array<int> m_damageGivenCount;
var float m_damageReceivedFrequency;
var float m_damageGivenFrequency;
var array<InvalidatedCoverEntry> m_invalidCoverDueToDeath;
var SPSquad.ESPSquadCommands m_squadCommand;
var SPSquad.ESPSquadCommandPriority m_squadCommandPriority;
var SPSquad.ESPDefendAreaDestAssignment m_defendAreaDestAssignment;
var SPKynapseLevelData.AITypes m_eAIType;
var Volume m_defendAreaVolume;
var Actor m_defendAreaTarget;
var int m_defendAreaTargetVertexID;
var array<int> m_defendAreaVerts;
var array<SPNeighborhoodRating> m_defendAreaNeighborhoodRatingArray;
var array<DefendAreaZoneInfo> m_defendAreaZoneInfo;
var Vector m_defendAreaTargetLastLoc;
var Vector m_defendAreaTargetOrientationLastLoc;
var Vector m_defendAreaTargetDynamicOrientation;
var float m_attackDistWhileDefendingArea;
var float m_attackHeightCheckWhileDefendingArea;
var bool m_bUpdateEnemiesInDefendArea;
var transient bool bUsingAbsoluteDiscrimination;
var transient bool bUsingAbsolutePreferrence;
var array<Controller> m_enemiesInDefendArea;
var float m_lastUpdateEnemiesInDefendAreaTime;
var transient array<name> DiscriminatedSquads;
var transient array<name> PreferredSquads;
var transient int m_defendAreaTargetNumNeighborhoodEntries;
var array<RoamingLocation> m_RoamingLocations;

// Export USPSquad::execIsSquadDefendingArea(FFrame&, void* const)
native function bool IsSquadDefendingArea();

// Export USPSquad::execIsActorInDefendArea(FFrame&, void* const)
native function bool IsActorInDefendArea(Actor chkActor, optional bool bNoIsDefendAreaCheck);

// Export USPSquad::execIsLocationInDefendArea(FFrame&, void* const)
native function bool IsLocationInDefendArea(const out Vector chkLocation, optional bool bNoIsDefendAreaCheck);

// Export USPSquad::execGetKynapseVertsInDefendArea(FFrame&, void* const)
native function bool GetKynapseVertsInDefendArea();

// Export USPSquad::execResetDefendAreaNeighborhoodRatings(FFrame&, void* const)
native function ResetDefendAreaNeighborhoodRatings();

// Export USPSquad::execGetDefendAreaExtents(FFrame&, void* const)
native function Vector GetDefendAreaExtents();

// Export USPSquad::execGetDefendAreaCentroid(FFrame&, void* const)
native function bool GetDefendAreaCentroid(out Vector centroid);

// Export USPSquad::execUpdateEnemiesInDefendArea(FFrame&, void* const)
native function UpdateEnemiesInDefendArea();

// Export USPSquad::execPreferSquad(FFrame&, void* const)
native function PreferSquad(name preferredSquadName);

// Export USPSquad::execDiscriminateSquad(FFrame&, void* const)
native function DiscriminateSquad(name discriminatedSquadName);

// Export USPSquad::execSetAbsolutePreference(FFrame&, void* const)
native function SetAbsolutePreference(bool t_or_f);

// Export USPSquad::execSetAbsoluteDiscrimination(FFrame&, void* const)
native function SetAbsoluteDiscrimination(bool t_or_f);

// Export USPSquad::execClearSquadTargettingBias(FFrame&, void* const)
native function ClearSquadTargettingBias();

// Export USPSquad::execInitDefendAreaTarget(FFrame&, void* const)
native function InitDefendAreaTarget();

// Export USPSquad::execUpdateDefendAreaTargetInfo(FFrame&, void* const)
native function UpdateDefendAreaTargetInfo();

// Export USPSquad::execGetWorldInfo(FFrame&, void* const)
native static final function WorldInfo GetWorldInfo();

// Export USPSquad::execIsCoverInvalidDueToDeath(FFrame&, void* const)
native final function bool IsCoverInvalidDueToDeath(SPCoverNode Cover);

// Export USPSquad::execInvalidateCoverDueToDeath(FFrame&, void* const)
native final function InvalidateCoverDueToDeath(SPCoverNode Cover, float Duration);

// Export USPSquad::execAddRoamingPoint(FFrame&, void* const)
native final function AddRoamingPoint(const out Vector roamPoint);

// Export USPSquad::execRemoveRoamingPoint(FFrame&, void* const)
native final function RemoveRoamingPoint(const out Vector roamPoint);

// Export USPSquad::execIsRoamingPoint(FFrame&, void* const)
native final function bool IsRoamingPoint(const out Vector roamPoint);

// Export USPSquad::execFindRoamingPoint(FFrame&, void* const)
native final function bool FindRoamingPoint(SPAIController C, bool bRespectDefendArea, float minimumMoveDistance, bool bAutoClaimSpot, out Vector roamPoint);

// Export USPSquad::execUnclaimRoamingPoint(FFrame&, void* const)
native final function UnclaimRoamingPoint(SPAIController C, const out Vector roamPoint);

function OnSetGriffonAttackType(SeqAct_SetGriffonAttackType Action)
{
    //return;    
}

// Export USPSquad::execSPAILog(FFrame&, void* const)
native final function SPAILog(name logCategory, string LogText);

function Initialize(name squadName, SPTeamInfo Team)
{
    // End:0x32
    if((m_team != none) && m_team != Team)
    {
        m_team.RemoveSquad(self);
    }
    m_team = Team;
    m_squadName = squadName;
    //return;    
}

simulated function Destroyed()
{
    local int Idx;
    local SPAIController spController;

    // End:0x24
    if(m_team != none)
    {
        m_team.RemoveSquad(self);        
    }
    Idx = 0;
    J0x2B:

    // End:0x93 [Loop If]
    if(Idx < m_members.Length)
    {
        spController = SPAIController(m_members[Idx]);
        // End:0x89
        if((spController != none) && spController.m_squad == self)
        {
            spController.SetSquad(none);
        }
        Idx++;
        // [Loop Continue]
        goto J0x2B;
    }
    super(Actor).Destroyed();
    //return;    
}

function bool IsSafeToDelete()
{
    // End:0x4A
    if(((((m_members.Length == 0) && int(m_squadCommand) == int(0)) && DiscriminatedSquads.Length == 0) && PreferredSquads.Length == 0) && m_RoamingLocations.Length == 0)
    {
        return true;
    }
    return false;
    //return ReturnValue;    
}

function bool AddSquadMember(Controller newMember)
{
    local int Idx;
    local SPAIController spController;
    local Controller curMember;
    local PandoraPlayerController playaController;

    // End:0x0D
    if(newMember == none)
    {
        return false;
    }
    // End:0x32
    if(m_team != newMember.PlayerReplicationInfo.Team)
    {
        return false;
    }
    // End:0x168
    if(!IsAMember(newMember))
    {
        m_members[m_members.Length] = newMember;
        spController = SPAIController(newMember);
        // End:0x8D
        if(spController != none)
        {
            spController.SetSquad(self);            
        }
        else
        {
            playaController = PandoraPlayerController(newMember);
            // End:0xBE
            if(playaController != none)
            {
                playaController.SetSquad(self);
            }
        }
        Idx = 0;
        J0xC5:

        // End:0x159 [Loop If]
        if(Idx < m_members.Length)
        {
            curMember = m_members[Idx];
            // End:0x14F
            if(curMember != newMember)
            {
                // End:0x119
                if(spController != none)
                {
                    spController.NotifyNewSquadMember(curMember);
                }
                // End:0x14F
                if(curMember.IsA('SPAIController'))
                {
                    SPAIController(curMember).NotifyNewSquadMember(newMember);
                }
            }
            Idx++;
            // [Loop Continue]
            goto J0xC5;
        }
        IssueSquadCommandToMember(newMember);
    }
    return true;
    //return ReturnValue;    
}

function bool RemoveSquadMember(Controller removeMember, optional bool bNoReferenceCheck)
{
    local int Idx;
    local SPAIController spController;

    // End:0x8E
    if(IsAMember(removeMember, Idx))
    {
        ClearSquadCommandToMember(removeMember);
        // End:0x80
        if(!bNoReferenceCheck)
        {
            spController = SPAIController(m_members[Idx]);
            // End:0x80
            if((spController != none) && spController.m_squad == self)
            {
                spController.SetSquad(none, true);
            }
        }
        m_members.Remove(Idx, 1);
        return true;
    }
    return false;
    //return ReturnValue;    
}

// Export USPSquad::execIsAMember(FFrame&, void* const)
native function bool IsAMember(Controller chkMember, optional out int idxOut);

function bool HasSquadMembers(Controller chkMember)
{
    local int Idx;

    Idx = 0;
    J0x07:

    // End:0x38 [Loop If]
    if(Idx < m_members.Length)
    {
        // End:0x2E
        if(m_members[Idx] != chkMember)
        {
            return true;
        }
        Idx++;
        // [Loop Continue]
        goto J0x07;
    }
    return false;
    //return ReturnValue;    
}

event bool GetSquadMembers(out array<Controller> squadMembers)
{
    local int Idx;

    squadMembers.Length = m_members.Length;
    Idx = 0;
    J0x14:

    // End:0x45 [Loop If]
    if(Idx < m_members.Length)
    {
        squadMembers[Idx] = m_members[Idx];
        Idx++;
        // [Loop Continue]
        goto J0x14;
    }
    return squadMembers.Length != 0;
    //return ReturnValue;    
}

function Update(float updateRate)
{
    local int Idx;

    m_damageReceivedFrequency = 0.0000000;
    // End:0x7F
    if(m_damageReceivedCount.Length > 0)
    {
        Idx = 0;
        J0x1E:

        // End:0x4C [Loop If]
        if(Idx < m_damageReceivedCount.Length)
        {
            m_damageReceivedFrequency += float(m_damageReceivedCount[Idx]);
            Idx++;
            // [Loop Continue]
            goto J0x1E;
        }
        m_damageReceivedFrequency /= (float(Idx) * updateRate);
        m_damageReceivedCount.Insert(0, 1);
        // End:0x7F
        if(m_damageReceivedCount.Length > 20)
        {
            m_damageReceivedCount.Length = 20;
        }
    }
    m_damageGivenFrequency = 0.0000000;
    // End:0xFE
    if(m_damageGivenCount.Length > 0)
    {
        Idx = 0;
        J0x9D:

        // End:0xCB [Loop If]
        if(Idx < m_damageGivenCount.Length)
        {
            m_damageGivenFrequency += float(m_damageGivenCount[Idx]);
            Idx++;
            // [Loop Continue]
            goto J0x9D;
        }
        m_damageGivenFrequency /= (float(Idx) * updateRate);
        m_damageGivenCount.Insert(0, 1);
        // End:0xFE
        if(m_damageGivenCount.Length > 20)
        {
            m_damageGivenCount.Length = 20;
        }
    }
    // End:0x146
    if(int(m_squadCommand) == int(1))
    {
        UpdateEnemiesInDefendArea();
        // End:0x131
        if(!IsSquadDefendingArea())
        {
            ClearSquadCommandToAllMembers();
        }
        // End:0x146
        if(m_defendAreaTarget != none)
        {
            UpdateDefendAreaTargetInfo();
        }
    }
    //return;    
}

function BroadcastNotifyEnemy(SPAIController notifier, Controller NewEnemy)
{
    local int Idx;
    local SPAIController squadMember;

    Idx = 0;
    J0x07:

    // End:0x71 [Loop If]
    if(Idx < m_members.Length)
    {
        squadMember = SPAIController(m_members[Idx]);
        // End:0x67
        if((squadMember != none) && squadMember != notifier)
        {
            squadMember.NotifyEnemy(notifier, NewEnemy);
        }
        Idx++;
        // [Loop Continue]
        goto J0x07;
    }
    //return;    
}

function BroadcastSquadAIEvent(SPAIController notifier, name squadEvent)
{
    local int Idx;
    local SPAIController squadMember;

    Idx = 0;
    J0x07:

    // End:0x71 [Loop If]
    if(Idx < m_members.Length)
    {
        squadMember = SPAIController(m_members[Idx]);
        // End:0x67
        if((squadMember != none) && squadMember != notifier)
        {
            squadMember.NotifySquadAIEvent(notifier, squadEvent);
        }
        Idx++;
        // [Loop Continue]
        goto J0x07;
    }
    //return;    
}

function AdjustMorale(float Adjustment)
{
    m_morale += Adjustment;
    //return;    
}

function NotifyDamagedReceived(Controller Victim, Controller cInstigator)
{
    // End:0x14
    if(m_damageReceivedCount.Length == 0)
    {
        m_damageReceivedCount.Length = 1;
    }
    m_damageReceivedCount[0]++;
    //return;    
}

function NotifyDamageGiven(Controller Victim, Controller cInstigator)
{
    // End:0x14
    if(m_damageGivenCount.Length == 0)
    {
        m_damageGivenCount.Length = 1;
    }
    m_damageGivenCount[0]++;
    //return;    
}

function MoveSquadMembersToNewSquad(SPSquad newSquad)
{
    local int Idx;
    local array<Controller> squadMembers;

    // End:0x0D
    if(newSquad == none)
    {
        return;
    }
    // End:0x1B
    if(m_members.Length == 0)
    {
        return;
    }
    // End:0x36
    if(newSquad.m_team != m_team)
    {
        return;
    }
    squadMembers.Length = m_members.Length;
    Idx = 0;
    J0x4A:

    // End:0x7B [Loop If]
    if(Idx < m_members.Length)
    {
        squadMembers[Idx] = m_members[Idx];
        Idx++;
        // [Loop Continue]
        goto J0x4A;
    }
    Idx = 0;
    J0x82:

    // End:0xBB [Loop If]
    if(Idx < squadMembers.Length)
    {
        newSquad.AddSquadMember(squadMembers[Idx]);
        Idx++;
        // [Loop Continue]
        goto J0x82;
    }
    //return;    
}

function bool IsEnemyTargettedBySquad(Pawn chkEnemy)
{
    local int Idx;
    local Controller squadMember;

    Idx = 0;
    J0x07:

    // End:0x5F [Loop If]
    if(Idx < m_members.Length)
    {
        squadMember = m_members[Idx];
        // End:0x55
        if((squadMember != none) && squadMember.GetEnemy() == chkEnemy)
        {
            return true;
        }
        Idx++;
        // [Loop Continue]
        goto J0x07;
    }
    return false;
    //return ReturnValue;    
}

// Export USPSquad::execGetNumMembersTargettingEnemy(FFrame&, void* const)
native function int GetNumMembersTargettingEnemy(Pawn chkEnemy, SPAIController Caller);

// Export USPSquad::execGetMembersTargettingEnemy(FFrame&, void* const)
native function int GetMembersTargettingEnemy(Pawn chkEnemy, out array<Controller> outMembersTargettingEnemy);

function int NumMembers()
{
    local int Idx, Count;

    Count = 0;
    Idx = 0;
    J0x0E:

    // End:0xA5 [Loop If]
    if(Idx < m_members.Length)
    {
        // End:0x9B
        if(m_members[Idx] != none)
        {
            // End:0x9B
            if(m_members[Idx].Pawn != none)
            {
                // End:0x9B
                if(!m_members[Idx].Pawn.IsPendingKill())
                {
                    // End:0x9B
                    if(m_members[Idx].Pawn.Health > 0)
                    {
                        Count++;
                    }
                }
            }
        }
        Idx++;
        // [Loop Continue]
        goto J0x0E;
    }
    return Count;
    //return ReturnValue;    
}

function IssueSquadCommandToAllMembers()
{
    local int Idx;

    Idx = 0;
    J0x07:

    // End:0x36 [Loop If]
    if(Idx < m_members.Length)
    {
        IssueSquadCommandToMember(m_members[Idx]);
        Idx++;
        // [Loop Continue]
        goto J0x07;
    }
    //return;    
}

function ClearSquadCommandToAllMembers()
{
    local int Idx;

    Idx = 0;
    J0x07:

    // End:0x36 [Loop If]
    if(Idx < m_members.Length)
    {
        ClearSquadCommandToMember(m_members[Idx]);
        Idx++;
        // [Loop Continue]
        goto J0x07;
    }
    switch(m_squadCommand)
    {
        // End:0x50
        case 1:
            ClearDefendAreaSquadCommand();
            // End:0x56
            break;
        // End:0xFFFF
        default:
            // End:0x56
            break;
            break;
    }
    //return;    
}

function IssueSquadCommandToMember(Controller member)
{
    switch(m_squadCommand)
    {
        // End:0x1F
        case 1:
            IssueDefendAreaSquadCommandToMember(member);
            // End:0x25
            break;
        // End:0xFFFF
        default:
            // End:0x25
            break;
            break;
    }
    //return;    
}

function ClearSquadCommandToMember(Controller member)
{
    switch(m_squadCommand)
    {
        // End:0x1F
        case 1:
            ClearDefendAreaSquadCommandToMember(member);
            // End:0x25
            break;
        // End:0xFFFF
        default:
            // End:0x25
            break;
            break;
    }
    //return;    
}

function SetMaxAggressiveUnitsInSquad(int maxAggressiveUnit, bool bUseGameplayDataDefaultValue)
{
    //return;    
}

function bool DoesSquadRequireAdvancedNoticeOfEnemiesInDefendArea(SPSquad.ESPSquadCommandPriority commandPriority)
{
    return false;
    //return ReturnValue;    
}

function bool CanDefendGenericActor()
{
    return false;
    //return ReturnValue;    
}

function SetDefendAreaSquadCommand(SquadCommandDefendArea_Params Param)
{
    // End:0x8A
    if(((((int(m_squadCommand) == int(1)) && int(Param.commandPriority) == int(m_squadCommandPriority)) && Param.defendAreaVolume == m_defendAreaVolume) && int(Param.destAssignment) == int(m_defendAreaDestAssignment)) && Param.defendAreaTarget == m_defendAreaTarget)
    {
        return;
    }
    // End:0xB3
    if((Param.defendAreaVolume == none) && !CanDefendGenericActor())
    {
        return;
    }
    ClearSquadCommandToAllMembers();
    m_squadCommand = 1;
    m_squadCommandPriority = Param.commandPriority;
    m_defendAreaVolume = Param.defendAreaVolume;
    m_defendAreaDestAssignment = Param.destAssignment;
    m_attackDistWhileDefendingArea = Param.AttackDistWhileDefendingArea;
    m_attackHeightCheckWhileDefendingArea = Param.attackHeightCheckWhileDefendingArea;
    m_defendAreaTarget = Param.defendAreaTarget;
    m_bUpdateEnemiesInDefendArea = DoesSquadRequireAdvancedNoticeOfEnemiesInDefendArea(Param.commandPriority);
    m_enemiesInDefendArea.Length = 0;
    m_defendAreaTargetVertexID = -1;
    // End:0x192
    if(m_defendAreaTarget != none)
    {
        InitDefendAreaTarget();
    }
    GetKynapseVertsInDefendArea();
    IssueSquadCommandToAllMembers();
    //return;    
}

function ClearDefendAreaSquadCommand()
{
    m_squadCommand = 0;
    m_squadCommandPriority = 0;
    m_defendAreaVolume = none;
    m_defendAreaDestAssignment = 0;
    m_attackDistWhileDefendingArea = 3000.0000000;
    m_bUpdateEnemiesInDefendArea = false;
    m_enemiesInDefendArea.Length = 0;
    m_defendAreaTarget = none;
    m_defendAreaTargetVertexID = -1;
    m_defendAreaTargetNumNeighborhoodEntries = 0;
    m_defendAreaTargetLastLoc.X = 100000.0000000;
    m_defendAreaTargetLastLoc.Y = 100000.0000000;
    m_defendAreaTargetLastLoc.Z = 100000.0000000;
    m_defendAreaTargetOrientationLastLoc.X = 100000.0000000;
    m_defendAreaTargetOrientationLastLoc.Y = 100000.0000000;
    m_defendAreaTargetOrientationLastLoc.Z = 100000.0000000;
    ClearDefendAreaZoneInfo();
    //return;    
}

function IssueDefendAreaSquadCommandToMember(Controller member)
{
    local SPAIController spAI;
    local SquadCommandDefendArea_Params Param;

    spAI = SPAIController(member);
    // End:0xBA
    if(spAI != none)
    {
        Param.defendAreaVolume = m_defendAreaVolume;
        Param.defendAreaTarget = m_defendAreaTarget;
        Param.commandPriority = m_squadCommandPriority;
        Param.destAssignment = m_defendAreaDestAssignment;
        Param.AttackDistWhileDefendingArea = m_attackDistWhileDefendingArea;
        Param.attackHeightCheckWhileDefendingArea = m_attackHeightCheckWhileDefendingArea;
        spAI.SetDefendAreaSquadCommand(1, Param);
    }
    //return;    
}

function ClearDefendAreaSquadCommandToMember(Controller member)
{
    local SPAIController spAI;

    spAI = SPAIController(member);
    // End:0x2F
    if(spAI != none)
    {
        spAI.ClearDefendAreaSquadCommand();
    }
    //return;    
}

function bool GetDefendAreaLocation(out Vector Loc)
{
    // End:0x52
    if(IsSquadDefendingArea())
    {
        // End:0x32
        if(m_defendAreaVolume != none)
        {
            Loc = m_defendAreaVolume.Location;
            return true;            
        }
        else
        {
            // End:0x52
            if(m_defendAreaTarget != none)
            {
                Loc = m_defendAreaTarget.Location;
            }
        }
    }
    return false;
    //return ReturnValue;    
}

function string GetDefendAreaName()
{
    // End:0x50
    if(IsSquadDefendingArea())
    {
        // End:0x30
        if(m_defendAreaVolume != none)
        {
            return m_defendAreaVolume.GetDebugName();            
        }
        else
        {
            // End:0x50
            if(m_defendAreaTarget != none)
            {
                return m_defendAreaTarget.GetDebugName();
            }
        }
    }
    return "None";
    //return ReturnValue;    
}

event ClearDefendAreaZoneInfo()
{
    local int Idx;

    Idx = 0;
    J0x07:

    // End:0x51 [Loop If]
    if(Idx < m_defendAreaZoneInfo.Length)
    {
        m_defendAreaZoneInfo[Idx].numOccupiedCover = 0;
        m_defendAreaZoneInfo[Idx].numOccupiedNonCoverNodes = 0;
        Idx++;
        // [Loop Continue]
        goto J0x07;
    }
    //return;    
}

function UpdateDefendAreaNodes()
{
    //return;    
}

// Export USPSquad::execPickDefendAreaDestinationForMember(FFrame&, void* const)
native function bool PickDefendAreaDestinationForMember(Controller member, optional bool bNoCoverPos);

function SPCoverNode PickCoverInDefAreaForMember(SPAIController spAI, float defAreaRad, Vector defAreaCentroid, Vector rotAxisAt, Vector rotAxisRight, Vector rotAxisUp)
{
    return none;
    //return ReturnValue;    
}

static event ClearSquadCommandsForAllSquads(optional bool bRemoveAllMembers = false)
{
    local int teamIdx, squadIdx;
    local SPTeamInfo SPTeamInfo;
    local SPSquad SPSquad;
    local PandoraGameInfo spGameInfo;
    local WorldInfo spWorldInfo;

    spWorldInfo = GetWorldInfo();
    // End:0x1E
    if(spWorldInfo == none)
    {
        return;
    }
    spGameInfo = PandoraGameInfo(spWorldInfo.Game);
    // End:0x45
    if(spGameInfo == none)
    {
        return;
    }
    teamIdx = 0;
    J0x4C:

    // End:0xEB [Loop If]
    if(teamIdx < spGameInfo.m_teams.Length)
    {
        SPTeamInfo = spGameInfo.m_teams[teamIdx];
        squadIdx = 0;
        J0x88:

        // End:0xE1 [Loop If]
        if(squadIdx < SPTeamInfo.m_squads.Length)
        {
            SPSquad = SPTeamInfo.m_squads[squadIdx];
            SPSquad.ClearSquadCommands(bRemoveAllMembers);
            squadIdx++;
            // [Loop Continue]
            goto J0x88;
        }
        teamIdx++;
        // [Loop Continue]
        goto J0x4C;
    }
    //return;    
}

event ClearSquadCommands(optional bool bRemoveAllMembers = false)
{
    ClearSquadTargettingBias();
    ClearDefendAreaSquadCommand();
    // End:0x43
    if(bRemoveAllMembers)
    {
        J0x22:

        // End:0x43 [Loop If]
        if(m_members.Length > 0)
        {
            RemoveSquadMember(m_members[0], true);
            // [Loop Continue]
            goto J0x22;
        }
    }
    //return;    
}
