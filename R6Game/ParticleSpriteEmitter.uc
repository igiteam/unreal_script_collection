class ParticleSpriteEmitter extends ParticleEmitter
    native
    editinlinenew
    collapsecategories
    hidecategories(Object,Object);

enum EParticleScreenAlignment
{
    PSA_Square,                     // 0
    PSA_Rectangle,                  // 1
    PSA_Velocity,                   // 2
    PSA_MAX                         // 3
};

var(Sprite) ParticleSpriteEmitter.EParticleScreenAlignment ScreenAlignment;
var(Sprite) MaterialInstance Material;
var(Sprite) MaterialInstance HeatMaterial;
