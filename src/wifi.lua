--
-- User: david.bigagli@gmail.com
-- Date: 03/04/18
-- Time: 23.05
--
-- Manage Wifi
--
dofile('config_wifi.lua')

-- Configure wifi
wifi.setmode(wifi.STATION)
print('set mode=STATION (mode='..wifi.getmode()..')\n')
print('MAC Address: ',wifi.sta.getmac())
print('Chip ID: ',node.chipid())
print('Heap Size: ',node.heap(),'\n')

-- Configure WiFi
wifi.sta.config(config_wifi)

-- Configure IP
if config_ip ~= nil and config_ip.ip ~= nil and config_ip.netmask ~= nil and config_ip.gateway ~= nil then
    wifi.sta.setip(config_ip)
end

----------------------------------
-- WiFi Connection Verification --
----------------------------------
tmr.alarm(0, 1000, 1, function()
    if wifi.sta.getip() == nil or wifi.sta.status() ~= wifi.STA_GOTIP then
        print("Connecting to AP...\n")
    else
        ip, nm, gw=wifi.sta.getip()
        print("IP Info: \nIP Address: ",ip)
        print("Netmask: ",nm)
        print("Gateway Addr: ",gw,'\n')
        tmr.stop(0)
    end
end)

