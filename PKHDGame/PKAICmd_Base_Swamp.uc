class PKAICmd_Base_Swamp extends EvilAICmd_Base_Combat within PKAI_Boss_Swamp;

const WaterBallChanceInIdle = 0.06;
const WaterHandChanceInIdlePhaseOne = 0.25;
const WaterHandChanceInIdlePhaseTwo = 0.09;
const FireBallChanceInIdle = 0.08;
const BossLowerWalkRadius = 3400;
const BossUpperWalkRadius = 3600;
const BubblesSpawnRadius = 3500;

var int LoopIndex;
var Vector MoveLocation;
var Rotator NewRotation;
var bool bFirstPhaseOver;
var bool bDirectionSet;
var PKPawn_Boss_Swamp_Base MySwampPawn;
var float LastTimeIdle;
var name DisplayState;
var float Parameter;
var float MoveAngle;
var array<Vector> BubbleSpawnPositions;
var array<PKItem_Boss_Swamp_Bubble_Base> SixBurningBubbles;
var array<int> PairedNumbers;
var PKItem_Boss_Swamp_Bubble_Base BubbleToExtinguish;
var int BubbleToExtinguishNumber;

function InitVars()
{
    Outer.MapCenter = vect(0.0000000, 0.0000000, 1.0000000) * float(3340);
    bFirstPhaseOver = false;
    LastTimeIdle = 1.0000000;
    bDirectionSet = false;
    MySwampPawn = PKPawn_Boss_Swamp_Base(Outer.MyEvilPawn);
    BubbleToExtinguish = none;
    BubbleToExtinguishNumber = -1;
    PairUpBubbles();
    SetUpBubbleSpawnPositions();
    //return;    
}

function PairUpBubbles()
{
    PairedNumbers.Remove(0, PairedNumbers.Length);
    PairedNumbers.AddItem(4);
    PairedNumbers.AddItem(2);
    PairedNumbers.AddItem(1);
    PairedNumbers.AddItem(5);
    PairedNumbers.AddItem(0);
    PairedNumbers.AddItem(3);
    //return;    
}

function SetUpBubbleSpawnPositions()
{
    local Vector BubbleSpawnPosition;

    BubbleSpawnPosition = Outer.Pawn.Location;
    BubbleSpawnPositions.Remove(0, BubbleSpawnPositions.Length);
    LoopIndex = 0;
    J0x5E:

    // End:0x174 [Loop If]
    if(LoopIndex < 6)
    {
        BubbleSpawnPosition.X = Outer.MapCenter.X + (float(3500) * Cos(float(LoopIndex * 60) * 0.0174533));
        BubbleSpawnPosition.Y = Outer.MapCenter.Y + (float(3500) * Sin(float(LoopIndex * 60) * 0.0174533));
        BubbleSpawnPositions.AddItem(BubbleSpawnPosition);
        LoopIndex++;
        // [Loop Continue]
        goto J0x5E;
    }
    //return;    
}

function Pushed()
{
    super.Pushed();
    Outer.AutoAcquireEnemy();
    InitVars();
    Outer.SetTimer(0.5000000, true, 'Evaluate', self);
    Outer.SetTimer(0.5000000, true, 'CreateBubble', self);
    GotoState('Idle');
    //return;    
}

function Evaluate()
{
    // End:0x26
    if(Outer.Enemy == none)
    {
        return;
    }
    // End:0xDD
    if((float(Outer.Pawn.Health) < (float(Outer.Pawn.HealthMax) * 0.7500000)) && bFirstPhaseOver == false)
    {
        MySwampPawn.AbortMoving();
        GotoState('SwitchPhase');
        return;
    }
    // End:0x12E
    if(MySwampPawn.bStartExtinguishing)
    {
        MySwampPawn.AbortMoving();
        GotoState('ExtinguishFlames');
        return;
    }
    // End:0x168
    if(!MySwampPawn.IsStillWalking())
    {
        GotoState('Idle', 'Update');
    }
    //return;    
}

