class R6EffectGasParam extends Actor
    native
    notplaceable
    hidecategories(lighting);

var export editinline R6EffectGasComponent m_Component;

defaultproperties
{
    // Reference: R6EffectGasComponent'Default__R6EffectGasParam.R6EffectGasComponent0'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    begin object name="R6EffectGasComponent0" class=Class'R6EffectGasComponent'
    end object
    m_Component=R6EffectGasComponent0
    bHidden=true
    bIgnoreVehicles=true
    bIgnoreEncroachers=true
    m_bIsDynamicObstacle=true
    bMovable=false
    m_bCanFireThrough=true
    bCollideActors=true
    // Reference: SpriteComponent'Default__R6EffectGasParam.Sprite'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    // Archetype: SpriteComponent'Default__Actor.Sprite'
    begin object name="Sprite"
    end object
    Components[0]=Sprite
    Components[1]=R6EffectGasComponent0
    CollisionComponent=R6EffectGasComponent0
    m_fBulletGoThrough=1.0000000
}