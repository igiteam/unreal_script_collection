//-----------------------------------------------------------
//
//-----------------------------------------------------------
class HDSpecialWeaponAttachment extends HDWeaponAttachment;

simulated function AttachTo( TMPawn OwnerPawn )
{
	if ( OwnerPawn.Mesh != none )
	{
		if ( Mesh != None )
		{
			Mesh.SetShadowParent(OwnerPawn.Mesh);
			Mesh.SetLightEnvironment(OwnerPawn.LightEnvironment);
			OwnerPawn.Mesh.AttachComponentToSocket(Mesh, AttachmentSocket);
			Mesh.SetHidden(false);
		}
	}

	OwnerPawn.SetWeapAnimType(WeapAnimType);

	GotoState('CurrentlyAttached');
}

simulated function DetachFrom( SkeletalMeshComponent MeshCpnt )
{
		// Weapon Mesh Shadow
	if ( Mesh != None )
	{
		Mesh.SetShadowParent(None);
		Mesh.SetLightEnvironment(None);
	}
	if ( MeshCpnt != None )
	{
		// detach weapon mesh from player skelmesh
		if ( Mesh != None )
		{
			MeshCpnt.DetachComponent( Mesh );
		}
	}
	Mesh.SetHidden(true);

	GotoState('');
}

