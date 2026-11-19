class FHWeap_SprayPaintCan extends UTWeap_LinkGun;

var int paintAmmoOldOldOld;
var name weaponSocket;
var float timeSinceStartFire;
var float armAnimationTime;

simulated function UpdateBeam(float DeltaTime)
{
	super.UpdateBeam(DeltaTime);
	AmmoCount = AmmoCount == 0 ? 0 : AmmoCount - 1; // Hacking a bit here
}


simulated function bool HasAmmo( byte FireModeNum, optional int Amount )
{
	if(AmmoCount == 0)
		UTPawn(Instigator).SetWeaponAmbientSound(none);
	return AmmoCount > 0;
}

//simulated function ProcessBeamHit(vector StartTrace, vector AimDir, out ImpactInfo TestImpact, float DeltaTime)
//{
//}

simulated function vector GetLinkedToLocation()
{
}

function AttemptLinkTo(Actor Who, PrimitiveComponent HitComponent)
{
}

simulated state WeaponBeamFiring
{
	simulated function BeginState(Name PreviousStateName)
	{
		local UTPawn POwner;
		// In this override, I removed the code that makes
		// the light around the spray on the wall disappear.

		if (BeamPreFireAnim[CurrentFireMode] != '')
		{
			// Raise arm mesh quickly
			PlayWeaponAnimation( BeamPreFireAnim[CurrentFireMode], armAnimationTime);
		}

		POwner = UTPawn(Instigator);
		if (POwner != None)
		{
			AddBeamEmitter();
			POwner.SetWeaponAmbientSound(WeaponFireSnd[CurrentFireMode]);
		}
		WeaponPlaySound(StartAltFireSound);
		timeSinceStartFire = 0.0;
		FHAttachment_SprayPainter(FHNormalPlayer(Owner).CurrentWeaponAttachment).placingDecals = false;
	}

	simulated function Tick(float DeltaTime)
	{
		super.Tick(DeltaTime);
		// Wait for arm animation to raise before placing decals
		timeSinceStartFire += DeltaTime;
		FHAttachment_SprayPainter(FHNormalPlayer(Owner).CurrentWeaponAttachment).placingDecals = 
			timeSinceStartFire > armAnimationTime * 2;
	}
}

simulated function UpdateBeamEmitter(vector FlashLocation, vector HitNormal, actor HitActor)
{
	if (LinkedTo != None)
	{
		FlashLocation = GetLinkedToLocation();
	}

	BeamTemplate[1]=ParticleSystem'FH_particle.spraypaint_FX_x_axis_pos';

	if (BeamEmitter[CurrentFireMode] != none)
	{
		SetBeamEmitterHidden( !UTPawn(Instigator).IsFirstPerson() );
		BeamEmitter[CurrentFireMode].SetVectorParameter(EndPointParamName,FlashLocation);
	}
}

simulated event SetPosition(UDKPawn Holder)
{
	if ( !Holder.IsFirstPerson() )
		return;

	FHNormalPlayer(Owner).EyeHeight = FHNormalPlayer(Owner).bIsCrouched ? 20 : 45;
	super.SetPosition(Holder);
}


// Decompiled with UE Explorer.
defaultproperties
{
    armAnimationTime=0.1800000
    StartAltFireSound=none
    EndAltFireSound=none
    // Reference: ParticleSystemComponent'Default__FHWeap_SprayPaintCan.PoweredUpComponent'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'PoweredUpComponent'
    // Archetype: ParticleSystemComponent'UTGame.Default__UTWeap_LinkGun.PoweredUpComponent'
    begin object name="PoweredUpComponent"
        ReplacementPrimitive=none
    end object
    PoweredUpEffect=PoweredUpComponent
    BeamTemplate[1]=ParticleSystem'FH_particle.spraypaint_FX_x_axis_pos'
    // Reference: ForceFeedbackWaveform'Default__FHWeap_SprayPaintCan.BeamForceFeedbackWaveform1'
    // Archetype: ForceFeedbackWaveform'UTGame.Default__UTWeap_LinkGun.BeamForceFeedbackWaveform1'
    begin object name="BeamForceFeedbackWaveform1"
    end object
    BeamWeaponFireWaveForm=BeamForceFeedbackWaveform1
    MaxAmmoCount=60000
    // Reference: ForceFeedbackWaveform'Default__FHWeap_SprayPaintCan.ForceFeedbackWaveformShooting1'
    // Archetype: ForceFeedbackWaveform'UTGame.Default__UTWeap_LinkGun.ForceFeedbackWaveformShooting1'
    begin object name="ForceFeedbackWaveformShooting1"
    end object
    WeaponFireWaveForm=ForceFeedbackWaveformShooting1
    AttachmentClass=Class'FHAttachment_SprayPainter'
    WeaponFireSnd=/* Array type was not detected. */
    WeaponPutDownSnd=none
    WeaponEquipSnd=none
    JumpDamping=10.0000000
    MuzzleFlashPSCTemplate=none
    MuzzleFlashAltPSCTemplate=none
    AmmoCount=50000
    WeaponProjectiles=/* Array type was not detected. */
    InstantHitDamage=/* Array type was not detected. */
    WeaponRange=200.0000000
    // Reference: UDKSkeletalMeshComponent'Default__FHWeap_SprayPaintCan.FirstPersonMesh'
    // Archetype: UDKSkeletalMeshComponent'UTGame.Default__UTWeap_LinkGun.FirstPersonMesh'
    begin object name="FirstPersonMesh"
        SkeletalMesh=SkeletalMesh'ClarkePackage.ArmMesh'
        // Reference: AnimNodeSequence'Default__FHWeap_SprayPaintCan.FirstPersonMesh.MeshSequenceA'
        // Archetype: AnimNodeSequence'UTGame.Default__UTWeap_LinkGun.MeshSequenceA'
        begin object name="MeshSequenceA"
        end object
        Animations=MeshSequenceA
        AnimSets[0]=AnimSet'ClarkePackage.ArmMesh_Anims'
        ReplacementPrimitive=none
    end object
    Mesh=FirstPersonMesh
    // Reference: SkeletalMeshComponent'Default__FHWeap_SprayPaintCan.PickupMesh'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'PickupMesh'
    // Archetype: SkeletalMeshComponent'UTGame.Default__UTWeap_LinkGun.PickupMesh'
    begin object name="PickupMesh"
        ReplacementPrimitive=none
    end object
    DroppedPickupMesh=PickupMesh
    PickupFactoryMesh=PickupMesh
}