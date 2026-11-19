///////////////////////////////////////////////////////////////////////////////
// ClearPoint.uc - ClearPoint class
// A point that Officers will stack-up at based on priority

class ClearPoint extends BaseDoorPoint
	notplaceable
    native;
///////////////////////////////////////////////////////////////////////////////

///////////////////////////////////////////////////////////////////////////////
//
// ClearPoint variables

var   protected Texture			ClearPointIcons[4];
var	  array<ClearRoutePoint>	ClearRoutePoints;

// For Debugging
var	  array<vector>				ClearPathLocations;
var	  private color				ClearPathColors[4];

///////////////////////////////////////////////////////////////////////////////









// Decompiled with UE Explorer.
defaultproperties
{
    ClearPathColors[0]=(R=255,G=255,B=255,A=255)
    ClearPathColors[1]=(R=0,G=0,B=0,A=255)
    ClearPathColors[2]=(R=200,G=200,B=255,A=255)
    ClearPathColors[3]=(R=255,G=96,B=0,A=255)
}