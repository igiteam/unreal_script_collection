class PKDmgType_Flamer extends PKDmgType_Base;

static function SpawnHitEffect(Pawn P, float Damage, Vector Momentum, name BoneName, Vector HitLocation)
{
    local PKEmit_BodyFlame BF;
    local Vector EffectLocation;
    local TraceHitInfo MyHitInfo;
    local UTPawn UTP;

    UTP = UTPawn(P);
    // End:0x30D
    if((UTP != none) && !UTP.bGibbed)
    {
        EffectLocation = HitLocation;
        // End:0x1D8
        if(BoneName == 'None')
        {
            MyHitInfo.HitComponent = P.Mesh;
            P.CheckHitInfo(MyHitInfo, P.Mesh, Momentum, EffectLocation);
            BoneName = MyHitInfo.BoneName;
            // End:0x1D8
            if((BoneName == 'None') && UTPawn(P) != none)
            {
                EffectLocation = 0.5000000 * (HitLocation + P.Location);
                EffectLocation.Z = HitLocation.Z;
            }
        }
        // End:0x24F
        if(P.IsFirstPerson())
        {
            BF = P.Spawn(Class'PKEmit_BodyPlayerFlame', P,, EffectLocation, Rotator(Momentum));            
        }
        else
        {
            BF = P.Spawn(Class'PKEmit_BodyFlame', P,, EffectLocation, Rotator(Momentum));
        }
        BF.AttachTo(P, BoneName);
        BF.LifeSpan = GetHitEffectDuration(P, Damage);
    }
    //return;    
}

static function float GetHitEffectDuration(Pawn P, float Damage)
{
    return ((P.Health <= 0) ? 5.0000000 : 5.0000000);
    //return ReturnValue;    
}

defaultproperties
{
    bCausesBlood=false
    bNeverGibs=true
    DamageWeaponClass=Class'PKWeap_SMG_Base'
    DamageWeaponFireMode=1
    DeathString="`o fried by `k's flamer"
    ImpactTypeExplosionID=EImpactTypeExplosion.ITE_Flamer
    // Reference: ForceFeedbackWaveform'Default__PKDmgType_Flamer.ForceFeedbackWaveform0'
    // Archetype: ForceFeedbackWaveform'Default__PKDmgType_Base.ForceFeedbackWaveform0'
    begin object name="ForceFeedbackWaveform0"
    end object
    DamagedFFWaveform=ForceFeedbackWaveform0
    // Reference: ForceFeedbackWaveform'Default__PKDmgType_Flamer.ForceFeedbackWaveform1'
    // Archetype: ForceFeedbackWaveform'Default__PKDmgType_Base.ForceFeedbackWaveform1'
    begin object name="ForceFeedbackWaveform1"
    end object
    KilledFFWaveform=ForceFeedbackWaveform1
}