//=============================================================================
// SASGrenadeExplosion
//
// Explosion effects for G60 'flash-bang' grenade.
//=============================================================================

class Explosion_G60_Grenade extends SASGenericExplosion;


//-----------------------------------------------------------------------------
// Functions
simulated function BlowUp()
{
	local SASPlayerController tPC;

	Super.BlowUp();

	// create blinding flash - ie leave afterimages if looking directly at explosion
	tPC = SASPlayerController(Level.GetLocalPlayerController());
	
	if (tPC != None)
	{
		if (SASHUD(tPC.myHUD).BlindingBrightFlash(self))
		{
			//auronafix get rid of this?

			//tPC.DecayMotionBlur ( 20 );
		}

		tPC.PlayTinnitusSound( Location );
	}
}

//-----------------------------------------------------------------------------
// Default properties


// Decompiled with UE Explorer.
defaultproperties
{
    mDamageDataList=/* Array type was not detected. */
    mExplosionSounds=/* Array type was not detected. */
    mExplosionSoundRadius=500.0000000
    mFlashRadius=1000.0000000
    mFlashIntensity=1.0000000
    mBangRadius=1000.0000000
    mBangIntensity=1.0000000
    // Reference: SpriteEmitter'Explosion_G60_Grenade.SparkInner'
    begin object name=SparkInner class=Class'Engine.SpriteEmitter'
        UseDirectionAs=1
        Acceleration=(X=0.0000000,Y=0.0000000,Z=-700.0000000)
        MaxParticles=25
        RespawnDeadParticles=false
        StartSizeRange=(X=(Min=8.0000000,Max=16.0000000),Y=(Min=8.0000000,Max=12.0000000),Z=(Min=8.0000000,Max=16.0000000))
        InitialParticlesPerSecond=200.0000000
        AutomaticInitialSpawning=false
        Texture=Texture'SFXTx.Muzzle_Flashes.sparktest'
        SecondsBeforeInactive=0.0000000
        LifetimeRange=(Min=0.0100000,Max=0.1000000)
        StartVelocityRange=(X=(Min=-500.0000000,Max=500.0000000),Y=(Min=-500.0000000,Max=500.0000000),Z=(Min=-500.0000000,Max=500.0000000))
        VelocityLossRange=(X=(Min=1.0000000,Max=1.0000000),Y=(Min=1.0000000,Max=1.0000000),Z=(Min=1.0000000,Max=1.0000000))
    end object
    Emitters[0]=SparkInner
    // Reference: SpriteEmitter'Explosion_G60_Grenade.Flash'
    begin object name=Flash class=Class'Engine.SpriteEmitter'
        MaxParticles=1
        RespawnDeadParticles=false
        UseSizeScale=true
        UseRegularSizeScale=false
        SizeScale=/* Array type was not detected. */
        UniformSize=true
        InitialParticlesPerSecond=5000.0000000
        AutomaticInitialSpawning=false
        Texture=Texture'SFXTx.lights.FxL_Corona_StandLight'
        SecondsBeforeInactive=0.0000000
        LifetimeRange=(Min=0.3000000,Max=0.3000000)
    end object
    Emitters[1]=Flash
    // Reference: SpriteEmitter'Explosion_G60_Grenade.SparkLag'
    begin object name=SparkLag class=Class'Engine.SpriteEmitter'
        UseDirectionAs=1
        Acceleration=(X=0.0000000,Y=0.0000000,Z=-700.0000000)
        MaxParticles=25
        RespawnDeadParticles=false
        StartSizeRange=(X=(Min=8.0000000,Max=16.0000000),Y=(Min=8.0000000,Max=12.0000000),Z=(Min=8.0000000,Max=16.0000000))
        InitialParticlesPerSecond=200.0000000
        AutomaticInitialSpawning=false
        Texture=Texture'SFXTx.Muzzle_Flashes.sparktest'
        SecondsBeforeInactive=0.0000000
        LifetimeRange=(Min=0.0100000,Max=1.0000000)
        StartVelocityRange=(X=(Min=-500.0000000,Max=500.0000000),Y=(Min=-500.0000000,Max=500.0000000),Z=(Min=-500.0000000,Max=500.0000000))
        VelocityLossRange=(X=(Min=1.0000000,Max=1.0000000),Y=(Min=1.0000000,Max=1.0000000),Z=(Min=1.0000000,Max=1.0000000))
    end object
    Emitters[2]=SparkLag
    LightBrightness=200.0000000
    LightRadius=20.0000000
    LightType=12
    LightPeriod=30
    LightCustomIntensity=1.0000000
    bDynamicLight=true
}