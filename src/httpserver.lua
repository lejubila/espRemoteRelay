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

            for relay_name, _ in pairsKeySorted(config_relay) do
                if relay.relay_closed[relay_name] then
                    html_relay = html_relay .. "<li><a href='/close?relay=" .. relay_name .. "'>Close '" .. relay_name .. "'</a></li>"
                else
                    html_relay = html_relay .. "<li><a href='/open?relay=" .. relay_name .. "'>Open '" .. relay_name .. "'</a></li>"
                end
            end

            data = {
                head_title = 'espRemoteRelay',
                title = 'espRemoteRelay',
                body = '<ul>' .. html_relay .. '</ul>'
            }

            res:send( httpserver.tpl_render('base.tpl', data) )
        end)

        httpServer:use('/open', function(req, res)
            if req.query.relay and relay.close(req.query.relay) then
                res:redirect('/')
            else
                data = {
                    head_title = 'espRemoteRelay',
                    title = 'espRemoteRelay',
                    body = '<p>Open Error</p><p><a href="/">Return to home</a></p>'
                }
                res:send( httpserver.tpl_render('base.tpl', data) )
            end
        end)

        httpServer:use('/close', function(req, res)
            if req.query.relay and relay.open(req.query.relay) then
                res:redirect('/')
            else
                data = {
                    head_title = 'espRemoteRelay',
                    title = 'espRemoteRelay',
                    body = '<p>Close Error</p><p><a href="/">Return to home</a></p>'
                }
                res:send( httpserver.tpl_render('base.tpl', data) )
            end
        end)

    end,

    tpl_render = function(tpl_file, data)
        tpl = '';
        if file.open(tpl_file) then
            tpl = file.read()
            file.close()
        end

        for k, v in pairs(data) do
            tpl = tpl:gsub('%%'..k..'%%', v)
        end

        return tpl
    end

}