function CreateBubble()
{
    local Vector BubbleSpawnPosition;
    local PKItem_Boss_Swamp_Bubble_Base Bubble;

    // End:0x1C0
    if(bFirstPhaseOver == false)
    {
        BubbleSpawnPosition = Vector(Rotator(MySwampPawn.Location + MySwampPawn.Velocity) + MakeRotator(0, int(RandRange(-45.0000000, 45.0000000) * 182.0444000), 0)) * RandRange(2200.0000000, 4200.0000000);
        BubbleSpawnPosition.Z = Outer.MapCenter.Z;
        Bubble = Outer.Pawn.Spawn(MySwampPawn.BubbleActorClass,,, BubbleSpawnPosition);
        Bubble.SwampBoss = MySwampPawn;
        Bubble.BubbleType = 0;
        Bubble.bBurnable = false;
    }
    //return;    
}

function FaceEnemy()
{
    MySwampPawn.AbortMoving();
    Outer.SetFocalPoint(Outer.Enemy.Location);
    Outer.SetDesiredRotation(Rotator(Outer.Enemy.Location - Outer.Pawn.Location));
    //return;    
}

auto state Idle
{
    function AttemptWalking()
    {
        // End:0x41
        if(RandRange(0.0000000, 100.0000000) > float(50))
        {
            Outer.bClockwise = true;            
        }
        else
        {
            Outer.bClockwise = false;
        }
        MoveLocation = Outer.MapCenter + (Normal(vect(1.0000000, 1.0000000, 0.0000000) * (Outer.MapCenter - MySwampPawn.Location)) * float(3500));
        // End:0x19D
        if(Outer.bClockwise)
        {
            MySwampPawn.SetDesiredRotation(MakeRotator(0, int(float(Rotator(Outer.MapCenter - MySwampPawn.Location).Yaw) - (float(90) * 182.0444000)), 0));            
        }
        else
        {
            MySwampPawn.SetDesiredRotation(MakeRotator(0, int(float(Rotator(Outer.MapCenter - MySwampPawn.Location).Yaw) + (float(90) * 182.0444000)), 0));
        }
        //return;        
    }

    function float GetAttackEvaluationMultiplier()
    {
        // End:0x74
        if(MySwampPawn.bAttackedByPlayer || (Outer.WorldInfo.TimeSeconds - LastTimeIdle) > float(10))
        {
            return 1.2000000;            
        }
        else
        {
            return 1.0000000;
        }
        //return ReturnValue;        
    }
Begin:

    DisplayState = 'Idle';
    LastTimeIdle = Outer.WorldInfo.TimeSeconds;
Update:


    // End:0xBA
    if(!Outer.HasValidEnemy())
    {
        Outer.Sleep(1.0000000);
        Outer.AutoAcquireEnemy();
        goto 'Update';
    }
    // End:0x215
    if((LastTimeIdle + 3.0000000) < Outer.WorldInfo.TimeSeconds)
    {
        // End:0x184
        if(!bFirstPhaseOver)
        {
            // End:0x149
            if(RandRange(0.0000000, 1.0000000) < (0.0600000 * (GetAttackEvaluationMultiplier())))
            {
                GotoState('Waterball');
            }
            // End:0x181
            if(RandRange(0.0000000, 1.0000000) < (0.2500000 * (GetAttackEvaluationMultiplier())))
            {
                GotoState('WaterhandPhaseOne');
            }            
        }
        else
        {
            // End:0x1BC
            if(RandRange(0.0000000, 1.0000000) < (0.0900000 * (GetAttackEvaluationMultiplier())))
            {
                GotoState('WaterhandPhaseTwo');
            }
            // End:0x1F4
            if(RandRange(0.0000000, 1.0000000) < (0.0800000 * (GetAttackEvaluationMultiplier())))
            {
                GotoState('Fireball');
            }
        }
        MySwampPawn.bAttackedByPlayer = false;
    }
    // End:0x61C
    if(!MySwampPawn.IsStillWalking())
    {
        AttemptWalking();
        LastTimeIdle = Outer.WorldInfo.TimeSeconds;
        // End:0x5F2
        if(((RDiff(Outer.Pawn.Rotation, MakeRotator(0, int(float(Rotator(Outer.MapCenter - Outer.Pawn.Location).Yaw) - (float(90) * 182.0444000)), 0)) < RDiff(Outer.Pawn.Rotation, MakeRotator(0, int(float(Rotator(Outer.MapCenter - Outer.Pawn.Location).Yaw) + (float(90) * 182.0444000)), 0))) && !Outer.bClockwise) || (RDiff(Outer.Pawn.Rotation, MakeRotator(0, int(float(Rotator(Outer.MapCenter - Outer.Pawn.Location).Yaw) - (float(90) * 182.0444000)), 0)) > RDiff(Outer.Pawn.Rotation, MakeRotator(0, int(float(Rotator(Outer.MapCenter - Outer.Pawn.Location).Yaw) + (float(90) * 182.0444000)), 0))) && Outer.bClockwise)
        {
            PushState('HandleRotation');
        }
        MySwampPawn.SetMovePoint(MoveLocation, 128);
    }
    Outer.Sleep(1.0000000);
    goto 'Update';
    stop;                    
}

