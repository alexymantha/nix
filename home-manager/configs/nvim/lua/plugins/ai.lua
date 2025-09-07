return {
    {
        "frankroeder/parrot.nvim",
        dependencies = { 'ibhagwan/fzf-lua', 'nvim-lua/plenary.nvim' },
        config = function()
            require("parrot").setup {
                providers = {
                    gotoai = {
                        name = "gotoai",
                        api_key = os.getenv "CHAT_EXPERTCITY_KEY",
                        endpoint = os.getenv "CHAT_ENDPOINT",
                        model_endpoint = "https://api.anthropic.com/v1/models",
                        params = {
                            chat = { max_tokens = 4096 },
                            command = { max_tokens = 4096 },
                        },
                        topic = {
                            model = "gpt-5-nano",
                            params = { max_completion_tokens = 64 },
                        },
                        models = {
                            "bedrock-claude-v4.0_Sonnet",
                            "bedrock-claude-v3.7_Sonnet",
                            "bedrock-claude-v3.5_Sonnet",
                            "gpt-5-nano",
                            "gpt-5",
                        },
                    },
                },
                hooks = {
                    SpellCheck = function(prt, params)
                        local chat_prompt = [[
                              Your task is to take the text provided and rewrite it into a clear,
                              grammatically correct version while preserving the original meaning
                              as closely as possible. Correct any spelling mistakes, punctuation
                              errors, verb tense issues, word choice problems, and other
                              grammatical mistakes. You must not change the structure of a sentence,
                              only correct the simple mistakes above.
                            ]]
                        prt.ChatNew(params, chat_prompt)
                    end,
                }
            }


            vim.keymap.set("n", "<Leader>ac", ":PrtChatToggle<CR>")
            vim.keymap.set("n", "<Leader>an", ":PrtChatNew<CR>", { desc = "Start new chat" })
            vim.keymap.set("v", "<Leader>an", ":PrtChatNew<CR>", { desc = "Start new chat with selection" })
            vim.keymap.set("v", "<Leader>ar", ":PrtChatRewrite")
            vim.keymap.set("v", "<Leader>ap", ":PrtChatPrepend")
            vim.keymap.set("v", "<Leader>ab", ":PrtChatAppend")
            vim.keymap.set("n", "<C-CR>", ":PrtChatResponde<CR>")
            vim.keymap.set("i", "<C-CR>", ":PrtChatResponde<CR>")
        end,
    },
    {
        "zbirenbaum/copilot.lua",
        cmd = "Copilot",
        event = "InsertEnter",
        opts = {
            suggestion = { enabled = false },
            panel = { enabled = false },
        },
    },
}
