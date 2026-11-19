class MOHAWindBarrier extends MOHAWindVolume
    hidecategories(Navigation,Object,Movement,Display);

defaultproperties
{
    bHardConstraint=true
    bDeadenController=true
    WindStrength=3000.0000000
    WindMaxStrengthVolumeRatio=0.7500000
    WindVolumeType=1
    // Reference: ArrowComponent'Default__MOHAWindBarrier.ArrowComponent0'
    begin object name=ArrowComponent0
        ArrowColor=(R=255,G=0,B=0,A=255)
    end object
    WindVolumeEditorDirectionArrow=ArrowComponent0
    // Reference: MOHADrawWindVolumeComponent'Default__MOHAWindBarrier.DrawComponent0'
    begin object name=DrawComponent0
    end object
    DrawComponent=DrawComponent0
    // Reference: BrushComponent'Default__MOHAWindBarrier.BrushComponent0'
    begin object name=BrushComponent0
    end object
    BrushComponent=BrushComponent0
    Components[0]=BrushComponent0
    Components[1]=ArrowComponent0
    Components[2]=DrawComponent0
    CollisionComponent=BrushComponent0
    CollisionType=0
}