state HandleRotation
{
    ignores Evaluate;
Begin:

    Outer.AbortMoving();
    Outer.FinishRotation();
    MySwampPawn.SetMovePoint(MoveLocation, 128);
    PopState();
    stop;                
}

state Waterball
{
    ignores Evaluate;
Begin:

    DisplayState = 'Waterball';
    FaceEnemy();
    Outer.FinishRotation();
    Outer.SetFocalPoint(Outer.Enemy.Location);
    Outer.MyEvilPawn.ServerDoPawnAction(68);
    Outer.Sleep(0.5000000);
    GotoState('Idle');
    stop;            
}

state WaterhandPhaseOne
{
    ignores Evaluate;
Begin:

    DisplayState = 'WaterhandPhaseOne';
    FaceEnemy();
    Outer.FinishRotation();
    Outer.SetFocalPoint(Outer.Enemy.Location);
    Outer.MyEvilPawn.ServerDoPawnAction(70);
    GotoState('Idle');
    stop;                
}

state WaterhandPhaseTwo
{
    ignores Evaluate;
Begin:

    DisplayState = 'WaterhandPhaseTwo';
    FaceEnemy();
    Outer.FinishRotation();
    Outer.SetFocalPoint(Outer.Enemy.Location);
    Outer.MyEvilPawn.ServerDoPawnAction(71);
    GotoState('Idle');
    stop;                
}

state Fireball
{
    ignores Evaluate;
Begin:

    DisplayState = 'Fireball';
    FaceEnemy();
    Outer.FinishRotation();
    Outer.SetFocalPoint(Outer.Enemy.Location);
    Outer.MyEvilPawn.ServerDoPawnAction(69);
    Outer.Sleep(0.5000000);
    GotoState('Idle');
    stop;            
}

state SwitchPhase
{
    ignores Evaluate;

    function CreateBubbles()
    {
        local PKItem_Boss_Swamp_Bubble_Base Bubble;

        // End:0x4D
        if(SixBurningBubbles.Length > 0)
        {
            // End:0x40
            foreach SixBurningBubbles(Bubble)
            {
                Bubble.Destroy();                
            }            
            SixBurningBubbles.Length = 0;
        }
        LoopIndex = 0;
        J0x58:

        // End:0x16A [Loop If]
        if(LoopIndex < 6)
        {
            Bubble = Outer.Pawn.Spawn(MySwampPawn.BubbleActorClass,,, BubbleSpawnPositions[LoopIndex]);
            Bubble.SwampBoss = MySwampPawn;
            Bubble.BubbleType = 1;
            Bubble.bBurnable = true;
            SixBurningBubbles.AddItem(Bubble);
            LoopIndex++;
            // [Loop Continue]
            goto J0x58;
        }
        LoopIndex = 0;
        J0x175:

        // End:0x1D9 [Loop If]
        if(LoopIndex < 6)
        {
            SixBurningBubbles[LoopIndex].PairedBubble = SixBurningBubbles[PairedNumbers[LoopIndex]];
            LoopIndex++;
            // [Loop Continue]
            goto J0x175;
        }
        //return;        
    }
Begin:

    DisplayState = 'SwitchPhase';
    Outer.ClearTimer('CreateBubble');
    bFirstPhaseOver = true;
    MySwampPawn.bFirstPhaseOver = true;
    CreateBubbles();
    Outer.Sleep(0.1000000);
    GotoState('Idle');
    stop;        
}

