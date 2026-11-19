class R6Vehicle extends KAsset
    native
    placeable
    hidecategories(lighting,Bump);

const kVehPartNum = 13;

enum EVehPart
{
    EVehPart_Chassis,               // 0
    EVehPart_FLW,                   // 1
    EVehPart_BLW,                   // 2
    EVehPart_FRW,                   // 3
    EVehPart_BRW,                   // 4
    EVehPart_LDoor,                 // 5
    EVehPart_RDoor,                 // 6
    EVehPart_BLDoor,                // 7
    EVehPart_BRDoor,                // 8
    EVehPart_Detail1,               // 9
    EVehPart_Detail2,               // 10
    EVehPart_Detail3,               // 11
    EVehPart_Detail4,               // 12
    EVehPart_Max                    // 13
};

var() bool m_bKeepLocation;
var() bool m_bKeepYaw;
var() array<MaterialInstance> m_aDestroyMaterials;
var() array<MaterialInstance> m_aOKMaterials;
var int m_aPartLifePoint[13];
var Emitter m_EngineFX;
var RB_ConstraintActor m_pLocationConstraint;
var transient Vector m_vOriginalLocation;
var transient Rotator m_rOriginalRotation;
var const float m_fLastTimeImpactSoundTriggered;

// Export UR6Vehicle::execConstraintBrokenNotify(FFrame&, void* const)
native event ConstraintBrokenNotify(name ConstraintName, Actor ConstraintOwner, Vector ConstrainLocation);

// Export UR6Vehicle::execInitNoDamage(FFrame&, void* const)
native final function InitNoDamage(bool bInitRBPhys);

simulated function PostBeginPlay()
{
    InitNoDamage(false);
    return;
}

function SaveOriginalData()
{
    m_vOriginalLocation = Location;
    m_rOriginalRotation = Rotation;
    SaveOriginalData();
    return;
}

function ResetOriginalData()
{
    InitNoDamage(true);
    SetLocation(m_vOriginalLocation);
    SetRotation(m_rOriginalRotation);
    ResetOriginalData();
    return;
}

defaultproperties
{
    // Reference: SkeletalMeshComponent'Default__R6Vehicle.KAssetSkelMeshComponent'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    // Archetype: SkeletalMeshComponent'Default__KAsset.KAssetSkelMeshComponent'
    begin object name="KAssetSkelMeshComponent"
        BlockActors=true
        BlockNonZeroExtent=true
    end object
    SkeletalMeshComponent=KAssetSkelMeshComponent
    bWakeOnLevelStart=true
    bBlockActors=true
    bNoEncroachCheck=true
    Components[0]=KAssetSkelMeshComponent
    m_supportedExplosionEffects=/* ERROR: System.ArgumentOutOfRangeException */
    CollisionComponent=KAssetSkelMeshComponent
}