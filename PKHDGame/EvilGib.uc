class EvilGib extends Actor
    config(Game)
    notplaceable
    hidecategories(Navigation);

struct StaticMeshDatum
{
    var() StaticMesh TheStaticMesh;
    var() SkeletalMesh TheSkelMesh;
    var() PhysicsAsset ThePhysAsset;
    var() float DrawScale;
    var bool bUseSecondaryGibMeshMITV;

    structdefaultproperties
    {
        TheStaticMesh=none
        TheSkelMesh=none
        ThePhysAsset=none
        DrawScale=1.0000000
        bUseSecondaryGibMeshMITV=false
    }
};

var export editinline DynamicLightEnvironmentComponent GibLightEnvironment;
var() SoundCue HitSound;
var export editinline MeshComponent GibMeshComp;
var MaterialInstanceConstant MIC_Gib;
var MaterialInstance MI_Decal;
var() MaterialInstanceTimeVarying MITV_DecalTemplate;
var() float DecalWidth;
var() float DecalHeight;
var() float MomentumScale;
var name DecalDissolveParamName;
var float DecalWaitTimeBeforeDissolve;
var() MaterialInstanceTimeVarying MITV_GibMeshTemplate;
var protected MaterialInstanceTimeVarying MITV_GibMeshTemplateSecondary;
var protected name GibMeshDissolveParamName;
var() float GibMeshWaitTimeBeforeDissolve;
var export editinline ParticleSystemComponent PSC_GibEffect;
var ParticleSystem PS_CustomEffect;
var globalconfig bool bUseUnrealPhysics;
var bool bStopMovingCamera;
var() bool bLateChooseGib;
var() array<StaticMeshDatum> GibMeshesData;
var Vector OldCamLoc;
var Rotator OldCamRot;

simulated event PreBeginPlay()
{
    super.PreBeginPlay();
    // End:0x23
    if(!bLateChooseGib)
    {
        ChooseGib();
    }
    //return;    
}

simulated function SetTexturesToBeResident(float TimeToBeResident)
{
    local int MatIdx;

    MatIdx = 0;
    J0x0B:

    // End:0x90 [Loop If]
    if(MatIdx < GibMeshComp.Materials.Length)
    {
        GibMeshComp.Materials[MatIdx].SetForceMipLevelsToBeResident(false, false, TimeToBeResident);
        ++MatIdx;
        // [Loop Continue]
        goto J0x0B;
    }
    //return;    
}

simulated function DisplayDebug(HUD HUD, out float out_YL, out float out_YPos)
{
    // End:0x85
    if(SkeletalMeshComponent(GibMeshComp) != none)
    {
        HUD.Canvas.DrawText("Mesh " $ string(SkeletalMeshComponent(GibMeshComp).SkeletalMesh), false);        
    }
    else
    {
        HUD.Canvas.DrawText("Mesh " $ string(StaticMeshComponent(GibMeshComp).StaticMesh), false);
    }
    out_YPos += out_YL;
    HUD.Canvas.SetPos(4.0000000, out_YPos);
    super.DisplayDebug(HUD, out_YL, out_YPos);
    //return;    
}

simulated function SetNewGibStaticMesh(StaticMesh NewStaticMesh)
{
    local StaticMeshDatum STMeshDatum;

    STMeshDatum.TheStaticMesh = NewStaticMesh;
    GibMeshesData.AddItem(STMeshDatum);
    ChooseGib();
    //return;    
}

simulated function SetGibStaticMesh(StaticMesh NewStaticMesh)
{
    local editinline StaticMeshComponent SMC;

    GibMeshComp = new (self) Class'EvilGibStaticMeshComponent';
    CollisionComponent = GibMeshComp;
    SMC = StaticMeshComponent(GibMeshComp);
    AttachComponent(GibMeshComp);
    SMC.SetStaticMesh(NewStaticMesh);
    SMC.SetLightEnvironment(GibLightEnvironment);
    //return;    
}

