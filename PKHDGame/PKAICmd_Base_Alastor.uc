class PKAICmd_Base_Alastor extends EvilAICmd_Base_Combat within PKAI_Boss_Alastor;

const MinAttack1Range = 3072;
const MinAttack2Range = 2048;
const MinAttack3Range = 1024;
const MinAttack4Range = 512;
const MapCenter = vect(0,0,0);
const WalkStep = 256;

var int LoopIndex;
var Vector MoveLocation;
var float PawnDistToCenter;
var float PawnDistToEnemy;
var float PawnDistToTarget;
var float EnemyDistToCenter;
var name DisplayState;
var int MoveDistance;
var int FlySpeed;
var int RandBound;
var int AttackBalancer;
var PKPawn_Boss_Alastor_Base Boss;
var float LastTimeBreathBehindPillars;
var float LastTimeFireBall;
var float WalkAwayStartTime;
var int Angle;

function bool IsStillWalking()
{
    return Outer.FindCommandOfClass(Class'EvilGame.EvilAICmd_MoveToGoal') != none;
    //return ReturnValue;    
}

function Pushed()
{
    super.Pushed();
    Boss = PKPawn_Boss_Alastor_Base(Outer.Pawn);
    // End:0xCA
    if(Outer.Stage == 0)
    {
        Boss.Mesh.SetHidden(true);
        Boss.SetLocation(Boss.SpawnLocation);
    }
    // End:0x146
    if((Boss.Particles != none) && Boss.Particles.bIsActive)
    {
        Boss.BreathStop();
    }
    Outer.SetTimer(GetTransitionCheckTime(), false, 'CheckTimedCombatTransition');
    Outer.SetTimer(0.1000000, true, 'UpdateDists', self);
    RandBound = 2048;
    AttackBalancer = 0;
    Outer.AutoAcquireEnemy();
    GotoState('BaseState');
    //return;    
}

function UpdateDists()
{
    PawnDistToCenter = VSize2D(Boss.Location - vect(0.0000000, 0.0000000, 0.0000000));
    // End:0x15F
    if(Outer.Enemy != none)
    {
        PawnDistToEnemy = VSize2D(Boss.Location - Outer.Enemy.Location);
        PawnDistToTarget = VSize2D(Boss.Location - MoveLocation);
        EnemyDistToCenter = VSize2D(Outer.Enemy.Location - vect(0.0000000, 0.0000000, 0.0000000));
    }
    //return;    
}

function CheckHealers()
{
    local PKItem_Boss_Alastor_Statue_Base currentMonk;

    // End:0x7C
    foreach Boss.MonkList(currentMonk)
    {
        // End:0x7B
        if(!currentMonk.IsAlive())
        {
            Boss.MonkList.RemoveItem(currentMonk);
        }        
    }    
    // End:0x1AF
    if(Boss.MonkList.Length <= 0)
    {
        Boss.bReadyToDie = true;
        // End:0x1AF
        if(Boss.Health <= 0)
        {
            Boss.Health = 5;
            Boss.TakeDamage(25, Outer.Enemy.Controller, Outer.Location, vect(0.0000000, 0.0000000, 0.0000000), Class'EvilGame.EvilDmgType_Base',, Outer.Enemy);
        }
    }
    //return;    
}

auto state BaseState
{Begin:

    DisplayState = 'BaseState';
    // End:0xC3
    if(!Outer.HasValidEnemy())
    {
        Boss.SetPhysics(4);
        Boss.Velocity = vect(0.0000000, 0.0000000, 0.0000000);
        Outer.Sleep(1.0000000);
        Outer.AutoAcquireEnemy();
        goto 'Begin';
    }
    // End:0xFE
    if(Outer.Stage == 0)
    {
        PushState('BaseFlying');        
    }
    else
    {
        PushState('BaseWalking');
    }
    goto 'Begin';
    stop;                
}

