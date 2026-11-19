class R6BreakableGlassParams extends R6Config
    native
    hidecategories(Object);

var(Collision) float fCollisionBreakForce;
var(Collision) float fHalfThickness;
var(Collision) bool bUseVisualThickness;
var(BreakDirs) bool bNoShard;
var(ParticlesInit) bool bNoParticle;
var(BreakDirs) int iNbDirMin;
var(BreakDirs) int iNbDirMax;
var(BreakDirs) float fDirRandom;
var(BreakDirs) ParticleSystem pBreakParticleFX;
var(BrokenShards) float fMinBreakCoef;
var(BrokenShards) float fMaxBreakCoef;
var(BrokenShards) float fMaxBreakInterDist;
var(BrokenShards) float fMinBreakDist;
var(BrokenShards) float fBreakGap;
var(BrokenShards) int iNbDestroyedMin;
var(BrokenShards) int iNbDestroyedMax;
var(BrokenShards) float fDestroyRemain;
var(BrokenShards) ParticleSystem pShardParticleFX;
var(ParticlesInit) float fMinParticleSpeed;
var(ParticlesInit) float fMaxParticleSpeed;
var(ParticlesInit) float fShardParticleSpeed;
var(ParticlesInit) float fMaxParticleRotationRate;
var(ParticlesInit) float fParticleSpread;
var(ParticlesInit) float fLifeTime;
var(ParticlesInit) float fFadeOutTime;
var(ParticlesInit) float fMaxSize;
var(ParticlesInit) float fSizeRandom;
var(ParticlesEvolve) float fParticleGravity;
var(ParticlesEvolve) float fMaxDistFromObject;
var(ParticlesEvolve) float fRestOffset;
var(ParticlesEvolve) float fSlideSlope;
var(ParticlesEvolve) float fSlideDamping;
var(Materials) MaterialInstance m_pDefaultMaterialOK;
var(Materials) MaterialInstance m_pDefaultMaterialBroken;
var(Materials) MaterialInstance m_pDefaultMaterialParticle;

defaultproperties
{
    fCollisionBreakForce=-1.0000000
    fHalfThickness=0.5000000
    iNbDirMin=6
    iNbDirMax=12
    fDirRandom=0.5000000
    fMinBreakCoef=0.2000000
    fMaxBreakCoef=0.5000000
    fMaxBreakInterDist=10.0000000
    fMinBreakDist=10.0000000
    fBreakGap=1.0000000
    iNbDestroyedMin=1
    iNbDestroyedMax=2
    fDestroyRemain=2.0000000
    fMinParticleSpeed=200.0000000
    fMaxParticleSpeed=1000.0000000
    fShardParticleSpeed=100.0000000
    fMaxParticleRotationRate=65536.0000000
    fParticleSpread=80.0000000
    fLifeTime=10.0000000
    fFadeOutTime=2.0000000
    fMaxSize=50.0000000
    fSizeRandom=0.5000000
    fParticleGravity=500.0000000
    fMaxDistFromObject=2048.0000000
    fRestOffset=2.0000000
    fSlideSlope=0.8000000
    fSlideDamping=0.5000000
    m_szThumbnailTexture="KellerResource.BreakableGlass"
    m_szDescription="Breakable Glass Parameters"
}