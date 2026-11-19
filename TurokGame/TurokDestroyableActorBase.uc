class TurokDestroyableActorBase extends TurokInteractiveActor
    native
    nativereplication
    placeable
    hidecategories(Navigation);

enum EDestroyableState
{
    DESTROYABLE_Intact,             // 0
    DESTROYABLE_Swapped,            // 1
    DESTROYABLE_Destroyed,          // 2
    DESTROYABLE_MAX                 // 3
};

struct native DestructionImpulse
{
    var @NULL Location;
    var @NULL Momentum;
    var class<Class> DamageType;

    structdefaultproperties
    {
        Location=(X=0.0000000,Y=0.0000000,Z=0.0000000)
        Momentum=(X=0.0000000,Y=0.0000000,Z=0.0000000)
        DamageType=none
    }
};

var() export editinline @NULL mpBaseDestroyableComponent;
var() export editinline @NULL mpNonDestroyableComponent;
var() bool mSpawnNonDestroyableAsKActor;
var() @NULL mpSwapParticleSystem;
var int mMaxNumVisibleComponents;
var int mCurNumVisibleComponents;
var repnotify byte mBaseDestroyableState;
var protected @NULL mImpulse;
var export editinline @NULL mSoundController;

replication
{
    // Pos:0x000
    if(bNetDirty || bNetInitial
        mBaseDestroyableState;
}

// Export UTurokDestroyableActorBase::execRestore(FFrame&, void* const)
native function Restore();

// Export UTurokDestroyableActorBase::execGetCurNumVisibleComponents(FFrame&, void* const)
native function int GetCurNumVisibleComponents();

// Export UTurokDestroyableActorBase::execGetMaxNumVisibleComponents(FFrame&, void* const)
native function int GetMaxNumVisibleComponents();

// Export UTurokDestroyableActorBase::execAddToManager(FFrame&, void* const)
native function AddToManager();

// Export UTurokDestroyableActorBase::execUpdateManager(FFrame&, void* const)
native function UpdateManager(int Update);

// Export UTurokDestroyableActorBase::execCanDestroy(FFrame&, void* const)
native function bool CanDestroy();

simulated event TakeImpact(class<Class> DamageType, float Damage, @NULL HitLocation, @NULL HitMomentum, @NULL HitInfo)
{
    mImpulse.DamageType = DamageType;
    mImpulse.Location = HitLocation;
    mImpulse.Momentum = HitMomentum;
    //return;    
}

event TakeDamage(int Damage, @NULL pEventInstigator, @NULL HitLocation, @NULL Momentum, class<Class> pDamageType, optional @NULL pHitInfo, optional @NULL DamageCauser)
{
    // End:0x13
    if(pDamageType == Class'TurokDamageTypeFlare')
    {
        return;
    }
    super(Actor).TakeDamage(Damage, pEventInstigator, HitLocation, Momentum, pDamageType, pHitInfo);
    // End:0x72
    if(int(WorldInfo.NetMode) == int(NM_Standalone))
    {
        // End:0x72
        if(int(mBaseDestroyableState) == int(0))
        {
            // End:0x72
            if(!CanDestroy())
            {
                return;
            }
        }
    }
    // End:0x94
    if(int(mBaseDestroyableState) == int(0))
    {
        mBaseDestroyableState = 1;
        UpdateBaseDestroyableState();
    }
    // End:0x11F
    if(((mpBaseDestroyableComponent != none) && int(mBaseDestroyableState) == int(1)) && (pHitInfo.HitComponent == none) || pHitInfo.HitComponent == mpBaseDestroyableComponent)
    {
        // End:0x11F
        if(mpBaseDestroyableComponent.TakeDamage(Damage, HitLocation, Momentum, pDamageType))
        {
            mBaseDestroyableState = 2;
            UpdateBaseDestroyableState();
        }
    }
    //return;    
}

simulated event ReplicatedEvent(name VarName)
{
    // End:0x1F
    if(VarName == 'mBaseDestroyableState')
    {
        UpdateBaseDestroyableState();
        return;
    }
    super(Actor).ReplicatedEvent(VarName);
    //return;    
}

simulated event UpdateBaseDestroyableState()
{
    // End:0x1D
    if(int(mBaseDestroyableState) == int(1))
    {
        OnDestroyableSwapped();        
    }
    else
    {
        // End:0x3A
        if(int(mBaseDestroyableState) == int(2))
        {
            OnDestroyableDestroyed();            
        }
        else
        {
            // End:0x54
            if(int(mBaseDestroyableState) == int(0))
            {
                Restore();
            }
        }
    }
    //return;    
}

simulated function Reset()
{
    Restore();
    //return;    
}

simulated function OnDestroyableDestroyed()
{
    // End:0x100
    if(!mpBaseDestroyableComponent.IsDestroyed())
    {
        mpIntactComponent.SetHidden(true);
        mpIntactComponent.SetActorCollision(false, false);
        mpIntactComponent.SetBlockRigidBody(false);
        mpIntactComponent.TermComponentRBPhys();
        // End:0x82
        if(mpNonDestroyableComponent != none)
        {
            // End:0x82
            if(!mSpawnNonDestroyableAsKActor)
            {
                mpNonDestroyableComponent.SetHidden(false);
            }
        }
        // End:0xD7
        if(mImpulse.DamageType != none)
        {
            mpBaseDestroyableComponent.PlayDestructionEffects(mImpulse.Location, mImpulse.Momentum, mImpulse.DamageType);
        }
        mpBaseDestroyableComponent.DestroyComponent();
        UpdateManager(-1);
        mCurNumVisibleComponents--;
    }
    //return;    
}

simulated function OnDestroyableSwapped()
{
    mpIntactComponent.SetHidden(true);
    mpIntactComponent.SetActorCollision(false, false);
    mpIntactComponent.SetBlockRigidBody(false);
    mpIntactComponent.TermComponentRBPhys();
    // End:0x90
    if(mImpulse.DamageType != none)
    {
        PlaySwapEffects(mImpulse.Location, mImpulse.Momentum, mImpulse.DamageType);
    }
    // End:0xBD
    if(mpNonDestroyableComponent != none)
    {
        // End:0xBD
        if(!mSpawnNonDestroyableAsKActor)
        {
            mpNonDestroyableComponent.SetHidden(false);
            mCurNumVisibleComponents++;
        }
    }
    // End:0xDF
    if(mpBaseDestroyableComponent != none)
    {
        mpBaseDestroyableComponent.SetHidden(false);
        mCurNumVisibleComponents++;
    }
    AddToManager();
    //return;    
}

simulated function PlaySwapEffects(@NULL HitLocation, @NULL Momentum, class<Class> pDamageType)
{
    local @NULL pSpawnedKActor, drawScaleCopy, ApplyImpulse, emitterPool;

    // End:0x4C
    if(mpSwapParticleSystem != none)
    {
        emitterPool = Class'TurokPlayerController'.static.GetLocalPlayerController().GetEmitterManager();
        emitterPool.GetEmitter(mpSwapParticleSystem, self, HitLocation);
    }
    // End:0x215
    if(mpNonDestroyableComponent != none)
    {
        // End:0x215
        if(mSpawnNonDestroyableAsKActor)
        {
            mpNonDestroyableComponent.SetHidden(true);
            mpNonDestroyableComponent.SetTraceBlocking(false, false);
            mpNonDestroyableComponent.SetActorCollision(false, false);
            mpNonDestroyableComponent.SetBlockRigidBody(false);
            mpNonDestroyableComponent.TermComponentRBPhys();
            pSpawnedKActor = __NFUN_278__(Class'Engine.KActor');
            // End:0xD7
            if(pSpawnedKActor == none)
            {                
            }
            else
            {
                pSpawnedKActor.StaticMeshComponent.SetStaticMesh(mpNonDestroyableComponent.StaticMesh);
                pSpawnedKActor.StaticMeshComponent.PhysMaterialOverride = mpNonDestroyableComponent.PhysMaterialOverride;
                drawScaleCopy.X = DrawScale3D.X;
                drawScaleCopy.Y = DrawScale3D.Y;
                drawScaleCopy.Z = DrawScale3D.Z;
                pSpawnedKActor.SetDrawScale3D(drawScaleCopy);
                pSpawnedKActor.StaticMeshComponent.WakeRigidBody();
                // End:0x215
                if(pDamageType.default.KDamageImpulse > float(0))
                {
                    // End:0x215
                    if(VSize(Momentum) >= 0.0010000)
                    {
                        ApplyImpulse = Normal(Momentum) * pDamageType.default.KDamageImpulse;
                        pSpawnedKActor.StaticMeshComponent.AddImpulse(ApplyImpulse, HitLocation);
                    }
                }
            }
        }
    }
    //return;    
}

simulated function TakeRadiusDamage(@NULL InstigatedBy, float BaseDamage, float DamageRadius, class<Class> DamageType, float Momentum, @NULL HurtOrigin, bool bFullDamage, @NULL DamageCauser)
{
    local @NULL radHitDir, radHitLoc, radHitInfo;

    radHitDir = Location - HurtOrigin;
    CheckHitInfo(radHitInfo, mpNonDestroyableComponent, Normal(radHitDir), radHitLoc, true);
    TakeImpact(DamageType, BaseDamage, Location, HurtOrigin * Momentum, radHitInfo);
    // End:0x98
    if(int(Role) == int(ROLE_Authority))
    {
        super(Actor).TakeRadiusDamage(InstigatedBy, BaseDamage, DamageRadius, DamageType, Momentum, HurtOrigin, bFullDamage, DamageCauser);
    }
    //return;    
}

simulated function PlayDestructionSound(@NULL sc)
{
    // End:0x1F
    if(!mSoundController.bAttached)
    {
        AttachComponent(mSoundController);
    }
    mSoundController.TryPlayLocalSound(sc);
    //return;    
}

defaultproperties
{
    // Reference: TurokDestroyableComponent'Default__TurokDestroyableActorBase.pBaseDestroyableComponent0'
    begin object name=pBaseDestroyableComponent0 class=Class'TurokDestroyableComponent'
        LightEnvironment=DynamicLightEnvironmentComponent'Default__TurokDestroyableActorBase.MyLightEnvironment'
        LightingChannels=(Static=false,Dynamic=true)
    end object
    mpBaseDestroyableComponent=pBaseDestroyableComponent0
    // Reference: TurokUVAnimComponent'Default__TurokDestroyableActorBase.pNonDestroyableComponent0'
    begin object name=pNonDestroyableComponent0 class=Class'TurokUVAnimComponent'
        LightEnvironment=DynamicLightEnvironmentComponent'Default__TurokDestroyableActorBase.MyLightEnvironment'
        CastShadow=false
        bForceDirectLightMap=true
        bCastDynamicShadow=false
        LightingChannels=(bInitialized=true,Dynamic=true)
    end object
    mpNonDestroyableComponent=pNonDestroyableComponent0
    // Reference: TurokSoundController'Default__TurokDestroyableActorBase.TurokSoundControllerComponent'
    begin object name=TurokSoundControllerComponent class=Class'TurokSoundController'
    end object
    mSoundController=TurokSoundControllerComponent
    // Reference: TurokUVAnimComponent'Default__TurokDestroyableActorBase.pIntactComponent0'
    begin object name=pIntactComponent0
        LightEnvironment=DynamicLightEnvironmentComponent'Default__TurokDestroyableActorBase.MyLightEnvironment'
    end object
    mpIntactComponent=pIntactComponent0
    // Reference: DynamicLightEnvironmentComponent'Default__TurokDestroyableActorBase.MyLightEnvironment'
    begin object name=MyLightEnvironment
    end object
    LightEnvironment=MyLightEnvironment
    bMovable=false
    bRenderStasis=true
    Components[0]=MyLightEnvironment
    Components[1]=pIntactComponent0
}