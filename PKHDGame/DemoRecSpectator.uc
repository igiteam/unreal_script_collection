class DemoRecSpectator extends UTPlayerController
    config(Game)
    hidecategories(Navigation);

var bool bFindPlayer;
var config bool bLockRotationToViewTarget;
var config bool bAutoSwitchPlayers;
var PlayerReplicationInfo MyRealViewTarget;
var config float AutoSwitchPlayerInterval;

simulated event PostBeginPlay()
{
    super(PlayerController).PostBeginPlay();
    // End:0x3A
    if(PlayerReplicationInfo != none)
    {
        PlayerReplicationInfo.bOutOfLives = true;
    }
    //return;    
}

simulated event ReceivedPlayer()
{
    super.ReceivedPlayer();
    // End:0x81
    if((int(Role) == int(ROLE_Authority)) && WorldInfo.Game != none)
    {
        ClientSetHUD(WorldInfo.Game.HUDType);
    }
    //return;    
}

function InitPlayerReplicationInfo()
{
    super(Controller).InitPlayerReplicationInfo();
    PlayerReplicationInfo.PlayerName = "DemoRecSpectator";
    PlayerReplicationInfo.bIsSpectator = true;
    PlayerReplicationInfo.bOnlySpectator = true;
    PlayerReplicationInfo.bOutOfLives = true;
    PlayerReplicationInfo.bWaitingPlayer = false;
    //return;    
}

exec function Slomo(float NewTimeDilation)
{
    WorldInfo.DemoPlayTimeDilation = NewTimeDilation;
    //return;    
}

exec function ViewClass(class<Actor> aClass, optional bool bQuiet, optional bool bCheat)
{
    local Actor Other, first;
    local bool bFound;

    first = none;
    // End:0x8B
    foreach AllActors(aClass, Other)
    {
        // End:0x67
        if(bFound || first == none)
        {
            first = Other;
            // End:0x67
            if(bFound)
            {
                // End:0x8B
                break;
            }
        }
        // End:0x8A
        if(Other == ViewTarget)
        {
            bFound = true;
        }        
    }    
    // End:0xC8
    if(first != none)
    {
        SetViewTarget(first);
        SetBehindView(ViewTarget != self);        
    }
    else
    {
        SetViewTarget(self);
    }
    //return;    
}

exec function DemoViewNextPlayer()
{
    local Pawn P, Pick;
    local bool bFound;

    // End:0xF0
    foreach WorldInfo.AllPawns(Class'Engine.Pawn', P)
    {
        // End:0xEF
        if(P.PlayerReplicationInfo != none)
        {
            // End:0x7C
            if(Pick == none)
            {
                Pick = P;
            }
            // End:0xA2
            if(bFound)
            {
                Pick = P;
                // End:0xF0
                break;
                // End:0xEF
                continue;
            }
            bFound = (RealViewTarget == P.PlayerReplicationInfo) || ViewTarget == P;
        }        
    }    
    SetViewTarget(Pick);
    //return;    
}

function SetViewTarget(Actor NewViewTarget, optional ViewTargetTransitionParams TransitionParams)
{
    super.SetViewTarget(NewViewTarget, TransitionParams);
    // End:0x3F
    if(NewViewTarget != self)
    {
        MyRealViewTarget = RealViewTarget;
    }
    //return;    
}

unreliable server function ServerViewSelf(optional ViewTargetTransitionParams TransitionParams)
{
    super.ServerViewSelf(TransitionParams);
    MyRealViewTarget = none;
    //return;    
}

reliable client simulated function ClientSetRealViewTarget(PlayerReplicationInfo NewTarget)
{
    SetViewTarget(self);
    RealViewTarget = NewTarget;
    MyRealViewTarget = NewTarget;
    bFindPlayer = NewTarget == none;
    //return;    
}

function bool SetPause(bool bPause, optional delegate<CanUnpause> CanUnpauseDelegate = CanUnpause)
{
    // End:0x7B
    if(int(WorldInfo.NetMode) == int(NM_Client))
    {
        WorldInfo.Pauser = ((bPause) ? PlayerReplicationInfo : none);
        return true;        
    }
    else
    {
        return false;
    }
    //return ReturnValue;    
}

exec function Pause()
{
    // End:0x33
    if(int(WorldInfo.NetMode) == int(NM_Client))
    {
        ServerPause();
    }
    //return;    
}

simulated event GetPlayerViewPoint(out Vector CameraLocation, out Rotator CameraRotation)
{
    bFreeCamera = !bLockRotationToViewTarget && bBehindView || Vehicle(ViewTarget) != none;
    super.GetPlayerViewPoint(CameraLocation, CameraRotation);
    //return;    
}