state BaseFlying
{Begin:

    DisplayState = 'BaseFlying';
    Boss.SetPhysics(4);
    Boss.Mesh.RootMotionMode = 2;
    Boss.SetLocation((Normal(VRand() * vect(1.0000000, 1.0000000, 0.0000000)) * float(1024)) * float(32));
    Boss.bCanFly = true;
    Boss.bCollideWorld = false;
    Boss.bHasTIPAnims45Deg = false;
    Boss.bHasTIPAnims90Deg = false;
    Outer.Sleep(RandRange(1.0000000, 3.0000000));
    // End:0x180
    if(Boss.Health <= 0)
    {
        GotoState('BreakFalling');
    }
    // End:0x1C4
    if(RandRange(0.0000000, 10.0000000) <= float(6 - AttackBalancer))
    {
        AttackBalancer++;
        GotoState('MeleeStrikeFlying');        
    }
    else
    {
        AttackBalancer--;
        GotoState('FireStrikeFlying');
    }
    goto 'Begin';
    stop;                    
}

state MeleeStrikeFlying
{
    function Strike()
    {
        local PKPlayerPawn PlayerPawn;

        Outer.PlaySound(Boss.MeleeStrikeFlyingSwish,,,, Boss.Location);
        // End:0x147
        foreach Outer.VisibleActors(Class'PKPlayerPawn', PlayerPawn, float(Boss.StrikeRadius), Boss.Location)
        {
            PlayerPawn.TakeDamage(Boss.StrikeDamage, Outer, PlayerPawn.Location, vect(0.0000000, 0.0000000, 0.0000000), Class'EvilGame.EvilDmgType_Melee');            
        }        
        Outer.GetALocalPlayerController().ClientPlayCameraShake(CameraShake'PP_Resources.PlayerHitCameraShake', 0.5000000);
        //return;        
    }
Begin:

    DisplayState = 'MeleeStrikeFlying';
    Outer.AbortMoving();
    Outer.StopLatentExecution();
    Boss.SetPhysics(4);
    Boss.Mesh.RootMotionMode = 2;
    Boss.SetLocation((((Normal(VRand() * vect(1.0000000, 1.0000000, 0.0000000)) * float(1024)) * float(32)) + (vect(0.0000000, 0.0000000, 1.0000000) * Outer.Enemy.Location)) + (vect(0.0000000, 0.0000000, 1.0000000) * float(32)));
    UpdateDists();
    FlySpeed = int(Boss.AirSpeed / float(3));
    Boss.SetRotation(Rotator((Outer.Enemy.Location - Boss.Location) * vect(1.0000000, 1.0000000, 0.0000000)));
    Boss.Velocity = (Vector(Boss.Rotation) * vect(1.0000000, 1.0000000, 0.0000000)) * float(FlySpeed);
    Boss.Mesh.SetHidden(false);
    Outer.SetFocalPoint(Outer.Enemy.Location + Outer.Enemy.Velocity);
    Boss.PlayFullbodySlotAnim('Fly');
    Outer.MoveTimer = 1.0000000;
    Outer.Focus = Outer.Enemy;
Update1:


    DisplayState = 'MeleeStrikeFlying_Charge';
    Boss.SetRotation(Rotator((Outer.Enemy.Location - Boss.Location) * vect(1.0000000, 1.0000000, 0.0000000)));
    Boss.Velocity = (Vector(Boss.Rotation) * vect(1.0000000, 1.0000000, 0.0000000)) * float(FlySpeed);
    // End:0x4B7
    if(PawnDistToCenter > float(4096))
    {
        Outer.Sleep(0.1000000);
        goto 'Update1';
    }
    MoveLocation = ((((Vector(Boss.Rotation) * vect(1.0000000, 1.0000000, 0.0000000)) * float(1024)) * float(32)) + (vect(0.0000000, 0.0000000, 1.0000000) * Outer.Enemy.Location)) + (vect(0.0000000, 0.0000000, 1.0000000) * float(256));
    UpdateDists();
    Outer.PlaySound(Boss.MeleeStrikeFlyingScream,,,, Boss.Location);
    Boss.PlayFullbodySlotAnim('Fly_Idle');
Update2:


    DisplayState = 'MeleeStrikeFlying_Strike';
    // End:0x63C
    if(float(FlySpeed) < Boss.AirSpeed)
    {
        FlySpeed += 20;
    }
    Outer.Focus = none;
    Outer.SetFocalPoint(MoveLocation);
    Boss.Velocity = (Vector(Boss.Rotation) * vect(1.0000000, 1.0000000, 0.0000000)) * float(FlySpeed);
    // End:0x768
    if(PawnDistToEnemy < float(Boss.StrikeRadius))
    {
        Strike();
        Outer.Sleep(1.0000000);
        Boss.PlayFullbodySlotAnim('Fly');
        goto 'Update3';
    }
    Outer.Sleep(0.1000000);
    // End:0x7A8
    if(PawnDistToTarget > float(1024 * 24))
    {
        goto 'Update2';
    }
Update3:


    DisplayState = 'MeleeStrikeFlying_Retreat';
    Outer.SetFocalPoint(MoveLocation);
    Boss.Velocity = (Vector(Boss.Rotation) * vect(1.0000000, 1.0000000, 0.0000000)) * float(FlySpeed);
    Outer.Sleep(0.1000000);
    // End:0x87C
    if(PawnDistToTarget > float(1024))
    {
        goto 'Update3';
    }
    Boss.Mesh.SetHidden(true);
    Boss.StopFullbodySlotAnim();
    GotoState('BaseFlying');
    stop;        
}

