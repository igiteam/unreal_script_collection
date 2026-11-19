class PKItem_Boss_Swamp_Tentacle_Base extends PKItem_Boss_Base_Item
    notplaceable
    hidecategories(Navigation);

var export editinline SkeletalMeshComponent TentacleMesh;
var export editinline SkeletalMeshComponent MyTentacleMesh;
var array<name> AnimNames;
var PKPawn_Boss_Swamp_Base SwampBoss;
var bool bReadyToHit;
var PKPawn Enemy;
var PKPlayerPawn SuckTarget;
var repnotify name AttackAnim;

replication
{
    // Pos:0x000
    if(bNetDirty)
        AttackAnim, bReadyToHit;
}

simulated function StartHit()
{
    bReadyToHit = true;
    Velocity = vect(0.0000000, 0.0000000, 0.0000000);
    //return;    
}

simulated function EndHit()
{
    bReadyToHit = false;
    Velocity = (vect(0.0000000, 0.0000000, 1.0000000) + (Normal(Enemy.Location - Location) * vect(1.0000000, 1.0000000, 0.0000000))) * float(-4096);
    //return;    
}

function PlayRandomAttack()
{
    SetHidden(false);
    SetRotation(Rotator((Enemy.Location - Location) * vect(1.0000000, 1.0000000, 0.0000000)));
    AttackAnim = AnimNames[int(RandRange(0.0000000, 2.0000000))];
    bReadyToHit = false;
    MyTentacleMesh.PlayAnim(AttackAnim);
    //return;    
}

event PostBeginPlay()
{
    super(Actor).PostBeginPlay();
    Enemy = PKPawn(GetALocalPlayerController().Pawn);
    SetRotation(Rotator((Enemy.Location - Location) * vect(1.0000000, 1.0000000, 0.0000000)));
    Velocity = (vect(0.0000000, 0.0000000, 1.0000000) + (Normal(Enemy.Location - Location) * vect(1.0000000, 1.0000000, 0.0000000))) * float(2048);
    PlayRandomAttack();
    //return;    
}

event Touch(Actor Other, PrimitiveComponent OtherComp, Vector HitLocation, Vector HitNormal)
{
    // End:0x89
    if(bReadyToHit && Other != SwampBoss)
    {
        Other.TakeDamage(25, SwampBoss.MyPKAI, HitLocation, vect(0.0000000, 0.0000000, 0.0000000), Class'EvilGame.EvilDmgType_Melee',, self);        
    }
    else
    {
        super(Actor).Touch(Other, OtherComp, HitLocation, HitNormal);
    }
    //return;    
}

simulated event Tick(float DeltaTime)
{
    local PKPlayerPawn PlayerPawn;
    local Vector TempLocation;

    TempLocation = MyTentacleMesh.GetBoneLocation('joint10');
    // End:0x19E
    foreach DynamicActors(Class'PKPlayerPawn', PlayerPawn)
    {
        // End:0x19D
        if(bReadyToHit && VSize(PlayerPawn.Location - TempLocation) < float(SwampBoss.TentacleDamageRadius))
        {
            bReadyToHit = false;
            PlayerPawn.TakeDamage(SwampBoss.TentacleDamage, SwampBoss.MyPKAI, MyTentacleMesh.GetBoneLocation('joint10'), vect(0.0000000, 0.0000000, 0.0000000), Class'EvilGame.EvilDmgType_Melee',, self);
            // End:0x19D
            if(RandRange(0.0000000, 1.0000000) < SwampBoss.TentacleSuckChance)
            {
                SuckTarget = PlayerPawn;
            }
        }        
    }    
    // End:0x248
    if(SuckTarget != none)
    {
        SuckTarget.MoveSmooth(TempLocation - SuckTarget.Location);
        SuckTarget.GetPC().PushState('TornadoRotate');
        SuckTarget.SetPhysics(2);
    }
    super(Actor).Tick(DeltaTime);
    //return;    
}

simulated event ReplicatedEvent(name VarName)
{
    switch(VarName)
    {
        // End:0x4F
        case 'AttackAnim':
            MyTentacleMesh.PlayAnim(AttackAnim);
            // End:0x65
            break;
        // End:0xFFFF
        default:
            super(Actor).ReplicatedEvent(VarName);
            break;
    }
    //return;    
}
