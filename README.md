Karaoke
=======
This program attempts to create karaoke of a song. 
It attempts to remove voice and then writes it to a new wav file.
This program utilizes the well known fact that voice is recorded equally in both channels
without any stereo effect.
First one of the channel is high pass filterd. This is done to protect the low end bass which 
is also recorded equally on both channels. 
Then this channel is subtracted from the other. The commoon part that is voice gets cancelled.
This method is called the OUT of PHASE STEREO (OOPS) technique.
But The use of high pass filters is a new addition to ampify the bass and drums value first before minimizing vocals.
