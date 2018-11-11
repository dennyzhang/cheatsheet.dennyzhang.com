// https://asoftwareguy.com/2014/04/17/get-the-ip-address-for-a-host-name-in-groovy/
def hostname = 'google.com'
println InetAddress.getByName(hostname).address.collect { it & 0xFF }.join('.')
