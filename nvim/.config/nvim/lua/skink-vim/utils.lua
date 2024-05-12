local uv = vim.loop
local M = {}


function M.merge_tables(...)
    local tables = { ... }
    local merged = {}

    for _, t in ipairs(tables) do
        for k, v in pairs(t) do
            merged[k] = v
        end
    end

    return merged
end

function M.watch_file(filepath, on_change)
    local watcher = uv.new_fs_event()
    watcher:start(filepath, {}, on_change)
    return watcher -- Return the watcher in case you need to stop it later
end

function M.watch_directory(directory, target_file, on_change)
    local watcher = uv.new_fs_event()
    watcher:start(directory, { watch_entry = true }, function(err, filename, events)
        if err then
        else
            if filename == target_file then
                on_change(err, filename, events)
            end
        end
    end)
    return watcher
end

function M.async_system(cmd)
    local handle
    local stdout = vim.loop.new_pipe(false)
    local stderr = vim.loop.new_pipe(false)

    handle, _ = vim.loop.spawn('sh', {
        args = { '-c', cmd },
        stdio = { nil, stdout, stderr }
    }, vim.schedule_wrap(function()
        stdout:read_stop()
        stderr:read_stop()
        stdout:close()
        stderr:close()
        handle:close()
    end))

    stdout:read_start(vim.schedule_wrap(function(err, data)
        if err then
            print('Error reading stdout:', err)
        elseif data then
            print('Output:', data)
        end
    end))

    stderr:read_start(vim.schedule_wrap(function(err, data)
        if err then
            print('Error reading stderr:', err)
        elseif data then
            print('Error:', data)
        end
    end))
end

function M.with_desc(table, desc)
    return M.merge_tables(table, { desc = desc })
end

return M
