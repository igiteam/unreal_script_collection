class AdvAI_PolarBear extends EvilAIController
    config(AI)
    hidecategories(Navigation);

var array<Vector> SpawnLocation;

function bool NotifyBump(Actor Other, Vector HitNormal)
{
    //return ReturnValue;    
}

event Possess(Pawn NewPawn, bool bVehicleTransition)
{
    super.Possess(NewPawn, bVehicleTransition);
    AutoAcquireEnemy();
    SetAttackBehavior(Enemy);
    SpawnLocation.AddItem(MyEvilPawn.Location);    
    //return;    
}

function bool CanMeleeAttack()
{
    return super.CanMeleeAttack();
    //return ReturnValue;    
}

simulated function StartMeleeAttack()
{
    super.StartMeleeAttack();
    // End:0x46
    if(int(CurrentAggressionLevel) == int(3))
    {
        AbortCommand(CommandList, Class'EvilAICmd_PolarBear_Melee');
        ChangeAgrressionLevel(2);
    }
    //return;    
}

function OnAIMoveToActor(SeqAct_AIMoveToActor Action)
{
    super.OnAIMoveToActor(Action);
    SpawnLocation.AddItem(MyEvilPawn.Location);    
    //return;    
}

defaultproperties
{
    bMoveToGoalByNavMesh_TryToUnstuck=false
    bIgnoreStepAside=true
    DefaultCommand=Class'AdvAICmd_Base_PolarBear'
    MeleeCommand=Class'EvilAICmd_PolarBear_Melee'
    EnemyDistance_Melee=200.0000000
    EnemyDistance_MeleeCharge=50.0000000
    EnemyDistance_HearFootSteps=1000.0000000
    SightSenseDistanceThreshold=500.0000000
    SightRadius=4000.0000000
    // Reference: EvilAIReactManager'Default__AdvAI_PolarBear.ReactionManager0'
    begin object name=ReactionManager0
    end object
    ReactionManager=ReactionManager0
    DefaultReactConditions=/* Array type was not detected. */
    TimeBetweenMeleeCommands=5.0000000
}