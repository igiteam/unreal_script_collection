class R6BreakableActorSimple extends StaticMeshActor
    native
    placeable
    hidecategories(lighting);

const kSBMaxMaterials = 3;
const kSBMaxSounds = 4;
const kSBMaxFxParams = 5;

enum ESimpleBreakState
{
    ESBS_Breakable,                 // 0
    ESBS_FirstState,                // 1
    ESBS_SecondState,               // 2
    ESBS_MAX                        // 3
};

var(Breakable) float m_fLifePoints;
var(Breakable) StaticMesh m_pDestroyMesh;
var(Breakable) MaterialInstance m_aDestroyMaterials[3];
var(Breakable) bool m_bBreakOnFire;
var(Breakable) bool m_bBreakOnExplosion;
var(Breakable) bool m_bBreakOnBullet;
var bool m_bIsInGodMode;
var(Breakable) R6BreakableActorSimple.ESimpleBreakState m_eBreakState;
var(Breakable) ParticleSystem m_pDestroyEffect;
var(Breakable) Vector m_vDestroyEffectPos;
var(Breakable) editinline ParticleSysParam m_DestroyEffectParameters[5];
var(Breakable) /*0x04000000-0x00000000*/ SoundCue m_aDestroySounds[4];
var Light m_pLight;
var float m_fOriginalLifePoints;
var(Breakable) StaticMesh m_pOriginalMesh;
var(Breakable) MaterialInstance m_aOriginalMaterials[3];
var transient bool m_bIsPlaying;
var transient Emitter m_Emitter;

replication
{
    // Pos:0x000
    if(int(Role) == int(ROLE_Authority))
        m_fLifePoints;

    // Pos:0x00D
    if((int(Role) == int(ROLE_Authority)) && bNetInitial)
        m_DestroyEffectParameters, m_aDestroyMaterials, 
        m_aDestroySounds, m_aOriginalMaterials, 
        m_eBreakState, m_pDestroyEffect, 
        m_pDestroyMesh, m_pOriginalMesh, 
        m_vDestroyEffectPos;
}

// Export UR6BreakableActorSimple::execBreakableTakeDamage(FFrame&, void* const)
native final function BreakableTakeDamage(int iDamage, bool bExplosion, bool bFire);

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
    m_bBreakOnFire=true
    m_bBreakOnExplosion=true
    m_bBreakOnBullet=true
    m_fOriginalLifePoints=100.0000000
    // Reference: StaticMeshComponent'Default__R6BreakableActorSimple.StaticMeshComponent0'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    // Archetype: StaticMeshComponent'Default__StaticMeshActor.StaticMeshComponent0'
    begin object name="StaticMeshComponent0"
        WireframeColor=(R=128,G=255,B=255,A=255)
    end object
    StaticMeshComponent=StaticMeshComponent0
    bStatic=false
    bNoDelete=true
    bMovable=false
    Components[0]=StaticMeshComponent0
    RemoteRole=1
    TickGroup=1
    m_supportedExplosionEffects=/* ERROR: System.ArgumentOutOfRangeException */
    CollisionComponent=StaticMeshComponent0
}