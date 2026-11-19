class WindPointSourceComponent extends ActorComponent
    native
    editinlinenew
    collapsecategories
    hidecategories(Object);

var Vector Position;
var() interp float Strength;
var() interp float Phase;
var() interp float Frequency;
var() interp float Radius;
var() interp float Duration;
var() bool m_bAutoActivate;
var bool m_bActivate;
var Actor m_pActorToFollowToModulateStrength;
var float m_fDistanceMax;
var float m_fDistanceMin;