function UpdateRotation(float DeltaTime)
{
    local Rotator NewRotation;

    // End:0x31
    if(bLockRotationToViewTarget)
    {
        SetRotation(ViewTarget.Rotation);        
    }
    else
    {
        super.UpdateRotation(DeltaTime);
    }
    // End:0xA3
    if(Rotation.Roll != 0)
    {
        NewRotation = Rotation;
        NewRotation.Roll = 0;
        SetRotation(NewRotation);
    }
    //return;    
}

auto state Spectating
{
    function BeginState(name PreviousStateName)
    {
        super.BeginState(PreviousStateName);
        // End:0x37
        if(bAutoSwitchPlayers)
        {
            SetTimer(AutoSwitchPlayerInterval, true, 'DemoViewNextPlayer');
        }
        //return;        
    }

    exec function StartFire(optional byte FireModeNum)
    {
        SetBehindView(true);
        DemoViewNextPlayer();
        //return;        
    }

    function SendInitialViewTarget()
    {
        local PlayerController PC;

        // End:0x84
        foreach LocalPlayerControllers(Class'Engine.PlayerController', PC)
        {
            // End:0x83
            if(!PC.PlayerReplicationInfo.bOnlySpectator)
            {
                ClientSetRealViewTarget(PC.PlayerReplicationInfo);                
                return;
            }            
        }        
        ClientSetRealViewTarget(none);
        //return;        
    }

    simulated event GetPlayerViewPoint(out Vector CameraLocation, out Rotator CameraRotation)
    {
        global.GetPlayerViewPoint(CameraLocation, CameraRotation);
        //return;        
    }

    exec function BehindView()
    {
        SetBehindView(!bBehindView);
        //return;        
    }

    event PlayerTick(float DeltaTime)
    {
        local Pawn P;

        global.PlayerTick(DeltaTime);
        // End:0x252
        if(int(Role) == int(ROLE_AutonomousProxy))
        {
            // End:0x5A
            if((RealViewTarget == none) && MyRealViewTarget != none)
            {
                RealViewTarget = MyRealViewTarget;
            }
            // End:0xD2
            if(((RealViewTarget == none) || RealViewTarget == PlayerReplicationInfo) && bFindPlayer)
            {
                DemoViewNextPlayer();
                // End:0xCF
                if((RealViewTarget != none) && RealViewTarget != PlayerReplicationInfo)
                {
                    bFindPlayer = false;
                }                
            }
            else
            {
                // End:0x1C6
                if(((RealViewTarget != none) && RealViewTarget != PlayerReplicationInfo) && (Pawn(ViewTarget) == none) || Pawn(ViewTarget).PlayerReplicationInfo != RealViewTarget)
                {
                    // End:0x1C5
                    foreach WorldInfo.AllPawns(Class'Engine.Pawn', P)
                    {
                        // End:0x1C4
                        if(P.PlayerReplicationInfo == RealViewTarget)
                        {
                            SetViewTarget(P);
                            // End:0x1C5
                            break;
                        }                        
                    }                    
                }
            }
            // End:0x252
            if(Pawn(ViewTarget) != none)
            {
                TargetViewRotation = ViewTarget.Rotation;
                TargetViewRotation.Pitch = int(Pawn(ViewTarget).RemoteViewPitch) << int(8);
            }
        }
        //return;        
    }
Begin:

    // End:0x2E
    if(int(Role) == int(ROLE_Authority))
    {
        Sleep(0.0000000);
        Sleep(0.0000000);
        SendInitialViewTarget();
    }
    stop;        
}

defaultproperties
{
    bBehindView=true
    // Reference: ForceFeedbackWaveform'Default__DemoRecSpectator.ForceFeedbackWaveform7'
    // Archetype: ForceFeedbackWaveform'Default__UTPlayerController.ForceFeedbackWaveform7'
    begin object name="ForceFeedbackWaveform7"
    end object
    CameraShakeShortWaveForm=ForceFeedbackWaveform7
    // Reference: ForceFeedbackWaveform'Default__DemoRecSpectator.ForceFeedbackWaveform8'
    // Archetype: ForceFeedbackWaveform'Default__UTPlayerController.ForceFeedbackWaveform8'
    begin object name="ForceFeedbackWaveform8"
    end object
    CameraShakeLongWaveForm=ForceFeedbackWaveform8
    // Reference: CylinderComponent'Default__DemoRecSpectator.CollisionCylinder'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'CollisionCylinder'
    // Archetype: CylinderComponent'Default__UTPlayerController.CollisionCylinder'
    begin object name="CollisionCylinder"
        ReplacementPrimitive=none
    end object
    CylinderComponent=CollisionCylinder
    Components[0]=CollisionCylinder
    RemoteRole=ENetRole.ROLE_AutonomousProxy
    bDemoOwner=true
    CollisionComponent=CollisionCylinder
}