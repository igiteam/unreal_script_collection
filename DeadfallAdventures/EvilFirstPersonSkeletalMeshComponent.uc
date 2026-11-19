class EvilFirstPersonSkeletalMeshComponent extends UDKSkeletalMeshComponent
    config(Engine)
    editinlinenew
    hidecategories(Object);

event bool PlayParticleEffect(const AnimNotify_PlayParticleEffect AnimNotifyData)
{
    local Vector Loc;
    local Rotator Rot;
    local WorldInfo WI;
    local editinline UDKParticleSystemComponent PSC;
    local bool bPlayNonExtreme;

    WI = Class'Engine.WorldInfo'.static.GetWorldInfo();
    // End:0x54
    if(int(WI.NetMode) == int(NM_DedicatedServer))
    {
        return true;
    }
    // End:0x7A
    if(AnimNotifyData.PSTemplate == none)
    {
        return false;
    }
    bPlayNonExtreme = (AnimNotifyData.bIsExtremeContent && Class'Engine.Engine'.static.IsGame()) && !WI.GRI.ShouldShowGore();
    // End:0x138
    if(bPlayNonExtreme && AnimNotifyData.PSNonExtremeContentTemplate == none)
    {
        return false;
    }
    // End:0x3BA
    if(AnimNotifyData.bAttach)
    {
        PSC = new (self) Class'UDKBase.UDKParticleSystemComponent';
        // End:0x1BF
        if(bPlayNonExtreme)
        {
            PSC.SetTemplate(AnimNotifyData.PSNonExtremeContentTemplate);            
        }
        else
        {
            PSC.SetTemplate(AnimNotifyData.PSTemplate);
        }
        // End:0x25C
        if(AnimNotifyData.SocketName != 'None')
        {
            AttachComponentToSocket(PSC, AnimNotifyData.SocketName);            
        }
        else
        {
            // End:0x2BC
            if(AnimNotifyData.BoneName != 'None')
            {
                AttachComponent(PSC, AnimNotifyData.BoneName);
            }
        }
        PSC.SetDepthPriorityGroup(DepthPriorityGroup);
        PSC.SetFOV(FOV);
        PSC.SetVectorParameter('StartVelocity', Owner.Owner.Velocity);
        PSC.ActivateSystem(true);
        PSC.__OnSystemFinished__Delegate = SkelMeshCompOnParticleSystemFinished;        
    }
    else
    {
        // End:0x424
        if(AnimNotifyData.SocketName != 'None')
        {
            GetSocketWorldLocationAndRotation(AnimNotifyData.SocketName, Loc, Rot);            
        }
        else
        {
            // End:0x49D
            if(AnimNotifyData.BoneName != 'None')
            {
                Loc = GetBoneLocation(AnimNotifyData.BoneName);
                Rot = rot(0, 0, 1);                
            }
            else
            {
                Loc = GetPosition();
                Rot = rot(0, 0, 1);
            }
        }
        // End:0x645
        if(((Owner != none) && Owner.WorldInfo != none) && Owner.WorldInfo.MyEmitterPool != none)
        {
            // End:0x5C5
            if(bPlayNonExtreme)
            {
                Owner.WorldInfo.MyEmitterPool.SpawnEmitter(AnimNotifyData.PSNonExtremeContentTemplate, Loc, Rot);                
            }
            else
            {
                Owner.WorldInfo.MyEmitterPool.SpawnEmitter(AnimNotifyData.PSTemplate, Loc, Rot);
            }            
        }
        else
        {
            // End:0x7D1
            if(Class'Engine.Engine'.static.IsGame())
            {
                PSC = new (self) Class'UDKBase.UDKParticleSystemComponent';
                PSC.SetTemplate(AnimNotifyData.PSTemplate);
                PSC.SetAbsolute(true, true, true);
                PSC.SetTranslation(Loc);
                PSC.SetRotation(Rot);
                PSC.SetDepthPriorityGroup(DepthPriorityGroup);
                PSC.SetFOV(FOV);
                PSC.ActivateSystem(true);
                PSC.__OnSystemFinished__Delegate = SkelMeshCompOnParticleSystemFinished;                
            }
            else
            {
                // End:0xA1D
                if(Class'Engine.Engine'.static.IsEditor())
                {
                    PSC = new (self) Class'UDKBase.UDKParticleSystemComponent';
                    PSC.SetTemplate(AnimNotifyData.PSTemplate);
                    PSC.SetAbsolute(true, true, true);
                    PSC.SetTranslation(Loc);
                    PSC.SetRotation(Rot);
                    // End:0x91A
                    if(AnimNotifyData.SocketName != 'None')
                    {
                        AttachComponentToSocket(PSC, AnimNotifyData.SocketName);                        
                    }
                    else
                    {
                        // End:0x97A
                        if(AnimNotifyData.BoneName != 'None')
                        {
                            AttachComponent(PSC, AnimNotifyData.BoneName);
                        }
                    }
                    PSC.SetDepthPriorityGroup(DepthPriorityGroup);
                    PSC.SetFOV(FOV);
                    PSC.ActivateSystem(true);
                    PSC.__OnSystemFinished__Delegate = SkelMeshCompOnParticleSystemFinished;                    
                }
                else
                {
                    return false;
                }
            }
        }
    }
    // End:0xAB3
    if(((PSC != none) && AnimNotifyData.BoneSocketModuleActorName != 'None') && Owner != none)
    {
        PSC.SetActorParameter(AnimNotifyData.BoneSocketModuleActorName, Owner);
    }
    return true;
    //return ReturnValue;    
}

defaultproperties
{
    ReplacementPrimitive=none
}