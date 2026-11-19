class shared_DoNoteTracksPostCallback extends CoreTask within animscripts_shared;

// parameter
var name iFlagName;
var DelegateNoteTracksPostCallback iPostFunction;

// output

// local
var name lNote;
var bool lVal;

function OnNotify(name inNote, CoreNotify inData)
{
	local CoreAnimNotify data;

	assert (iFlagName == inNote);

	data = CoreAnimNotify(inData);
	if (data != none)
		lNote = data.data;
	else
		lNote = '';
}

state main
{
Begin:
	assert(iPostFunction != none);
	
	while (true)
	{
		waittill (iFlagName);

		if (!isDefined(lNote))
			lNote = 'undefined';

		lVal = HandleNoteTrack(lNote, iFlagName);
		
		iPostFunction.execute(lNote);
		
		if (lVal)
			_return();
	}
}
