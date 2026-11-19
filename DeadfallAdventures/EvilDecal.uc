class EvilDecal extends DecalComponent
    editinlinenew
    hidecategories(Collision,Object,Physics,PrimitiveComponent);

var Pawn Instigator;
var bool bRandomizeRotation;
var bool bRandomizeScaling;
var bool ClipDecalsUsingFastPath;
var Vector2D RandomScalingRange;
var float LifeSpan;
var MaterialInstanceTimeVarying MITV_Decal;
var float MinExplosionThickness;
var float MinImpactThickness;
var float PercentToSpawnOnFracturedMesh;

protected simulated function SharedAttachmentInit(Actor TargetAttachment, Vector RayDir)
{
    local float RandomScale;

    // End:0x20
    if(bRandomizeRotation)
    {
        DecalRotation = FRand() * 360.0000000;
    }
    // End:0x74
    if(bRandomizeScaling)
    {
        RandomScale = GetRangeValueByPct(RandomScalingRange, FRand());
        Width *= RandomScale;
        Height *= RandomScale;
    }
    //return;    
}

final simulated function AttachToSurface(EvilPawn Pawn, Vector TraceLocation, Vector TraceDirection, float TraceMagnitude)
{
    local Actor HitActor;
    local Vector HitL, HitN;
    local TraceHitInfo HitInfo;

    // End:0x28B
    if(Pawn != none)
    {
        Instigator = Pawn;
        HitActor = Pawn.Trace(HitL, HitN, TraceLocation + ((TraceDirection * TraceMagnitude) * 2.0000000), TraceLocation, false, vect(0.0000000, 0.0000000, 0.0000000), HitInfo, 2);
        // End:0x28B
        if(HitActor != none)
        {
            // End:0x10C
            if(HitActor.bStatic)
            {
                HitActor = Pawn.WorldInfo.GRI;
            }
            Location = HitL;
            Orientation = Rotator(-HitN);
            DecalRotation = 0.0000000;
            HitComponent = HitInfo.HitComponent;
            HitBone = HitInfo.BoneName;
            // End:0x1FC
            if(ClipDecalsUsingFastPath == true)
            {
                HitNodeIndex = HitInfo.Item;
                HitLevelIndex = HitInfo.LevelIndex;
                bNoClip = false;                
            }
            else
            {
                HitNodeIndex = -1;
                HitLevelIndex = -1;
                bNoClip = true;
            }
            FracturedStaticMeshComponentIndex = HitInfo.Item;
            SharedAttachmentInit(HitActor, TraceDirection);
            HitActor.AttachComponent(self);            
        }
    }
    //return;    
}

final simulated function AttachFromImpact(Pawn InInstigator, const out ImpactInfo Impact)
{
    local Actor HitActor;

    HitActor = ((Impact.HitActor.bStatic) ? Impact.HitActor.WorldInfo.GRI : Impact.HitActor);
    // End:0xCF
    if((FracturedStaticMeshActor(HitActor) != none) && FRand() > PercentToSpawnOnFracturedMesh)
    {
        return;
    }
    Instigator = InInstigator;
    Location = Impact.HitLocation;
    Orientation = Rotator(-Impact.HitNormal);
    DecalRotation = 0.0000000;
    HitComponent = Impact.HitInfo.HitComponent;
    HitBone = Impact.HitInfo.BoneName;
    // End:0x238
    if(ClipDecalsUsingFastPath == true)
    {
        HitNodeIndex = Impact.HitInfo.Item;
        HitLevelIndex = Impact.HitInfo.LevelIndex;        
    }
    else
    {
        HitNodeIndex = -1;
        HitLevelIndex = -1;
    }
    FracturedStaticMeshComponentIndex = Impact.HitInfo.Item;
    SharedAttachmentInit(HitActor, Impact.RayDir);
    HitActor.AttachComponent(self);
    //return;    
}

protected final simulated function CopyFromSource(DecalData Source, const out ImpactInfo Impact)
{
    local float DecalLifeSpan;

    // End:0x3D
    if(EvilPawn(Impact.HitActor) == none)
    {
        DecalLifeSpan = 999999.0000000;        
    }
    else
    {
        DecalLifeSpan = 15.0000000;
    }
    // End:0xF0
    if(MaterialInstanceTimeVarying(Source.DecalMaterial) != none)
    {
        MITV_Decal.SetParent(Source.DecalMaterial);
        MITV_Decal.SetDuration(DecalLifeSpan);
        SetDecalMaterial(MITV_Decal);        
    }
    else
    {
        SetDecalMaterial(Source.DecalMaterial);
    }
    Width = Source.Width;
    Height = Source.Height;
    FarPlane = float(Max(int(Source.Thickness), int(MinImpactThickness))) * 0.5000000;
    NearPlane = -FarPlane;
    bRandomizeRotation = Source.bRandomizeRotation;
    bRandomizeScaling = true;
    RandomScalingRange = Source.RandomScalingRange;
    ClipDecalsUsingFastPath = Source.ClipDecalsUsingFastPath;
    LifeSpan = DecalLifeSpan;
    //return;    
}

static function DecalData GetRandomDecalMaterial(const array<DecalData> DecalDataArray)
{
    local DecalData DecalData;

    // End:0x27
    if(DecalDataArray.Length > 0)
    {
        return DecalDataArray[Rand(DecalDataArray.Length)];
    }
    return DecalData;
    //return ReturnValue;    
}

defaultproperties
{
    LifeSpan=999999.0000000
    MinExplosionThickness=40.0000000
    MinImpactThickness=10.0000000
    PercentToSpawnOnFracturedMesh=0.6000000
    bProjectOnBackfaces=true
    DepthBias=-0.0001000
    BackfaceAngle=-0.0010000
    BlendRange=(X=80.0000000,Y=90.0000000)
    ReplacementPrimitive=none
    MaxDrawDistance=4000.0000000
    bIgnoreOwnerHidden=true
}