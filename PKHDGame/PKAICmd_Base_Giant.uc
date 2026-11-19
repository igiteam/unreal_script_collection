class PKAICmd_Base_Giant extends EvilAICmd_Base_Combat within PkAI_Boss_Giant;

const MaxRange = 5600;
const RandBound = 1680;
const DefaultDistanceToEnemy = 4200;
const HitLowerBound = 3400;
const HitUpperBound = 4000;
const WalkStep = 2048.0;

var int LoopIndex;
var float LastHitByEnemyTime;
var float LastSpawnTime;
var int DelayBetweenReactionsOnHit;
var float LastTimeIdle;
var bool bDontMoveAround;
var bool bTimeToAllowMovingAround;
var bool bWalkAfterTurn;
var bool bWalked;
var int TimeToAllowMovingAround;
var float Movement;
var name DisplayState;
var name DisplayAttack;
var float MinDistance;
var int SpikeCount;
var Vector UtilityVector;
var Rotator UtilityRotator;
var Actor Twister;
var PkPawn_Boss_Giant_Base Boss;

function Evaluate()
{
    // End:0x26
    if(!Outer.bEnteredEnclave)
    {
        return;
    }
    Boss.CountZombies();
    // End:0x104
    if((!Outer.bChainsBroken && Boss.currentZombiesList.Length < 3) && Outer.WorldInfo.TimeSeconds > (LastSpawnTime + 5.0000000))
    {
        DisplayAttack = 'Spawn';
        GotoState('Spawn', 'Begin');
    }
    // End:0x276
    if(RandRange(0.0000000, 100.0000000) < float(70))
    {
        // End:0x24A
        if(((LastHitByEnemyTime + float(DelayBetweenReactionsOnHit)) < Outer.WorldInfo.TimeSeconds) && Outer.EnemyDistToCenter < float(5600))
        {
            // End:0x1EA
            if(Outer.PawnDistToEnemy < (0.9000000 * float(4200)))
            {
                LastHitByEnemyTime += float(1);
                GotoState('GiantIdle');
                return;
            }
            LastHitByEnemyTime = Outer.WorldInfo.TimeSeconds;
            DelayBetweenReactionsOnHit = int(RandRange(3.0000000, 6.0000000));            
        }
        else
        {
            DelayBetweenReactionsOnHit -= int(0.4000000);
            // End:0x276
            if(DelayBetweenReactionsOnHit < 1)
            {
                DelayBetweenReactionsOnHit = 1;
            }
        }
    }
    GotoState('BaseState');
    //return;    
}

function bool IsStillWalking()
{
    return Outer.FindCommandOfClass(Class'EvilGame.EvilAICmd_MoveToGoal') != none;
    //return ReturnValue;    
}

function InitVars()
{
    LastHitByEnemyTime = -100.0000000;
    DelayBetweenReactionsOnHit = 10;
    Outer.MapCenter = vect(0.0000000, 0.0000000, 1.0000000) * float(-3700);
    LastTimeIdle = -2.0000000;
    bTimeToAllowMovingAround = false;
    TimeToAllowMovingAround = 0;
    bDontMoveAround = false;
    bWalkAfterTurn = false;
    bWalked = false;
    SpikeCount = 0;
    Boss.SetLocation(Outer.FindVerticalPosition(Boss.Location));
    //return;    
}

function Pushed()
{
    super.Pushed();
    Boss = PkPawn_Boss_Giant_Base(Outer.Pawn);
    DisplayState = 'Command Pushed';
    InitVars();
    Outer.SetTimer(1.0000000, true, 'Evaluate', self);
    Outer.AutoAcquireEnemy();
    GotoState('BaseState');
    //return;    
}

state HandleRotation
{
    ignores Evaluate;
Begin:

    Outer.Sleep(0.0500000);
    Outer.AbortMoving();
    Outer.FinishRotation();
    Outer.Sleep(0.0500000);
    PopState();
    stop;                
}

