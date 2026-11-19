class WindDirectionalSourceComponent extends ActorComponent
    native
    editinlinenew
    collapsecategories
    hidecategories(Object);

var Vector Direction;
var() interp float Strength;
var() interp float Phase;
var() interp float Frequency;
var() bool m_bAutoActivate;
var bool m_bActivate;
var Actor m_pActorToFollowToModulateStrength;
var float m_fDistanceMax;
var float m_fDistanceMin;
