//-----------------------------------------------------------
//
//-----------------------------------------------------------
class TPAnimNotify_SetHeadTrack extends AnimNotify
      native;

var() bool bDisable;

event SetHeadTrackNotify(AnimNodeSequence NodeSeq)
{
	local SkelControlLookAt htrack;
	local TPPawn myPawn;

	//`log(" ChadAI - TPAnimNotify_SetHeadTrack NodeSeq: " @ NodeSeq.NodeName @ " *=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*" );	

	myPawn = TPPawn(NodeSeq.SkelComponent.Owner);
	htrack = SkelControlLookAt(myPawn.Mesh.FindSkelControl('HeadTrack'));
	htrack.SetSkelControlActive(!bDisable);
}

// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)

