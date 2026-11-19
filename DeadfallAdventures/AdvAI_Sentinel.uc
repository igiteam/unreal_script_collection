class AdvAI_Sentinel extends AdvAIController
    config(AI)
    hidecategories(Navigation);

var AdvPawn_Sentinel_Base MyAdvPawn_Sentinel_Base;
var bool bControllerNotifiedAboutTeleport;

event Possess(Pawn NewPawn, bool bVehicleTransition)
{
    super.Possess(NewPawn, bVehicleTransition);
    MyAdvPawn_Sentinel_Base = AdvPawn_Sentinel_Base(NewPawn);
    //return;    
}

simulated function OnTeleport(SeqAct_Teleport Action)
{
    bControllerNotifiedAboutTeleport = true;
    // End:0x43
    if(!MyAdvPawn_Sentinel_Base.bPawnNotifiedAboutTeleport)
    {
        super(Controller).OnTeleport(Action);
    }
    // End:0x86
    if(Action != none)
    {
        bAllowCombatTransitions = false;
        AbortCommand(CommandList);
        PushState('Teleport');
    }
    bControllerNotifiedAboutTeleport = false;
    //return;    
}

state Teleport
{Begin:

    // End:0x40
    if((MyAdvPawn_Sentinel_Base != none) && MyAdvPawn_Sentinel_Base.TeleportDestActor != none)
    {
        Focus = none;
    }
WaitForTeleport:


    // End:0x87
    if((MyAdvPawn_Sentinel_Base == none) || !MyAdvPawn_Sentinel_Base.bAlreadyTeleported)
    {
        Sleep(0.1000000);
        goto 'WaitForTeleport';
    }
End:


    bAllowCombatTransitions = true;
    PopState();
    stop;        
}

defaultproperties
{
    bMoveToGoalByNavMesh_TryToUnstuck=false
    bIgnoreStepAside=true
    DefaultCommand=Class'AdvAICmd_Base_Sentinel'
    StrafesData=/* Array type was not detected. */
    EnemyDistance_Shoot=2500.0000000
    EnemyDistance_Melee=600.0000000
    EnemyDistance_MeleeCharge=800.0000000
    EnemyDistance_HearFootSteps=1000.0000000
    SightSenseDistanceThreshold=500.0000000
    SightRadius=4000.0000000
    // Reference: EvilAIReactManager'Default__AdvAI_Sentinel.ReactionManager0'
    begin object name=ReactionManager0
    end object
    ReactionManager=ReactionManager0
    DefaultReactConditions=/* Array type was not detected. */
    MaxTimeBetweenFireBurst=3.5000000
    MinTimeBetweenFireBurst=3.0000000
    TimeBetweenMeleeCommands=0.0000000
}