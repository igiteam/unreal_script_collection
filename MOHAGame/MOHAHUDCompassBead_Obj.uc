class MOHAHUDCompassBead_Obj extends MOHAHUDCompassBead
    native;

var EALAObjective Objective;
var() Vector2D vObjective_UV;
var() Vector2D vObjective_UVSize;
var() Vector2D vObjective_PixelSize;
var() Vector2D vObjectiveArrowUp_UV;
var() Vector2D vObjectiveArrowUp_UVSize;
var() Vector2D vObjectiveArrowUp_PixelSize;
var() Vector2D vObjectiveArrowDown_UV;
var() Vector2D vObjectiveArrowDown_UVSize;
var() Vector2D vObjectiveArrowDown_PixelSize;
var() Vector2D vCaret_UV;
var() Vector2D vCaret_UVSize;
var() Vector2D vCaret_PixelSize;
var() float fBeadBlinkFreq;

defaultproperties
{
    vObjective_UV=(X=450.0000000,Y=225.0000000)
    vObjective_UVSize=(X=62.0000000,Y=62.0000000)
    vObjective_PixelSize=(X=24.0000000,Y=25.0000000)
    vObjectiveArrowUp_UV=(X=450.0000000,Y=204.0000000)
    vObjectiveArrowUp_UVSize=(X=62.0000000,Y=83.0000000)
    vObjectiveArrowUp_PixelSize=(X=24.0000000,Y=32.1300000)
    vObjectiveArrowDown_UV=(X=450.0000000,Y=225.0000000)
    vObjectiveArrowDown_UVSize=(X=63.0000000,Y=83.0000000)
    vObjectiveArrowDown_PixelSize=(X=24.0000000,Y=32.1300000)
    vCaret_UV=(X=192.0000000,Y=224.0000000)
    vCaret_UVSize=(X=32.0000000,Y=32.0000000)
    vCaret_PixelSize=(X=16.0000000,Y=16.0000000)
    fBeadBlinkFreq=2.0000000
    bRenderIfOutofRange=true
    fHeightDiffAlpha=0.5000000
}