require 'rubygems'
require 'net/http'
require 'json'
require 'open-uri'

sleep 2

# Set timer to end call
begin
  log "@"*5 + "User has answered"
  log "@"*5 + "Session: " + $currentCall.sessionId

  #Create second thread for second for timer and announcements
  Thread.new do
    log "@"*5 + "Start second tread"
    sleep 60
    http = Net::HTTP.new("api.tropo.com")
    request = Net::HTTP::Get.new("/1.0/sessions/#{$currentCall.sessionId}/signals?action=signal&value=limitreached")
    response = http.request(request)
  end #thread

  if $currentCall.getHeader("x-sbc-numbertodial")

    # Blocked North American area codes
    blocked = []
    blocked.push(/^\+?1?8[024]9/)
    blocked.push(/^\+?1?26[48]/)
    blocked.push(/^\+?1?24[26]/)
    blocked.push(/^\+?1?34[05]/)
    blocked.push(/^\+?1?[62]84/)
    blocked.push(/^\+?1?67[10]/)
    blocked.push(/^\+?1?78[47]/)
    blocked.push(/^\+?1?8[024]9/)
    blocked.push(/^\+?1?86[89]/)
    blocked.push(/^\+?1?441/)
    blocked.push(/^\+?1?473/)
    blocked.push(/^\+?1?664/)
    blocked.push(/^\+?1?649/)
    blocked.push(/^\+?1?721/)
    blocked.push(/^\+?1?758/)
    blocked.push(/^\+?1?767/)
    blocked.push(/^\+?1?876/)
    blocked.push(/^\+?1?939/)


    phone = $currentCall.getHeader("x-sbc-numbertodial").gsub("-","").gsub(".","").gsub(" ", "")
    log "@"*5 +phone

    allowcall = true
    blocked.each { |x| 
      if phone =~ x 
        allowcall = false
        log "@"*5 + "Blocked Call"
      end
    }


    if allowcall

      transfer phone, { :allowsignals => "limitreached", :answerOnMedia => true, :playvalue => "http://hosting.tropo.com/13539/www/audio/ring.wav", :callerID => '4151234567'}

      say "your limit has been reached."
    else
      say "calls to this area code are blocked."
    end

  else

    apiurl = 'http://api.twelephone.com/sipaddress/chrismatthieu'

    url = URI.encode(apiurl)

    #JSON data to a Ruby hash
    apidata = JSON.parse(open(url).read)
                  
    #Get the relevant data
    sip = apidata["sipaddress"]

    log '@@@' + sip + '@@@'

    transfer 'sip:' + sip, { :allowsignals => "limitreached", :answerOnMedia => true, :playvalue => "http://hosting.tropo.com/13539/www/audio/ring.wav", :callerID => '4151234567'}
    say "your limit has been reached."

  end
  
end

sleep 2

