/**
 * Jetpack
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class JetPack extends JetPackBase;

/** Pawn this jetpack is attached to */
var NanoPawn_MetaCorp_SkywayPatrol SkyPatrol;





simulated function PostBeginPlay()
{
	Super.PostBeginPlay();

	SkyPatrol = NanoPawn_MetaCorp_SkywayPatrol(Owner);

	PSC_Thruster = new(self) class'NanoParticleSystemComponent';
	PSC_Thruster.SetTemplate(PS_Thruster);
	PSC_Thruster.DeactivateSystem();
	JetPackMesh.AttachComponentToSocket(PSC_Thruster,'Thruster');

	PSC_Exhaust[0] = new(self) class'NanoParticleSystemComponent';
	PSC_Exhaust[0].SetTemplate(PS_Exhaust);
	PSC_Exhaust[0].SetFloatParameter( 'Jetpower', 1.f );
	PSC_Exhaust[0].DeactivateSystem();
	JetPackMesh.AttachComponentToSocket(PSC_Exhaust[0],'RightWing');

	PSC_Exhaust[1] = new(self) class'NanoParticleSystemComponent';
	PSC_Exhaust[1].SetTemplate(PS_Exhaust);
	PSC_Exhaust[1].SetFloatParameter( 'Jetpower', 1.f );
	PSC_Exhaust[1].DeactivateSystem();
	JetPackMesh.AttachComponentToSocket(PSC_Exhaust[1],'LeftWing');
}


simulated function Destroyed()
{
	Super.Destroyed();

	SkyPatrol.StopFlying();
}


simulated function UpdateMesh( float DeltaTime )
{
	// Turn on thrusters when moving upward!
	if( SkyPatrol.Velocity.Z > 300.f && !SkyPatrol.bJuggled )
	{
		if( !PSC_Thruster.bIsActive )
		{
			PSC_Thruster.ActivateSystem();
		}
	}
	else
	{
		// Turn off thrusters when not moving upward
		if( PSC_Thruster.bIsActive )
		{
			PSC_Thruster.DeactivateSystem();
		}
	}
}



simulated function PlayExplode()
{
	local NanoExplosionActor ExplosionActor;

	if( !bExploded )
	{
		bExploded = TRUE;

		ExplosionActor = Spawn(class'NanoExplosionActor',,, Location, Rotator(vect(0,0,1)));
		if( ExplosionActor != None )
		{
			ExplosionActor.Instigator = SkyPatrol;
			ExplosionActor.InstigatorController = SkyPatrol.Controller;

			ExplosionTemplate.HitActor		= SkyPatrol;
			ExplosionTemplate.HitLocation	= Location;
			ExplosionTemplate.HitNormal		= vect(0,0,1);

			ExplosionActor.Attachee = SkyPatrol;
			ExplosionTemplate.bAttachExplosionEmitterToAttachee = TRUE;
			ExplosionActor.SetBase(SkyPatrol);

			ExplosionActor.Explode(ExplosionTemplate);
		}

		Destroy();
	}
}


reliable server function ServerSetNanoState(ENanoState NewState)
{
	SetNanoState(NewState, SkyPatrol.Controller);
}



defaultproperties
{
	bHardAttach=TRUE

	Begin Object Class=SkeletalMeshComponent Name=MyJetPackMesh
		SkeletalMesh=SkeletalMesh'MET_ShockTrooperProto.SK_MET_JetPack'
		bUpdateSkelWhenNotRendered=FALSE
	End Object
	JetPackMesh=MyJetPackMesh
	Components.Add(MyJetPackMesh)

	PS_Thruster=ParticleSystem'Nano_FX.Effects.P_Nano_JetPackBoost'
	PS_Exhaust=ParticleSystem'Nano_FX.Effects.P_Nano_JetPackExhaust'
	PS_Damaged=ParticleSystem'Nano_FX.Effects.P_Nano_FX_JetpackSmokeTrail'

	Begin Object Class=NanoExplosion Name=ExploTemplate0
		ParticleEmitterTemplate=ParticleSystem'Nano_FX.Effects.P_Nano_FX_Jetpack_Death'
		ExplosionSound=SoundCue'Weapon_Pistol.Pistol.Pistol_FirePlayer_Cue'

		MyDamageType=class'NDT_Bomb'
		MomentumTransferScale=1.f	// Scale momentum defined in DamageType
	End Object
	ExplosionTemplate=ExploTemplate0



	Begin Object Class=TargetableOctreeComponent Name=TargetableOctreeComp0
	End Object
	Components.Add(TargetableOctreeComp0)

}
