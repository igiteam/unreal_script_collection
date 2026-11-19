class SPWeaponAttachment extends Actor
    abstract
    native
    notplaceable;

enum WeaponAnimStates
{
    WAS_INVALID,                    // 0
    WAS_IDLE,                       // 1
    WAS_FIRE,                       // 2
    WAS_RELOAD,                     // 3
    WAS_SIPHON,                     // 4
    WAS_HEAL,                       // 5
    WAS_EQUIP,                      // 6
    WAS_UNEQUIP,                    // 7
    WAS_LDSIDLE,                    // 8
    WAS_MELEE,                      // 9
    WAS_LDSFIRE,                    // 10
    WAS_NUM_ELEMENTS,               // 11
    WAS_MAX                         // 12
};

var SPWeaponAttachment.WeaponAnimStates weaponAnimationState;
var ThirdPersonWeaponSounds m_ThirdPersonWeaponSounds;
var class<Actor> SplashEffect;
var export editinline MeshComponent Mesh;
var name AttachSocketName;
var name MuzzleFlashSocket;
var export editinline StaticMeshComponent MuzzleFlashMesh;
var protected ParticleSystem MuzzleFlashParticleSystem;
var private SPEmitter MuzzleFlashEmitter;
var float MuzzleFlashDuration;
var name AttachmentBoneName;
var float MaxImpactEffectDistance;
var float MaxFireEffectDistance;
var bool bAlignToSurfaceNormal;
var class<SPWeapon> WeaponClass;

simulated function name GetWeaponID()
{
    return WeaponClass.default.WeapID;
    //return ReturnValue;    
}

simulated event PostBeginPlay()
{
    local editinline SPSkeletalMeshComponent SkelMesh;

    super.PostBeginPlay();
    WeaponClass.static.GetThirdPersonWeaponSounds(WorldInfo, WeaponClass, m_ThirdPersonWeaponSounds);
    SkelMesh = SPSkeletalMeshComponent(Mesh);
    // End:0x68
    if(SkelMesh != none)
    {
        SkelMesh.bUpdateSkelWhenNotRendered = false;
        SkelMesh.bIgnoreControllersWhenNotRendered = true;
    }
    PlayAnimationOnWeaponAttachment(1);
    //return;    
}

simulated event Destroyed()
{
    // End:0x17
    if(HasMuzzleFlashEmitter())
    {
        DestroyMuzzleFlashEmitter();
    }
    super.Destroyed();
    //return;    
}

function SetSkin(Material NewMaterial)
{
    local int I, Cnt;

    // End:0xF5
    if(NewMaterial == none)
    {
        // End:0x8C
        if(default.Mesh.Materials.Length > 0)
        {
            Cnt = default.Mesh.Materials.Length;
            I = 0;
            J0x3E:

            // End:0x89 [Loop If]
            if(I < Cnt)
            {
                Mesh.SetMaterial(I, default.Mesh.GetMaterial(I));
                I++;
                // [Loop Continue]
                goto J0x3E;
            }            
        }
        else
        {
            // End:0xF2
            if(Mesh.Materials.Length > 0)
            {
                Cnt = Mesh.Materials.Length;
                I = 0;
                J0xBF:

                // End:0xF2 [Loop If]
                if(I < Cnt)
                {
                    Mesh.SetMaterial(I, none);
                    I++;
                    // [Loop Continue]
                    goto J0xBF;
                }
            }
        }        
    }
    else
    {
        // End:0x1A7
        if((default.Mesh.Materials.Length > 0) || Mesh.GetNumElements() > 0)
        {
            Cnt = ((default.Mesh.Materials.Length > 0) ? default.Mesh.Materials.Length : Mesh.GetNumElements());
            I = 0;
            J0x170:

            // End:0x1A7 [Loop If]
            if(I < Cnt)
            {
                Mesh.SetMaterial(I, NewMaterial);
                I++;
                // [Loop Continue]
                goto J0x170;
            }
        }
    }
    //return;    
}

