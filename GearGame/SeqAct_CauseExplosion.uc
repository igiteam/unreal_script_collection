/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class SeqAct_CauseExplosion extends SequenceAction;

/** Defines the explosion. */
var() export editinline GearExplosion	CustomExplosionTemplate;

var() class<GearProj_ExplosiveBase>		    ProjectileExplosionToEmulate;


event Activated()
{
	local Actor TargetActor;
	local GearExplosionActorReplicated ExploActor;

	if (Targets.length > 0)
	{
		// is it a pawn?
		TargetActor = Actor(Targets[0]);
		if (TargetActor != None)
		{
			if (CustomExplosionTemplate != None)
			{
				// explode using the given template
				ExploActor = GetWorldInfo().Spawn(class'GearExplosionActorReplicated',,, TargetActor.Location, TargetActor.Rotation,, true);
				if (ExploActor != None)
				{
					CustomExplosionTemplate.InitFromContentTemplate();
					ExploActor.Explode(CustomExplosionTemplate);
				}
			}
			else if (ProjectileExplosionToEmulate != None)
			{
				// emulate the explosion of a certian projectile class
				ExploActor = GetWorldInfo().Spawn(class'GearExplosionActorReplicated',,, TargetActor.Location, TargetActor.Rotation,, true);
				if (ExploActor != None)
				{
					ExploActor.EmulateProjectileExplosion(ProjectileExplosionToEmulate);
				}
			}
		}
	}
}

simulated protected function CopyDataFromScreenShakeStruct(CameraShake Shake, ScreenShakeStruct SSS)
{
	// copy oscillation params
	Shake.OscillationDuration = SSS.TimeDuration;

	Shake.RotOscillation.Pitch.Amplitude = SSS.RotAmplitude.X;
	Shake.RotOscillation.Pitch.Frequency = SSS.RotFrequency.X;
	Shake.RotOscillation.Pitch.InitialOffset = EInitialOscillatorOffset(SSS.RotParam.X);

	Shake.RotOscillation.Yaw.Amplitude = SSS.RotAmplitude.Y;
	Shake.RotOscillation.Yaw.Frequency = SSS.RotFrequency.Y;
	Shake.RotOscillation.Yaw.InitialOffset = EInitialOscillatorOffset(SSS.RotParam.Y);

	Shake.RotOscillation.Roll.Amplitude = SSS.RotAmplitude.Z;
	Shake.RotOscillation.Roll.Frequency = SSS.RotFrequency.Z;
	Shake.RotOscillation.Roll.InitialOffset = EInitialOscillatorOffset(SSS.RotParam.Z);

	Shake.LocOscillation.X.Amplitude = SSS.LocAmplitude.X;
	Shake.LocOscillation.X.Frequency = SSS.LocFrequency.X;
	Shake.LocOscillation.X.InitialOffset = EInitialOscillatorOffset(SSS.LocParam.X);

	Shake.LocOscillation.Y.Amplitude = SSS.LocAmplitude.Y;
	Shake.LocOscillation.Y.Frequency = SSS.LocFrequency.Y;
	Shake.LocOscillation.Y.InitialOffset = EInitialOscillatorOffset(SSS.LocParam.Y);

	Shake.LocOscillation.Z.Amplitude = SSS.LocAmplitude.Z;
	Shake.LocOscillation.Z.Frequency = SSS.LocFrequency.Z;
	Shake.LocOscillation.Z.InitialOffset = EInitialOscillatorOffset(SSS.LocParam.Z);

	Shake.FOVOscillation.Amplitude = SSS.FOVAmplitude;
	Shake.FOVOscillation.Frequency = SSS.FOVFrequency;
	Shake.FOVOscillation.InitialOffset = EInitialOscillatorOffset(SSS.FOVParam);

	GearCameraShake(Shake).bOverrideTargetingDampening = SSS.bOverrideTargetingDampening;
	GearCameraShake(Shake).TargetingDampening = SSS.TargetingDampening;
}