state FireStrikeFlying
{Begin:

    DisplayState = 'FireStrikeFlying';
    Outer.AbortMoving();
    Outer.StopLatentExecution();
    Boss.SetPhysics(4);
    Boss.Mesh.RootMotionMode = 2;
    Boss.SetLocation((((Normal((Outer.Enemy.Location - vect(0.0000000, 0.0000000, 0.0000000)) * vect(1.0000000, 1.0000000, 0.0000000)) * float(1024)) * float(12)) + (vect(0.0000000, 0.0000000, 1.0000000) * Outer.Enemy.Location)) - ((vect(0.0000000, 0.0000000, 1.0000000) * float(1024)) * float(8)));
    Boss.SetRotation(Rotator((vect(0.0000000, 0.0000000, 0.0000000) - Boss.Location) * vect(1.0000000, 1.0000000, 0.0000000)));
    MoveLocation = ((Outer.Enemy.Location * vect(0.0000000, 0.0000000, 1.0000000)) + (vect(0.0000000, 0.0000000, 0.0000000) * vect(1.0000000, 1.0000000, 0.0000000))) - ((Normal((vect(0.0000000, 0.0000000, 0.0000000) - Boss.Location) * vect(1.0000000, 1.0000000, 0.0000000)) * float(1024)) * 3.5000000);
    MoveLocation.Z = 10150.0000000;
    Boss.Velocity = Normal(MoveLocation - Boss.Location) * float(2048);
    Boss.Mesh.SetHidden(false);
    Outer.SetFocalPoint(Outer.Enemy.Location + Outer.Enemy.Velocity);
    Boss.PlayFullbodySlotAnim('fly_up');
    Outer.PlaySound(Boss.MeleeStrikeFlyingScream,,,, Boss.Location);
    Outer.MoveTimer = 1.0000000;
Update1:


    DisplayState = 'FireStrikeFlying_Climbing';
    Boss.Velocity = Normal(MoveLocation - Boss.Location) * float(2048);
    Outer.SetFocalPoint(Outer.Enemy.Location);
    Outer.Sleep(0.1000000);
    // End:0x5B6
    if((PawnDistToTarget > float(16)) && Boss.Location.Z < MoveLocation.Z)
    {
        goto 'Update1';
    }
    Boss.MoveSmooth(MoveLocation - Boss.Location);
    MoveLocation = (((Outer.Enemy.Location * vect(0.0000000, 0.0000000, 1.0000000)) + (vect(0.0000000, 0.0000000, 0.0000000) * vect(1.0000000, 1.0000000, 0.0000000))) - ((Normal((vect(0.0000000, 0.0000000, 0.0000000) - Boss.Location) * vect(1.0000000, 1.0000000, 0.0000000)) * float(1024)) * float(24))) - ((vect(0.0000000, 0.0000000, 1.0000000) * float(1024)) * float(8));
    Boss.Velocity = vect(0.0000000, 0.0000000, 0.0000000);
Update2:


    DisplayState = 'FireStrikeFlying_Strike';
    Boss.SetPhysics(4);
    Boss.BreathStart();
    Outer.PlaySound(Boss.FireStrikeFlyingScream,,,, Boss.Location);
    LoopIndex = 0;
    J0x7B3:

    // End:0x841 [Loop If]
    if(LoopIndex < 6)
    {
        Outer.SetFocalPoint(Outer.Enemy.Location);
        Outer.Sleep(0.5000000);
        LoopIndex++;
        // [Loop Continue]
        goto J0x7B3;
    }
    Boss.BreathStop();
    Boss.SetPhysics(4);
Update3:


    DisplayState = 'FireStrikeFlying_Falling';
    Outer.SetFocalPoint(MoveLocation);
    Boss.Velocity = Normal(MoveLocation - Boss.Location) * float(2048);
    Boss.PlayFullbodySlotAnim('fly_down');
    Outer.Sleep(0.5000000);
    // End:0x96D
    if(PawnDistToTarget > float(1024))
    {
        goto 'Update3';
    }
    Boss.Mesh.SetHidden(true);
    Boss.StopFullbodySlotAnim();
    GotoState('BaseFlying');
    stop;                    
}

