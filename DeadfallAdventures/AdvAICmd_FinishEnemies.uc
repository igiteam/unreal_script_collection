class AdvAICmd_FinishEnemies extends EvilAICmd_Base_Combat within AdvAI_AztecMummy;

var bool bFinishWhenReady;
var bool bAllowAbort;
var AdvPawn EnemyToFinish;
var EvilPawn PlayerToFinish;

function string GetDebugString()
{
    return (((((Outer.GetHumanReadableName() @ "\nEnemy: ") @ string(Outer.Enemy)) @ "\nEnemyToFinish ") @ string(EnemyToFinish)) @ "\nEnemy locked: ") @ string(Outer.bIsEnemyLocked);
    //return ReturnValue;    
}

function string LogDebugEnemy()
{
    return (((("Pawn: " @ string(Outer.Pawn)) @ " EnemyToFinish: ") @ string(EnemyToFinish)) @ " locked: ") @ string(EnemyToFinish.MyAdvAI.bIsEnemyLocked);
    //return ReturnValue;    
}

function Popped()
{
    super.Popped();
    //return;    
}

function Pushed()
{
    super.Pushed();
    Outer.SetTimer(Outer.FinishEnemiesModeDuration, false, 'FinishCommandAndDie', self);
    GotoState('ChooseEnemy');
    AdvPawn(Outer.Pawn).bShouldPlayFullBodyHit = false;
    //return;    
}

function bool AllowTransitionTo(class<GameAICommand> AttemptCommand)
{
    return ClassIsChildOf(AttemptCommand, Class'EvilGame.EvilAICmd_Base_Melee') && bAllowAbort;
    //return ReturnValue;    
}

function bool IsEnemyLocked()
{
    return EnemyToFinish.MyAdvAI.bIsEnemyLocked && EnemyToFinish.MyAdvAI.Enemy != Outer.Pawn;
    //return ReturnValue;    
}

function DefaultMeleeAttack()
{
    Outer.bGodMode = false;
    bAllowAbort = true;
    AdvPawn(Outer.Pawn).bShouldPlayFullBodyHit = true;
    Outer.LastMeleeCommandTime -= Outer.TimeBetweenMeleeCommands;
    Outer.MeleeCommand = Outer.default.MeleeCommand;
    Outer.DefaultCommand = Outer.default.DefaultCommand;
    Outer.BeginMeleeCommand(Outer.Enemy);
    //return;    
}

function FinishCommandAndDie()
{
    Outer.bGodMode = false;
    AdvPawn(Outer.Pawn).bShouldPlayFullBodyHit = true;
    Outer.Pawn.Suicide();
    // End:0xD7
    if(EnemyToFinish != none)
    {
        EnemyToFinish.MyAdvAI.UnlockEnemy();
    }
    ExitWithSuccess();
    //return;    
}

function TimeToAcquireEnemyElapsed()
{
    Outer.bGodMode = false;
    ExitWithSuccess();
    //return;    
}

function AdjustEnemyRating(out float out_Rating, EvilPawn EnemyPawn)
{
    local AdvPawn AdvEnemy;

    AdvEnemy = AdvPawn(EnemyPawn);
    // End:0xB5
    if((((AdvEnemy != none) && AdvEnemy.MyAdvAI != none) && AdvEnemy.MyAdvAI.bIsEnemyLocked) && AdvEnemy != EnemyToFinish)
    {
        out_Rating = 0.1000000;        
    }
    else
    {
        super(EvilAICommand).AdjustEnemyRating(out_Rating, EnemyPawn);
    }
    //return;    
}

auto state ChooseEnemy
{Begin:

    // End:0x17
    if(bFinishWhenReady)
    {
        FinishCommandAndDie();
    }
    Outer.AutoAcquireEnemy();
    // End:0x181
    if(Outer.HasValidEnemy())
    {
        Outer.ClearTimer('TimeToAcquireEnemyElapsed');
        // End:0xC5
        if(Outer.Enemy.IsPlayerPawn())
        {
            DefaultMeleeAttack();            
        }
        else
        {
            EnemyToFinish = AdvPawn(Outer.Enemy);
            PlayerToFinish = none;
            // End:0x181
            if((EnemyToFinish != none) && !IsEnemyLocked())
            {
                EnemyToFinish.MyAdvAI.SetAndLockEnemy(Outer.Pawn);
                GotoState('MoveToEnemy');
            }
        }
    }
    Outer.SetTimer(Outer.ChoosingEnenyToFinishDuration, false, 'TimeToAcquireEnemyElapsed');
    Outer.Sleep(0.1000000);
    goto 'Begin';
    stop;            
}

state MoveToEnemy
{Begin:

    // End:0x1B
    if(IsEnemyLocked())
    {
        GotoState('ChooseEnemy');
    }
    Outer.SetMoveGoal(EnemyToFinish, Outer.EnemyDistance_Finisher, true, false, false);
    // End:0xC0
    if(EnemyToFinish.GetCanBeFinished(AdvPawn(Outer.Pawn)))
    {
        GotoState('FinishEnemy');        
    }
    else
    {
        GotoState('ChooseEnemy');
    }
    GotoState('ChooseEnemy');
    stop;                
}

state FinishEnemy
{
    function FinishCommandAndDie()
    {
        bFinishWhenReady = true;
        //return;        
    }
Begin:

    // End:0x1B
    if(IsEnemyLocked())
    {
        GotoState('ChooseEnemy');
    }
    // End:0x110
    if(EvilPawn(Outer.Pawn).CanDoPawnAction(60, true) && Outer.HasValidEnemy())
    {
        Outer.bGodMode = true;
        Outer.DoFinisherAttack(EnemyToFinish);
        bFinishWhenReady = true;
        EnemyToFinish.MyAdvAI.bIsEnemyLocked = false;        
    }
    else
    {
        DefaultMeleeAttack();
    }
    GotoState('ChooseEnemy');
    stop;                
}