simulated function bool IsFullyAutomatic()
{
    // End:0x0D
    if(WeaponClass == none)
    {
        return false;
    }
    return !WeaponClass.default.bSemiAuto;
    //return ReturnValue;    
}

simulated function name GetWeaponIdleAnimToUse()
{
    return WeaponClass.default.WeaponIdleAnim;
    //return ReturnValue;    
}

simulated function name GetWeaponFireAnimToUse()
{
    return WeaponClass.default.WeaponFireAnim;
    //return ReturnValue;    
}

simulated function name GetWeaponReloadAnimToUse()
{
    local SPPawn theOwner;

    theOwner = SPPawn(Owner);
    // End:0x47
    if((theOwner == none) || theOwner.UseFirstPersonAnims())
    {
        return WeaponClass.default.WeaponReloadAnim;        
    }
    else
    {
        return WeaponClass.default.WeaponIdleAnim;
    }
    //return ReturnValue;    
}

simulated function PlayAnimationOnWeaponAttachment(SPWeaponAttachment.WeaponAnimStates weaponState)
{
    local bool bLooping;
    local name Sequence;
    local editinline SPSkeletalMeshComponent SkelMesh;
    local PlayerPawn PawnOwner;

    weaponAnimationState = weaponState;
    bLooping = false;
    switch(weaponAnimationState)
    {
        // End:0x3B
        case 1:
            Sequence = GetWeaponIdleAnimToUse();
            bLooping = true;
            // End:0xB9
            break;
        // End:0x9E
        case 2:
            Sequence = GetWeaponFireAnimToUse();
            bLooping = IsFullyAutomatic();
            PawnOwner = PlayerPawn(Owner);
            // End:0x9B
            if(!bLooping && PawnOwner != none)
            {
                PawnOwner.m_bResetFireAnim = true;
            }
            // End:0xB9
            break;
        // End:0xB6
        case 3:
            Sequence = GetWeaponReloadAnimToUse();
            // End:0xB9
            break;
        // End:0xFFFF
        default:
            break;
    }
    SkelMesh = SPSkeletalMeshComponent(Mesh);
    AnimNodeSequence(SkelMesh.Animations).SetAnim(Sequence);
    AnimNodeSequence(SkelMesh.Animations).PlayAnim(bLooping);
    //return;    
}

simulated function AttachTo(SPPawn OwnerPawn)
{
    // End:0xF0
    if(OwnerPawn.Mesh != none)
    {
        // End:0xE2
        if(Mesh != none)
        {
            AttachmentBoneName = 'JO_Gun';
            Mesh.SetDepthPriorityGroup(1);
            Mesh.SetFOV(0.0000000);
            OwnerPawn.Mesh.SetFOV(0.0000000);
            OwnerPawn.Mesh.AttachComponent(Mesh, AttachmentBoneName);
            Mesh.SetShadowParent(OwnerPawn.Mesh);
            Mesh.SetLightEnvironment(OwnerPawn.LightEnvironment);
        }
        GotoState('CurrentlyAttached');
    }
    //return;    
}

simulated function DetachFrom(SPSkeletalMeshComponent MeshCpnt)
{
    SetSkin(none);
    // End:0x38
    if(Mesh != none)
    {
        Mesh.SetShadowParent(none);
        Mesh.SetLightEnvironment(none);
    }
    // End:0x63
    if(MeshCpnt != none)
    {
        // End:0x63
        if(Mesh != none)
        {
            MeshCpnt.DetachComponent(Mesh);
        }
    }
    GotoState('None');
    //return;    
}

simulated event MuzzleFlashTimer()
{
    //return;    
}

simulated event CauseMuzzleFlash()
{
    SetTimer(MuzzleFlashDuration, false, 'MuzzleFlashTimer');
    //return;    
}

simulated event StopMuzzleFlash()
{
    //return;    
}