state BreakFalling
{Begin:

    DisplayState = 'BreakFalling';
    Boss.PlayFullbodySlotAnim('fall');
    Boss.Velocity = vect(0.0000000, 0.0000000, 0.0000000);
    Boss.BurnStart();
    Outer.Sleep(0.5000000);
    Boss.SetLocation(((vect(1.0000000, 1.0000000, 0.0000000) * vect(0.0000000, 0.0000000, 0.0000000)) + (vect(0.0000000, 0.0000000, 1.0000000) * Outer.Enemy.Location)) + ((vect(0.0000000, 0.0000000, 1.0000000) * float(1024)) * float(24)));
    Outer.SetFocalPoint(Boss.Location + ((vect(1.0000000, 1.0000000, 0.0000000) * Vector(Boss.Rotation)) * float(1024)));
    Boss.Velocity = ((vect(0.0000000, 0.0000000, 0.0000000) - Boss.Location) * vect(1.0000000, 1.0000000, 0.0000000)) + (vect(0.0000000, 0.0000000, 1.0000000) * float(-8192));
    Boss.SetPhysics(4);
    Outer.Sleep(0.5000000);
    Boss.Mesh.SetHidden(false);
    Boss.bCollideWorld = true;
    Outer.PlaySound(Boss.MeleeStrikeFlyingScream,,,, Boss.Location);
Update1:


    Outer.Sleep(0.0500000);
    Boss.Velocity = ((vect(0.0000000, 0.0000000, 0.0000000) - Boss.Location) * vect(1.0000000, 1.0000000, 0.0000000)) + (vect(0.0000000, 0.0000000, 1.0000000) * float(-8192));
    // End:0x435
    if(Boss.Location.Z > (Outer.Enemy.Location.Z + float(128)))
    {
        goto 'Update1';
    }
    Boss.DestroyFloor();
    Boss.bCollideWorld = false;
    Boss.SetPhysics(2);
    Boss.PlayFullbodySlotAnim('fall');
    Boss.Velocity = vect(0.0000000, 0.0000000, 1.0000000) * float(-2048);
    Outer.Sleep(0.5000000);
    Boss.bCollideWorld = true;
    Boss.bHasTIPAnims45Deg = true;
    Boss.bHasTIPAnims90Deg = true;
    Outer.SetFocalPoint(Boss.Location + ((vect(1.0000000, 1.0000000, 0.0000000) * Vector(Boss.Rotation)) * float(1024)));
    Boss.BurnStop();
    Boss.ServerDoPawnAction(81);
    Boss.PlayFullbodySlotAnim('fly_up');
Update2:


    Outer.Sleep(0.1000000);
    // End:0x6A3
    if(int(Boss.Physics) == int(2))
    {
        goto 'Update2';
    }
    Boss.StopFullbodySlotAnim();
    Boss.ServerDoPawnAction(82);
    Outer.Stage++;
    Outer.Sleep(0.0100000);
    Boss.HealthMax = Boss.HealthMax * 6;
    Boss.Health = Boss.HealthMax;
    Outer.MoveTimer = 1.0000000;
    Outer.AbortMoving();
    Outer.SetFocalPoint(Outer.Enemy.Location);
    Boss.TakeDamage(0, Outer.Enemy.Controller, Outer.Enemy.Location, vect(0.0000000, 0.0000000, 0.0000000), Class'PKDmgType_Rocket',, Outer.Enemy);
    GotoState('BaseWalking');
    stop;            
}

