class MeleeCombatActivationService extends AxonFSMService;

var int SuppressionLevel;
var export editinline AxonEnemyService EnemyService;
var MOHAScriptAIController Controller;
var export editinline AxonPointService PointService;
var float fRange;
var float fBehindRange;
var float fStationaryRange;
var float fShortAngle;
var float fLongAngle;
var int iTraversalDepth;
var float fUseShortAngleTime;
var Pawn CurrentEnemy;
var bool bMeleeTarget;
var bool bForceWaitForActivation;

function StartFSMService()
{
    bMeleeTarget = false;
    GotoState('CheckForEnemy');
    //return;    
}

function StartAsMeleeTarget()
{
    local name AttackerName;
    local Object Attacker;

    // End:0x7E
    if(owningBrainState.GetCallbackParamName('Attacker', AttackerName))
    {
        Attacker = owningBrainState.OwningBSS.GetObjectFromName(AttackerName);
        // End:0x7E
        if((Attacker != none) && Pawn(Attacker) != none)
        {
            bMeleeTarget = true;
            CurrentEnemy = Pawn(Attacker);
            Finish();
        }
    }
    //return;    
}

function OnLostEnemy()
{
    GotoState('CheckForEnemy');
    //return;    
}

state CheckForEnemy extends ClearActivationState
{
    function ChildBeginState(name PreviousStateName)
    {
        owningBrainState.RegisterAxonActivationNamedScriptEventListener('MeleeTarget', StartAsMeleeTarget, SuppressionLevel);
        EnemyService.RegisterAxonActivationHasEnemy(OnHasEnemy, SuppressionLevel, mInstanceID);
        //return;        
    }

    function OnHasEnemy()
    {
        // End:0x3A
        if(!bForceWaitForActivation && (FRand() * 100.0000000) < Controller.fMeleeAggressivenessPct)
        {
            GotoState('CheckLongRange');            
        }
        else
        {
            GotoState('wait');
        }
        //return;        
    }
    stop;    
}

state wait extends ClearActivationState
{
    function ChildBeginState(name PreviousStateName)
    {
        owningBrainState.RegisterAxonActivationNamedScriptEventListener('MeleeTarget', StartAsMeleeTarget, SuppressionLevel);
        EnemyService.RegisterAxonActivationLostEnemy(OnLostEnemy, SuppressionLevel, mInstanceID);
        owningBrainState.RegisterAxonActivationTimer(Controller.fWaitBetweenLongRangeMeleeTime, TimedOut, SuppressionLevel, mInstanceID);
        // End:0xCC
        if(Controller.TeamIndex == 1)
        {
            owningBrainState.RegisterAxonActivationStimulus('PlayerPresenceMeleeRange', 'PlayerPresenceMeleeRange', TimedOut, SuppressionLevel);
        }
        //return;        
    }

    function TimedOut()
    {
        GotoState('CheckLongRange');
        //return;        
    }
    stop;    
}

state CheckLongRange extends ClearActivationState
{
    function ChildBeginState(name PreviousStateName)
    {
        owningBrainState.RegisterAxonActivationNamedScriptEventListener('MeleeTarget', StartAsMeleeTarget, SuppressionLevel);
        EnemyService.RegisterAxonActivationLostEnemy(OnLostEnemy, SuppressionLevel, mInstanceID);
        PointService.RegisterActivationDirectPath(LongAttack, 0.0000000, fRange, 0.0000000, fBehindRange, fStationaryRange, GetDirectPathAngle(), iTraversalDepth,,, SuppressionLevel, mInstanceID);
        //return;        
    }

    function float GetDirectPathAngle()
    {
        return fShortAngle;
        //return ReturnValue;        
    }

    function LongAttack()
    {
        // End:0x24
        if(PointService.GetDirectPathEnemy(CurrentEnemy))
        {
            Finish();            
        }
        else
        {
            GotoState('wait');
        }
        //return;        
    }
    stop;    
}

state CheckLongRangeWide extends CheckLongRange
{
    function float GetDirectPathAngle()
    {
        return fLongAngle;
        //return ReturnValue;        
    }
    stop;    
}

defaultproperties
{
    fRange=400.0000000
    fBehindRange=200.0000000
    fStationaryRange=400.0000000
    fShortAngle=120.0000000
    fLongAngle=180.0000000
    iTraversalDepth=4
    fUseShortAngleTime=3.0000000
}