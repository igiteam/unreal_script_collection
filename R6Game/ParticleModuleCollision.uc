class ParticleModuleCollision extends ParticleModuleCollisionBase
    native
    editinlinenew
    collapsecategories
    hidecategories(Object,Object,Object);

var(Collision) noclear export editinline DistributionVector DampingFactor;
var(Collision) noclear export editinline DistributionVector DampingFactorRotation;
var(Collision) noclear export editinline DistributionFloat MaxCollisions;
var(Collision) bool bApplyPhysics;
var(Collision) bool m_bAllowLifeToExceedMaxCollisions;
var(Collision) noclear export editinline DistributionFloat ParticleMass;
var(Collision) ParticleSystem m_EmitterToSpawnOnCollision;
var(Collision) int m_iNoCollisionAtLODGreaterThan;

defaultproperties
{
    // Reference: DistributionVectorUniform'Default__ParticleModuleCollision.DistributionDampingFactor'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    begin object name="DistributionDampingFactor" class=Class'DistributionVectorUniform'
    end object
    DampingFactor=DistributionDampingFactor
    // Reference: DistributionVectorConstant'Default__ParticleModuleCollision.DistributionDampingFactorRotation'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    begin object name="DistributionDampingFactorRotation" class=Class'DistributionVectorConstant'
        Constant=(X=1.0000000,Y=1.0000000,Z=1.0000000)
    end object
    DampingFactorRotation=DistributionDampingFactorRotation
    // Reference: DistributionFloatUniform'Default__ParticleModuleCollision.DistributionMaxCollisions'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    begin object name="DistributionMaxCollisions" class=Class'DistributionFloatUniform'
    end object
    MaxCollisions=DistributionMaxCollisions
    // Reference: DistributionFloatConstant'Default__ParticleModuleCollision.DistributionParticleMass'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    begin object name="DistributionParticleMass" class=Class'DistributionFloatConstant'
        Constant=0.1000000
    end object
    ParticleMass=DistributionParticleMass
    m_iNoCollisionAtLODGreaterThan=1
    bSpawnModule=true
    bUpdateModule=true
}