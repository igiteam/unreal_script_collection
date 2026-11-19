//=============================================================================
// SASFire_on_mesh
//
// Fire emitter used by SASFireArea
//=============================================================================

class SASFire_on_mesh extends Emitter;

//#exec OBJ LOAD FILE=..\Textures\jm-particl2.utx PACKAGE=jm-particl2

//-----------------------------------------------------------------------------
// Functions

//-----------------------------------------------------------------------------
// UC functions called from cpp

//-----------------------------------------------------------------------------
// Default properties


// Decompiled with UE Explorer.
defaultproperties
{
    // Reference: SpriteEmitter'SASFire_on_mesh.NonDying_Particle_On_Mesh'
    begin object name=NonDying_Particle_On_Mesh class=Class'Engine.SpriteEmitter'
        MaxParticles=149
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
    Emitters[0]=NonDying_Particle_On_Mesh
    bNoDelete=false
}