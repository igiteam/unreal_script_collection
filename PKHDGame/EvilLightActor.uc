class EvilLightActor extends Actor
    notplaceable
    hidecategories(Navigation);

var protected export editinline transient UDKExplosionLight DynamicLightComp;
var protected export editinline transient PointLightComponent PointLightComp;
var() export editinline UDKExplosionLight DynamicLightTemplate;
var() export editinline PointLightComponent PointLightTemplate;
var() bool IsDynamic;
var() bool bLoopedExplosionTimeShift;
var() bool bDestroyLightOnPawnBaseDied;
var() bool bDestroyLightOnFinish;
var repnotify bool bReplicatedActivate;
var() float FadeOutTime;

replication
{
    // Pos:0x000
    if(bNetDirty)
        bReplicatedActivate;
}

simulated event ReplicatedEvent(name VarName)
{
    // End:0x31
    if(VarName == 'bReplicatedActivate')
    {
        // End:0x2E
        if(bReplicatedActivate)
        {
            Activate();
        }        
    }
    else
    {
        super.ReplicatedEvent(VarName);
    }
    //return;    
}

function PawnBaseDied()
{
    super.PawnBaseDied();
    Destroy();
    //return;    
}

simulated function DisableLight(bool bDisable)
{
    // End:0x3D
    if(DynamicLightComp != none)
    {
        DynamicLightComp.SetEnabled(!bDisable);        
    }
    else
    {
        // End:0x77
        if(PointLightComp != none)
        {
            PointLightComp.SetEnabled(!bDisable);
        }
    }
    //return;    
}

simulated function RestartLight(UDKExplosionLight Light)
{
    Light.ResetLight();
    //return;    
}

function SetDestroy()
{
    // End:0x2B
    if(FadeOutTime > float(0))
    {
        SetTimer(FadeOutTime, false, 'Destroy_T');        
    }
    else
    {
        Destroy();
    }
    //return;    
}

simulated function DeactivateOnLightFinished(UDKExplosionLight Light)
{
    Deactivate();
    // End:0x21
    if(bDestroyLightOnFinish)
    {
        SetDestroy();
    }
    //return;    
}

function Destroy_T()
{
    Destroy();
    //return;    
}

function ServerActivate()
{
    bReplicatedActivate = true;
    Activate();
    bForceNetUpdate = true;
    //return;    
}

simulated function Activate()
{
    // End:0xE6
    if(IsDynamic && DynamicLightComp == none)
    {
        DynamicLightComp = new (self) DynamicLightTemplate.Class (DynamicLightTemplate);
        // End:0x93
        if(bLoopedExplosionTimeShift)
        {
            DynamicLightComp.__OnLightFinished__Delegate = RestartLight;            
        }
        else
        {
            // End:0xD0
            if(bDestroyLightOnFinish)
            {
                DynamicLightComp.__OnLightFinished__Delegate = DeactivateOnLightFinished;
            }
        }
        AttachComponent(DynamicLightComp);        
    }
    else
    {
        // End:0x14E
        if(!IsDynamic && PointLightComp == none)
        {
            PointLightComp = new (self) PointLightTemplate.Class (PointLightTemplate);
            AttachComponent(PointLightComp);
        }
    }
    //return;    
}

simulated function Deactivate()
{
    // End:0x6B
    if(DynamicLightComp != none)
    {
        // End:0x4D
        if(FadeOutTime > float(0))
        {
            SetDynamicLightFadeOut(DynamicLightComp, FadeOutTime);
            GotoState('FadeOut');            
        }
        else
        {
            DetachComponent(DynamicLightComp);
            DynamicLightComp = none;
        }
    }
    // End:0x98
    if(PointLightComp != none)
    {
        DetachComponent(PointLightComp);
        PointLightComp = none;
    }
    //return;    
}

simulated function SetDynamicLightFadeOut(UDKExplosionLight Light, float FadeTime)
{
    local LightValues LV;

    Light.Lifetime = 0.0000000;
    Light.TimeShiftIndex = 0;
    Light.TimeShift.Remove(0, Light.TimeShift.Length);
    LV.Brightness = Light.Brightness;
    LV.LightColor = Light.LightColor;
    LV.Radius = Light.Radius;
    LV.StartTime = 0.0000000;
    Light.TimeShift.AddItem(LV);
    LV.Brightness = 0.0000000;
    LV.LightColor = Light.LightColor;
    LV.Radius = 0.0000000;
    LV.StartTime = FadeTime;
    Light.TimeShift.AddItem(LV);
    //return;    
}

simulated function Restart()
{
    // End:0x2E
    if(DynamicLightComp != none)
    {
        DynamicLightComp.ResetLight();
    }
    // End:0x51
    if(PointLightComp != none)
    {
        Deactivate();
        Activate();
    }
    //return;    
}

simulated event Destroyed()
{
    Deactivate();
    super.Destroyed();
    //return;    
}

state FadeOut
{
    simulated function RestartLight(UDKExplosionLight Light)
    {
        DetachComponent(DynamicLightComp);
        DynamicLightComp = none;
        //return;        
    }
    stop;    
}

defaultproperties
{
    // Reference: UDKExplosionLight'Default__EvilLightActor.DynamicLightTemplateArchetype'
    begin object name="DynamicLightTemplateArchetype" class=Class'UDKBase.UDKExplosionLight'
    end object
    DynamicLightTemplate=DynamicLightTemplateArchetype
    // Reference: PointLightComponent'Default__EvilLightActor.PointLightTemplateArchetype'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'PointLightTemplateArchetype'
    begin object name="PointLightTemplateArchetype" class=Class'Engine.PointLightComponent'
    end object
    PointLightTemplate=PointLightTemplateArchetype
    bDestroyLightOnPawnBaseDied=true
}