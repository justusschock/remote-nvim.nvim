local uv = vim.fn.has("nvim-0.10") and vim.uv or vim.loop

-- Check if a specific port is available
local function is_port_available(port)
  local socket = uv.new_tcp()
  local success = socket:bind("127.0.0.1", port)
  socket:close()
  return success == 0
end

-- Get default port from command line argument if provided
local default_port = tonumber(arg and arg[1])

-- Try default port first if provided
if default_port and is_port_available(default_port) then
  print(default_port)
else
  -- Fall back to ephemeral port
  local socket = uv.new_tcp()
  socket:bind("127.0.0.1", 0)
  local result = socket.getsockname(socket)
  socket:close()

  if result then
    print(result["port"])
  end
end
