class TurokDestroyableActor extends TurokDestroyableActorBase
    native
    nativereplication
    placeable
    hidecategories(Navigation);

var() export editinline @NULL mDestroyableComponents[20];
var() bool mbFlammable;
var() array mIgnoredDamageTypes;
var int mNumDestroyableComponents;
var protected repnotify byte mDestroyableStates[20];

replication
{
    // Pos:0x000
    if(bNetDirty || bNetInitial
        mDestroyableStates;
}

// Export UTurokDestroyableActor::execGetPercentDestroyed(FFrame&, void* const)
native function float GetPercentDestroyed();

// Export UTurokDestroyableActor::execRestore(FFrame&, void* const)
native function Restore();

// Export UTurokDestroyableActor::execAddToManager(FFrame&, void* const)
native function AddToManager();

// Export UTurokDestroyableActor::execUpdateManager(FFrame&, void* const)
native function UpdateManager(int Update);

// Export UTurokDestroyableActor::execCanDestroy(FFrame&, void* const)
native function bool CanDestroy();

simulated function @NULL TraceDestroyableComponents(@NULL Loc, @NULL Dir)
{
    local int I;
    local @NULL out_NewHitLocation, out_HitNormal, TraceEnd, TraceStart;

    TraceStart = Loc - (float(128) * Normal(Dir));
    TraceEnd = Loc + (float(128) * Normal(Dir));
    I = 0;
    J0x3B:

    // End:0x97 [Loop If]
    if(I < mNumDestroyableComponents)
    {
        // End:0x8D
        if(TraceComponent(out_NewHitLocation, out_HitNormal, mDestroyableComponents[I], TraceEnd, TraceStart, vect(0.0000000, 0.0000000, 0.0000000)))
        {
            return mDestroyableComponents[I];
        }
        I++;
        // [Loop Continue]
        goto J0x3B;
    }
    //return ReturnValue;    
}

event TakeDamage(int Damage, @NULL pEventInstigator, @NULL HitLocation, @NULL Momentum, class<Class> pDamageType, optional @NULL pHitInfo, optional @NULL DamageCauser)
{
    local int I;
    local editinline @NULL pDamagedComponent;

    // End:0x31
    if(!mbFlammable && (pDamageType == Class'TurokDamageTypeFlameThrower') || pDamageType == Class'TurokDamageTypeNapalmGrenade')
    {
        return;
    }
    // End:0x58
    if((mIgnoredDamageTypes.Length > 0) && mIgnoredDamageTypes.Find(switch(pDamageType)) != -1)
    {
        {
            return;
        }
        super.TakeDamage(Damage, pEventInstigator, HitLocation, Momentum, pDamageType, pHitInfo);
        // End:0x8F
        if(int(mBaseDestroyableState) == int(0))
        {
            return;
        }
        pDamagedComponent = TurokDestroyableComponent(pHitInfo.HitComponent);
        // End:0x133
        if(pDamagedComponent == none)
        {
            I = 0;
            J0xBB:

            // End:0x130 [Loop If]
            if(I < mNumDestroyableComponents)
            {
                pDamagedComponent = mDestroyableComponents[I];
                // End:0x126
                if(pDamagedComponent.TakeDamage(Damage, HitLocation, Momentum, pDamageType))
                {
                    mDestroyableStates[pDamagedComponent.mIndex] = 2;
                    UpdateDestroyableState();
                }
                I++;
                // [Loop Continue]
                goto J0xBB;
            }            
        }
        else
        {
            // End:0x1B3
            if(pHitInfo.HitComponent != mpNonDestroyableComponent)
            {
                // End:0x159
                if(pDamagedComponent == none)
                {
                    return;
                }
                // End:0x1B3
                if(pDamagedComponent != mpBaseDestroyableComponent)
                {
                    // End:0x1B3
                    if(pDamagedComponent.TakeDamage(Damage, HitLocation, Momentum, pDamageType))
                    {
                        mDestroyableStates[pDamagedComponent.mIndex] = 2;
                        UpdateDestroyableState();
                    }
                }
            }
        }
        // End:0x20E
        if((mpBaseDestroyableComponent != none) && mpBaseDestroyableComponent.IsDestroyed())
        {
            I = 0;
            J0x1DD:

            // End:0x204 [Loop If]
            if(I < mNumDestroyableComponents)
            {
                mDestroyableStates[I] = 2;
                I++;
                // [Loop Continue]
                goto J0x1DD;
            }
            UpdateDestroyableState();
        }
        //return;        
}

simulated event ReplicatedEvent(name VarName)
{
    // End:0x1F
    if(VarName == 'mDestroyableStates')
    {
        UpdateDestroyableState();
        return;
    }
    super.ReplicatedEvent(VarName);
    //return;    
}

simulated event UpdateDestroyableState()
{
    local int I;
    local float NumDestroyed;
    local bool bShouldCheck;
    local array Events;
    local int idx;
    local float PercentageToTrigger;

    bShouldCheck = false;
    I = 0;
    J0x0F:

    // End:0x16F [Loop If]
    if(I < mNumDestroyableComponents)
    {
        // End:0xE7
        if((mDestroyableComponents[I].IsDestroyed() == false) && int(mDestroyableStates[I]) == int(2))
        {
            // End:0xB0
            if(mImpulse.DamageType != none)
            {
                mDestroyableComponents[I].PlayDestructionEffects(mImpulse.Location, mImpulse.Momentum, mImpulse.DamageType);
            }
            mDestroyableComponents[I].DestroyComponent();
            bShouldCheck = true;
            mCurNumVisibleComponents--;
            UpdateManager(-1);
        }
        // End:0x109
        if(int(mDestroyableStates[I]) == int(2))
        {
            NumDestroyed += 1.0000000;
        }
        // End:0x165
        if((mDestroyableComponents[I].IsDestroyed() == true) && int(mDestroyableStates[I]) == int(0))
        {
            NumDestroyed -= 1.0000000;
            mDestroyableComponents[I].Init();
        }
        I++;
        // [Loop Continue]
        goto J0x0F;
    }
    // End:0x246
    if(bShouldCheck)
    {
        FindEventsOfClass(Class'TurokSeqEvent_DestroyableActorDestroyed', Events);
        idx = 0;
        J0x18F:

        // End:0x246 [Loop If]
        if(idx < Events.Length)
        {
            PercentageToTrigger = TurokSeqEvent_DestroyableActorDestroyed(Events[idx]).mDamageAmount;
            // End:0x23C
            if((TurokSeqEvent_DestroyableActorDestroyed(Events[idx]).mbOnDamageAmount && (100.0000000 * (NumDestroyed / float(mNumDestroyableComponents))) >= PercentageToTrigger) && (100.0000000 * ((NumDestroyed - float(1)) / float(mNumDestroyableComponents))) < PercentageToTrigger)
            {
                Events[idx].CheckActivate(self, none);
            }
            idx++;
            // [Loop Continue]
            goto J0x18F;
        }
    }
    //return;    
}

simulated function PostBeginPlay()
{
    local int I;

    super(TurokInteractiveActor).PostBeginPlay();
    mNumDestroyableComponents = 0;
    I = 0;
    J0x14:

    // End:0xAD [Loop If]
    if(I < 20)
    {
        // End:0xA0
        if(mDestroyableComponents[I] != none)
        {
            AttachComponent(mDestroyableComponents[I]);
            mDestroyableComponents[I].mIndex = I;
            mDestroyableComponents[I].Init();
            mDestroyableComponents[I].SetShadowParent(mpNonDestroyableComponent);
            mMaxNumVisibleComponents++;
            mNumDestroyableComponents++;
            // [Explicit Continue]
            goto J0xA3;
        }
        // [Explicit Break]
        goto J0xAD;
        J0xA3:

        I++;
        // [Loop Continue]
        goto J0x14;
    }
    J0xAD:

    //return;    
}

simulated function OnDestroyableSwapped()
{
    local int I;

    super.OnDestroyableSwapped();
    I = 0;
    J0x0D:

    // End:0x43 [Loop If]
    if(I < mNumDestroyableComponents)
    {
        mDestroyableComponents[I].SetHidden(false);
        mCurNumVisibleComponents++;
        I++;
        // [Loop Continue]
        goto J0x0D;
    }
    //return;    
}

simulated function OnDestroyableDestroyed()
{
    local array Events;
    local int idx;

    super.OnDestroyableDestroyed();
    FindEventsOfClass(Class'TurokSeqEvent_DestroyableActorDestroyed', Events);
    idx = 0;
    J0x1D:

    // End:0x6E [Loop If]
    if(idx < Events.Length)
    {
        // End:0x64
        if(TurokSeqEvent_DestroyableActorDestroyed(Events[idx]).mbOnDestroyed)
        {
            Events[idx].CheckActivate(self, none);
        }
        idx++;
        // [Loop Continue]
        goto J0x1D;
    }
    //return;    
}

defaultproperties
{
    // Reference: TurokDes[0]troyableComponent'Default__TurokDestroyableActor.pDestroyableComponent0'
    begin object name=pDestroyableComponent0 class=Class'TurokDestroyableComponent'
        LightEnvironment=DynamicLightEnvironmentComponent'Default__TurokDestroyableActor.MyLightEnvironment'
        LightingChannels=(Static=false,Dynamic=true)
    end object
    mDestroyableComponents=pDestroyableComponent0
    // Reference: TurokDestroyableComponent'Default__TurokDestroyableActor.pDestroyableComponent1'
    begin object name=pDestroyableComponent1 class=Class'TurokDestroyableComponent'
        LightEnvironment=DynamicLightEnvironmentComponent'Default__TurokDestroyableActor.MyLightEnvironment'
        LightingChannels=(Static=false,Dynamic=true)
    end object
    mDestroyableComponents=pDestroyableComponent1
    // Reference: TurokDestroyableComponent'Default__TurokDestroyableActor.pDestroyableComponent2'
    begin object name=pDestroyableComponent2 class=Class'TurokDestroyableComponent'
        LightEnvironment=DynamicLightEnvironmentComponent'Default__TurokDestroyableActor.MyLightEnvironment'
        LightingChannels=(Static=false,Dynamic=true)
    end object
    mDestroyableComponents=pDestroyableComponent2
    // Reference: TurokDestroyableComponent'Default__TurokDestroyableActor.pDestroyableComponent3'
    begin object name=pDestroyableComponent3 class=Class'TurokDestroyableComponent'
        LightEnvironment=DynamicLightEnvironmentComponent'Default__TurokDestroyableActor.MyLightEnvironment'
        LightingChannels=(Static=false,Dynamic=true)
    end object
    mDestroyableComponents=pDestroyableComponent3
    // Reference: TurokDestroyableComponent'Default__TurokDestroyableActor.pDestroyableComponent4'
    begin object name=pDestroyableComponent4 class=Class'TurokDestroyableComponent'
        LightEnvironment=DynamicLightEnvironmentComponent'Default__TurokDestroyableActor.MyLightEnvironment'
        LightingChannels=(Static=false,Dynamic=true)
    end object
    mDestroyableComponents=pDestroyableComponent4
    // Reference: TurokDestroyableComponent'Default__TurokDestroyableActor.pDestroyableComponent5'
    begin object name=pDestroyableComponent5 class=Class'TurokDestroyableComponent'
        LightEnvironment=DynamicLightEnvironmentComponent'Default__TurokDestroyableActor.MyLightEnvironment'
        LightingChannels=(Static=false,Dynamic=true)
    end object
    mDestroyableComponents=pDestroyableComponent5
    // Reference: TurokDestroyableComponent'Default__TurokDestroyableActor.pDestroyableComponent6'
    begin object name=pDestroyableComponent6 class=Class'TurokDestroyableComponent'
        LightEnvironment=DynamicLightEnvironmentComponent'Default__TurokDestroyableActor.MyLightEnvironment'
        LightingChannels=(Static=false,Dynamic=true)
    end object
    mDestroyableComponents=pDestroyableComponent6
    // Reference: TurokDestroyableComponent'Default__TurokDestroyableActor.pDestroyableComponent7'
    begin object name=pDestroyableComponent7 class=Class'TurokDestroyableComponent'
        LightEnvironment=DynamicLightEnvironmentComponent'Default__TurokDestroyableActor.MyLightEnvironment'
        LightingChannels=(Static=false,Dynamic=true)
    end object
    mDestroyableComponents=pDestroyableComponent7
    // Reference: TurokDestroyableComponent'Default__TurokDestroyableActor.pDestroyableComponent8'
    begin object name=pDestroyableComponent8 class=Class'TurokDestroyableComponent'
        LightEnvironment=DynamicLightEnvironmentComponent'Default__TurokDestroyableActor.MyLightEnvironment'
        LightingChannels=(Static=false,Dynamic=true)
    end object
    mDestroyableComponents=pDestroyableComponent8
    // Reference: TurokDestroyableComponent'Default__TurokDestroyableActor.pDestroyableComponent9'
    begin object name=pDestroyableComponent9 class=Class'TurokDestroyableComponent'
        LightEnvironment=DynamicLightEnvironmentComponent'Default__TurokDestroyableActor.MyLightEnvironment'
        LightingChannels=(Static=false,Dynamic=true)
    end object
    mDestroyableComponents=pDestroyableComponent9
    // Reference: TurokDestroyableComponent'Default__TurokDestroyableActor.pDestroyableComponent10'
    begin object name=pDestroyableComponent10 class=Class'TurokDestroyableComponent'
        LightEnvironment=DynamicLightEnvironmentComponent'Default__TurokDestroyableActor.MyLightEnvironment'
        LightingChannels=(Static=false,Dynamic=true)
    end object
    mDestroyableComponents=pDestroyableComponent10
    // Reference: TurokDestroyableComponent'Default__TurokDestroyableActor.pDestroyableComponent11'
    begin object name=pDestroyableComponent11 class=Class'TurokDestroyableComponent'
        LightEnvironment=DynamicLightEnvironmentComponent'Default__TurokDestroyableActor.MyLightEnvironment'
        LightingChannels=(Static=false,Dynamic=true)
    end object
    mDestroyableComponents=pDestroyableComponent11
    // Reference: TurokDestroyableComponent'Default__TurokDestroyableActor.pDestroyableComponent12'
    begin object name=pDestroyableComponent12 class=Class'TurokDestroyableComponent'
        LightEnvironment=DynamicLightEnvironmentComponent'Default__TurokDestroyableActor.MyLightEnvironment'
        LightingChannels=(Static=false,Dynamic=true)
    end object
    mDestroyableComponents=pDestroyableComponent12
    // Reference: TurokDestroyableComponent'Default__TurokDestroyableActor.pDestroyableComponent13'
    begin object name=pDestroyableComponent13 class=Class'TurokDestroyableComponent'
        LightEnvironment=DynamicLightEnvironmentComponent'Default__TurokDestroyableActor.MyLightEnvironment'
        LightingChannels=(Static=false,Dynamic=true)
    end object
    mDestroyableComponents=pDestroyableComponent13
    // Reference: TurokDestroyableComponent'Default__TurokDestroyableActor.pDestroyableComponent14'
    begin object name=pDestroyableComponent14 class=Class'TurokDestroyableComponent'
        LightEnvironment=DynamicLightEnvironmentComponent'Default__TurokDestroyableActor.MyLightEnvironment'
        LightingChannels=(Static=false,Dynamic=true)
    end object
    mDestroyableComponents=pDestroyableComponent14
    // Reference: TurokDestroyableComponent'Default__TurokDestroyableActor.pDestroyableComponent15'
    begin object name=pDestroyableComponent15 class=Class'TurokDestroyableComponent'
        LightEnvironment=DynamicLightEnvironmentComponent'Default__TurokDestroyableActor.MyLightEnvironment'
        LightingChannels=(Static=false,Dynamic=true)
    end object
    mDestroyableComponents=pDestroyableComponent15
    // Reference: TurokDestroyableComponent'Default__TurokDestroyableActor.pDestroyableComponent16'
    begin object name=pDestroyableComponent16 class=Class'TurokDestroyableComponent'
        LightEnvironment=DynamicLightEnvironmentComponent'Default__TurokDestroyableActor.MyLightEnvironment'
        LightingChannels=(Static=false,Dynamic=true)
    end object
    mDestroyableComponents=pDestroyableComponent16
    // Reference: TurokDestroyableComponent'Default__TurokDestroyableActor.pDestroyableComponent17'
    begin object name=pDestroyableComponent17 class=Class'TurokDestroyableComponent'
        LightEnvironment=DynamicLightEnvironmentComponent'Default__TurokDestroyableActor.MyLightEnvironment'
        LightingChannels=(Static=false,Dynamic=true)
    end object
    mDestroyableComponents=pDestroyableComponent17
    // Reference: TurokDestroyableComponent'Default__TurokDestroyableActor.pDestroyableComponent18'
    begin object name=pDestroyableComponent18 class=Class'TurokDestroyableComponent'
        LightEnvironment=DynamicLightEnvironmentComponent'Default__TurokDestroyableActor.MyLightEnvironment'
        LightingChannels=(Static=false,Dynamic=true)
    end object
    mDestroyableComponents=pDestroyableComponent18
    // Reference: TurokDestroyableComponent'Default__TurokDestroyableActor.pDestroyableComponent19'
    begin object name=pDestroyableComponent19 class=Class'TurokDestroyableComponent'
        LightEnvironment=DynamicLightEnvironmentComponent'Default__TurokDestroyableActor.MyLightEnvironment'
        LightingChannels=(Static=false,Dynamic=true)
    end object
    mDestroyableComponents=pDestroyableComponent19
    mbFlammable=true
    // Reference: TurokDestroyableComponent'Default__TurokDestroyableActor.pBaseDestroyableComponent0'
    begin object name=pBaseDestroyableComponent0
        LightEnvironment=DynamicLightEnvironmentComponent'Default__TurokDestroyableActor.MyLightEnvironment'
    end object
    mpBaseDestroyableComponent=pBaseDestroyableComponent0
    // Reference: TurokUVAnimComponent'Default__TurokDestroyableActor.pNonDestroyableComponent0'
    begin object name=pNonDestroyableComponent0
        LightEnvironment=DynamicLightEnvironmentComponent'Default__TurokDestroyableActor.MyLightEnvironment'
    end object
    mpNonDestroyableComponent=pNonDestroyableComponent0
    // Reference: TurokSoundController'Default__TurokDestroyableActor.TurokSoundControllerComponent'
    begin object name=TurokSoundControllerComponent
    end object
    mSoundController=TurokSoundControllerComponent
    // Reference: TurokUVAnimComponent'Default__TurokDestroyableActor.pIntactComponent0'
    begin object name=pIntactComponent0
        LightEnvironment=DynamicLightEnvironmentComponent'Default__TurokDestroyableActor.MyLightEnvironment'
    end object
    mpIntactComponent=pIntactComponent0
    // Reference: DynamicLightEnvironmentComponent'Default__TurokDestroyableActor.MyLightEnvironment'
    begin object name=MyLightEnvironment
    end object
    LightEnvironment=MyLightEnvironment
    bWorldGeometry=false
    Components[0]=MyLightEnvironment
    Components[1]=pIntactComponent0
    SupportedEvents=/* Array type was not detected. */
}