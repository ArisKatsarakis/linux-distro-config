local M = {}

local state = {
  floating = {
    buf = -1,
    win = -1,
  }
}

function M.OpenCenteredBuffer(opts)
  local width = math.floor(vim.o.columns * 0.8)
  local height = math.floor(vim.o.lines * 0.8)

  local win_config = {
    relative = "editor",
    width = width,
    height = height,
    col = math.floor((vim.o.columns - width) / 2),
    row = math.floor((vim.o.lines - height) / 2),
    style = "minimal",
    border = "rounded"
  }
  local buf = nil
  if vim.api.nvim_buf_is_valid(opts.buf) then
    buf = opts.buf
  else
    buf = vim.api.nvim_create_buf(false, true)
  end

  local win = vim.api.nvim_open_win(buf, true, win_config)

  return { buf = buf, win = win }
end

local job_id = 0
function M.TermCenter()
  if not vim.api.nvim_win_is_valid(state.floating.win) then
    state.floating = M.OpenCenteredBuffer({ buf = state.floating.buf })
    if vim.bo[state.floating.buf].buftype ~= 'terminal' then
      vim.cmd.terminal()
      vim.cmd("setlocal nobuflisted")
      job_id = vim.bo.channel
    end
  else
    vim.api.nvim_win_hide(state.floating.win)
  end
end

return M
