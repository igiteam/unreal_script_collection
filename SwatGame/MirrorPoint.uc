///////////////////////////////////////////////////////////////////////////////
class MirrorPoint extends Engine.Actor implements SwatAICommon.IMirrorPoint
	placeable
	native
	config(SwatGame);
///////////////////////////////////////////////////////////////////////////////

///////////////////////////////////////////////////////////////////////////////
// 
// Variables

enum EMirroringSide
{
	MirrorToLeft,
	MirrorToRight
};

var() EMirroringSide				MirrorDirection;

// set by processing in UnrealEd
var private const bool				bIsMirroringFromPointValid;
var private const vector			MirroringFromPoint;		
var private const vector			MirroringToPoint;
var private const Rotator			MirroringRotation;

// config
var config float					OffsetFromMirrorPoint;
var config float					OffsetFromCornerDirection;

///////////////////////////////////////////////////////////////////////////////
// 
// Variables


function vector GetMirroringFromPoint()		{ return MirroringFromPoint; }
function vector GetMirroringToPoint()		{ return MirroringToPoint; }
function rotator GetMirroringDirection()	{ return Rotation; }

//This is placeholder until evidence is implemented.
//I am creating the class while implementing the CommandInterface, so that
//  I can implement the 'MirrorCorner' command.

///////////////////////////////////////////////////////////////////////////////


















// Decompiled with UE Explorer.
defaultproperties
{
    OffsetFromMirrorPoint=32.0000000
    OffsetFromCornerDirection=16.0000000
    DrawType=8
    StaticMesh=StaticMesh'Doors_sm.MirrorPoint'
    bHidden=true
    bAcceptsProjectors=false
    bCollideActors=true
    bDirectional=true
}