state BaseWalking
{Begin:

    DisplayState = 'BaseWalking';
    Boss.Mesh.SetHidden(false);
    // End:0x77
    if(Outer.Stage == 3)
    {
        CheckHealers();
    }
    // End:0x104
    if(Boss.Health <= 0)
    {
        // End:0xD1
        if(Outer.Stage < 3)
        {
            GotoState('BreakWalking');            
        }
        else
        {
            // End:0x104
            if(Boss.MonkList.Length > 0)
            {
                GotoState('Healing');
            }
        }
    }
    // End:0x5C8
    if(!Boss.IsWalking())
    {
        // End:0x21E
        if(((PawnDistToEnemy < float(512)) || (RDiff(Rotator(Outer.Enemy.Location - Boss.Location), Boss.Rotation) > float(30)) && Rand(100) < 10) || (Outer.Stage == 3) && PawnDistToCenter > float(3000))
        {
            GotoState('WalkAway');
        }
        Outer.Focus = Outer.Enemy;
        PushState('HandleRotation');
        Outer.Focus = none;
        // End:0x2BD
        if(Boss.Health <= 0)
        {
            goto 'Begin';
        }
        // End:0x36E
        if(((Outer.Stage == 3) && EnemyDistToCenter > float(4096)) && RandRange(0.0000000, 100.0000000) > float(30))
        {
            // End:0x36E
            if((Outer.WorldInfo.TimeSeconds - LastTimeBreathBehindPillars) > 5.0000000)
            {
                GotoState('FireBreathPillars');
            }
        }
        // End:0x3F7
        if(PawnDistToEnemy < float(2048))
        {
            // End:0x3DE
            if((RandRange(0.0000000, 10.0000000) <= float(6 - AttackBalancer)) && EnemyDistToCenter < float(3200))
            {
                AttackBalancer++;
                GotoState('MeleeStrikeWalking');                
            }
            else
            {
                AttackBalancer--;
                GotoState('FireBreathWalking');
            }
        }
        // End:0x48B
        if((PawnDistToEnemy < float(3072)) && VSize2D((Outer.Enemy.Location + Boss.Location) / float(2)) < float(1280))
        {
            GotoState('FireStrikeWalking');
        }
        // End:0x564
        if((EnemyDistToCenter < float(3072)) && RandRange(0.0000000, 100.0000000) < float(75))
        {
            Outer.SetMovePoint_NonNavmesh((vect(1.0000000, 1.0000000, 0.0000000) * Outer.Enemy.Location) + (vect(0.0000000, 0.0000000, 1.0000000) * Boss.Location), 256.0000000, false);
            goto 'Begin';            
        }
        else
        {
            // End:0x5BA
            if((Outer.WorldInfo.TimeSeconds - LastTimeFireBall) > 5.0000000)
            {
                GotoState('FireBallWalking');
            }
        }
        GotoState('WalkAway');
    }
    Outer.Sleep(0.1000000);
    goto 'Begin';
    stop;                    
}

state HandleRotation
{Begin:

    Outer.Sleep(0.0500000);
    Outer.AbortMoving();
    Outer.FinishRotation();
    Outer.Sleep(0.0500000);
    PopState();
    stop;                
}

