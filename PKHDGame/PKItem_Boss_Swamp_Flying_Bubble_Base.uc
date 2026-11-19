class PKItem_Boss_Swamp_Flying_Bubble_Base extends PKItem_Boss_Base_Item
    notplaceable
    hidecategories(Navigation);

const Speed = 1000;

var export editinline StaticMeshComponent BubbleMesh;
var EvilExplosion ParticlesOnDestroy;
var SoundCue SoundOnDestroy;
var SoundCue SoundOnSpawn;
var export editinline AudioComponent FlyingSoundLoop;
var PKPawn_Boss_Swamp_Base SwampBoss;
var array<PKItem_Boss_Swamp_Bubble_Base> AssociatedBubbles;
var PKItem_Boss_Swamp_Bubble_Base OriginBubble;
var PKItem_Boss_Swamp_Bubble_Base DestinationBubble;
var PKItem_Boss_Swamp_Bubble_Base BubbleSwapVariable;
var bool bDestroyed;
var bool bFlying;
var Rotator NewRotation;
var float DistanceBetweenBubbles;
var float BubbleDistanceDelta;
var float RotationCount;

simulated event PostBeginPlay()
{
    super(Actor).PostBeginPlay();
    bDestroyed = true;
    bFlying = false;
    SetDrawScale(0.5000000);
    FlyingSoundLoop.Play();
    //return;    
}

simulated event TakeDamage(int Damage, Controller InstigatedBy, Vector HitLocation, Vector Momentum, class<DamageType> DamageType, optional TraceHitInfo HitInfo, optional Actor DamageCauser)
{
    // End:0x28
    if(!InstigatedBy.IsPlayerOwned())
    {
        return;
    }
    Explode();
    // End:0x15A
    if(VSize(SwampBoss.Location - Location) < float(SwampBoss.BubbleDamageRadius))
    {
        // End:0x10C
        if(!SwampBoss.bIsCurrentyExtinguishing && SwampBoss.bFirstPhaseOver)
        {
            SwampBoss.bStartExtinguishing = true;
            SwampBoss.bIsCurrentyExtinguishing = true;
        }
        SwampBoss.bVulnerable = true;
        SwampBoss.SetParameterForAllMaterials('BossState', 0.5000000);
    }
    Velocity = vect(0.0000000, 0.0000000, 0.0000000);
    bDestroyed = true;
    bFlying = false;
    GotoState('Chillin', 'Begin');
    //return;    
}

simulated event Destroyed()
{
    Explode();
    BubbleMesh.SetHidden(true);
    super(Actor).Destroyed();
    //return;    
}

simulated function Explode()
{
    SwampBoss.PlayArchetypeEffect(ParticlesOnDestroy, Location, MakeRotator(int(float(90) * 182.0444000), 0, 0));
    PlaySound(SoundOnDestroy,,,, Location);
    BubbleMesh.SetHidden(true);
    //return;    
}

event Tick(float DeltaTime)
{
    super(Actor).Tick(DeltaTime);
    // End:0xE9
    if(bFlying && VSize2D(DestinationBubble.Location - Location) < (DistanceBetweenBubbles - (RotationCount * BubbleDistanceDelta)))
    {
        NewRotation.Pitch -= int((DeltaTime * float(60)) * 182.0444000);
        RotationCount += (DeltaTime * float(60));
        Velocity = Normal(Vector(NewRotation)) * float(1000);
    }
    //return;    
}

auto simulated state Chillin
{
    function float GetRandDelay()
    {
        return RandRange(0.1000000, 1.0000000);
        //return ReturnValue;        
    }
Begin:

    // End:0x90
    if(bDestroyed)
    {
        bDestroyed = false;
        // End:0x63
        if(RandRange(0.0000000, 100.0000000) < float(50))
        {
            OriginBubble = AssociatedBubbles[0];
            DestinationBubble = AssociatedBubbles[1];            
        }
        else
        {
            OriginBubble = AssociatedBubbles[1];
            DestinationBubble = AssociatedBubbles[0];
        }        
    }
    else
    {
        BubbleSwapVariable = OriginBubble;
        OriginBubble = DestinationBubble;
        DestinationBubble = BubbleSwapVariable;
    }
    DistanceBetweenBubbles = VSize2D(DestinationBubble.Location - OriginBubble.Location);
    BubbleDistanceDelta = DistanceBetweenBubbles / float(90);
    RotationCount = 1.0000000;
    SetLocation(OriginBubble.Location);
    Sleep(GetRandDelay());
    bFlying = true;
    NewRotation = Rotator(DestinationBubble.Location - Location);
    NewRotation.Pitch += int(float(45) * 182.0444000);
    Velocity = Normal(Vector(NewRotation)) * float(1000);
    BubbleMesh.SetHidden(false);
    PlaySound(SoundOnSpawn,,,, Location);
    goto 'Flying';
Flying:


    Sleep(0.1000000);
    // End:0x2DB
    if((RotationCount == float(90)) || Location.Z < float(3450))
    {
        Velocity = vect(0.0000000, 0.0000000, 0.0000000);
        bFlying = false;
        BubbleMesh.SetHidden(true);
        goto 'Begin';        
    }
    else
    {
        goto 'Flying';
    }
    stop;            
}