auto state BaseState
{Begin:

    Outer.SetFocalPoint(Boss.Location + (Vector(Boss.Rotation) * float(10240)));
    // End:0x310
    if(!Outer.bEnteredEnclave)
    {
        DisplayState = 'EnteringEnclave';
        Outer.MoveLocation = Outer.MapCenter;
        Outer.MoveLocation = Outer.FindVerticalPosition(Outer.MoveLocation);
        Boss.SetPhysics(4);
        Outer.SetFocalPoint(Boss.Location + (Normal(Outer.MoveLocation - Boss.Location) * float(10240)));
        PushState('HandleRotation');
        Outer.SetMovePoint_NonNavmesh(Outer.MoveLocation, 2048.0000000, true);
EnteringEnclave:


        Outer.AutoAcquireEnemy();
        // End:0x2EF
        if(IsStillWalking())
        {
            Outer.SetFocalPoint(Boss.Location + (Vector(Boss.Rotation) * float(10240)));
            Outer.Sleep(0.1000000);
            goto 'EnteringEnclave';
        }
        Outer.bEnteredEnclave = true;
    }
    DisplayState = 'BaseState';
    // End:0x3F6
    if(!Outer.HasValidEnemy())
    {
        Outer.SetFocalPoint(Boss.Location + (Vector(Boss.Rotation) * float(10240)));
        Outer.Sleep(0.1000000);
        Outer.AutoAcquireEnemy();
        goto 'Begin';
    }
    // End:0x426
    if(Outer.bChainsBroken)
    {
        GotoState('GiantIdle');
    }
    Boss.CountZombies();
    // End:0x4DD
    if((Boss.currentZombiesList.Length == 0) && Outer.WorldInfo.TimeSeconds > (LastSpawnTime + 5.0000000))
    {
        DisplayAttack = 'Spawn';
        GotoState('Spawn', 'Begin');
    }
    // End:0x6F2
    if((!Outer.bChainsBroken && Outer.PawnDistToEnemy > (float(4200) * 0.9000000)) && Outer.PawnDistToEnemy < (float(4200) * 1.1000000))
    {
        Outer.SetFocalPoint(Boss.Location + (Normal(Outer.Enemy.Location - Boss.Location) * float(10240)));
        PushState('HandleRotation');
        // End:0x681
        if(RandRange(0.0000000, 100.0000000) > float(30))
        {
            Outer.AbortMoving();
            DisplayAttack = 'Strike';
            GotoState('Strike', 'Begin');            
        }
        else
        {
            // End:0x6F2
            if(Outer.WorldInfo.TimeSeconds > (LastSpawnTime + 5.0000000))
            {
                DisplayAttack = 'Spawn';
                GotoState('Spawn', 'Begin');
            }
        }
    }
    // End:0x781
    if(Outer.PawnDistToEnemy > float(5600))
    {
        // End:0x781
        if(RandRange(0.0000000, 100.0000000) < float(50))
        {
            Outer.AbortMoving();
            DisplayAttack = 'Spikes';
            GotoState('Spikes', 'Begin');
        }
    }
    // End:0x908
    if(IsStillWalking())
    {
        // End:0x905
        if((57.2957800 * FindDeltaAngle(0.0000959 * float(Boss.Rotation.Yaw), 0.0000959 * float(Rotator(Outer.Enemy.Location - Boss.Location).Yaw))) > float(50))
        {
            Outer.SetFocalPoint(Boss.Location + (Normal(Outer.Enemy.Location - Boss.Location) * float(10240)));
            PushState('HandleRotation');
        }        
    }
    else
    {
        Outer.SetFocalPoint(Boss.Location + (Normal(Outer.Enemy.Location - Boss.Location) * float(10240)));
        PushState('HandleRotation');
    }
    // End:0xB90
    if((Outer.PawnDistToEnemy < (1.1000000 * float(4200))) || !Outer.bChainsBroken && RandRange(0.0000000, 100.0000000) < float(50))
    {
        // End:0xB7F
        if((RandRange(0.0000000, 100.0000000) < float(40)) && Outer.PawnDistToEnemy > (float(4200) * 0.5000000))
        {
            // End:0xAE8
            if(RandRange(0.0000000, 100.0000000) < float(30))
            {
                Outer.AbortMoving();
                DisplayAttack = 'Spikes';
                GotoState('Spikes', 'Begin');                
            }
            else
            {
                // End:0xB7F
                if(!Outer.bChainsBroken && Outer.WorldInfo.TimeSeconds > (LastSpawnTime + 5.0000000))
                {
                    DisplayAttack = 'Spawn';
                    GotoState('Spawn', 'Begin');
                }
            }
        }
        GotoState('Loitering');        
    }
    else
    {
        GotoState('GoingToPlayer');
    }
    stop;        
}

