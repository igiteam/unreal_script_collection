class ActionRandomNumber extends Action;

var() float minimum;
var() float maximum;

// execute
latent function Variable execute()
{
	local int forceWholeNumber;

	Super.execute();

	forceWholeNumber = (FRand() * (maximum - minimum) + minimum) + 0.5;

	return newTemporaryVariable(class'VariableFloat', string(forceWholeNumber));
}

// editorDisplayString
function editorDisplayString(out string s)
{
	s = "A random number between " $ propertyDisplayString('minimum') $ " and " $ propertyDisplayString('maximum');
}











// Decompiled with UE Explorer.
defaultproperties
{
    maximum=1.0000000
    actionDisplayName="Random Number"
    actionHelp="Generates a random number within a given range"
    returnType=Class'Variable'
    category="Variable"
}