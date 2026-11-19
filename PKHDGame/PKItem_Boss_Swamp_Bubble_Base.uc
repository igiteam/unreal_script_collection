class PKItem_Boss_Swamp_Bubble_Base extends PKItem_Boss_Base_Item
    notplaceable
    hidecategories(Navigation);

enum EType
{
    BUB_Random,                     // 0
    BUB_Burning,                    // 1
    BUB_Flying,                     // 2
    BUB_MAX                         // 3
};

var export editinline StaticMeshComponent BubbleMesh;
var export editinline StaticMeshComponent MyBubbleMesh;
var export editinline ParticleSystemComponent FireParticles;
var EvilExplosion ParticlesOnDestroy;
var ParticleSystem ParticlesOnBurn;
var SoundCue SoundOnDestroy;
var SoundCue SoundOnSpawn;
var SoundCue SoundOnIgnite;
var SoundCue SoundOnFire;
var PKPawn_Boss_Swamp_Base SwampBoss;
var int TimeToLive;
var PKItem_Boss_Swamp_Bubble_Base.EType BubbleType;
var repnotify bool bIsBurning;
var repnotify bool bIsFading;
var bool bBurnable;
var PKItem_Boss_Swamp_Bubble_Base PairedBubble;
var PKItem_Boss_Swamp_Flying_Bubble_Base FlyingBubble;

replication
{
    // Pos:0x000
    if(bNetDirty)
        BubbleType, bBurnable, 
        bIsBurning, bIsFading;
}

simulated event PostBeginPlay()
{
    super(Actor).PostBeginPlay();
    SetDrawScale(0.0100000);
    SetTimer(0.0500000, false, 'BubbleGrow', self);
    PlaySound(SoundOnSpawn,,,, Location);
    //return;    
}

simulated function BubbleGrow()
{
    SetDrawScale(DrawScale + 0.0100000);
    // End:0x40
    if(DrawScale < 0.5000000)
    {
        SetTimer(0.0500000, false, 'BubbleGrow', self);
    }
    //return;    
}

simulated function CreateFlyingBubble()
{
    FlyingBubble = SwampBoss.Spawn(SwampBoss.FlyingBubbleActorClass,,, Location);
    FlyingBubble.SwampBoss = SwampBoss;
    FlyingBubble.AssociatedBubbles.AddItem(self);
    FlyingBubble.AssociatedBubbles.AddItem(PairedBubble);
    PairedBubble.FlyingBubble = FlyingBubble;
    FlyingBubble.BubbleMesh.SetHidden(true);
    //return;    
}

event Touch(Actor Other, PrimitiveComponent OtherComp, Vector HitLocation, Vector HitNormal)
{
    // End:0x58
    if((int(BubbleType) == int(2)) && Other.IsPlayerOwned())
    {
        DetachComponent(BubbleMesh);
        Explode();
        Destroy();
    }
    //return;    
}

event HitWall(Vector HitNormal, Actor Wall, PrimitiveComponent WallComp)
{
    // End:0x37
    if(int(BubbleType) == int(2))
    {
        DetachComponent(BubbleMesh);
        Explode();
        Destroy();        
    }
    else
    {
        super(Actor).HitWall(HitNormal, Wall, WallComp);
    }
    //return;    
}

simulated event TakeDamage(int Damage, Controller InstigatedBy, Vector HitLocation, Vector Momentum, class<DamageType> DamageType, optional TraceHitInfo HitInfo, optional Actor DamageCauser)
{
    // End:0x1A5
    if((InstigatedBy != none) && InstigatedBy.IsPlayerOwned())
    {
        // End:0x12B
        if(int(BubbleType) == int(0))
        {
            // End:0x108
            if(VSize2D(SwampBoss.Location - Location) < float(SwampBoss.BubbleDamageRadius))
            {
                SwampBoss.TakeBubbleDamage(SwampBoss.BubbleDamage, InstigatedBy, Location, vect(0.0000000, 0.0000000, 0.0000000), Class'PKDmgType_Grenade',, self);
            }
            DetachComponent(BubbleMesh);
            Explode();
            Destroy();            
        }
        else
        {
            // End:0x162
            if(int(BubbleType) == int(2))
            {
                DetachComponent(BubbleMesh);
                Explode();
                Destroy();                
            }
            else
            {
                // End:0x1A5
                if(bBurnable)
                {
                    PutOnFire();
                    // End:0x1A5
                    if(PairedBubble.bIsBurning)
                    {
                        CreateFlyingBubble();
                    }
                }
            }
        }
    }
    //return;    
}

