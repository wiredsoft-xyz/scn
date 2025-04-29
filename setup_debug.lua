for _, v in ipairs(arg) do
    if v == "--debug" then
        DEBUG = true

        if pcall(require, "lldebugger") then
            require("lldebugger").start()
            print("Debug mode enabled")
        else
            print("lldebugger not found. make sure to launch with <F5>.")
            os.exit(1)
        end
        break
    end
end