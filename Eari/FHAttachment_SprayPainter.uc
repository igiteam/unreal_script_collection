// Description of purpose of this class - Please flesh out
// Adding Author
// Date Added

class FHAttachment_SprayPainter extends UTAttachment_LinkGun;

var MaterialInstanceConstant SprayDecal;
var bool placingDecals;

simulated function SetImpactedActor(Actor HitActor, vector HitLocation, vector HitNormal, TraceHitInfo HitInfo)
{
	local MaterialInstanceConstant MITV_Decal;

	if(HitActor == none)
		return;

	if (placingDecals && TicksBetweenDecals <= TicksSinceLastDecal)
	{
		// Apply beam decal
		MITV_Decal = new(self) class'MaterialInstanceConstant';
		MITV_Decal.SetParent( SprayDecal );
		WorldInfo.MyDecalManager.SetTickIsDisabled(true); // Decals don't tick so they last forever
		WorldInfo.MyDecalManager.SpawnDecal(MITV_Decal, HitLocation, rotator(-HitNormal), DecalWidth, 
			DecalHeight, 10.0, FALSE);
		TicksSinceLastDecal = 0;
	}
	else
	{
		++TicksSinceLastDecal;
	}

}


// Decompiled with UE Explorer.
defaultproperties
{
    SprayDecal=MaterialInstanceConstant'SprayCanPackage.Decals.SprayMark_INST'
    DecalWidth=20.0000000
    DecalHeight=20.0000000
    // Reference: ParticleSystemComponent'Default__FHAttachment_SprayPainter.PoweredUpComponent'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'PoweredUpComponent'
    // Archetype: ParticleSystemComponent'UTGame.Default__UTAttachment_LinkGun.PoweredUpComponent'
    begin object name="PoweredUpComponent"
        ReplacementPrimitive=none
    end object
    PoweredUpEffect=PoweredUpComponent
    // Reference: SkeletalMeshComponent'Default__FHAttachment_SprayPainter.SkeletalMeshComponent0'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'SkeletalMeshComponent0'
    // Archetype: SkeletalMeshComponent'UTGame.Default__UTAttachment_LinkGun.SkeletalMeshComponent0'
    begin object name="SkeletalMeshComponent0"
        SkeletalMesh=none
        // Reference: UTAnimNodeSequence'Default__FHAttachment_SprayPainter.SkeletalMeshComponent0.MeshSequenceA'
        // Archetype: UTAnimNodeSequence'UTGame.Default__UTAttachment_LinkGun.SkeletalMeshComponent0.MeshSequenceA'
        begin object name="MeshSequenceA"
        end object
        Animations=MeshSequenceA
        ReplacementPrimitive=none
    end object
    Mesh=SkeletalMeshComponent0
    MaxDecalRangeSq=0.0000000
}