class PKAI_Boss_Alastor extends PKAIController
    config(AI)
    hidecategories(Navigation);

enum EStage
{
    Alastor_Stage,                  // 0
    Alastor_Stage_1,                // 1
    Alastor_Stage_2,                // 2
    Alastor_Stage_3,                // 3
    Alastor_Stage_MAX               // 4
};

var int Stage;
var PKPawn_Boss_Alastor_Base MyAlastorPawn;
var Pawn Target;

function UpdateFocalPoint()
{
    SetFocalPoint(Target.Location + (Normal(Target.Location - MyAlastorPawn.Location) * float(10240)));
    //return;    
}

function CreateCheckpointRecord(out CheckpointRecord Record)
{
    super(EvilAIController).CreateCheckpointRecord(Record);
    Record.BossStageId = Stage;
    //return;    
}

function ApplyCheckpointRecord(const out CheckpointRecord Record)
{
    super(EvilAIController).ApplyCheckpointRecord(Record);
    Stage = Record.BossStageId;
    //return;    
}

event Possess(Pawn NewPawn, bool bVehicleTransition)
{
    super.Possess(NewPawn, bVehicleTransition);
    AutoAcquireEnemy();
    SetAttackBehavior();
    MyAlastorPawn = PKPawn_Boss_Alastor_Base(NewPawn);
    SpawnMeteor();
    //return;    
}

function SpawnMeteor()
{
    local Vector MeteorSpawnLocation;
    local PKItem_Boss_Alastor_Meteor_Base MeteorActor;

    MeteorSpawnLocation = ((vect(1.0000000, 1.0000000, 0.0000000) * VRand()) * float(3072)) + (vect(0.0000000, 0.0000000, 1.0000000) * (GetALocalPlayerController().Pawn.Location.Z + float(16000)));
    MeteorActor = Spawn(MyAlastorPawn.MeteorActorClass,,, MeteorSpawnLocation);
    MeteorActor.Boss = MyAlastorPawn;
    SetTimer(RandRange(1.0000000, 3.0000000), false, 'SpawnMeteor', self);
    //return;    
}

defaultproperties
{
    DefaultCommand=Class'PKAICmd_Base_Alastor'
    MeleeCommand=none
    GuardCommand=none
    StrafeCommand=none
    // Reference: EvilAIReactManager'Default__PKAI_Boss_Alastor.ReactionManager0'
    // Archetype: EvilAIReactManager'Default__PKAIController.ReactionManager0'
    begin object name="ReactionManager0"
    end object
    ReactionManager=ReactionManager0
    DefaultReactConditions=/* Array type was not detected. */
}