state WalkAway
{
    function Vector GetBestWanderLocation()
    {
        local Vector currentTarget, BestTarget;

        BestTarget = (Boss.Location * vect(0.0000000, 0.0000000, 1.0000000)) + (vect(1.0000000, 1.0000000, 0.0000000) * (vect(0.0000000, 0.0000000, 0.0000000) + ((VRand() * float(RandBound)) * RandRange(0.5000000, 0.9500000))));
        LoopIndex = 0;
        J0x89:

        // End:0x1F5 [Loop If]
        if(LoopIndex < 5)
        {
            currentTarget = (Boss.Location * vect(0.0000000, 0.0000000, 1.0000000)) + ((vect(1.0000000, 1.0000000, 0.0000000) * vect(0.0000000, 0.0000000, 0.0000000)) + ((Normal(vect(1.0000000, 1.0000000, 0.0000000) * VRand()) * float(RandBound)) * RandRange(0.5000000, 0.9500000)));
            // End:0x1E7
            if(RDiff(Rotator(currentTarget - Boss.Location), Boss.Rotation) < RDiff(Rotator(BestTarget - Boss.Location), Boss.Rotation))
            {
                BestTarget = currentTarget;
            }
            LoopIndex++;
            // [Loop Continue]
            goto J0x89;
        }
        return BestTarget;
        //return ReturnValue;        
    }
Begin:

    DisplayState = 'WalkAway';
    WalkAwayStartTime = Outer.WorldInfo.TimeSeconds;
    Boss.BreathStop();
    Boss.bForceMoveMode = true;
    Boss.MoveModeToEnforce = 2;
GetNextMove:


    // End:0x147
    if((RandRange(0.0000000, 100.0000000) < float(10)) || (Outer.WorldInfo.TimeSeconds - WalkAwayStartTime) > 5.0000000)
    {
        Boss.bForceMoveMode = false;
        GotoState('BaseWalking');
    }
    MoveLocation = GetBestWanderLocation();
    Outer.SetMovePoint_NonNavmesh(MoveLocation, 256.0000000, false);
Update:


    // End:0x29A
    if((Boss.Health <= 0) || (PawnDistToEnemy > float(1024)) && RDiff(Rotator(Outer.Enemy.Location - Boss.Location), Boss.Rotation) < float(30))
    {
        Outer.AbortMoving();
        Boss.bForceMoveMode = false;
        GotoState('BaseWalking');
    }
    // End:0x2E3
    if(Boss.IsWalking())
    {
        Outer.Sleep(0.0100000);
        goto 'Update';
    }
    Boss.bForceMoveMode = false;
    goto 'GetNextMove';
    stop;        
}

state MeleeStrikeWalking
{Begin:

    DisplayState = 'MeleeStrikeWalking';
    Outer.SetMovePoint_NonNavmesh((vect(1.0000000, 1.0000000, 0.0000000) * Outer.Enemy.Location) + (vect(0.0000000, 0.0000000, 1.0000000) * Boss.Location), 1024.0000000, false);
Update:


    // End:0x113
    if((EnemyDistToCenter > float(3200)) || Boss.Health <= 0)
    {
        Outer.AbortMoving();
        GotoState('BaseWalking');
    }
    Outer.Sleep(0.1000000);
    // End:0x15C
    if(Boss.IsWalking())
    {
        goto 'Update';
    }
    Outer.Focus = none;
    Outer.SetFocalPoint(Outer.Enemy.Location + (Normal(Outer.Enemy.Location - Boss.Location) * float(10240)));
    Outer.Target = Outer.Enemy;
    Outer.SetTimer(0.5000000, false, 'UpdateFocalPoint', Outer);
    Boss.ServerDoPawnAction(63);
    GotoState('BaseWalking');
    stop;                    
}

state FireStrikeWalking
{Begin:

    DisplayState = 'FireStrikeWalking';
    Outer.Focus = none;
    Outer.SetFocalPoint(Boss.Location + (Vector(Boss.Rotation) * float(10240)));
    Outer.Target = Outer.Enemy;
    Outer.SetTimer(0.8500000, false, 'UpdateFocalPoint', Outer);
    Boss.ServerDoPawnAction(64);
    GotoState('BaseWalking');
    stop;                
}

state FireBreathWalking
{Begin:

    DisplayState = 'FireBreathWalking';
    Outer.Focus = none;
    Outer.SetFocalPoint(Boss.Location + (Vector(Boss.Rotation) * float(10240)));
    Boss.ServerDoPawnAction(65);
    GotoState('BaseWalking');
    stop;                    
}

