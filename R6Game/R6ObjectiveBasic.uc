class R6ObjectiveBasic extends R6Objective
    native
    hidecategories(lighting,Movement,Collision);

var string m_sFailureDescId;

// Export UR6ObjectiveBasic::execGetDescription(FFrame&, void* const)
native function GetDescription(out string Desc);

// Export UR6ObjectiveBasic::execGetDescriptionNoLoc(FFrame&, void* const)
native function GetDescriptionNoLoc(out string out_Desc);

// Export UR6ObjectiveBasic::execGetFailureReason(FFrame&, void* const)
native function bool GetFailureReason(out R6MissionFailedInfo out_Info);

event float GetFailureWaitTime()
{
    return 0.0000000;
    return;
}

event bool GetOptionalParamString(out string strParam)
{
    return false;
    return;
}

event Destroyed()
{
    R6GameInfo(WorldInfo.Game).m_ObjectiveManager.UnRegisterObjective(self);
    Destroyed();
    return;
}

event SetSuccess()
{
    // End:0x2C
    if(R6GameInfo(WorldInfo.Game).m_ObjectiveManager.IsMissionFailed())
    {
        return;
    }
    m_eStatus = 2;
    R6GameInfo(WorldInfo.Game).OnObjectiveSucceeded(self);
    return;
}

event SetFailure()
{
    R6GameInfo(WorldInfo.Game).m_ObjectiveManager.CheckMissionFailure(self);
    m_eStatus = 3;
    R6GameInfo(WorldInfo.Game).OnObjectiveFailed(self);
    return;
}

event EnableSelf()
{
    R6GameInfo(WorldInfo.Game).m_ObjectiveManager.RegisterObjective(self);
    R6GameInfo(WorldInfo.Game).OnObjectiveRegistered(self);
    return;
}

event DisableSelf()
{
    R6GameInfo(WorldInfo.Game).m_ObjectiveManager.UnRegisterObjective(self);
    return;
}

function ZoneEntered(R6ExtractionZone PZone, R6Pawn pPawn)
{
    return;
}

function ZoneExited(R6ExtractionZone PZone, R6Pawn pPawn)
{
    return;
}

defaultproperties
{
    bNoDelete=true
}