state ExtinguishFlames
{
    ignores Evaluate;

    function FindClosestBubble()
    {
        local float ClosestDistance;
        local PKItem_Boss_Swamp_Bubble_Base TempBubble;

        ClosestDistance = 10000.0000000;
        LoopIndex = 0;
        J0x1A:

        // End:0x14D [Loop If]
        if(LoopIndex < 6)
        {
            TempBubble = SixBurningBubbles[LoopIndex];
            // End:0x13F
            if(VSize2D(TempBubble.Location - Outer.Pawn.Location) < ClosestDistance)
            {
                ClosestDistance = VSize2D(TempBubble.Location - Outer.Pawn.Location);
                BubbleToExtinguish = TempBubble;
                BubbleToExtinguishNumber = LoopIndex;
            }
            LoopIndex++;
            // [Loop Continue]
            goto J0x1A;
        }
        //return;        
    }

    function bool AllBubblesExtinguished()
    {
        local PKItem_Boss_Swamp_Bubble_Base TempBubble;

        // End:0x3D
        foreach SixBurningBubbles(TempBubble)
        {
            // End:0x3C
            if(TempBubble.bIsBurning)
            {                
                return false;
            }            
        }        
        // End:0x6E
        foreach SixBurningBubbles(TempBubble)
        {
            TempBubble.Destroy();            
        }        
        SixBurningBubbles.Length = 0;
        return true;
        //return ReturnValue;        
    }

    function bool CheckDirection()
    {
        return RDiff(Rotator(BubbleToExtinguish.Location - Outer.Pawn.Location), MakeRotator(0, int(float(Rotator(Outer.MapCenter - Outer.Pawn.Location).Yaw) - (float(90) * 182.0444000)), 0)) < RDiff(Rotator(BubbleToExtinguish.Location - Outer.Pawn.Location), MakeRotator(0, int(float(Rotator(Outer.MapCenter - Outer.Pawn.Location).Yaw) + (float(90) * 182.0444000)), 0));
        //return ReturnValue;        
    }
Begin:

    DisplayState = 'ExtinguishFlames';
    MySwampPawn.bStartExtinguishing = false;
    MySwampPawn.AbortMoving();
    Outer.StopLatentExecution();
    FindClosestBubble();
    Outer.SetFocalPoint(BubbleToExtinguish.Location);
    Outer.bClockwise = CheckDirection();
    Outer.FinishRotation();
ChaseTheFires:


    // End:0x3BE
    if(!MySwampPawn.IsStillWalking())
    {
        // End:0x3BE
        if(BubbleToExtinguish != none)
        {
            Outer.bClockwise = CheckDirection();
            Outer.SetFocalPoint(BubbleToExtinguish.Location);
            // End:0x272
            if(VSize2D(MySwampPawn.Location - BubbleToExtinguish.Location) > float(1024))
            {
                MySwampPawn.SetMovePoint(BubbleToExtinguish.Location, 1024);
                J0x22D:

                // End:0x26F [Loop If]
                if(MySwampPawn.IsStillWalking())
                {
                    Outer.Sleep(0.1000000);
                    // [Loop Continue]
                    goto J0x22D;
                }                
            }
            else
            {
                Outer.FinishRotation();
            }
            // End:0x32C
            if(BubbleToExtinguish.bIsBurning)
            {
                PKPawn_Boss_Swamp_Base(Outer.MyEvilPawn).BubbleToExtinguish = BubbleToExtinguish;
                Outer.MyEvilPawn.ServerDoPawnAction(73);
            }
            // End:0x377
            if(Outer.bClockwise)
            {
                BubbleToExtinguishNumber++;
                // End:0x374
                if(BubbleToExtinguishNumber == 6)
                {
                    BubbleToExtinguishNumber = 0;
                }                
            }
            else
            {
                BubbleToExtinguishNumber--;
                // End:0x3A1
                if(BubbleToExtinguishNumber == -1)
                {
                    BubbleToExtinguishNumber = 5;
                }
            }
            BubbleToExtinguish = SixBurningBubbles[BubbleToExtinguishNumber];
        }
    }
    // End:0x3D8
    if(AllBubblesExtinguished())
    {
        goto 'Finish';        
    }
    else
    {
        goto 'ChaseTheFires';
    }
    J0x3E2:

    BubbleToExtinguish = none;
    BubbleToExtinguishNumber = -1;
    MySwampPawn.bIsCurrentyExtinguishing = false;
    MySwampPawn.bVulnerable = false;
    MySwampPawn.SetParameterForAllMaterials('BossState', 0.0000000);
    Outer.SetTimer(0.3000000, true, 'CreateBubble', self);
    bFirstPhaseOver = false;
    MySwampPawn.bFirstPhaseOver = false;
    MySwampPawn.AbortMoving();
    Outer.Sleep(1.5000000);
    GotoState('Idle');
    stop;        
}
