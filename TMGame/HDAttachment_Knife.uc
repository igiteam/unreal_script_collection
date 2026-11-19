//-----------------------------------------------------------
//
//-----------------------------------------------------------
class HDAttachment_Knife extends HDWeaponAttachment;

var     SkeletalMeshComponent MeleeWeapon;

simulated function AttachTo( TMPawn OwnerPawn )
{
	if ( OwnerPawn.Mesh != none )
	{
		if ( MeleeWeapon != None )
		{
			MeleeWeapon.SetShadowParent(OwnerPawn.Mesh);
			MeleeWeapon.SetLightEnvironment(OwnerPawn.LightEnvironment);
			OwnerPawn.Mesh.AttachComponentToSocket(MeleeWeapon, AttachmentSocket);
			MeleeWeapon.SetHidden(false);
		}
	}
}

simulated function DetachFrom( SkeletalMeshComponent MeshCpnt )
{
		// Weapon Mesh Shadow
	if ( MeleeWeapon != None )
	{
		MeleeWeapon.SetShadowParent(None);
		MeleeWeapon.SetLightEnvironment(None);
	}
	if ( MeshCpnt != None )
	{
		// detach weapon mesh from player skelmesh
		if ( MeleeWeapon != None )
		{
			MeshCpnt.DetachComponent( MeleeWeapon );
		}
	}
	MeleeWeapon.SetHidden(true);
}

