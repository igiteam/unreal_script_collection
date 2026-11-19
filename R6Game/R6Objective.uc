class R6Objective extends Info
    abstract
    native
    notplaceable
    hidecategories(lighting,Movement,Collision);

enum EObjectiveStatus
{
    STATUS_NONE,                    // 0
    STATUS_IDLE,                    // 1
    STATUS_SUCCESS,                 // 2
    STATUS_FAILURE,                 // 3
    STATUS_MAX                      // 4
};

var() bool m_bHiddenInManager;
var() bool m_bGameOverIfFailed;
var SeqVar_R6Objective m_pKismetVar;
var R6Objective.EObjectiveStatus m_eStatus;

// Export UR6Objective::execUpdate(FFrame&, void* const)
native function Update(float fDeltaTime);

// Export UR6Objective::execGetDescription(FFrame&, void* const)
native function GetDescription(out string Desc);

// Export UR6Objective::execGetDescriptionNoLoc(FFrame&, void* const)
native function GetDescriptionNoLoc(out string out_Desc);

// Export UR6Objective::execGetFailureReason(FFrame&, void* const)
native event bool GetFailureReason(out R6MissionFailedInfo out_Info);

event PreBeginPlay()
{
    PreBeginPlay();
    m_eStatus = 1;
    return;
}

event Destroyed()
{
    return;
}

event SetSuccess()
{
    return;
}

event SetFailure()
{
    return;
}

event EnableSelf()
{
    return;
}

event DisableSelf()
{
    return;
}

function PawnDied(Pawn deadPawn, Controller Killer)
{
    return;
}

function SaveOriginalData()
{
    SaveOriginalData();
    return;
}

function ResetOriginalData()
{
    m_eStatus = 1;
    ResetOriginalData();
    return;
}

simulated function byte GetTeamNum()
{
    return byte(255);
    return;
}

event SetTeamNum(byte u8TeamNum)
{
    return;
}

defaultproperties
{
    bHiddenEd=true
    m_bDeleteOnReset=false
    Components=none
    TickGroup=1
    SupportedEvents=none
}