simulated event bool GetMuzzleLoc(out Vector Loc, optional out Rotator Rot)
{
    local editinline SkeletalMeshComponent skMesh;
    local Pawn PawnOwner;

    skMesh = SkeletalMeshComponent(Mesh);
    // End:0x7F
    if(WeaponClass != none)
    {
        // End:0x57
        if(skMesh == none)
        {
            PawnOwner = Pawn(Owner);
            // End:0x57
            if(PawnOwner != none)
            {
                skMesh = PawnOwner.Mesh;
            }
        }
        // End:0x7F
        if(WeaponClass.static.StaticGetMuzzleLoc(Mesh, Loc, Rot))
        {
            return true;
        }
    }
    Loc = Location;
    Rot = Rotation;
    return false;
    //return ReturnValue;    
}

simulated function SpawnMuzzleFlash(Vector Loc, Rotator Rot)
{
    local editinline SPSkeletalMeshComponent skMesh;
    local Pawn PawnOwner;

    PawnOwner = Pawn(Owner);
    skMesh = SPSkeletalMeshComponent(Mesh);
    // End:0x1BD
    if((MuzzleFlashParticleSystem != none) && WeaponClass != none)
    {
        MuzzleFlashEmitter = Spawn(Class'SPEmitterSpawnable',,, Loc, Rot);
        // End:0x1BD
        if(MuzzleFlashEmitter != none)
        {
            // End:0xC7
            if(skMesh != none)
            {
                MuzzleFlashEmitter.SetOwner(skMesh.Owner);
                MuzzleFlashEmitter.SetBase(skMesh.Owner,, skMesh, WeaponClass.default.MuzzleSocket, true);                
            }
            else
            {
                // End:0x145
                if(PawnOwner != none)
                {
                    MuzzleFlashEmitter.SetOwner(PawnOwner.Mesh.Owner);
                    MuzzleFlashEmitter.SetBase(PawnOwner.Mesh.Owner,, PawnOwner.Mesh, WeaponClass.default.AttachBoneName, true);
                }
            }
            MuzzleFlashEmitter.SetTemplate(MuzzleFlashParticleSystem, true);
            MuzzleFlashEmitter.bDestroyOnSystemFinish = true;
            MuzzleFlashEmitter.ParticleSystemComponent.SecondsBeforeInactive = 0.0000000;
            MuzzleFlashEmitter.ParticleSystemComponent.ActivateSystem();
            MuzzleFlashEmitter.bKillDuringLevelTransition = true;
        }
    }
    //return;    
}

simulated function RemoveMuzzleFlash()
{
    //return;    
}

simulated event PlayReloadAnim()
{
    PlayAnimationOnWeaponAttachment(3);
    //return;    
}

simulated event PlayFireAnim()
{
    // End:0x1E
    if((IsFiring()) && IsFullyAutomatic())
    {
        return;
    }
    PlayAnimationOnWeaponAttachment(2);
    //return;    
}

simulated function StartFiring()
{
    PlayFireAnim();
    WeaponClass.static.StaticWeaponPlaySound(m_ThirdPersonWeaponSounds.FireSound, self);
    //return;    
}

simulated function StopFiring()
{
    local editinline SPSkeletalMeshComponent SkelMesh;

    // End:0x76
    if(IsFiring())
    {
        SkelMesh = SPSkeletalMeshComponent(Mesh);
        // End:0x49
        if(SkelMesh != none)
        {
            AnimNodeSequence(SkelMesh.Animations).bLooping = false;
        }
        weaponAnimationState = 1;
        WeaponClass.static.StaticWeaponPlaySound(m_ThirdPersonWeaponSounds.FireEndSound, self);
    }
    //return;    
}

simulated function Tick(float DeltaTime)
{
    local editinline SPSkeletalMeshComponent SkelMesh;

    SkelMesh = SPSkeletalMeshComponent(Mesh);
    // End:0x4E
    if((SkelMesh != none) && AnimNodeSequence(SkelMesh.Animations).bPlaying == false)
    {
        PlayAnimationOnWeaponAttachment(1);
    }
    //return;    
}

