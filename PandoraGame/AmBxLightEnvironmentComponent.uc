class AmBxLightEnvironmentComponent extends DynamicLightEnvironmentComponent
    native
    collapsecategories;

var private native const transient Pointer AmBxState;
var LinearColor AmBxLightColor;
var Vector m_AmBxOffset;
var Vector m_CurrentAmBxOffset;
var Vector m_AmBxLightSnifferSize;
var float m_AmBxLightSnifferNormalLightFactor;
var float m_AmBxLightSnifferNonShadowLightFactor;
var float m_AmBxLightSnifferSkyLightFactor;
var float m_AmBxLightSnifferHitWallReductionFactor;
var bool m_bAmBxLightSnifferUseStaticLights;
var bool m_bAmBxLightSnifferUseDynamicLights;
var bool m_bAmBxLightSnifferUseNormalLight;
var bool m_bAmBxLightSnifferUseNonShadowLight;
var bool m_bAmBxLightSnifferUseSkyLight;
var float m_AmBxLightEnvironmentAbsIgnoreDist;
var float m_AmBxLightEnvironmentGlobalDesaturate;
var float LastTimeAmBxLightColorIgnored;
