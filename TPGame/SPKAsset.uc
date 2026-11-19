// integrated from Pandora to TP by Doug Kuppinger 8/25/06

class SPKAsset extends KAsset
	native
	placeable;


// apparently required to initialize a spawned physics asset, no method to initialize from script that I can find.. (pawn has one)
native function bool InitPhysics();



