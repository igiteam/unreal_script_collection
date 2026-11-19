class PKDmgType_FlamerWithLight extends PKDmgType_Flamer;

static function SpawnHitEffect(Pawn P, float Damage, Vector Momentum, name BoneName, Vector HitLocation)
{
    local editinline PKLight_Burning BurningLight;
    local Vector EffectLocation;
    local TraceHitInfo MyHitInfo;
    local UTPawn UTP;

    super.SpawnHitEffect(P, Damage, Momentum, BoneName, HitLocation);
    UTP = UTPawn(P);
    // End:0x278
    if((UTP != none) && !UTP.bGibbed)
    {
        EffectLocation = HitLocation;
        // End:0x20F
        if(BoneName == 'None')
        {
            MyHitInfo.HitComponent = P.Mesh;
            P.CheckHitInfo(MyHitInfo, P.Mesh, Momentum, EffectLocation);
            BoneName = MyHitInfo.BoneName;
            // End:0x20F
            if((BoneName == 'None') && UTPawn(P) != none)
            {
                EffectLocation = 0.5000000 * (HitLocation + P.Location);
                EffectLocation.Z = HitLocation.Z;
            }
        }
        BurningLight = new (UTP) Class'PKLight_Burning';
        UTP.Mesh.AttachComponent(BurningLight, BoneName);
    }
    //return;    
}

defaultproperties
{
    DeathString="`o boiled by `k's flamer"
    // Reference: ForceFeedbackWaveform'Default__PKDmgType_FlamerWithLight.ForceFeedbackWaveform0'
    // Archetype: ForceFeedbackWaveform'Default__PKDmgType_Flamer.ForceFeedbackWaveform0'
    begin object name="ForceFeedbackWaveform0"
    end object
    DamagedFFWaveform=ForceFeedbackWaveform0
    // Reference: ForceFeedbackWaveform'Default__PKDmgType_FlamerWithLight.ForceFeedbackWaveform1'
    // Archetype: ForceFeedbackWaveform'Default__PKDmgType_Flamer.ForceFeedbackWaveform1'
    begin object name="ForceFeedbackWaveform1"
    end object
    KilledFFWaveform=ForceFeedbackWaveform1
}