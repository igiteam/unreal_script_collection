class R6ObjectiveBasicMP extends R6ObjectiveBasic
    native
    hidecategories(lighting,Movement,Collision);

var const localized string m_szTeamDescription[2];
var R6GameEnums.ETEAMIDENTITY m_eTeamNumber;
var int m_iScore;
var int m_iScoreFailure;
var PlayerReplicationInfo m_pScorer;
var const localized string m_szDescription;
var const localized string m_szMsgSuccess;
var const localized string m_szMsgFailure;

function ResetOriginalData()
{
    m_pScorer = none;
    ResetOriginalData();
    return;
}

simulated function byte GetTeamNum()
{
    return m_eTeamNumber;
    return;
}

event SetTeamNum(byte u8TeamNum)
{
    m_eTeamNumber = u8TeamNum;
    return;
}

function int GetTimer()
{
    return;
}

function OnTaken(R6CarriedObject pObject)
{
    return;
}

function OnDropped(R6CarriedObject pObject)
{
    return;
}

function OnRespawned(R6CarriedObject pObject)
{
    return;
}

function OnExploded(R6InteractiveBomb pBomb)
{
    return;
}

function OnInteracted(R6InteractiveActor pActor, Pawn pPawn, bool bSuccess)
{
    return;
}

function OnPawnInteracted(R6Pawn pPawn, Pawn pInteractor, bool bSuccess)
{
    return;
}

function OnHostagesSpawned()
{
    return;
}

defaultproperties
{
    m_eTeamNumber=2
    m_iScore=1
    bNoDelete=false
}