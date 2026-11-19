//=============================================================================
// SASFire
//
// Fire emitter used by SASFireArea.
//=============================================================================

class SASFire extends Emitter
	native
	placeable;

var() class<SASExpandingProjector>	mBurnMarkClass;

//-----------------------------------------------------------------------------
// Functions

//-----------------------------------------------------------------------------
// UC functions called from cpp

// ICHACK - allow molotov's to trigger in the editor
event PreBeginPlay()
{
	// override Actor.PreBeginPlay -> otherwise class is Destroy()'d on construction in editor
}

///////////////////////////////////////////////////////////////////////////////
event PostBeginPlay()
{
	// spawn burnmark
	local SASExpandingProjector BurnMark;
	local Rotator rot;
	local Vector X,Y,Z;

	if(mBurnMarkClass!=none)
	{
		// point downwards
		GetAxes(Rotation,X,Y,Z);
		rot = rotator(-X);		// SASMolotov_Cocktail_Projectile : CreatePoolOfFire sets SASFireArea.Rotation to (-surfaceNormal)

		BurnMark = Spawn(mBurnMarkClass,,,Location,rot);
	}
}

//-----------------------------------------------------------------------------
// Default properties


// Decompiled with UE Explorer.
defaultproperties
{
    // Reference: SpriteEmitter'SASFire.Single_NonDying_Particle'
    begin object name=Single_NonDying_Particle class=Class'Engine.SpriteEmitter'
        MaxParticles=1
        ResetAfterChange=true
        RespawnDeadParticles=false
        UseRegularSizeScale=false
        StartSizeRange=(X=(Min=10.0000000,Max=10.0000000),Y=(Min=10.0000000,Max=10.0000000),Z=(Min=10.0000000,Max=10.0000000))
        UniformSize=true
        InitialParticlesPerSecond=60.0000000
        AutomaticInitialSpawning=false
        TextureUSubdivisions=3
        TextureVSubdivisions=3
        SubdivisionStart=2
        SubdivisionEnd=2
        UseRandomSubdivision=true
        LifetimeRange=(Min=0.0000000,Max=0.0000000)
    end object
    Emitters[0]=Single_NonDying_Particle
    bNoDelete=false
}