simulated function ChooseGib()
{
    local StaticMeshDatum SMD;
    local editinline StaticMeshComponent SMC;
    local editinline SkeletalMeshComponent SKMC;
    local int StartIndex, Index;
    local MaterialInstanceTimeVarying GibMaterialInstance;
    local editinline CylinderComponent MyCylinder;

    // End:0x599
    if(GibMeshesData.Length > 0)
    {
        Index = Rand(GibMeshesData.Length);
        // End:0x133
        if(((bUseUnrealPhysics || WorldInfo.bDropDetail) || int(WorldInfo.GetDetailMode()) == int(0)) || Class'Engine.Engine'.static.IsSplitScreen())
        {
            StartIndex = Index;
            J0xBA:

            // End:0x133 [Loop If]
            if(GibMeshesData[Index].ThePhysAsset != none)
            {
                Index++;
                // End:0x114
                if(Index >= GibMeshesData.Length)
                {
                    Index = 0;
                }
                // End:0x130
                if(Index == StartIndex)
                {
                    Destroy();
                    return;
                }
                // [Loop Continue]
                goto J0xBA;
            }
        }
        SMD = GibMeshesData[Index];
        // End:0x31D
        if(SMD.ThePhysAsset == none)
        {
            GibMeshComp = new (self) Class'EvilGibStaticMeshComponent';
            // End:0x261
            if(bUseUnrealPhysics)
            {
                MyCylinder = new (self) Class'Engine.CylinderComponent';
                CollisionComponent = MyCylinder;
                MyCylinder.SetCylinderSize(5.0000000, 5.0000000);
                MyCylinder.SetTraceBlocking(true, false);
                MyCylinder.SetActorCollision(true, false, false);
                SetPhysics(2);
                bCollideWorld = true;
                bBounce = true;
                AttachComponent(MyCylinder);                
            }
            else
            {
                CollisionComponent = GibMeshComp;
            }
            SMC = StaticMeshComponent(GibMeshComp);
            SMC.SetScale(SMD.DrawScale);
            AttachComponent(GibMeshComp);
            SMC.SetStaticMesh(SMD.TheStaticMesh);            
        }
        else
        {
            GibMeshComp = new (self) Class'EvilGibSkeletalMeshComponent';
            CollisionComponent = GibMeshComp;
            SKMC = SkeletalMeshComponent(GibMeshComp);
            SKMC.SetSkeletalMesh(SMD.TheSkelMesh);
            SKMC.SetPhysicsAsset(SMD.ThePhysAsset);
            SKMC.SetScale(SMD.DrawScale);
            AttachComponent(GibMeshComp);
            SKMC.SetHasPhysicsAssetInstance(true);
        }
        GibMeshComp.SetLightEnvironment(GibLightEnvironment);
        DoCustomGibEffects();
        // End:0x596
        if(!WorldInfo.IsConsoleBuild(3))
        {
            GibMaterialInstance = new (self) Class'Engine.MaterialInstanceTimeVarying';
            // End:0x509
            if(SMD.bUseSecondaryGibMeshMITV == false)
            {
                GibMaterialInstance.SetParent(MITV_GibMeshTemplate);                
            }
            else
            {
                GibMaterialInstance.SetParent(MITV_GibMeshTemplateSecondary);
            }
            GibMeshComp.SetMaterial(0, GibMaterialInstance);
            GibMaterialInstance.SetScalarStartTime(GibMeshDissolveParamName, GibMeshWaitTimeBeforeDissolve - (FRand() * 1.0000000));
        }        
    }
    else
    {
        Destroy();
    }
    //return;    
}

simulated function DoCustomGibEffects()
{
    //return;    
}

function Timer()
{
    local PlayerController PC;

    // End:0x52
    foreach LocalPlayerControllers(Class'Engine.PlayerController', PC)
    {
        // End:0x51
        if(PC.ViewTarget == self)
        {
            SetTimer(4.0000000, false);            
            return;
        }        
    }    
    Destroy();
    //return;    
}

event BecomeViewTarget(PlayerController PC)
{
    SetHidden(true);
    LifeSpan = 0.0000000;
    SetTimer(4.0000000, false);
    //return;    
}

simulated function bool CalcCamera(float fDeltaTime, out Vector out_CamLoc, out Rotator out_CamRot, out float out_FOV)
{
    local Actor HitActor;
    local Vector HitNormal, HitLocation;
    local int InYaw;

    // End:0x19C
    if(int(Physics) != int(0))
    {
        // End:0x158
        if(bStopMovingCamera)
        {
            OldCamRot.Roll = OldCamRot.Roll & 65535;
            // End:0xF6
            if((OldCamRot.Roll < 8192) || OldCamRot.Roll > 57343)
            {
                out_CamRot = Rotation;
                out_CamRot.Pitch = 0;
                OldCamRot = out_CamRot;                
            }
            else
            {
                InYaw = out_CamRot.Yaw;
                out_CamRot = OldCamRot;
                out_CamRot.Yaw = InYaw;
            }            
        }
        else
        {
            out_CamRot = Rotation;
            out_CamRot.Pitch = 0;
            OldCamRot = out_CamRot;
        }
    }
    out_CamLoc = Location;
    // End:0x25B
    if(OldCamLoc != vect(0.0000000, 0.0000000, 0.0000000))
    {
        HitActor = Trace(HitLocation, HitNormal, Location, OldCamLoc, false, vect(14.0000000, 14.0000000, 14.0000000));
        // End:0x25B
        if(HitActor != none)
        {
            out_CamLoc = HitLocation;
            bStopMovingCamera = HitNormal.Z > 0.7000000;
        }
    }
    OldCamLoc = out_CamLoc;
    return false;
    //return ReturnValue;    
}

