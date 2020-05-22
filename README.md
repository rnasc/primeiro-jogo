# README

This is a Rails implementation of Filipe Dechamps 'first multiplayer game' as 
proposed in his youtube channed, in a specific playlist:
https://www.youtube.com/watch?v=0sTfIZvjYJk&list=PLMdYygf53DP5SVQQrkKCVWDS0TwYLVitL

The original source code available in his Github page and is based on Javascript+NodeJs:
https://github.com/filipedeschamps/meu-primeiro-jogo-multiplayer

# Approach
This implementation approach is to make use of Rails Action Cable functionality
to implement a keyboard call for each key pressed in the page (can be improved
to call the server only on selected keys, but adds business logic to the presentation 
layer - to be checked).

# Small differences
pros:
* I have implemented a faster table update, by only redrawing the tbody tag and not the
entire table (should be 0,0001s faster, but any victory is a win, right?)
* I added a framerate marker on the topscreen. It measures Frames Per Second in the client
(I used to understand why my implementation is slower)

cons:
* it's slower. Maybe due to the additional layers by Action Cable (please someone point improvement
points here)
* I still can't color the current player. The Channel Id is given by me during the session
subscription. That's because rails will control only the session, which is the same among multiple
windows (makes sense, but doesn't apply to the current requirements). To be able to have a new 
game for every new browser tab, I'd need an identifyier: channel_id. But I never send it 
back to the client (it's server only), therefore I cannot know who's the current player. What I 
currently think of doing is to handle this in the server side, pointing which player should b
yellow (keep in the client just the keyboard listenning and the rendering logics). But haven't done yet.
