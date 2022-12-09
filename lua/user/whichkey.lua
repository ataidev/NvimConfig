local status_ok, which_key = pcall(require, "which-key")
if not status_ok then
    return
end

local setup = {
    plugins = {
        marks = true, -- shows a list of your marks on ' and `
        registers = true, -- shows your registers on " in NORMAL or <C-r> in INSERT mode
        spelling = {
            enabled = true, -- enabling this will show WhichKey when pressing z= to select spelling suggestions
            suggestions = 20, -- how many suggestions should be shown in the list?
        },
        -- the presets plugin, adds help for a bunch of default keybindings in Neovim
        -- No actual key bindings are created
        presets = {
            operators = false, -- adds help for operators like d, y, ... and registers them for motion / text object completion
            motions = true, -- adds help for motions
            text_objects = true, -- help for text objects triggered after entering an operator
            windows = true, -- default bindings on <c-w>
            nav = true, -- misc bindings to work with windows
            z = true, -- bindings for folds, spelling and others prefixed with z
            g = true, -- bindings for prefixed with g
        },
    },
    -- add operators that will trigger motion and text object completion
    -- to enable all native operators, set the preset / operators plugin above
    -- operators = { gc = "Comments" },
    key_labels = {
        -- override the label used to display some keys. It doesn't effect WK in any other way.
        -- For example:
        -- ["<space>"] = "SPC",
        -- ["<cr>"] = "RET",
        -- ["<tab>"] = "TAB",
    },
    icons = {
        breadcrumb = "»", -- symbol used in the command line area that shows your active key combo
        separator = "➜", -- symbol used between a key and it's label
        group = "+", -- symbol prepended to a group
    },
    popup_mappings = {
        scroll_down = "<c-d>", -- binding to scroll down inside the popup
        scroll_up = "<c-u>", -- binding to scroll up inside the popup
    },
    window = {
        border = "rounded", -- none, single, double, shadow
        position = "bottom", -- bottom, top
        margin = { 1, 0, 1, 0 }, -- extra window margin [top, right, bottom, left]
        padding = { 2, 2, 2, 2 }, -- extra window padding [top, right, bottom, left]
        winblend = 0,
    },
    layout = {
        height = { min = 4, max = 25 }, -- min and max height of the columns
        width = { min = 20, max = 50 }, -- min and max width of the columns
        spacing = 3, -- spacing between columns
        align = "left", -- align columns left, center or right
    },
    ignore_missing = true, -- enable this to hide mappings for which you didn't specify a label
    hidden = { "<silent>", "<cmd>", "<Cmd>", "<CR>", "call", "lua", "^:", "^ " }, -- hide mapping boilerplate
    show_help = true, -- show help message on the command line when the popup is visible
    triggers = "auto", -- automatically setup triggers
    -- triggers = {"<leader>"} -- or specify a list manually
    triggers_blacklist = {
        -- list of mode / prefixes that should never be hooked by WhichKey
        -- this is mostly relevant for key maps that start with a native binding
        -- most people should not need to change this
        i = { "j", "k" },
        v = { "j", "k" },
    },
}

local opts = {
    mode = "n", -- NORMAL mode
    prefix = "<leader>",
    buffer = nil, -- Global mappings. Specify a buffer number for buffer local mappings
    silent = true, -- use `silent` when creating keymaps
    noremap = true, -- use `noremap` when creating keymaps
    nowait = true, -- use `nowait` when creating keymaps
}

local mappings = {
    w = {'<cmd>write<CR>', 'save file'},
    v = {'<cmd>vertical split<CR>', 'split window vertically'},
    s = {'<cmd>split<CR>', 'split window'},
    h = {'<cmd>noh<CR>', 'clear highlights'},
    e = {'<cmd>NvimTreeToggle<CR>', 'open nvimtree'},
    r = {'<cmd>checktime<CR>', 'refresh open file'},
    f = {
        "<cmd>lua require('telescope.builtin').find_files(require('telescope.themes').get_dropdown{previewer = false})<cr>",
        "Find files",
    },
    F = { "<cmd>Telescope live_grep theme=ivy<cr>", "Find Text" },
    P = { "<cmd>lua require('telescope').extensions.projects.projects()<cr>", "Projects" },
    b = {
        name = '+buffer',
        d = { '<cmd>BufferOrderByDirectory<CR>', 'order by dir' },
        l = { '<cmd>BufferOrderByLanguage<CR>', 'order by language' },
    },

    l = {
        name = '+lsp',
        c = { '<cmd>Lspsaga code_action<CR>', 'code actions' },
        i = { '<cmd>Lspsaga show_line_diagnostics<CR>', 'info' },
        r = { '<cmd>Lspsaga rename<CR>', 'rename' },
        s = { '<cmd>Telescope lsp_document_symbols<CR>', 'document symbols' },
        S = { '<cmd>Telescope lsp_workspace_symbols<CR>', 'workspace symbols' },
        P = { '<cmd>Lspsaga preview_definition<CR>', 'preview definition' },
        f = { '<cmd>Lspsaga lsp_finder<CR>', 'lsp finder' },
        l = { '<cmd>Lspsaga show_line_diagnostics<CR>', 'line diagnostics' },
        d = { '<cmd>lua vim.lsp.buf.declaration()<CR>', 'declaration' },
        R = { '<cmd>lua vim.lsp.buf.references()<CR>', 'references' },
        p = { '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>', 'prev diagnostic' },
        n = { '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>', 'prev diagnostic' },
    },

    g = {
        name = '+git',
        s = { '<cmd>Telescope git_status<CR>', 'status' },
        l = { '<cmd>LazyGit<CR>', 'lazy git' },
        c = { '<cmd>LazyGitConfig<CR>', 'lazy git' },
    },

    d = {
        name = '+debugging',
        b = { "<cmd>lua require'dap'.toggle_breakpoint()<CR>", 'toggle breakpoint' },
        c = { "<cmd>lua require'dap'.continue()<CR>", 'continue' },
        o = { "<cmd>lua require'dap'.step_over()<CR>", 'step over' },
        O = { "<cmd>lua require'dap'.step_out()<CR>", 'step out' },
        i = { "<cmd>lua require'dap'.step_into()<CR>", 'step into' },
        C = { "<cmd>lua require'dap'.close()<CR>", 'close' },
        -- e = { '<cmd>lua require("dapui").eval()<CR>', 'evaluate' },
        l = { "<cmd>lua require'dap'.run_last()<CR>", 'run last' },
        t = { "<cmd>lua require('dapui').toggle()<CR>", 'toggle UI'},
        T = { "<cmd>lua require('neotest').run.run({strategy = 'dap'})<CR>", 'nearest test' },
    },
     t = {
        name = '+testing',
        n = { "<cmd>lua require('neotest').run.run()<CR>", 'test nearest' },
        f = { "<cmd>lua require('neotest').run.run(vim.fn.expand('%'))<CR>", 'test file' },
        s = { "<cmd>lua require('neotest').run.stop()<CR>", 'stop test' },
    }
}

which_key.setup(setup)
which_key.register(mappings, opts)
