if (currentCall.getHeader("x-chatroom")){
var chatroom = currentCall.getHeader("x-chatroom");
} else {
var chatroom = 'test';
}


record("Please re cord a 60 second message after the beep.", { 
    beep:true, 
    maxTime:60, 
    timeout:3, 
    silenceTimeout:2,    
    terminator:'#', 
    recordFormat:"audio/wav", 
    recordURI:"http://twelephone.com/upload/" + chatroom,
    onRecord: function(event) {
        say(event.recordURI);
    }
 
});