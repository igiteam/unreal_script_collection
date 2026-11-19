class R6BreakableActor extends KActor
    native
    notplaceable
    hidecategories(Material);

var R6_BreakableActorTemplate m_pTemplate;
var() array<byte> m_aiInitialBreakParts;
var export editinline array<export editinline R6BreakableStaticMeshComponent> m_aStaticMeshComponents;
var float m_fLifePoints;
var array<float> m_afSubPartLifePoints;
var int m_iChildrenUsed;
var R6BreakParams m_pCurParams;
var int m_iNbRefByConstraints;
var transient float m_fCumulatedCollision;
var RB_BodySetup m_pCustomizedBodySetup;
var float m_fRepDrawScale3DX;
var float m_fRepDrawScale3DY;
var float m_fRepDrawScale3DZ;
var bool m_bIsInGodMode;
var(lighting) const bool CastShadow;
var(lighting) const bool bCastDynamicShadow;
var(lighting) const bool bAcceptsDynamicLights;
var(TakeDamage) bool m_bPropagateTakeDamageEvents;
var bool m_bBreakableExploded;
var(lighting) const float CullDistance;
var(lighting) const float CullDistanceShadow;
var(lighting) const float fShadowDepthOffset;
var const Pointer m_pMassiveObject;

replication
{
    // Pos:0x000
    if(bNetInitial && int(Role) == int(ROLE_Authority))
        m_fRepDrawScale3DX, m_fRepDrawScale3DY, 
        m_fRepDrawScale3DZ, m_iChildrenUsed, 
        m_pCurParams, m_pTemplate;

    // Pos:0x018
    if(int(Role) == int(ROLE_Authority))
        m_bBreakableExploded;
}

// Export UR6BreakableActor::execBreakableTakeDamage(FFrame&, void* const)
native final function BreakableTakeDamage(int iDamage, bool bExplosion, bool bCollision, bool bFire, PrimitiveComponent pHitComponent, Controller pInstigator);

// Export UR6BreakableActor::execBreakableBreak(FFrame&, void* const)
native function BreakableBreak(int iFromChild, Controller pInstigator);

function OnToggleGodMode(SeqAct_ToggleGodMode inAction)
{
    // End:0x24
    if(inAction.InputLinks[0].bHasImpulse)
    {
        m_bIsInGodMode = true;        
    }
    else
    {
        // End:0x48
        if(inAction.InputLinks[1].bHasImpulse)
        {
            m_bIsInGodMode = false;            
        }
        else
        {
            m_bIsInGodMode = !m_bIsInGodMode;
        }
    }
    return;
}

event bool IsInGodMode()
{
    return m_bIsInGodMode;
    return;
}

defaultproperties
{
    m_fLifePoints=100.0000000
    m_fRepDrawScale3DX=1.0000000
    m_fRepDrawScale3DY=1.0000000
    m_fRepDrawScale3DZ=1.0000000
    CastShadow=true
    bCastDynamicShadow=true
    bAcceptsDynamicLights=true
    CullDistanceShadow=1000.0000000
    fShadowDepthOffset=0.0080000
    StaticMeshComponent=none
    bAlwaysRelevant=true
    m_bLifeSpanDontDeleteWhileRender=true
    // Reference: SpriteComponent'Default__R6BreakableActor.BreakableActorSprite'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    begin object name="BreakableActorSprite" class=Class'SpriteComponent'
        Sprite=Texture2D'KellerResource.BreakableObj'
        HiddenGame=true
        AlwaysLoadOnClient=false
        AlwaysLoadOnServer=false
        Scale=0.2500000
    end object
    Components[0]=BreakableActorSprite
    // Reference: R6BreakableCollisionComponent'Default__R6BreakableActor.BreakableCC'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    begin object name="BreakableCC" class=Class'R6BreakableCollisionComponent'
        BlockZeroExtent=true
        BlockNonZeroExtent=true
        BlockRigidBody=true
    end object
    Components[1]=BreakableCC
    RemoteRole=1
    m_supportedExplosionEffects=/* ERROR: System.ArgumentOutOfRangeException */
    CollisionComponent=BreakableCC
    SupportedEvents[0]=Class'SeqEvent_Touch'
    SupportedEvents[1]=Class'SeqEvent_Destroyed'
    SupportedEvents[2]=Class'SeqEvent_TakeDamage'
    SupportedEvents[3]=Class'SeqEvent_R6LookedAt'
    SupportedEvents[4]=Class'SeqEvent_RigidBodyCollision'
    SupportedEvents[5]=Class'SeqEvent_R6BreakableBroken'
}