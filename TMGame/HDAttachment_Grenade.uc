//-----------------------------------------------------------
//
//-----------------------------------------------------------
class HDAttachment_Grenade extends HDWeaponAttachment;

var     SkeletalMeshComponent   GrenadeMesh;

simulated function AttachTo( TMPawn OwnerPawn )
{
	if ( OwnerPawn.Mesh != none )
	{
		if ( GrenadeMesh != None )
		{
			GrenadeMesh.SetShadowParent(OwnerPawn.Mesh);
			GrenadeMesh.SetLightEnvironment(OwnerPawn.LightEnvironment);
			OwnerPawn.Mesh.AttachComponentToSocket(GrenadeMesh, AttachmentSocket);
			GrenadeMesh.SetHidden(false);
		}
	}

	OwnerPawn.SetWeapAnimType(WeapAnimType);
}

simulated function DetachFrom( SkeletalMeshComponent MeshCpnt )
{
	// Weapon Mesh Shadow
	if ( GrenadeMesh != None )
	{
		GrenadeMesh.SetShadowParent(None);
		GrenadeMesh.SetLightEnvironment(None);
	}
	if ( MeshCpnt != None )
	{
		// detach weapon mesh from player skelmesh
		if ( GrenadeMesh != None )
		{
			MeshCpnt.DetachComponent( GrenadeMesh );
		}
	}
	GrenadeMesh.SetHidden(true);
}

