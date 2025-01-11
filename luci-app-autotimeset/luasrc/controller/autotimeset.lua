module("luci.controller.autotimeset",package.seeall)
local fs=require"nixio.fs"
local http=require"luci.http"
function index()
	if not nixio.fs.access("/etc/config/autotimeset") then
		return
	end
        entry({"admin", "services"}, firstchild(), "services", 44).dependent = false
        local e = entry({"admin", "services", "autotimeset"}, alias("admin", "services", "autotimeset", "scheduledtask"), _("Scheduled Setting"), 20)
	e.dependent = false
	e.acl_depends = { "luci-app-autotimeset" }
        entry({"admin", "services", "autotimeset", "scheduledtask"}, cbi("autotimeset/scheduledtask"),  _("Scheduled task"), 10).leaf = true
        entry({"admin", "services", "autotimeset", "startuptask"}, cbi("autotimeset/startuptask"),  _("Startup task"), 20).leaf = true
        entry({"admin", "services", "autotimeset", "log"}, form("autotimeset/log"), _("Log"), 30).leaf = true
        entry({"admin","services","autotimeset","dellog"},call("dellog"))
        entry({"admin","services","autotimeset","getlog"},call("getlog"))
end

function getlog()
	logfile="/etc/autotimeset/autotimeset.log"
	if not fs.access(logfile) then
		http.write("")
		return
	end
	local f=io.open(logfile,"r")
	local a=f:read("*a") or ""
	f:close()
	a=string.gsub(a,"\n$","")
	http.prepare_content("text/plain; charset=utf-8")
	http.write(a)
end

function dellog()
	fs.writefile("/etc/autotimeset/autotimeset.log","")
	http.prepare_content("application/json")
	http.write('')
end
