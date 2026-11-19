class RetreatCoverFireBrainState extends AxonSquadOrderBrainState;

var export editinline AxonEnemyService EnemyService;
var export editinline BurstFireAxonScriptEvent BurstFireEvent;
var Actor Enemy;

function StartBrain()
{
    super(AxonBrainState).StartBrain();
    CCPerformerPawn(GetBot()).OnCCStimulus("MOHA_CC.Stimuli.CoveringFire", none);
    SetSuppressionLevel(13);
    EnemyService.ClearThreatAssessments();
    EnemyService.AddDistanceThreatAssessment();
    GotoState('ParentState');
    //return;    
}

function RegisterActivationEvents()
{
    RegisterAxonActivationTimer(0.0000000, ActivationEventTripped, 13, 'RetreatTimer');
    //return;    
}

function ActivationEventTripped()
{
    ActivateBrain();
    //return;    
}

function OnFinishMove()
{
    DestroyTransplantBrain();
    //return;    
}

function BurstDone()
{
    //return;    
}

state ParentState extends AxonBaseBookshelfState
{
    function ChildBeginState(name PreviousStateName)
    {
        RegisterAxonNamedScriptEventListener('FinishRetreat', OnFinishMove);
        PushEventStack();
        GotoState('CheckForEnemy');
        //return;        
    }
    stop;    
}

state CheckForEnemy extends ParentState
{
    function ChildBeginState(name PreviousStateName)
    {
        EnemyService.GetEnemy(OnHasEnemyResult);
        //return;        
    }

    function OnHasEnemyResult()
    {
        Enemy = EnemyService.GetGetEnemyResult();
        // End:0x35
        if(Enemy == none)
        {
            GotoState('wait');            
        }
        else
        {
            CheckForCanSuppress();
        }
        //return;        
    }

    function CheckForCanSuppress()
    {
        EnemyService.CanSuppressEnemy(OnCanSuppressEnemyResult);
        //return;        
    }

    function OnCanSuppressEnemyResult()
    {
        local bool bCanSuppress;

        bCanSuppress = EnemyService.GetCanSuppressEnemyResult();
        // End:0x34
        if(bCanSuppress)
        {
            GotoState('CoveringFire');            
        }
        else
        {
            GotoState('wait');
        }
        //return;        
    }
    stop;    
}

state wait extends ParentState
{
    function ChildBeginState(name PreviousStateName)
    {
        RegisterAxonSubstateTimer(1.0000000, ReEngage);
        //return;        
    }

    function ReEngage()
    {
        GotoState('CheckForEnemy');
        //return;        
    }
    stop;    
}

state CoveringFire extends ParentState
{
    function ChildBeginState(name PreviousStateName)
    {
        BurstFireEvent.RegisterBurstSubstate(Controller, Controller.GetVeryLongBurst(), BurstDone, Enemy);
        //return;        
    }

    function BurstDone()
    {
        GotoState('CheckForEnemy');
        //return;        
    }
    stop;    
}

defaultproperties
{
    // Reference: AxonEnemyService'Default__RetreatCoverFireBrainState.FireEnemyService0'
    begin object name=FireEnemyService0 class=Class'AxonEnemyService'
    end object
    EnemyService=FireEnemyService0
    // Reference: BurstFireAxonScriptEvent'Default__RetreatCoverFireBrainState.BurstFireEvent0'
    begin object name=BurstFireEvent0 class=Class'BurstFireAxonScriptEvent'
    end object
    BurstFireEvent=BurstFireEvent0
    EventServices=/* Array type was not detected. */
    AxonScriptEvents=/* Array type was not detected. */
}