simulated protected function CopyDataFromScreenShakeAnimStruct(CameraShake Shake, ScreenShakeAnimStruct SSAS)
{
	Shake.Anim = SSAS.Anim;
	Shake.AnimScale = SSAS.AnimScale;
	Shake.AnimPlayRate= SSAS.AnimPlayRate;
	Shake.AnimBlendInTime = SSAS.AnimBlendInTime;
	Shake.AnimBlendOutTime = SSAS.AnimBlendOutTime;
	Shake.bRandomAnimSegment = SSAS.bRandomSegment;
	Shake.RandomAnimSegmentDuration = SSAS.RandomSegmentDuration;
	Shake.bSingleInstance = SSAS.bSingleInstance;
}

function VersionUpdated(int OldVersion, int NewVersion)
{
	local int MyOldVersion, MyNewVersion;
	MyOldVersion = OldVersion - Super.GetObjClassVersion();
	MyNewVersion = NewVersion - Super.GetObjClassVersion();

	// upgrading from 1 to 2, update the GearExplosion data format with the new data
	if ( (MyOldVersion <= 1) && (MyNewVersion > 1) )
	{
		if ( (CustomExplosionTemplate != None) && (CustomExplosionTemplate.bDoExploCameraAnimShake || CustomExplosionTemplate.bDoExploCameraShake) )
		{
			CustomExplosionTemplate.CamShake = new(CustomExplosionTemplate) class'GearCameraShake';
			if (CustomExplosionTemplate.bDoExploCameraShake)
			{
				CopyDataFromScreenShakeStruct(CustomExplosionTemplate.CamShake, CustomExplosionTemplate.ExploShake);
			}
			if (CustomExplosionTemplate.bDoExploCameraAnimShake)
			{
				CopyDataFromScreenShakeAnimStruct(CustomExplosionTemplate.CamShake, CustomExplosionTemplate.ExploAnimShake);
			}

			// directionals
			if (CustomExplosionTemplate.ExploAnimShake.Anim_Left != None)
			{
				CustomExplosionTemplate.CamShake_Left = new(CustomExplosionTemplate) class'GearCameraShake';
				CopyDataFromScreenShakeAnimStruct(CustomExplosionTemplate.CamShake_Left, CustomExplosionTemplate.ExploAnimShake);
				CustomExplosionTemplate.CamShake_Left.Anim = CustomExplosionTemplate.ExploAnimShake.Anim_Left;
			}
			if (CustomExplosionTemplate.ExploAnimShake.Anim_Right != None)
			{
				CustomExplosionTemplate.CamShake_Right = new(CustomExplosionTemplate) class'GearCameraShake';
				CopyDataFromScreenShakeAnimStruct(CustomExplosionTemplate.CamShake_Right, CustomExplosionTemplate.ExploAnimShake);
				CustomExplosionTemplate.CamShake_Right.Anim = CustomExplosionTemplate.ExploAnimShake.Anim_Right;
			}
			if (CustomExplosionTemplate.ExploAnimShake.Anim_Rear != None)
			{
				CustomExplosionTemplate.CamShake_Rear = new(CustomExplosionTemplate) class'GearCameraShake';
				CopyDataFromScreenShakeAnimStruct(CustomExplosionTemplate.CamShake_Rear, CustomExplosionTemplate.ExploAnimShake);
				CustomExplosionTemplate.CamShake_Rear.Anim = CustomExplosionTemplate.ExploAnimShake.Anim_Rear;
			}
		}
	}
}

/**
 * Return the version number for this class.  Child classes should increment this method by calling Super then adding
 * a individual class version to the result.  When a class is first created, the number should be 0; each time one of the
 * link arrays is modified (VariableLinks, OutputLinks, InputLinks, etc.), the number that is added to the result of
 * Super.GetObjClassVersion() should be incremented by 1.
 *
 * @return	the version number for this specific class.
 */
static event int GetObjClassVersion()
{
	return Super.GetObjClassVersion() + 2;
}

defaultproperties
{
	ObjName="Cause Explosion"
	ObjCategory="Gear"

	// handled in Activated above
	bCallHandler=FALSE
}