state GoingToPlayer
{
    ignores Evaluate;
Begin:

    DisplayState = 'GoingToPlayer';
    LastHitByEnemyTime = Outer.WorldInfo.TimeSeconds;
    Outer.MoveLocation = Outer.Enemy.Location;
    Outer.MoveLocation = Outer.FindVerticalPosition(Outer.MoveLocation);
    Outer.SetFocalPoint(Outer.MoveLocation + (Normal(Outer.MoveLocation - Boss.Location) * float(10240)));
    PushState('HandleRotation');
    Outer.SetMovePoint_NonNavmesh(Outer.MoveLocation, 4200.0000000, true);
    GotoState('Walking');
    stop;                
}

state Walking
{Begin:

    DisplayState = 'Walking';
    LastHitByEnemyTime = Outer.WorldInfo.TimeSeconds;
    // End:0x2C9
    if(IsStillWalking())
    {
        // End:0xF6
        if((Outer.PawnDistToEnemy > (float(4200) * 0.9000000)) && Outer.PawnDistToEnemy < (float(4200) * 1.1000000))
        {
            Outer.AbortMoving();
            GotoState('Strike', 'Begin');
        }
        // End:0x2C6
        if(Outer.PawnDistToCenter > float(5600))
        {
            Outer.MoveLocation = Boss.Location + Normal(Vector(Boss.DesiredRotation));
            // End:0x2C6
            if(VSize2D(Outer.MoveLocation) > Outer.PawnDistToCenter)
            {
                Outer.AbortMoving();
                UtilityVector = Outer.MapCenter + ((VRand() * vect(1.0000000, 1.0000000, 0.0000000)) * float(1680));
                Outer.SetFocalPoint(Boss.Location + (Normal(UtilityVector - Boss.Location) * float(10240)));
                PushState('HandleRotation');
                GotoState('BaseState');
            }
        }        
    }
    else
    {
        GotoState('StandingIdle');
    }
    Outer.Sleep(0.1000000);
    goto 'Begin';
    stop;        
}

state StandingIdle
{Begin:

    DisplayState = 'StandingIdle';
    LastHitByEnemyTime = Outer.WorldInfo.TimeSeconds;
    // End:0x125
    if((!Outer.bChainsBroken && Outer.PawnDistToEnemy > (float(4200) * 0.9000000)) && Outer.PawnDistToEnemy < (float(4200) * 1.1000000))
    {
        Outer.AbortMoving();
        DisplayAttack = 'Strike from standing idle';
        GotoState('Strike', 'Begin');        
    }
    else
    {
        // End:0x1B4
        if(Outer.PawnDistToEnemy > float(5600))
        {
            // End:0x1B4
            if(RandRange(0.0000000, 100.0000000) < float(60))
            {
                Outer.AbortMoving();
                DisplayAttack = 'Spikes from standing idle';
                GotoState('Spikes', 'Begin');
            }
        }
    }
    Outer.Sleep(0.1000000);
    goto 'Begin';
    stop;                    
}

state Loitering
{
    function Vector GetBestWanderLocation()
    {
        local Vector currentTarget, BestTarget;

        BestTarget = vect(1.0000000, 1.0000000, 0.0000000) * (Outer.MapCenter + ((VRand() * float(5600)) * RandRange(0.5000000, 0.9500000)));
        LoopIndex = 0;
        J0x66:

        // End:0x1BE [Loop If]
        if(LoopIndex < 25)
        {
            currentTarget = vect(1.0000000, 1.0000000, 0.0000000) * (Outer.MapCenter + ((VRand() * float(5600)) * RandRange(0.5000000, 0.9500000)));
            // End:0x1B0
            if((VSize2D(currentTarget) <= float(5600)) && RDiff(Rotator(currentTarget - Boss.Location), Boss.Rotation) < RDiff(Rotator(BestTarget - Boss.Location), Boss.Rotation))
            {
                BestTarget = currentTarget;
            }
            LoopIndex++;
            // [Loop Continue]
            goto J0x66;
        }
        return BestTarget;
        //return ReturnValue;        
    }
Begin:

    DisplayState = 'Loitering';
    LastHitByEnemyTime = Outer.WorldInfo.TimeSeconds;
    Outer.MoveLocation = Outer.FindVerticalPosition(GetBestWanderLocation());
    Outer.SetFocalPoint(Boss.Location + (Normal(Outer.MoveLocation - Boss.Location) * float(10240)));
    PushState('HandleRotation');
    Outer.SetMovePoint_NonNavmesh(Outer.MoveLocation, 2048.0000000, true);
    Outer.Sleep(1.0000000);
    GotoState('BaseState');
    stop;                    
}

