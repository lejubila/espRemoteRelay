--
-- User: david.bigagli@gmail.com
-- Date: 01/04/18
-- Time: 19.27
-- To change this template use File | Settings | File Templates.
--

dofile('common.lua')
dofile('relay.lua')
dofile('wifi.lua')
dofile('socketserver.lua')
dofile('httpserver.lua')

relay.init_all()
socketserver.init()
httpserver.init()



