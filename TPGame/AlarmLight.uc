class AlarmLight extends Alarm
    placeable;

var PointLightComponent AlarmLightComponent;

simulated function PostBeginPlay()
{
	super.PostBeginPlay();
}

auto state AlarmWait
{   
    event Tick( float DeltaTime )
    {                
        if(!bAlarmOn)
        {
            AlarmLightComponent.SetEnabled(false);
        }      
        else if(bAlarmOn)
        {           
            AlarmLightComponent.SetEnabled(true);       
        }   
    }        
}
    
