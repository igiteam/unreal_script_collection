class PKAI_Boss_Swamp extends PKAIController
    config(AI)
    hidecategories(Navigation);

var array<PKItem_Boss_Swamp_Firefly_Base> Fireflies;
var Vector MapCenter;
var float PawnDistToCenter;
var float PawnDistToEnemy;
var float EnemyDistToCenter;
var bool bClockwise;

function CreateFireflies(Pawn MySwampPawn)
{
    local PKItem_Boss_Swamp_Firefly_Base Firefly;
    local Vector FireflySpawnPosition;
    local int LoopIndex;
    local float FireflySpawnRadius;

    FireflySpawnRadius = 4000.0000000;
    FireflySpawnPosition.Z = MapCenter.Z + float(1000);
    LoopIndex = 0;
    J0x5C:

    // End:0x1FA [Loop If]
    if(LoopIndex < 20)
    {
        FireflySpawnPosition.X = MapCenter.X + (FireflySpawnRadius * Cos(float(LoopIndex * 18) * 0.0174533));
        FireflySpawnPosition.Y = MapCenter.Y + (FireflySpawnRadius * Sin(float(LoopIndex * 18) * 0.0174533));
        Firefly = Pawn.Spawn(PKPawn_Boss_Swamp_Base(MySwampPawn).FireflyActorClass,,, FireflySpawnPosition);
        Firefly.DefaultLocation = FireflySpawnPosition;
        Firefly.BossPawn = MySwampPawn;
        Fireflies.AddItem(Firefly);
        LoopIndex++;
        // [Loop Continue]
        goto J0x5C;
    }
    //return;    
}

function CreateTentacle(float AngleOffset)
{
    local Vector TargetPosition;
    local float AngleEnemy, AngleBoss, AngleDist, ChangeAngle, TargetAngle, TentacleDistFromCenter;

    local PKItem_Boss_Swamp_Tentacle_Base Tentacle;
    local Rotator TargetRotation;

    TargetPosition = ((EnemyDistToCenter < float(10)) ? Enemy.Location : Pawn.Location);
    TargetPosition = Normal(TargetPosition);
    AngleEnemy = Atan2(Enemy.Location.X, Enemy.Location.Y);
    AngleBoss = Atan2(Pawn.Location.X, Pawn.Location.Y);
    TargetAngle = ((EnemyDistToCenter < float(10)) ? AngleEnemy : AngleBoss);
    AngleDist = RDiff(Rotator(Enemy.Location), Rotator(Pawn.Location));
    // End:0x21D
    if(AngleDist > float(23))
    {
        ChangeAngle = RandRange(-0.2000000, 0.2000000) + AngleOffset;        
    }
    else
    {
        ChangeAngle = RandRange(0.3500000, 0.4500000) + AngleOffset;
        // End:0x26F
        if(AngleEnemy > AngleBoss)
        {
            ChangeAngle *= float(-1);
        }
    }
    TargetPosition.X = MapCenter.X + (float(1) * Cos(ChangeAngle + TargetAngle));
    TargetPosition.Y = MapCenter.Y + (float(1) * Sin(ChangeAngle + TargetAngle));
    // End:0x363
    if(EnemyDistToCenter < float(2048))
    {
        TentacleDistFromCenter = RandRange(2048.0000000, 2536.0000000) + (EnemyDistToCenter * 0.5000000);        
    }
    else
    {
        TentacleDistFromCenter = RandRange(2048.0000000, 2536.0000000) + EnemyDistToCenter;
        // End:0x3B0
        if(TentacleDistFromCenter > float(4096))
        {
            TentacleDistFromCenter = 4096.0000000;
        }
    }
    TargetPosition *= TentacleDistFromCenter;
    TargetPosition.Z = MapCenter.Z - float(1024);
    TargetRotation = Rotator(MapCenter - TargetPosition);
    Tentacle = Pawn.Spawn(PKPawn_Boss_Swamp_Base(Pawn).TentacleActorClass,,, TargetPosition, TargetRotation);
    Tentacle.SetRotation(TargetRotation);
    Tentacle.PlayRandomAttack();
    Tentacle.SwampBoss = PKPawn_Boss_Swamp_Base(Pawn);
    //return;    
}

function CreateFireball()
{
    local PKItem_Boss_Swamp_Fireball_Base FireflyFireball;

    FireflyFireball = Pawn.Spawn(PKPawn_Boss_Swamp_Base(Pawn).FireballActorClass,,, Pawn.Mesh.GetBoneLocation('d_l_srodek'));
    FireflyFireball.BallOfFireflies = Fireflies;
    FireflyFireball.SwampBoss = PKPawn_Boss_Swamp_Base(Pawn);
    FireflyFireball.GoToDestination(Enemy.Location);
    //return;    
}

function GatherFireflies()
{
    local PKItem_Boss_Swamp_Firefly_Base Firefly;

    // End:0x76
    foreach Fireflies(Firefly)
    {
        Firefly.GoToDestination(Pawn.Mesh.GetBoneLocation('LeftHand'), 1);        
    }    
    //return;    
}

function bool NotifyBump(Actor Other, Vector HitNormal)
{
    //return ReturnValue;    
}

event PostBeginPlay()
{
    super(Controller).PostBeginPlay();
    MapCenter = vect(0.0000000, 0.0000000, 1.0000000) * float(3340);
    UpdateDists();
    SetTimer(0.5000000, true, 'UpdateDists', self);
    //return;    
}

event Possess(Pawn NewPawn, bool bVehicleTransition)
{
    super.Possess(NewPawn, bVehicleTransition);
    AutoAcquireEnemy();
    SetAttackBehavior();
    CreateFireflies(NewPawn);
    //return;    
}

function UpdateDists()
{
    PawnDistToCenter = VSize2D(Pawn.Location - MapCenter);
    // End:0xDB
    if(Enemy != none)
    {
        PawnDistToEnemy = VSize2D(Pawn.Location - Enemy.Location);
        EnemyDistToCenter = VSize2D(Enemy.Location - MapCenter);
    }
    //return;    
}

defaultproperties
{
    bClockwise=true
    DefaultCommand=Class'PKAICmd_Base_Swamp'
    MeleeCommand=none
    GuardCommand=none
    StrafeCommand=none
    // Reference: EvilAIReactManager'Default__PKAI_Boss_Swamp.ReactionManager0'
    // Archetype: EvilAIReactManager'Default__PKAIController.ReactionManager0'
    begin object name="ReactionManager0"
    end object
    ReactionManager=ReactionManager0
    DefaultReactConditions=/* Array type was not detected. */
}