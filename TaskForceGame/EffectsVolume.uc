
class EffectsVolume extends Volume; 

var(EffectsVolume) class<Emitter>	EmitterClass; 
var(EffectsVolume) Range			RespawnInterval; 

var(EffectsVolume) bool 			bUseVolumeDims; 
var(EffectsVolume) bool				bRespawn; 

function PostBeginPlay()
{
	Super.PostBeginPlay();

	SetTimer(RandRange(	RespawnInterval.Min, RespawnInterval.Max ), false); 
}

simulated function Timer()
{
	local Box Dims; 
	local vector SpawnLocation; 
	local Emitter E;
	
	Dims = GetVolumeBoundingBox(0); // get dims in wold coords
	
	// create random location for within dims of the volume box
	// if not stretching to the dims of the volume
	if (!bUseVolumeDims)
	{
		SpawnLocation = Dims.Max*VRand();
		SpawnLocation.Z = 0;
	}
	
	E = Spawn(EmitterClass,,, Location + SpawnLocation, Rotation); 
	
	if (bUseVolumeDims)
		E.BoundingBox = Dims;
	
	if (bRespawn)
		SetTimer(RandRange(	RespawnInterval.Min, RespawnInterval.Max ), false); 
}





// Decompiled with UE Explorer.
defaultproperties
{
    bRespawn=true
    DrawType=0
    bStatic=false
    bCollideActors=false
}