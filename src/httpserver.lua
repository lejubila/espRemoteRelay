--
-- User: david.bigagli@gmail.com
-- Date: 08/04/18
-- Time: 23.01
--

dofile('config_httpserver.lua')
dofile('httpServerSupport.lua')

httpserver = {

    init = function()

        httpServer:listen(config_httpserver.port)

        httpServer:use('/', function(req, res)
            local html_relay = ''

            for relay_name, _ in pairs(config_relay) do
                if relay.relay_closed[relay_name] then
                    html_relay = html_relay .. "<li><a href='/close?relay=" .. relay_name .. "'>Close '" .. relay_name .. "'</a></li>"
                else
                    html_relay = html_relay .. "<li><a href='/open?relay=" .. relay_name .. "'>Open '" .. relay_name .. "'</a></li>"
                end
            end

            res:send([[
            <html>
                <head>
                    <title>espRemoteRelay</title>
                </head>
                <body>
                    <h1>espRemoteRelay</h1>
                    <div>
                        <ul>
                            ]]  .. html_relay .. [[
                        </ul>
                    </div>
                </body>
            </html>
            ]]) -- /welcome?name=doge
        end)

        httpServer:use('/open', function(req, res)
            if req.query.relay and relay.close(req.query.relay) then
                res:redirect('/')
            else
                res:send([[
                <html>
                    <head>
                        <title>espRemoteRelay</title>
                    </head>
                    <body>
                        <h1>espRemoteRelay</h1>
                        <div>
                            Open Error
                        </div>
                    </body>
                </html>
                ]])
            end
        end)

        httpServer:use('/close', function(req, res)
            if req.query.relay and relay.open(req.query.relay) then
                res:redirect('/')
            else
                res:send([[
                <html>
                    <head>
                        <title>espRemoteRelay</title>
                    </head>
                    <body>
                        <h1>espRemoteRelay</h1>
                        <div>
                            Close Error
                        </div>
                    </body>
                </html>
                ]])
            end
        end)

    end

}