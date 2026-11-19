class R6SinglePlayerGame extends R6GameInfo
    native
    config(Game)
    hidecategories(lighting,Movement,Collision);

var /*0x04000000-0x00000000*/ const SoundCue m_EndCreditsMusic;
var /*0x04000000-0x00000000*/ const SoundCue m_EndCreditsVO;

simulated function bool CanThrowWeapon(Pawn P)
{
    return P.Weapon != none;
    return;
}

function ResetGameInfo()
{
    ResetGameInfo();
    GotoState('PendingMatch');
    return;
}

// Export UR6SinglePlayerGame::execOnObjectiveFailed(FFrame&, void* const)
native function OnObjectiveFailed(R6Objective pObjective);

function StartMatch()
{
    StartMatch();
    GameReplicationInfo.bStopCountDown = false;
    return;
}

function CreateInitialObjectives()
{
    local R6Objective pObj;

    pObj = __NFUN_278__(Class'R6ObjectivePlayerStayAlive');
    // End:0x34
    if(pObj != none)
    {
        m_ObjectiveManager.AddObjective(pObj);
    }
    pObj = __NFUN_278__(Class'R6ObjectiveRainbowTeamStayAlive');
    // End:0x68
    if(pObj != none)
    {
        m_ObjectiveManager.AddObjective(pObj);
    }
    pObj = __NFUN_278__(Class'R6ObjectiveKillCivilians');
    // End:0x9C
    if(pObj != none)
    {
        m_ObjectiveManager.AddObjective(pObj);
    }
    return;
}

function InitCharacterTemplateFromStartSpot(Pawn PawnToInit, NavigationPoint StartSpot)
{
    local R6Character CharacterToInit;
    local R6PlayerStart R6PlayerStartSpot;

    // End:0x95
    if((PawnToInit != none) && StartSpot != none)
    {
        CharacterToInit = R6Character(PawnToInit);
        R6PlayerStartSpot = R6PlayerStart(StartSpot);
        // End:0x95
        if(((CharacterToInit != none) && R6PlayerStartSpot != none) && R6PlayerStartSpot.m_PlayerCharacterTemplate != none)
        {
            CharacterToInit.m_CharacterTemplate = R6PlayerStartSpot.m_PlayerCharacterTemplate;
            CharacterToInit.GenerateRandomCharacter();
        }
    }
    return;
}

function CheckPlayIntro()
{
    DoCheckPlayIntro();
    return;
}

// Export UR6SinglePlayerGame::execDoCheckPlayIntro(FFrame&, void* const)
native final function DoCheckPlayIntro();

auto state PendingMatch
{Begin:

    StartMatch();
    stop;                
}

defaultproperties
{
    m_EndCreditsMusic=SoundCue'Dare.Music.Play_theme_M_MenuEnding'
    m_EndCreditsVO=SoundCue'Dare.VO_06Dam_PIP_14.Play_NEW_PIP_1'
    bRestartLevel=false
}