//------------------------------------
//	Set up like any other mover.. only it affects it's children differently
//------------------------------------
class ComplexMover extends Mover
	notplaceable;
	
struct ChildStruct {

	var() edfindable ComplexMover Child;
};
	
var() editinline array<ChildStruct> Children;

// my last position on update.. (to get offsets to apply to children)
var vector lastUpdatePos;
var rotator lastUpdateRot;

function PostBeginPlay ( ) {

	local int i;

	Super.PostBeginPlay ( );
	
	// store my location & rotation for shits and giggles
	lastUpdatePos = Location;
	lastUpdateRot = Rotation;
	
	// loop over all my children and hardattach them
	if ( Children.Length > 0 ) {
	
		// loop over all
		for ( i = 0; i < Children.Length; i++ ) {
		
			// check for valid complex mover
			if ( Children[i].Child != None ) {
			
				Children[i].Child.SetBase ( Self );
			}		
		}
	}
}

function UpdateFromParent ( vector offsetLoc, rotator offsetRot ) {

	local int i;

	// store my current as my base
	BasePos = Location;
	BaseRot = Rotation;
	
	// apply this rotation to all my keyframes offsets
	for ( i = 0; i < NumKeys; i++ ) {
	
		KeyPos[i] = KeyPos[i] >> offsetRot;
	}
				
	// apply this to all my children
	if ( Children.Length > 0 ) {
	
		// loop over all
		for ( i = 0; i < Children.Length; i++ ) {
		
			// check for valid complex mover
			if ( Children[i].Child != None ) {
			
				Children[i].Child.UpdateFromParent ( offsetLoc, offsetRot );		
			}		
		}
	}
}

simulated event KeyFrameReached ( ) {

	local vector offsetPos;
	local rotator offsetRot;
	local int i;
	
	// get the offsets
	offsetPos = Location - lastUpdatePos;
	offsetRot = Rotation - lastUpdateRot;
	lastUpdatePos = Location;
	lastUpdateRot = Rotation;
	
	// apply this to all my children
	if ( Children.Length > 0 ) {
	
		// loop over all
		for ( i = 0; i < Children.Length; i++ ) {
		
			// check for valid complex mover
			if ( Children[i].Child != None ) {
			
				Children[i].Child.UpdateFromParent ( offsetPos, offsetRot );		
			}		
		}
	}
	
	Super.KeyFrameReached ( );
}

// default properties

// Decompiled with UE Explorer.
defaultproperties
{
    Texture=Texture'Engine.S_WhiteCircle'
    SoundRadius=256.0000000
}