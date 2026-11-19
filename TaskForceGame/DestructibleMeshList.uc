class DestructibleMeshList extends Object
	hidecategories(Object) 
	editinlinenew
	native;

struct native DestructibleMeshStruct {
	var() bool bDestroyable;
	var() StaticMesh MyStaticMesh;
	var() export array<Material> Skins;
};

// Rotator of Ranges
/*struct native RangeRotator
{
	var()	Range Pitch;
	var()	Range Yaw;
	var()	Range Roll;
};*/

var() export DestructibleMeshStruct MyMeshStruct;
var() export int TriggerAt;
var() export RangeVector PosOffset;
var() export RangeVector RotOffset;
var	Vector PositionalOffset;
var Rotator RotationalOffset;
var bool bTriggered;

