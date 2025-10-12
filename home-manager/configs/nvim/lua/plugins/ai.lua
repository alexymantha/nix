return {
    {
        "frankroeder/parrot.nvim",
        dependencies = { 'ibhagwan/fzf-lua', 'nvim-lua/plenary.nvim' },
        cond = function()
            return (os.getenv("CHAT_GOTO_KEY") and os.getenv("CHAT_GOTO_ENDPOINT")) or os.getenv("CLAUDE_KEY")
        end,
        config = function()
            local gotoai_key = os.getenv("CHAT_GOTO_KEY")
            local gotoai_endpoint = os.getenv("CHAT_GOTO_ENDPOINT")

            local providers = {}
            if gotoai_key and gotoai_endpoint then
                providers.gotoai = {
                    name = "gotoai",
                    api_key = gotoai_key,
                    endpoint = gotoai_endpoint,
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
                }
            end

            local claude_key = os.getenv("CLAUDE_KEY")

            if claude_key then
                providers.anthropic = {
                    name = "anthropic",
                    endpoint = "https://api.anthropic.com/v1/messages",
                    model_endpoint = "https://api.anthropic.com/v1/models",
                    api_key = claude_key,
                    params = {
                        chat = { max_tokens = 4096 },
                        command = { max_tokens = 4096 },
                    },
                    topic = {
                        model = "claude-3-5-haiku-latest",
                        params = { max_tokens = 32 },
                    },
                    headers = function(self)
                        return {
                            ["Content-Type"] = "application/json",
                            ["x-api-key"] = self.api_key,
                            ["anthropic-version"] = "2023-06-01",
                        }
                    end,
                    models = {
                        "claude-sonnet-4-20250514",
                        "claude-3-7-sonnet-20250219",
                        "claude-3-5-sonnet-20241022",
                        "claude-3-5-haiku-20241022",
                    },
                    preprocess_payload = function(payload)
                        for _, message in ipairs(payload.messages) do
                            message.content = message.content:gsub("^%s*(.-)%s*$", "%1")
                        end
                        if payload.messages[1] and payload.messages[1].role == "system" then
                            -- remove the first message that serves as the system prompt as anthropic
                            -- expects the system prompt to be part of the API call body and not the messages
                            payload.system = payload.messages[1].content
                            table.remove(payload.messages, 1)
                        end
                        return payload
                    end,
                }
            end
            if next(providers) then
                require("parrot").setup {
                    providers = providers,
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
            end
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
