class R6Turret extends R6InteractiveActor
    native
    config(Game)
    placeable
    hidecategories(lighting);

var() /*0x20000000-0x00000000*/ int m_iMaxLeftAimingAngle;
var() /*0x20000000-0x00000000*/ int m_iMaxRightAimingAngle;
var() /*0x20000000-0x00000000*/ int m_iMaxUpAimingAngle;
var() /*0x20000000-0x00000000*/ int m_iMaxDownAimingAngle;
var export editinline SkeletalMeshComponent m_TurretMesh;
var R6FixedLMG m_pMountedWeapon;
var name m_weaponAttachSocketName;
var R6Pawn m_operator;
var bool m_bOperating;
var float m_fOperatorDistance;
var name m_TripodReloadAnim;
var transient float m_fDistToTeamSquared;
var transient bool m_bResetAnimAfterOperatorLeft;

replication
{
    // Pos:0x000
    if(int(Role) == int(ROLE_Authority))
        m_bOperating, m_operator;
}

// Export UR6Turret::execGetRestrainedAim(FFrame&, void* const)
native final function Rotator GetRestrainedAim();

// Export UR6Turret::execMountWeapon(FFrame&, void* const)
native final function MountWeapon();

simulated function PostBeginPlay()
{
    PostBeginPlay();
    // End:0x1D
    if(int(Role) == int(ROLE_Authority))
    {
        MountWeapon();
    }
    return;
}

function ResetOriginalData()
{
    ResetOriginalData();
    m_operator = none;
    m_bOperating = false;
    // End:0x2C
    if(int(Role) == int(ROLE_Authority))
    {
        MountWeapon();
    }
    return;
}

simulated event OperatorEnter(Pawn pPawn)
{
    m_bOperating = true;
    m_operator = R6Pawn(pPawn);
    NetUpdateTime = WorldInfo.TimeSeconds - 1.0000000;
    NetPriority = 3.0000000;
    NetUpdateFrequency = 100.0000000;
    return;
}

simulated event OperatorLeave()
{
    m_operator = none;
    m_bOperating = false;
    NetUpdateTime = WorldInfo.TimeSeconds - 1.0000000;
    // End:0x47
    if(m_pMountedWeapon != none)
    {
        m_pMountedWeapon.StopFire(0);
    }
    NetPriority = default.NetPriority;
    NetUpdateTime = WorldInfo.TimeSeconds - float(1);
    NetUpdateFrequency = 8.0000000;
    return;
}

simulated function DrawAnimDebug(Canvas Canvas, name StartingPoint, int iOffsetX, int iOffsetY, bool bAnimDebugRelevantOnly)
{
    // End:0x34
    if(m_TurretMesh != none)
    {
        m_TurretMesh.super(R6Turret).DrawAnimDebug(Canvas, StartingPoint, iOffsetX, iOffsetY, bAnimDebugRelevantOnly);
    }
    return;
}

defaultproperties
{
    m_iMaxLeftAimingAngle=-10012
    m_iMaxRightAimingAngle=10012
    m_iMaxUpAimingAngle=7281
    m_iMaxDownAimingAngle=-5461
    // Reference: SkeletalMeshComponent'Default__R6Turret.TurretBaseMesh'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    begin object name="TurretBaseMesh" class=Class'Engine.SkeletalMeshComponent'
        Rotation=(Pitch=0,Yaw=32768,Roll=0)
    end object
    m_TurretMesh=TurretBaseMesh
    m_weaponAttachSocketName="R65_AM_Weapon"
    m_fOperatorDistance=51.5000000
    m_TripodReloadAnim="TripodStandFixedGunReloadEmpty"
    m_ActorName="Fixed Weapon Tripod"
    m_bCheckInteractRotation=true
    m_bCanBeUsedByTeam=false
    m_eInteractDesc=11
    m_Mesh=TurretBaseMesh
    bHardAttach=true
    m_bCanSeeThrough=true
    m_bIgnoreForNavMesh=true
    // Reference: SpriteComponent'Default__R6Turret.Sprite'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    // Archetype: SpriteComponent'Default__R6InteractiveActor.Sprite'
    begin object name="Sprite"
    end object
    Components[0]=Sprite
    // Reference: CylinderComponent'Default__R6Turret.CollisionCylinder'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    begin object name="CollisionCylinder" class=Class'Engine.CylinderComponent'
        CollisionHeight=30.0000000
        CollisionRadius=40.0000000
        CollideActors=true
        Translation=(X=0.0000000,Y=0.0000000,Z=15.0000000)
    end object
    Components[1]=CollisionCylinder
    Components[2]=TurretBaseMesh
    // Reference: ArrowComponent'Default__R6Turret.Arrow'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    begin object name="Arrow" class=Class'Engine.ArrowComponent'
        ArrowColor=(R=150,G=100,B=150,A=255)
        ArrowSize=5.0000000
    end object
    Components[3]=Arrow
    CollisionComponent=CollisionCylinder
}