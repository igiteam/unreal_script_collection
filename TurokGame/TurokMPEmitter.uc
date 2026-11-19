class TurokMPEmitter extends Emitter
    native
    hidecategories(Navigation);

var(Multiplayer) private noclear export editinline @NULL mGameModeRestriction;

defaultproperties
{
    // Reference: TurokMPGameModeRestriction'Default__TurokMPEmitter.GameModeRestriction0'
    begin object name=GameModeRestriction0 class=Class'TurokMPGameModeRestriction'
    end object
    mGameModeRestriction=GameModeRestriction0
    // Reference: ParticleSystemComponent'Default__TurokMPEmitter.ParticleSystemComponent0'
    begin object name=ParticleSystemComponent0
        LightEnvironment=DynamicLightEnvironmentComponent'Default__TurokMPEmitter.MyLightEnvironment'
    end object
    ParticleSystemComponent=ParticleSystemComponent0
    // Reference: DynamicLightEnvironmentComponent'Default__TurokMPEmitter.MyLightEnvironment'
    begin object name=MyLightEnvironment
    end object
    LightEnvironment=MyLightEnvironment
    bRenderStasis=true
    bMultiplayerRenderStasis=true
    // Reference: SpriteComponent'Default__TurokMPEmitter.Sprite'
    begin object name=Sprite
    end object
    Components[0]=Sprite
    Components[1]=MyLightEnvironment
    Components[2]=ParticleSystemComponent0
    // Reference: ArrowComponent'Default__TurokMPEmitter.ArrowComponent0'
    begin object name=ArrowComponent0
    end object
    Components[3]=ArrowComponent0
    RemoteRole=0
}