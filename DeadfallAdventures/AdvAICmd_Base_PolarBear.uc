class AdvAICmd_Base_PolarBear extends AdvAICmd_Base_Animal within EvilAIController;

var bool bMeleePerformed;
var Vector LastRunToLocation;
var int LocationIndex;

function bool IsPerformingMelee()
{
    return Outer.FindCommandOfClass(Class'EvilAICmd_PolarBear_Melee') != none;
    //return ReturnValue;    
}

state RunAway
{
    ignores Evaluate;
Begin:

    // End:0x131
    if(VSize(LastRunToLocation - Outer.Pawn.Location) < (Outer.EnemyDistance_MeleeCharge * float(3)))
    {
        LastRunToLocation = AdvAI_PolarBear(Outer.Pawn.Controller).SpawnLocation[LocationIndex];
        Outer.SetMovePoint(LastRunToLocation,, false);
        LocationIndex--;
        // End:0x131
        if(LocationIndex < 0)
        {
            Outer.ReturnToIdle();
        }
    }
    Outer.Sleep(0.5000000);
    goto 'Begin';
    stop;                
}

state InCombat
{Begin:

    // End:0x17E
    if(int(Outer.CurrentAggressionLevel) == int(2))
    {
        Outer.AbortMoving();
        Outer.AbortCommand(none, none);
        LocationIndex = AdvAI_PolarBear(Outer.Pawn.Controller).SpawnLocation.Length - 1;
        LastRunToLocation = AdvAI_PolarBear(Outer.Pawn.Controller).SpawnLocation[LocationIndex];
        Outer.SetMovePoint(LastRunToLocation,, false);
        LocationIndex--;
        PushState('RunAway', 'Begin');
    }
    // End:0x1C1
    if(!Outer.HasValidEnemy())
    {
        Outer.ReturnToIdle();
    }
    // End:0x27E
    if(!Outer.MyEvilPawn.bOnLightInfluenceFromFlashLight && int(Outer.MyEvilPawn.PawnAction) != 55)
    {
        Outer.SetEnemyMoveGoal(Outer.EnemyDistance_Melee, true);        
    }
    else
    {
        Outer.Sleep(0.1000000);
    }
    Outer.Focus = Outer.Enemy;
    goto 'Begin';
    stop;        
}
