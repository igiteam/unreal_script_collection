//-----------------------------------------------------------
//
//-----------------------------------------------------------
class HDExlpodeRadialBlurActor extends RadialBlurActor
    notplaceable;

var() float                     BlurFalloffSpeed;

event Tick( float DeltaTime )
{
    local float blur;
    if ( RadialBlur.bEnabled && RadialBlur.BlurScale >= 0.f )
    {
        blur = RadialBlur.BlurScale - BlurFallOffSpeed * DeltaTime;
        blur = FClamp( blur, 0, RadialBlur.default.BlurScale );
        RadialBlur.SetBlurScale( blur  );
        if ( blur == 0.f )
        {
            RadialBlur.SetEnabled(False);
            RadialBlur.SetBlurScale(RadialBlur.default.BlurScale);
        }
    }
}