simulated function bool IsFiring()
{
    return int(weaponAnimationState) == int(2);
    //return ReturnValue;    
}

simulated event Projectile SpawnProjectile(Vector ProjLoc, Rotator projRot)
{
    local Actor SpawnedActor;
    local Projectile SpawnedProjectile;

    SpawnedActor = WorldInfo.MyActorPool.GetActorFromPool(WeaponClass.static.StaticGetProjectileClass(), 'None', ProjLoc, projRot, none, true, false, self, Instigator, false, 0, true);
    SpawnedProjectile = Projectile(SpawnedActor);
    // End:0x9E
    if(SpawnedProjectile != none)
    {
        SpawnedProjectile.Init(Vector(projRot));
        SpawnedProjectile.SetCollision(false, false);
    }
    return SpawnedProjectile;
    //return ReturnValue;    
}

simulated event PlayFireEffects(optional bool bUseFakeFire)
{
    local Rotator projRot;
    local Vector ProjLoc;

    WeaponClass.static.StaticWeaponPlaySound(m_ThirdPersonWeaponSounds.FireSound, self);
    GetProjectilePosAndRot(ProjLoc, projRot);
    SpawnProjectile(ProjLoc, projRot);
    SpawnMuzzleFlash(ProjLoc, projRot);
    //return;    
}

simulated function GetProjectilePosAndRot(out Vector out_ProjLoc, out Rotator out_ProjDir)
{
    local Vector emitSocketPos;
    local Rotator emitSocketRot;
    local Vector cameraPos;
    local Rotator cameraRot;
    local Actor HitActor;
    local TraceHitInfo HitInfo;
    local Vector hitPos, HitNormal, EndTrace, StartTrace;
    local PlayerPawn thePlayerPawn;
    local Vector vectorEmitToHit;

    SPSkeletalMeshComponent(Mesh).GetSocketWorldLocationAndRotation('emit', emitSocketPos, emitSocketRot);
    thePlayerPawn = PlayerPawn(Owner);
    Class'PandoraPlayerCamera'.static.GetFirstPersonBaseInfoFromConstants(thePlayerPawn, cameraPos, cameraRot);
    StartTrace = cameraPos;
    // End:0xA8
    if(int(WorldInfo.NetMode) == int(NM_Standalone))
    {
        EndTrace = cameraPos + (Vector(cameraRot) * WeaponClass.default.WeaponRange);        
    }
    else
    {
        EndTrace = cameraPos + (Vector(cameraRot) * WeaponClass.default.WeaponRangeMP);
    }
    HitActor = Owner.Trace(hitPos, HitNormal, EndTrace, StartTrace, true, vect(0.0000000, 0.0000000, 0.0000000), HitInfo, 1 | 10, true);
    // End:0x123
    if(HitActor == none)
    {
        hitPos = EndTrace;
    }
    vectorEmitToHit = hitPos - emitSocketPos;
    out_ProjLoc = emitSocketPos;
    out_ProjDir = Rotator(vectorEmitToHit);
    //return;    
}

simulated function bool HasMuzzleFlashEmitter()
{
    // End:0x0D
    if(MuzzleFlashEmitter == none)
    {
        return false;
    }
    // End:0x22
    if(MuzzleFlashEmitter.bDeleteMe)
    {
        return false;
    }
    return true;
    //return ReturnValue;    
}

simulated function HideMuzzleFlashEmitter(bool bHide)
{
    MuzzleFlashEmitter.SetHidden(bHide);
    //return;    
}

simulated function DestroyMuzzleFlashEmitter()
{
    MuzzleFlashEmitter.Destroy();
    MuzzleFlashEmitter = none;
    //return;    
}

state CurrentlyAttached
{    stop;    
}
