class PkAI_Boss_Giant extends PKAIController
    config(AI)
    hidecategories(Navigation);

var bool bChainsBroken;
var bool bEnteredEnclave;
var float PawnDistToCenter;
var float PawnDistToEnemy;
var float EnemyDistToCenter;
var Vector MapCenter;
var Vector MoveLocation;

event Possess(Pawn NewPawn, bool bVehicleTransition)
{
    super.Possess(NewPawn, bVehicleTransition);
    AutoAcquireEnemy();
    SetAttackBehavior();
    SetTimer(0.1000000, true, 'UpdateDists', self);
    //return;    
}

function UpdateDists()
{
    PawnDistToCenter = VSize2D(Pawn.Location - MapCenter);
    // End:0xFB
    if(Enemy != none)
    {
        PawnDistToEnemy = VSize2D(Pawn.Location - (Enemy.Location + Enemy.Velocity));
        EnemyDistToCenter = VSize2D(Enemy.Location - MapCenter);
    }
    // End:0x20C
    if((float(Pawn.Health) < (float(Pawn.HealthMax) * 0.5000000)) && bChainsBroken == false)
    {
        AbortMoving();
        GetActiveCommand().GotoState('BaseState');
        bChainsBroken = true;
        SetFocalPoint(Pawn.Location + (Vector(Pawn.Rotation) * float(8192)));
        MyEvilPawn.ServerDoPawnAction(54, true);
    }
    //return;    
}

function Vector FindVerticalPosition(Vector InLocation)
{
    local Vector HitLocation, HitNormal, TraceEnd, TraceStart, NewLocation;

    local Landscape HitLandscape;

    TraceStart = (vect(1.0000000, 1.0000000, 0.0000000) * InLocation) - (vect(0.0000000, 0.0000000, 1.0000000) * float(4000));
    TraceEnd = (vect(1.0000000, 1.0000000, 0.0000000) * InLocation) - (vect(0.0000000, 0.0000000, 1.0000000) * float(3200));
    // End:0xEC
    foreach TraceActors(Class'Engine.Landscape', HitLandscape, HitLocation, HitNormal, TraceEnd, TraceStart)
    {
        NewLocation = HitLocation + (vect(0.0000000, 0.0000000, 1.0000000) * float(1024));        
        return NewLocation;        
    }    
    return InLocation;
    //return ReturnValue;    
}

defaultproperties
{
    DefaultCommand=Class'PKAICmd_Base_Giant'
    MeleeCommand=none
    GuardCommand=none
    StrafeCommand=none
    SightSenseDistanceThreshold=102400.0000000
    // Reference: EvilAIReactManager'Default__PkAI_Boss_Giant.ReactionManager0'
    // Archetype: EvilAIReactManager'Default__PKAIController.ReactionManager0'
    begin object name="ReactionManager0"
    end object
    ReactionManager=ReactionManager0
    DefaultReactConditions=/* Array type was not detected. */
}