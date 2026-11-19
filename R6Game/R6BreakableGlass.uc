class R6BreakableGlass extends StaticMeshActor
    native
    notplaceable
    hidecategories(lighting);

enum EGlassVisibleDir
{
    BREAKABLEGLASS_VISIBLE_BOTH,    // 0
    BREAKABLEGLASS_VISIBLE_INSIDE,  // 1
    BREAKABLEGLASS_VISIBLE_OUTSIDE, // 2
    BREAKABLEGLASS_VISIBLE_MAX      // 3
};

enum EGlassSize
{
    EGlassSize_Small,               // 0
    EGlassSize_Medium,              // 1
    EGlassSize_Large,               // 2
    EGlassSize_MAX                  // 3
};

struct SR6BreakableGlassDamageReplicateStruct
{
    var float m_fDamage;
    var Vector m_vHitPoint;
    var Vector m_vMomentum;
    var int m_iIndex;
    var int m_iRandSeed;
    var export editinline PrimitiveComponent m_pComponent;
    var bool m_bIsExplosion;
    var bool m_bIsFire;
    var bool m_bSkipTest;
    var bool m_bNew;

    structdefaultproperties
    {
        m_fDamage=0.0000000
        m_vHitPoint=(X=0.0000000,Y=0.0000000,Z=0.0000000)
        m_vMomentum=(X=0.0000000,Y=0.0000000,Z=0.0000000)
        m_iIndex=0
        m_iRandSeed=0
        m_pComponent=none
        m_bIsExplosion=false
        m_bIsFire=false
        m_bSkipTest=false
        m_bNew=false
    }
};

struct SR6BreakableGlassRadiusDamageReplicateStruct
{
    var float m_fDistMaxDamage;
    var float m_fBaseDamage;
    var float m_fDamageRadius;
    var Vector m_vHurtOrigin;
    var int m_iRandSeed;
    var bool m_bNew;

    structdefaultproperties
    {
        m_fDistMaxDamage=0.0000000
        m_fBaseDamage=0.0000000
        m_fDamageRadius=0.0000000
        m_vHurtOrigin=(X=0.0000000,Y=0.0000000,Z=0.0000000)
        m_iRandSeed=0
        m_bNew=false
    }
};

var export editinline R6BreakableGlassComponent m_pBreakableGlassComponent;
var R6BreakableGlassTemplate m_pTemplate;
var() bool m_bBreakOnLevelStart;
var() bool m_bNoBorder;
var() KAggregateGeom m_FixedCollision;
var() R6BreakableGlass.EGlassVisibleDir m_eVisibleDir;
var(R6Sound) /*0x04000000-0x00000000*/ R6BreakableGlass.EGlassSize m_eGlassSize;
var transient SR6BreakableGlassDamageReplicateStruct m_DamageReplication;
var int m_iNetCheck;
var transient SR6BreakableGlassRadiusDamageReplicateStruct m_RadiusDamageReplication;

replication
{
    // Pos:0x000
    if(int(Role) == int(ROLE_Authority))
        m_iNetCheck;

    // Pos:0x00D
    if((int(Role) == int(ROLE_Authority)) && !bNetInitial)
        m_DamageReplication, m_RadiusDamageReplication;
}

// Export UR6BreakableGlass::execGlassTakeDamage(FFrame&, void* const)
native final function bool GlassTakeDamage(float Damage, Pawn pInstigator, Vector HitLocation, PrimitiveComponent pHitPrimitive, Vector Momentum, bool isExplosion, bool isFire, optional int Index);

// Export UR6BreakableGlass::execGlassTakeRadiusDamage(FFrame&, void* const)
native final function GlassTakeRadiusDamage(Pawn pInstigator, float fDistMaxDam, float BaseDamage, float DamageRadius, Vector HurtOrigin);

defaultproperties
{
    // Reference: R6BreakableGlassComponent'Default__R6BreakableGlass.BreakableGlassComponent'
    begin object name="BreakableGlassComponent" class=Class'Engine.R6BreakableGlassComponent'
    end object
    m_pBreakableGlassComponent=BreakableGlassComponent
    m_eGlassSize=1
    m_iNetCheck=-1
    // Reference: StaticMeshComponent'Default__R6BreakableGlass.StaticMeshComponent0'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    // Archetype: StaticMeshComponent'Default__StaticMeshActor.StaticMeshComponent0'
    begin object name="StaticMeshComponent0"
        WireframeColor=(R=128,G=128,B=32,A=255)
    end object
    StaticMeshComponent=StaticMeshComponent0
    bStatic=false
    bNoDelete=true
    bStasis=true
    bWorldGeometry=false
    bAlwaysRelevant=true
    bMovable=false
    Components[0]=StaticMeshComponent0
    // Reference: SpriteComponent'Default__R6BreakableGlass.BreakableGlassSprite'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    begin object name="BreakableGlassSprite" class=Class'SpriteComponent'
        Sprite=Texture2D'KellerResource.breakableGlass'
        HiddenGame=true
        AlwaysLoadOnClient=false
        AlwaysLoadOnServer=false
        Scale=0.2500000
    end object
    Components[1]=BreakableGlassSprite
    Components[2]=BreakableGlassComponent
    RemoteRole=1
    m_eExplosionCollisionOverride=2
    TickGroup=1
    m_supportedExplosionEffects=/* ERROR: System.ArgumentOutOfRangeException */
    NetUpdateFrequency=0.1000000
    CollisionComponent=StaticMeshComponent0
}