state FireBallWalking
{Begin:

    DisplayState = 'FireBallWalking';
    Outer.Focus = none;
    Outer.SetFocalPoint(Boss.Location + (Vector(Boss.Rotation) * float(10240)));
    Outer.Target = Outer.Enemy;
    Boss.ServerDoPawnAction(67);
    MoveLocation = (((vect(1.0000000, 1.0000000, 0.0000000) * Outer.Enemy.Location) + (vect(0.0000000, 0.0000000, 1.0000000) * Boss.Location)) + Boss.Location) / float(2);
    // End:0x226
    if(VSize2D(MoveLocation - vect(0.0000000, 0.0000000, 0.0000000)) < float(3000))
    {
        Outer.SetFocalPoint(MoveLocation);
        Outer.SetMovePoint_NonNavmesh(MoveLocation, 256.0000000, false);
    }
    LastTimeFireBall = Outer.WorldInfo.TimeSeconds;
    GotoState('BaseWalking');
    stop;            
}

state FireBreathPillars
{
    function Vector getBreathPosition()
    {
        local int currentDist, bestDist;
        local Vector CurrentPos, bestPos;

        bestDist = 8192;
        LoopIndex = 0;
        J0x1A:

        // End:0x14E [Loop If]
        if(LoopIndex < 8)
        {
            CurrentPos = (Vector(MakeRotator(0, int((22.5000000 + float(LoopIndex * 45)) * 182.0444000), 0)) * float(2800)) + (vect(0.0000000, 0.0000000, 1.0000000) * Outer.Pawn.Location);
            currentDist = int(VSize2D(Outer.Enemy.Location - CurrentPos));
            // End:0x140
            if(currentDist < bestDist)
            {
                bestPos = CurrentPos;
                bestDist = currentDist;
            }
            LoopIndex++;
            // [Loop Continue]
            goto J0x1A;
        }
        return bestPos;
        //return ReturnValue;        
    }
Begin:

    DisplayState = 'FireBreathPillars';
    Boss.bPreciseMove = true;
    MoveLocation = getBreathPosition();
    LastTimeBreathBehindPillars = Outer.WorldInfo.TimeSeconds;
    // End:0x124
    if(RDiff(Rotator((Outer.Enemy.Location - vect(0.0000000, 0.0000000, 0.0000000)) * vect(1.0000000, 1.0000000, 0.0000000)), Rotator((MoveLocation - vect(0.0000000, 0.0000000, 0.0000000)) * vect(1.0000000, 1.0000000, 0.0000000))) > float(10))
    {
        GotoState('BaseWalking');
    }
    Outer.SetMovePoint_NonNavmesh(MoveLocation,, false);
Update:


    // End:0x1EC
    if(IsStillWalking())
    {
        Outer.Sleep(0.1000000);
        // End:0x1E2
        if((EnemyDistToCenter < float(4096)) || Boss.Health <= 0)
        {
            Boss.bPreciseMove = false;
            GotoState('BaseWalking');
        }
        goto 'Update';
    }
    Boss.bPreciseMove = false;
    Outer.SetFocalPoint(Boss.Location + (Normal((Boss.Location - vect(0.0000000, 0.0000000, 0.0000000)) * vect(1.0000000, 1.0000000, 0.0000000)) * float(4096)));
    PushState('HandleRotation');
    Boss.ServerDoPawnAction(66);
    LastTimeBreathBehindPillars = Outer.WorldInfo.TimeSeconds;
    GotoState('BaseWalking');
    stop;            
}

