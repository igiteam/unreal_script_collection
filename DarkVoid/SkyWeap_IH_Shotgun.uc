class SkyWeap_IH_Shotgun extends SkyWeapon
    config(Game);

struct SBoneDist
{
    var Vector vBoneLoc;
    var float fDist;
    var float fDamageMultiplier;

    structdefaultproperties
    {
        vBoneLoc=(X=0.0000000,Y=0.0000000,Z=0.0000000)
        fDist=0.0000000
        fDamageMultiplier=0.0000000
    }
};

var() array<float> m_DamagePerZone;
var() array<float> m_MinConeRadius;
var() array<float> m_MaxConeRadius;
var() array<float> m_DamageMultiplier;
var() float m_fDamagePercentAtEdge;
var() float m_fDamageDecreaseStartRadius;
var array<Vector> m_TraceExtents;
var Vector m_vStartTrace;
var Vector m_vEndTrace;
var float m_fZoneSize;
var() float m_BeginReloadDelay;
var() float m_LoopReloadDelay;
var() float m_EndReloadDelay;
