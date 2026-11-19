class ParticleCloudEmitter extends ParticleSpriteEmitter
    native
    editinlinenew;

var(ScaleRotation) RawDistributionFloat XScale_Default;
var(ScaleRotation) RawDistributionFloat YScale_Default;
var(ScaleRotation) RawDistributionFloat RotationDegrees;
var(ScaleRotation) const editinline ParticleModuleRandomFlip PM_RandomFlip;
var ParticleModuleColorByHeight PM_ColorByHeight;
var(Attributes) const editinline ParticleModuleSubUVInit PM_SubUVInit;
var native const SkyCloudAsset SkyCloudPtr;
var(Lighting) bool bUseDefaultLighting;
var(Lighting) LinearColor CMin;
var(Lighting) LinearColor CMedian;
var(Lighting) LinearColor CMax;
var KBoxElem Bounds;
var(Attributes) int Density;
var(Attributes) float CullRadius;
