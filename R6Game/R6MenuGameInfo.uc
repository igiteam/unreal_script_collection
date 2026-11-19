class R6MenuGameInfo extends R6GameInfo
    native
    config(Game)
    hidecategories(lighting,Movement,Collision);

event InitGame(string Options, out string ErrorMessage)
{
    InitGame(Options, ErrorMessage);
    return;
}

event PostLogin(PlayerController NewPlayer)
{
    local R6PlayerController PlayerCtrl;

    PlayerCtrl = R6PlayerController(NewPlayer);
    PlayerCtrl.m_R6PlayerCamera.ForceCameraMode(2);
    PostLogin(NewPlayer);
    return;
}

function PostBeginPlay()
{
    PostBeginPlay();
    return;
}

function ResetGameInfo()
{
    ResetGameInfo();
    GotoState('PendingMatch');
    return;
}

auto state PendingMatch
{Begin:

    StartMatch();
    stop;                
}

defaultproperties
{
    m_bAllowIncapacitation=false
    bRestartLevel=false
    DefaultPawnClass=Class'R6MenuPawn'
    GameName="MENUGAMESIMULATION"
    GameMessageClass=Class'R6GameMessage'
    PlayerControllerClass=Class'R6MenuPlayerController'
}