simulated event RigidBodyCollision(PrimitiveComponent HitComponent, PrimitiveComponent OtherComponent, const out CollisionImpactData RigidCollisionData, int ContactIndex)
{
    // End:0xC4
    if((WorldInfo.TimeSeconds - CreationTime) > 0.4000000)
    {
        // End:0x62
        if(GibMeshComp != none)
        {
            GibMeshComp.SetNotifyRigidBodyCollision(false);
        }
        // End:0xC4
        if(EffectIsRelevant(Location, false, 4000.0000000))
        {
            // End:0xA6
            if(HitSound != none)
            {
                PlaySound(HitSound, true);
            }
            LeaveADecal(Location, Normal(Velocity));
        }
    }
    //return;    
}

simulated function LeaveADecal(Vector HitLoc, Vector HitNorm)
{
    local Actor TraceActor;
    local Vector out_HitLocation, out_HitNormal, TraceDest, TraceStart, TraceExtent;

    local TraceHitInfo HitInfo;

    // End:0x20A
    if(MITV_DecalTemplate != none)
    {
        TraceStart = HitLoc + (-HitNorm * float(15));
        TraceDest = HitLoc + (HitNorm * float(15));
        TraceActor = Trace(out_HitLocation, out_HitNormal, TraceDest, TraceStart, false, TraceExtent, HitInfo, 2);
        // End:0x20A
        if(TraceActor != none)
        {
            MI_Decal = new (self) Class'Engine.MaterialInstanceTimeVarying';
            MI_Decal.SetParent(MITV_DecalTemplate);
            WorldInfo.MyDecalManager.SpawnDecal(MI_Decal, out_HitLocation, Rotator(-out_HitNormal), DecalWidth, DecalHeight, 10.0000000, false,, HitInfo.HitComponent, true, false, HitInfo.BoneName, HitInfo.Item, HitInfo.LevelIndex);
            MaterialInstanceTimeVarying(MI_Decal).SetScalarStartTime(DecalDissolveParamName, DecalWaitTimeBeforeDissolve);
        }
    }
    //return;    
}

simulated function TurnOnCollision()
{
    GibMeshComp.SetBlockRigidBody(true);
    GibMeshComp.SetRBCollidesWithChannel(0, true);
    GibMeshComp.SetRBCollidesWithChannel(2, true);
    GibMeshComp.SetRBCollidesWithChannel(3, true);
    GibMeshComp.SetRBCollidesWithChannel(5, true);
    GibMeshComp.SetRBCollidesWithChannel(6, true);
    DetachComponent(GibMeshComp);
    AttachComponent(GibMeshComp);
    GibMeshComp.WakeRigidBody();
    //return;    
}

event Landed(Vector HitNormal, Actor FloorActor)
{
    HitWall(HitNormal, FloorActor, none);
    //return;    
}

event HitWall(Vector HitNormal, Actor Wall, PrimitiveComponent WallComp)
{
    local float Speed;

    Velocity = Velocity - ((float(2) * (Velocity Dot HitNormal)) * HitNormal);
    // End:0x68
    if(LifeSpan < (default.LifeSpan - 0.3000000))
    {
        Velocity *= 0.5000000;
    }
    Speed = VSize(Velocity);
    // End:0x112
    if((WorldInfo.TimeSeconds - CreationTime) > 0.4000000)
    {
        // End:0x112
        if(EffectIsRelevant(Location, false, 4000.0000000))
        {
            // End:0xF4
            if(HitSound != none)
            {
                PlaySound(HitSound, true);
            }
            LeaveADecal(Location, Normal(Velocity));
        }
    }
    // End:0x15D
    if((HitNormal.Z > 0.7000000) && Speed < float(20))
    {
        bBounce = false;
        SetPhysics(0);
    }
    //return;    
}

defaultproperties
{
    // Reference: DynamicLightEnvironmentComponent'Default__EvilGib.GibLightEnvironmentComp'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'GibLightEnvironmentComp'
    begin object name="GibLightEnvironmentComp" class=Class'Engine.DynamicLightEnvironmentComponent'
        AmbientShadowColor=(R=0.3000000,G=0.3000000,B=0.3000000,A=1.0000000)
        AmbientGlow=(R=0.5000000,G=0.5000000,B=0.5000000,A=1.0000000)
        bCastShadows=false
    end object
    GibLightEnvironment=GibLightEnvironmentComp
    DecalWidth=200.0000000
    DecalHeight=200.0000000
    MomentumScale=1.0000000
    DecalDissolveParamName="DissolveAmount"
    DecalWaitTimeBeforeDissolve=8.0000000
    GibMeshDissolveParamName="DissolveAmount"
    Components[0]=GibLightEnvironmentComp
    Physics=EPhysics.PHYS_RigidBody
    CollisionType=ECollisionType.COLLIDE_CustomDefault
    TickGroup=ETickingGroup.TG_PostAsyncWork
    bDestroyedByInterpActor=true
    bGameRelevant=true
    bCollideActors=true
    bProjTarget=true
    bNoEncroachCheck=true
    LifeSpan=10.0000000
}