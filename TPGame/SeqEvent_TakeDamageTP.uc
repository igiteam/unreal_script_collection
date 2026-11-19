class SeqEvent_TakeDamageTP extends SeqEvent_TakeDamage;

/** Total amount of damage to take before activating the event */
var() float DamagePercentageThreshold;

var float CurrentPercentage;

function bool IsValidDamageType(class<DamageType> inDamageType)
{
	local bool bValid;
    local int  i;

	bValid = true;
	if (DamageTypes.Length > 0)
	{
		for (i = 0; i < DamageTypes.Length; i++)
        {
            if (ClassIsChildOf(inDamageType, DamageTypes[i]) || DamageTypes[i] == inDamageType)
            {
                bValid = true;
                break;
            }
        }
	}
	if (bValid &&
		IgnoreDamageTypes.Length > 0)
	{
		// make sure it's not an ignored type
		bValid = (IgnoreDamageTypes.Find(inDamageType) == -1);
	}

	return bValid;
}

/**
 * Mirrored from parent, except uses percentages and IGNORES the DamageThreshold/MinDamageAmount
 * variables.
 */
function HandleDamage(Actor inOriginator, Actor inInstigator, class<DamageType> inDamageType, int inAmount)
{
	local SeqVar_Float FloatVar;
	local bool bAlreadyActivatedThisTick;
    local TPPawn tpPawn;

    tpPawn = TPPawn(inOriginator);

	if (inOriginator != None &&
        tpPawn != None &&
		bEnabled &&
		IsValidDamageType(inDamageType) &&
		(!bPlayerOnly ||
		 (inInstigator!= None && inInstigator.IsPlayerOwned())))
	{
        CurrentPercentage += inAmount/tpPawn.MaxPlayerHealth;

		if (CurrentPercentage >= DamagePercentageThreshold)
		{
			bAlreadyActivatedThisTick = (bActive && ActivationTime ~= GetWorldInfo().TimeSeconds);
			if (CheckActivate(inOriginator,inInstigator,false))
			{
				// write to any variables that want to know the exact damage taken
				foreach LinkedVariables(class'SeqVar_Float', FloatVar, "Damage Percent Taken")
				{
					//@hack carry over damage from multiple hits in the same tick
					//since Kismet doesn't currently support multiple activations in the same tick
					if (bAlreadyActivatedThisTick)
					{
						FloatVar.FloatValue += CurrentPercentage;
					}
					else
					{
						FloatVar.FloatValue = CurrentPercentage;
					}
				}
				// reset the damage counter on activation
				if (DamagePercentageThreshold <= 0.f)
				{
					CurrentPercentage = 0.f;
				}
				else
				{
					CurrentPercentage -= DamagePercentageThreshold;
				}
			}
		}
	}
}

function Reset()
{
	Super.Reset();

	CurrentPercentage= 0.f;
}

