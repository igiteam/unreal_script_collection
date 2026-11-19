class PKPlayerHitEffects extends EvilPlayerHitEffects
    hidecategories(Navigation);

simulated function ProcessHitEffects(float Damage, optional bool bBBPass = true, optional class<DamageType> DamageType = none)
{
    local float Ratio;
    local EvilPlayerController PC;
    local EvilPlayer_interface EPI;
    local PKPostProcessManager PKPP;

    PC = EvilPlayerController(Owner);
    PKPP = PKPostProcessManager(PC.GetPPManager());
    // End:0x458
    if(PC != none)
    {
        EPI = PC.GetPlayer();
        // End:0x458
        if(NotEqual_InterfaceInterface(EPI, EvilPlayer_interface(none)))
        {
            Ratio = Damage / EPI.GetPlayerPawn().DefaultHealth;
            // End:0x17F
            if((DamageType == Class'PKDmgType_Poison') || DamageType == Class'PKDmgType_PoisonDrowning')
            {
                PKPP.EnableFlash(MakeLinearColor(0.6000000, 0.0000000, 0.0000000, 0.5000000), 0.1500000, 0.1500000,, 2.0000000, 2.0000000);                
            }
            else
            {
                // End:0x20B
                if(DamageType == Class'PKDmgType_PoisonSlowdown')
                {
                    PKPP.EnableFlash(MakeLinearColor(0.0000000, 0.8000000, 0.3000000, 0.5000000), 0.1500000, 0.1500000,, 2.0000000, Class'PKDmgType_PoisonSlowdown'.default.SlowdownTimeInterval * 2.0000000);                    
                }
                else
                {
                    // End:0x28F
                    if((((DamageType == Class'PKDmgType_Flamer') || DamageType == Class'PKDmgType_FlamerWithLight') || DamageType == Class'EvilGame.EvilDmgType_Fire') || DamageType == Class'PKDmgType_AlastorFlames')
                    {
                        PKPP.EnableBurn();                        
                    }
                    else
                    {
                        // End:0x2C8
                        if(DamageType == Class'PKDmgType_Electro')
                        {
                            PKPP.EnableElectrocution();                            
                        }
                        else
                        {
                            // End:0x334
                            if(DamageType == Class'PKDmgType_NunSpell')
                            {
                                PKPP.EnableFlash(MakeLinearColor(1.0000000, 0.8000000, 0.0000000, 0.5000000), 0.1500000, 0.1500000,, 2.0000000, 10.0000000);                                
                            }
                            else
                            {
                                // End:0x3CB
                                if(DamageType == Class'PKDmgType_StakeBurning')
                                {
                                    PKPP.EnableBurn();
                                    PKPP.EnableMediumBlood(FClamp(Ratio, 0.1000000, 1.1000000), int(FClamp(float(int(Ratio * (0.2500000 + float(Rand(5))))), 0.0000000, 1.0000000)));                                    
                                }
                                else
                                {
                                    PKPP.EnableMediumBlood(FClamp(Ratio, 0.1000000, 1.1000000), int(FClamp(float(int(Ratio * (0.2500000 + float(Rand(5))))), 0.0000000, 1.0000000)));
                                }
                            }
                        }
                    }
                }
            }
            // End:0x458
            if(bBBPass)
            {
                BBOpacity = 0.3500000;
                SetTimer(0.0300000, true, 'BBPass_T');
            }
        }
    }
    //return;    
}