state Healing
{
    function CallHealers()
    {
        local PKItem_Boss_Alastor_Statue_Base currentMonk;

        // End:0x55
        foreach Boss.MonkList(currentMonk)
        {
            currentMonk.Heal(Boss);            
        }        
        //return;        
    }
Begin:

    DisplayState = 'Healing';
    Boss.Health = 0;
    Outer.SetFocalPoint((vect(1.0000000, 1.0000000, 0.0000000) * vect(0.0000000, 0.0000000, 0.0000000)) + (vect(0.0000000, 0.0000000, 1.0000000) * Boss.Location));
    PushState('HandleRotation');
    Boss.bPreciseMove = true;
    Outer.SetMovePoint_NonNavmesh((vect(1.0000000, 1.0000000, 0.0000000) * vect(0.0000000, 0.0000000, 0.0000000)) + (vect(0.0000000, 0.0000000, 1.0000000) * Boss.Location),, false);
Update:


    // End:0x177
    if(IsStillWalking())
    {
        Outer.Sleep(0.2500000);
        goto 'Update';
    }
    Boss.bPreciseMove = false;
    Outer.SetFocalPoint(Outer.Location + ((vect(1.0000000, 1.0000000, 0.0000000) * Vector(Boss.Rotation)) * float(1024)));
    PushState('HandleRotation');
    Boss.bVulnurable = false;
    Boss.ServerDoPawnAction(79);
    CallHealers();
    Boss.PlayFullbodySlotAnim('Charge_Loop');
    Boss.HealingSoundLoop.Play();
    LoopIndex = 0;
    J0x2DC:

    // End:0x368 [Loop If]
    if(LoopIndex < 15)
    {
        CheckHealers();
        Boss.RefreshHealthPercentage();
        // End:0x33D
        if(Boss.MonkList.Length == 0)
        {
            // [Explicit Break]
            goto J0x368;
        }
        Outer.Sleep(0.3000000);
        LoopIndex++;
        // [Loop Continue]
        goto J0x2DC;
    }
    J0x368:

    Boss.RefreshHealthPercentage();
    Boss.HealingSoundLoop.Stop();
    Boss.StopFullbodySlotAnim();
    Boss.HideFullBodyHealEffect();
    Boss.bVulnurable = true;
    Boss.ServerDoPawnAction(80);
    GotoState('BaseWalking');
    stop;            
}

state BreakWalking
{Begin:

    DisplayState = 'BreakWalking';
    Outer.SetFocalPoint((vect(1.0000000, 1.0000000, 0.0000000) * vect(0.0000000, 0.0000000, 0.0000000)) + (vect(0.0000000, 0.0000000, 1.0000000) * Boss.Location));
    PushState('HandleRotation');
    Boss.bPreciseMove = true;
    Outer.SetMovePoint_NonNavmesh((vect(1.0000000, 1.0000000, 0.0000000) * vect(0.0000000, 0.0000000, 0.0000000)) + (vect(0.0000000, 0.0000000, 1.0000000) * Boss.Location),, false);
Update1:


    // End:0x157
    if(IsStillWalking())
    {
        Outer.Sleep(0.2500000);
        goto 'Update1';
    }
    Boss.bPreciseMove = false;
    Outer.SetFocalPoint(Boss.Location + ((vect(1.0000000, 1.0000000, 0.0000000) * Vector(Boss.Rotation)) * float(1024)));
    PushState('HandleRotation');
    Boss.ServerDoPawnAction(61);
    Boss.bCollideWorld = false;
    Boss.PlayFullbodySlotAnim('fall');
    Boss.SetPhysics(2);
    Boss.Velocity = vect(0.0000000, 0.0000000, 1.0000000) * float(-2048);
    Outer.Sleep(0.5000000);
    Boss.bCollideWorld = true;
    Boss.ServerDoPawnAction(81);
    Boss.PlayFullbodySlotAnim('fly_up');
Update2:


    Outer.Sleep(0.1000000);
    // End:0x39F
    if(int(Boss.Physics) == int(2))
    {
        goto 'Update2';
    }
    Boss.StopFullbodySlotAnim();
    Boss.ServerDoPawnAction(82);
    Outer.Stage++;
    Boss.Health = Boss.HealthMax;
    Outer.AbortMoving();
    // End:0x4B2
    if(Outer.Stage == 3)
    {
        Boss.AddMonksToList();
        RandBound = 3000;
    }
    Boss.TakeDamage(0, Outer.Enemy.Controller, Outer.Enemy.Location, vect(0.0000000, 0.0000000, 0.0000000), Class'PKDmgType_Rocket',, Outer.Enemy);
    Outer.AutoAcquireEnemy();
    GotoState('BaseWalking');
    stop;        
}
