class SPSprintBar extends UIImage;

var MaterialInstanceConstant matInstance;
var float Radius;
var Surface sf;
var MaterialInterface mt;

final function bool SetMaterialValue(coerce float NewValue, optional bool bPercentageValue)
{
    // End:0x65
    if(matInstance == none)
    {
        matInstance = new (none) Class'Engine.MaterialInstanceConstant';
        sf = ImageComponent.ImageRef.GetSurface();
        mt = MaterialInterface(sf);
        matInstance.SetParent(mt);
    }
    // End:0xA4
    if((NewValue >= 0.0000000) && NewValue <= 1.0000000)
    {
        Radius = (-float(1) - 0.5000000 * float(4)) * 3.1415930;
    }
    matInstance.SetScalarParameterValue('Sprint_meter', Radius);
    return true;
    //return ReturnValue;    
}
