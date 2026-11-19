class LightComponent extends ActorComponent
    abstract
    native
    noexport;

struct Flickering
{
    var() bool m_bFlicker;
    var() float m_fBrightnessMin;
    var() float m_fBrightnessMax;
    var() float m_fSpeed;
    var() /*0x04000000-0x00000000*/ SoundCue m_FlickerSound;
    var() R6EngineEnums.EWaveMarker m_eWaveMarkerTag;
    var float m_fLastWaveMarker;

    structdefaultproperties
    {
        m_bFlicker=false
        m_fBrightnessMin=0.0000000
        m_fBrightnessMax=0.0000000
        m_fSpeed=0.0000000
        m_FlickerSound=none
        m_eWaveMarkerTag=0
        m_fLastWaveMarker=0.0000000
    }
};

var native const Pointer FirstDynamicPrimitiveLink;
var native const Pointer FirstStaticPrimitiveLink;
var native const Matrix WorldToLight;
var native const Matrix LightToWorld;
var native const Guid PersistentGuid;
var const Guid ComponentGuid;
var() interp float Brightness;
var() Color LightColor;
var() export editinline LightFunction Function;
var const array<Guid> IgnorePrimitives;
var private native const Map_Mirror IgnorePrimitivesMap;
var() const bool bEnabled;
var(Advanced) const bool AffectPawns;
var(Advanced) const bool AffectDynamicObjects;
var(Advanced) const bool AffectScene;
var() const bool CastShadows;
var(Advanced) const bool CastStaticShadows;
var(Advanced) bool CastDynamicShadows;
var(Advanced) const bool bForceDynamicLight;
var(Advanced) const bool UseDirectLightMap;
var const transient bool m_bLightIsInScene;
var() bool m_bIsSpecialLight;
var() bool m_bUseObjectPivotForZoneList;
var() bool bUseZoneList;
var() bool m_bAffectOtherLevels;
var() array<ZoneInfo> AffectedZonesList;
var native const transient QWord m_AffectedZonesMask;
var() Flickering m_Flicker;
var() float m_fAmbientValue;
var() bool m_bForceSpecularColor;
var() Color m_SpecularColor;
var() float m_fSpecularColorBrightness;
var const transient Pointer m_pLightInfo;
var const transient int m_iLightInfoID;
var transient int m_iLastTimeCacheUpdate;
var transient Pointer m_pMTCache[2];
var bool m_bDelayAddRemoveLight;
var int m_iTickToDelay;
var int m_iLastAddRemoveTick;
var const transient int Tag;
var native const transient array<int> m_OctreeNodes;
var() float CullDistance;

// Export ULightComponent::execUpdate(FFrame&, void* const)
native function Update();

// Export ULightComponent::execSetEnabled(FFrame&, void* const)
native final function SetEnabled(bool bSetEnabled);