state GiantIdle
{Begin:

    DisplayState = 'Idle';
    // End:0x26C
    if(((LastTimeIdle + float(1)) < Outer.WorldInfo.TimeSeconds) && Boss.ReachedDesiredRotation())
    {
        LastTimeIdle = Outer.WorldInfo.TimeSeconds;
        // End:0x1C2
        if(!Outer.bChainsBroken)
        {
            // End:0x167
            if((RandRange(0.0000000, 1.0000000) < 0.1800000) && Outer.WorldInfo.TimeSeconds > (LastSpawnTime + 5.0000000))
            {
                DisplayAttack = 'Spawn from idle';
                GotoState('Spawn');
            }
            // End:0x193
            if(RandRange(0.0000000, 1.0000000) < 0.0900000)
            {
                GotoState('BaseState');
            }
            // End:0x1BF
            if(RandRange(0.0000000, 1.0000000) < 0.0400000)
            {
                GotoState('StandingIdle');
            }            
        }
        else
        {
            // End:0x201
            if(RandRange(0.0000000, 1.0000000) < 0.3600000)
            {
                DisplayAttack = 'Sucking from idle';
                GotoState('Suck');
            }
            // End:0x240
            if(RandRange(0.0000000, 1.0000000) < 0.2400000)
            {
                DisplayAttack = 'Spikes from idle';
                GotoState('Spikes');
            }
            // End:0x26C
            if(RandRange(0.0000000, 1.0000000) < 0.1200000)
            {
                GotoState('StandingIdle');
            }
        }
    }
    // End:0x2AB
    if(!IsStillWalking())
    {
        // End:0x2AB
        if(bTimeToAllowMovingAround)
        {
            bTimeToAllowMovingAround = false;
            TimeToAllowMovingAround = 0;
            bDontMoveAround = false;
        }
    }
    // End:0x2F6
    if(bTimeToAllowMovingAround)
    {
        TimeToAllowMovingAround -= 1;
        // End:0x2F6
        if(TimeToAllowMovingAround < 0)
        {
            TimeToAllowMovingAround = 0;
            bTimeToAllowMovingAround = false;
            bDontMoveAround = false;
        }
    }
    // End:0x352
    if(!IsStillWalking())
    {
        // End:0x352
        if(Outer.PawnDistToEnemy < float(350))
        {
            TimeToAllowMovingAround = 0;
            bTimeToAllowMovingAround = false;
            bDontMoveAround = false;
        }
    }
    // End:0xB19
    if(!bDontMoveAround)
    {
        // End:0xB19
        if(!IsStillWalking() && Boss.ReachedDesiredRotation())
        {
            // End:0x543
            if(bWalkAfterTurn)
            {
                bWalkAfterTurn = false;
                Outer.MoveLocation = ((VRand() * vect(1.0000000, 1.0000000, 0.0000000)) * float(1680)) + Outer.MapCenter;
                Outer.MoveLocation = Outer.FindVerticalPosition(Outer.MoveLocation);
                Outer.SetFocalPoint(Boss.Location + (Normal(Outer.MoveLocation - Boss.Location) * float(10240)));
                PushState('HandleRotation');
                Outer.SetMovePoint_NonNavmesh(Outer.MoveLocation, 2048.0000000, true);
            }
            // End:0x5B7
            if((RandRange(0.0000000, 1.0000000) <= 0.4000000) && bWalked)
            {
                bTimeToAllowMovingAround = true;
                TimeToAllowMovingAround = int(RandRange(50.0000000, 110.0000000));
                bDontMoveAround = true;
                bWalked = false;                
            }
            else
            {
                Movement = RandRange(2048.0000000 * 1.2000000, 2048.0000000 * float(2));
                // End:0x62A
                if(Outer.PawnDistToEnemy < float(350))
                {
                    Movement = RandRange(3400.0000000, 4000.0000000);
                }
                Outer.MoveLocation = Boss.Location + (Normal(Vector(Boss.DesiredRotation)) * Movement);
                Outer.MoveLocation = Outer.FindVerticalPosition(Outer.MoveLocation);
                // End:0x809
                if(VSize2D(Outer.MoveLocation) < float(5600))
                {
                    Outer.SetFocalPoint(Boss.Location + (Normal(Outer.MoveLocation - Boss.Location) * float(10240)));
                    PushState('HandleRotation');
                    Outer.SetMovePoint_NonNavmesh(Outer.MoveLocation, 2048.0000000, true);                    
                }
                else
                {
                    // End:0x977
                    if((57.2957800 * FindDeltaAngle(0.0000959 * float(Boss.Rotation.Yaw), 0.0000959 * float(Rotator(-Boss.Location).Yaw))) > float(45))
                    {
                        UtilityVector = ((VRand() * vect(1.0000000, 1.0000000, 0.0000000)) * float(1680)) + Outer.MapCenter;
                        Outer.SetFocalPoint(Boss.Location + (Normal(UtilityVector - Boss.Location) * float(10240)));
                        PushState('HandleRotation');
                        bWalkAfterTurn = true;                        
                    }
                    else
                    {
                        Outer.MoveLocation = ((VRand() * vect(1.0000000, 1.0000000, 0.0000000)) * float(1680)) + Outer.MapCenter;
                        Outer.MoveLocation = Outer.FindVerticalPosition(Outer.MoveLocation);
                        Outer.SetFocalPoint(Boss.Location + (Normal(Outer.MoveLocation - Boss.Location) * float(10240)));
                        PushState('HandleRotation');
                        Outer.SetMovePoint_NonNavmesh(Outer.MoveLocation, 2048.0000000, true);
                    }
                }
                bWalked = true;
            }
        }
    }
    Outer.Sleep(0.1000000);
    goto 'Begin';
    stop;                
}

