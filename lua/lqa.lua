--[[
- @file lqa.lua
- @brief  
- @author tenfyzhong
- @email tenfy@tenfy.cn
- @created 2023-02-05 22:40:28
--]]

local M = {}

local function getLoclistWinNr()
    local r = vim.fn.getloclist(0, { winid = 1 })
    if r.winid == 0 then
        return -1
    end
    return vim.fn.win_id2win(r.winid)
end

local function getQuickfixWinNr()
    local r = vim.fn.getqflist({ winid = 1 })
    if r.winid == 0 then
        return -1
    end
    return vim.fn.win_id2win(r.winid)
end

function M.Open()
    local loc = vim.fn.getloclist(0)
    if #loc > 0 then
        vim.cmd('silent botright lopen')
    else
        vim.cmd('silent botright copen')
    end
end

function M.Do(cmd)
    local prefix = ''

    if getLoclistWinNr() ~= -1 then
        prefix = 'l'
    elseif getQuickfixWinNr() ~= -1 then
        prefix = 'c'
    else
        print('No quickfix or loclist window open')
        return
    end

    local vicmd = string.format('silent %s%s', prefix, cmd)
    local ok, result = pcall(vim.cmd, vicmd)
    if not ok then
        print(result)
    end
end

function M.setup(opt)
    opt = opt or {}
    local keymap = opt.keymap or {}

    if keymap.previous and type(keymap.previous) == 'string' then
        vim.keymap.set('n', keymap.previous, function() require('lqa').Do('previous') end,
            { silent = true, desc = 'lqa: goto previous item in loclist/quickfix' })
    end

    if keymap.next and type(keymap.next) == 'string' then
        vim.keymap.set('n', keymap.next, function() require('lqa').Do('next') end,
            { silent = true, desc = 'lqa: goto next item in loclist/quickfix' })
    end

    if keymap.close and type(keymap.close) == 'string' then
        vim.keymap.set('n', keymap.close, function() require('lqa').Do('close') end,
            { silent = true, desc = 'lqa: close loclist/quickfix window' })
    end

    if keymap.open and type(keymap.open) == 'string' then
        vim.keymap.set('n', keymap.open, function() require('lqa').Open() end,
            { silent = true, desc = 'lqa: open loclist/quickfix window' })
    end

    if keymap.quickfix_open and type(keymap.quickfix_open) == 'string' then
        vim.keymap.set('n', keymap.quickfix_open, function() vim.cmd('silent botright copen') end,
            { silent = true, desc = 'lqa: open quickfix window' })
    end

    if keymap.loclist_open and type(keymap.loclist_open) == 'string' then
        vim.keymap.set('n', keymap.loclist_open, function() vim.cmd('silent botright lopen') end,
            { silent = true, desc = 'lqa: open quickfix window' })
    end
end

return M
