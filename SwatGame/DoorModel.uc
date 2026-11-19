class DoorModel extends DoorAttachment
    implements Engine.ICanBeUsed
    config(SwatGame)
	transient
	native;

var SwatDoor Door;

// these variables are used when opening the door model procedurally in UnrealEd 
//  to be able to re-test links between pathnodes when doors are open
var private Rotator SavedRotation;
var private vector  SavedLocation;

//This class represents the visual StaticMesh, per-poly-collision of a conseptual Door

replication
{
    reliable if (bNetDirty && (Role == Role_Authority))
        Door;
}

//ICanBeUsed implementation

simulated function bool CanBeUsedNow()
{
    return SwatDoor(Owner).CanInteract();
}

simulated function OnUsed(Pawn Other)
{
    SwatDoor(Owner).Interact(Other);
}

simulated function PostUsed();

// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)




































// Decompiled with UE Explorer.
defaultproperties
{
    bWorldGeometry=true
    MaxDynamicLights=2
    bCollideActors=true
    bBlockActors=true
    bBlockPlayers=true
    bBlockHavok=true
    HavokDataClass=Class'HavokDoorRigidBody'
}