simulated function Explode()
{
    local PKPlayerPawn PlayerPawn;

    SwampBoss.PlayArchetypeEffect(ParticlesOnDestroy, Location, MakeRotator(int(float(90) * 182.0444000), 0, 0));
    // End:0x145
    if(int(BubbleType) == int(2))
    {
        // End:0x144
        foreach DynamicActors(Class'PKPlayerPawn', PlayerPawn)
        {
            // End:0x143
            if(VSize(PlayerPawn.Location - Location) < float(SwampBoss.FireBallDamageRadius))
            {
                PlayerPawn.TakeDamage(SwampBoss.BubbleDamageToPlayer, SwampBoss.Controller, Location, vect(0.0000000, 0.0000000, 0.0000000), Class'PKDmgType_Grenade',, self);
            }            
        }        
    }
    PlaySound(SoundOnDestroy,,,, Location);
    //return;    
}

function Extinguish()
{
    bIsBurning = false;
    FireParticles.DeactivateSystem();
    FlyingBubble.Destroy();
    FlyingBubble = none;
    PairedBubble.FlyingBubble = none;
    SetTimer(1.0000000, false, 'Destroy', self);
    //return;    
}

function PutOnFire()
{
    bIsBurning = true;
    bBurnable = false;
    FireParticles = new (self) Class'EvilGame.UTParticleSystemComponent';
    FireParticles.SetTemplate(ParticlesOnBurn);
    AttachComponent(FireParticles);
    FireParticles.SetScale(5.0000000);
    FireParticles.ActivateSystem();
    MyBubbleMesh.SetHidden(true);
    PlaySound(SoundOnIgnite,,,, Location);
    PlaySound(SoundOnFire,,, true, Location);
    //return;    
}

simulated function BubbleFade()
{
    SetDrawScale(DrawScale - 0.0100000);
    // End:0x40
    if(DrawScale > 0.0100000)
    {
        SetTimer(0.0500000, false, 'BubbleFade', self);
    }
    //return;    
}

simulated event ReplicatedEvent(name VarName)
{
    switch(VarName)
    {
        // End:0x112
        case 'bIsBurning':
            // End:0xF0
            if(bIsBurning)
            {
                FireParticles = WorldInfo.MyEmitterPool.SpawnEmitter(ParticlesOnBurn, Location, Rotation);
                FireParticles.SetScale(2.0000000);
                FireParticles.ActivateSystem();
                MyBubbleMesh.SetHidden(true);                
            }
            else
            {
                FireParticles.DeactivateSystem();
            }
            // End:0x14E
            break;
        // End:0x138
        case 'bIsFading':
            // End:0x135
            if(bIsFading)
            {
                BubbleFade();
            }
            // End:0x14E
            break;
        // End:0xFFFF
        default:
            super(Actor).ReplicatedEvent(VarName);
            break;
    }
    //return;    
}

auto state RandomBubbleChillin
{Begin:

    // End:0x21
    if(int(BubbleType) == int(0))
    {
        goto 'Chill';        
    }
    else
    {
        GotoState('OtherBubbleChillin');
    }
    J0x2F:

    Sleep(0.5000000);
    // End:0x55
    if(DrawScale >= 0.5000000)
    {
        TimeToLive--;
    }
    // End:0x88
    if(TimeToLive == 0)
    {
        bIsFading = true;
        BubbleFade();
        Sleep(3.0000000);
        Destroy();        
    }
    else
    {
        goto 'Chill';
    }
    stop;        
}

state OtherBubbleChillin
{Begin:

    Sleep(1.0000000);
    goto 'Begin';
    stop;        
}
