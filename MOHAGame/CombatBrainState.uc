class CombatBrainState extends AxonControllerBrainState
    abstract;

var export editinline AxonEnemyService EnemyService;
var export editinline AxonCoverService CoverService;
var export editinline AxonAnimService AnimService;
var export editinline BurstFireAxonScriptEvent BurstFireEvent;
var export editinline DecaySuppressionAxonScriptEvent DecaySuppressionEvent;
var export editinline AmmoCountAxonScriptEvent AmmoCountEvent;
var export editinline CCRequestPerformanceAxonScriptEvent CCRequestEvent;
var export editinline CCAwaitPerformanceAxonScriptEvent CCAwaitEvent;
var int iSuppressionLevel;
var name instanceID;
var bool bNeedsReload;
var MOHAPawn LastSuppressingPawn;

function ActivationEventTripped()
{
    ActivateBrain();
    //return;    
}

function ResetSuppressionMeter()
{
    Controller.SuppressionMeter = 0.0000000;
    //return;    
}

function StartBrain()
{
    super(AxonBrainState).StartBrain();
    SetSuppressionLevel(iSuppressionLevel);
    ResetSuppressionMeter();
    CustomStart();
    GotoState('StartCombat');
    //return;    
}

function CustomStart()
{
    //return;    
}

function FinishBrain()
{
    super(AxonBrainState).FinishBrain();
    //return;    
}

function ShouldHide()
{
    //return;    
}

function UnHide()
{
    //return;    
}

function ResumeBrain(AxonBrainState usurperState)
{
    FinishBrain();
    //return;    
}

function ShotHitNear(float threat)
{
    Controller.AddSuppression(threat);
    //return;    
}

function FireNear()
{
    local float threat;
    local int Team;
    local StimulusSenderSubscription send;

    threat = 1.0000000;
    Team = 2;
    // End:0x8A
    if(GetCallbackParamSender('Sender', send))
    {
        send.Owner.GetStimuliSenderParamFloat('BulletImpact', 'threat', threat);
        send.Owner.GetStimuliSenderParamInt('BulletImpact', 'Team', Team);
    }
    // End:0xD9
    if(Team != Controller.TeamIndex)
    {
        LastSuppressingPawn = MOHAPawn(send.Owner.GetSpatialActor());
        ShotHitNear(threat);
    }
    //return;    
}

function RegisterCanThrowGrenade()
{
    // End:0x16
    if(!Controller.bThrowsGrenades)
    {
        return;
    }
    EnemyService.SubstateCanThrowGrenade(Controller, CanThrowGrenade,,,, instanceID);
    EnemyService.RegisterDefaultGrenadeConstraints(instanceID);
    //return;    
}

function CanThrowGrenade()
{
    // End:0x38
    if(Controller.bThrowsGrenades)
    {
        EnemyService.NotifyJustThrewGrenade(instanceID);
        GotoState('ThrowGrenade');
    }
    //return;    
}

function PlayerShotNear()
{
    //return;    
}

function SetPlayerShotAtThreat()
{
    Controller.SetPlayerShotAtMeThreatTime(Class'EALAWeapon'.static.GetPlayerShotAtThreatFromBrainState(self));
    //return;    
}

function RegisterPlayerShotNear(optional name Key = 'stack')
{
    // End:0x23
    if(Controller.TeamIndex == 0)
    {
        return;
    }
    RegisterAxonSubstateStimulus('PlayerShoot', 'PlayerShoot', PlayerShotNear,, Key);
    //return;    
}

function bool HasLivingEnemy(Pawn Enemy)
{
    // End:0x23
    if((Enemy != none) && Enemy.Health > 0)
    {
        return true;
    }
    return false;
    //return ReturnValue;    
}

function BurstDone()
{
    //return;    
}

function RegisterParentSubstateEvents()
{
    //return;    
}

function InitStartCombat()
{
    //return;    
}

function CombatLostEnemy()
{
    FinishBrain();
    //return;    
}

function ShouldReload()
{
    bNeedsReload = true;
    ClearEventMapEntry('Ammo');
    //return;    
}

function ConditionalRegisterReloadEvent()
{
    // End:0x68
    if(!AmmoCountEvent.IsRegistered())
    {
        AmmoCountEvent.RegisterAmmoCountSubstate(Controller, ShouldReload, Controller.GetWeaponAmmoCount(), MOHAPawn(Controller.Pawn), 'Ammo');
    }
    //return;    
}

function PostReload()
{
    bNeedsReload = false;
    ClearEventMapEntry('Ammo');
    //return;    
}

function RegisterCombatLostEnemy()
{
    EnemyService.SubstateLostEnemy(CombatLostEnemy, 'CombatBrainState', 'parentbackground');
    //return;    
}

state StartCombat extends AxonBaseBookshelfState
{
    function ChildBeginState(name PreviousStateName)
    {
        RegisterParentSubstateEvents();
        RegisterAxonSubstateStimulus('TakeFire', 'BulletImpact', FireNear,, 'parentbackground');
        RegisterCombatLostEnemy();
        PushEventStack();
        InitStartCombat();
        //return;        
    }
    stop;    
}

defaultproperties
{
    // Reference: AxonEnemyService'Default__CombatBrainState.FireEnemyService0'
    begin object name=FireEnemyService0 class=Class'AxonEnemyService'
    end object
    EnemyService=FireEnemyService0
    // Reference: MOHACoverService'Default__CombatBrainState.CoverService0'
    begin object name=CoverService0 class=Class'MOHACoverService'
    end object
    CoverService=CoverService0
    // Reference: AxonAnimService'Default__CombatBrainState.AnimService0'
    begin object name=AnimService0 class=Class'AxonAnimService'
    end object
    AnimService=AnimService0
    // Reference: BurstFireAxonScriptEvent'Default__CombatBrainState.BurstFireEvent0'
    begin object name=BurstFireEvent0 class=Class'BurstFireAxonScriptEvent'
    end object
    BurstFireEvent=BurstFireEvent0
    // Reference: DecaySuppressionAxonScriptEvent'Default__CombatBrainState.DecaySuppressionEvent0'
    begin object name=DecaySuppressionEvent0 class=Class'DecaySuppressionAxonScriptEvent'
    end object
    DecaySuppressionEvent=DecaySuppressionEvent0
    // Reference: AmmoCountAxonScriptEvent'Default__CombatBrainState.AmmoCountEvent0'
    begin object name=AmmoCountEvent0 class=Class'AmmoCountAxonScriptEvent'
    end object
    AmmoCountEvent=AmmoCountEvent0
    // Reference: CCRequestPerformanceAxonScriptEvent'Default__CombatBrainState.CCRequestEvent0'
    begin object name=CCRequestEvent0 class=Class'CCRequestPerformanceAxonScriptEvent'
    end object
    CCRequestEvent=CCRequestEvent0
    // Reference: CCAwaitPerformanceAxonScriptEvent'Default__CombatBrainState.CCAwaitEvent0'
    begin object name=CCAwaitEvent0 class=Class'CCAwaitPerformanceAxonScriptEvent'
    end object
    CCAwaitEvent=CCAwaitEvent0
    EventServices=/* Array type was not detected. */
    AxonScriptEvents=/* Array type was not detected. */
}