state Strike
{
    ignores Evaluate;
Begin:

    // End:0x30
    if(Outer.bChainsBroken)
    {
        GotoState('BaseState');
    }
    Outer.SetFocalPoint(Boss.Location + ((Normal((Outer.Enemy.Location + Outer.Enemy.Velocity) - Boss.Location) * vect(1.0000000, 1.0000000, 0.0000000)) * float(10240)));
    PushState('HandleRotation');
    DisplayState = 'Striking';
    Boss.ServerDoPawnAction(52);
    DisplayAttack = 'None';
    GotoState('BaseState');
    stop;                
}

state Spawn
{
    ignores Evaluate;
Begin:

    // End:0x30
    if(Outer.bChainsBroken)
    {
        GotoState('BaseState');
    }
    DisplayState = 'Spawning';
    Outer.SetFocalPoint(Boss.Location + (Vector(Boss.Rotation) * float(10240)));
    Boss.ServerDoPawnAction(53);
    DisplayAttack = 'None';
    LastSpawnTime = Outer.WorldInfo.TimeSeconds;
    GotoState('BaseState');
    stop;                    
}

state Spikes
{
    ignores Evaluate;
Begin:

    DisplayState = 'Spikes';
    Outer.SetFocalPoint(Boss.Location + ((Normal(Outer.Enemy.Location - Boss.Location) * vect(1.0000000, 1.0000000, 0.0000000)) * float(10240)));
    PushState('HandleRotation');
    Outer.AbortMoving();
    Boss.ServerDoPawnAction(51);
    SpikeCount = 0;
    DisplayAttack = 'None';
    GotoState('BaseState');
    stop;            
}

state Suck
{
    ignores Evaluate;
Begin:

    DisplayState = 'Suck_Start';
    Outer.SetFocalPoint(Boss.Location + ((Normal(Outer.Enemy.Location - Boss.Location) * vect(1.0000000, 1.0000000, 0.0000000)) * float(10240)));
    PushState('HandleRotation');
    Outer.Sleep(0.1000000);
    Boss.ServerDoPawnAction(57);
    Boss.BreathStop();
    DisplayState = 'Suck';
    Boss.StartTwister();
    Boss.Twister.Enemy = Outer.Enemy;
    LoopIndex = 0;
    J0x1C5:

    // End:0x30F [Loop If]
    if(LoopIndex < 6)
    {
        Outer.Sleep(0.1000000);
        Boss.ServerDoPawnAction(56);
        Outer.Sleep(0.1000000);
        Outer.SetFocalPoint(Boss.Location + ((Normal((Outer.Enemy.Location - Boss.Location) + (VRand() * 2048.0000000)) * vect(1.0000000, 1.0000000, 0.0000000)) * float(10240)));
        PushState('HandleRotation');
        LoopIndex++;
        // [Loop Continue]
        goto J0x1C5;
    }
    Boss.StopTwister();
    DisplayState = 'Suck_End';
    Outer.Sleep(0.1000000);
    Boss.ServerDoPawnAction(58);
    Outer.Sleep(0.1000000);
    GotoState('BaseState');
    stop;        
}
