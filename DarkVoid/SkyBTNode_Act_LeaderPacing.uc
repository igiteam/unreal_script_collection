class SkyBTNode_Act_LeaderPacing extends SkyBTNode_Leaf_Action
    native;

var(PacingControl) float InnerRadius;
var(PacingControl) float OuterRadius;
var(PacingControl) float InnerRadiusSpeed;
var(PacingControl) float OuterRadiusMinSpeed;
var(PacingControl) float OuterRadiusMaxSpeed;
var(PacingControl) float AbsoluteMinSpeed;
var(PacingControl) float AbsoluteMinSpeedDistance;
var transient float PrevBotRouteLocFactor;
var transient float PrevPlayerRouteLocFactor;
