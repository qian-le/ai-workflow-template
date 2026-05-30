# AI_TASK — Task Assignment

> **Role**: Written by **Codex (Architect)**, consumed by **Claude Code or other coding agent (Executor)**
>
> This file defines the single, bounded task the Executor must complete in this round. The Executor MUST NOT modify this file.

---

## Task Title

- Fill in the title of this round's task.

## Task Background

- Describe the current problem, context, and trigger for this task.

## Objective

- State the concrete result that MUST be achieved in this round.
- Scope to this round only — do not describe future plans.

## Allowed Scope (Files / Directories)

- List the files, directories, or modules the Executor is authorized to modify.
- If only a small number of files are allowed, list each one explicitly.

## Forbidden Scope

- Do NOT modify files outside the authorized scope.
- Do NOT modify infrastructure, dependencies, or config unless explicitly authorized.
- Do NOT modify `AI_TASK.md`.
- Do NOT fix unrelated issues discovered during execution.

## Execution Steps

1. Make the minimum change required to meet the objective.
2. After each key step, update the corresponding record file(s).
3. If something is unclear, write it to `AI_HANDOFF.md` — do not guess.

## Test / Verification Commands

- List the commands that MUST be run.
- Specify the working directory for each command.
- State the expected output or result.

## Failure Handling

- If execution fails, record the failing command and error output first.
- Do NOT use speculative changes to mask the problem.
- If blocked, write the blocker to `AI_HANDOFF.md` and stop.

## Safety Notes

- If the task involves destructive operations (deleting files, force-pushing, dropping tables, etc.), list explicit safeguards.
- If no destructive operations are involved, write `None`.
- Specify any environment variables, credentials, or secrets required and how they should be provided.

## Files the Executor Must Update After Completion

- `AI_HANDOFF.md`
- `AI_CHANGELOG.md`
- `AI_RUN_LOG.md`

## Required Final Report

- After completing all work, the Executor MUST produce a brief final report summarizing: what was done, what tests passed, any remaining issues, and the path to each updated record file.

## Task Intake Report Path

- Path where the Executor should look for this task file: `AI_TASK.md` (project root by default).
- If a different path is used, specify it here:
  - `___________________________`

## Completion Criteria

- All objectives met.
- No scope violations.
- All required test / verification commands executed.
- Handoff and log files updated.

## Constraints for the Executor

- Execute only the explicitly stated tasks in this file.
- Do NOT expand scope, refactor broadly, or make architectural decisions.
- Do NOT modify `AI_TASK.md`.
- Write uncertainties to `AI_HANDOFF.md` — never guess.
- If the task definition is insufficient, stop at the safe boundary and record the issue.

---

## <!-- 中文版 -->

<!--
## 任务标题
- 填写本轮任务标题

## 任务背景
- 说明当前问题、上下文和触发原因

## 目标
- 明确本轮必须完成的结果
- 只写本轮范围，不写未来规划

## 允许修改范围
- 写明允许修改的文件、目录或模块
- 如果只能修改少量文件，请逐个列出

## 禁止修改范围
- 不允许修改未授权文件
- 不允许修改基础架构、依赖、配置，除非本任务明确授权
- 不允许修改 AI_TASK.md
- 不允许顺手修复无关问题

## 执行步骤
1. 按任务目标执行最小修改
2. 每完成关键一步后更新对应记录文件
3. 无法确认的内容写入 AI_HANDOFF.md

## 测试/验证命令
- 写明必须执行的命令
- 写明运行目录
- 写明预期结果

## 失败处理方式
- 如果执行失败，先记录失败命令与报错
- 不允许用猜测性改动掩盖问题
- 无法继续时，把阻塞点写入 AI_HANDOFF.md

## 安全注意事项
- 如果任务涉及破坏性操作（删除文件、强制推送、删除数据库表等），列出明确的安全措施
- 如果不涉及破坏性操作，填写"无"
- 说明所需的环境变量、凭据或密钥及其提供方式

## Claude Code 或其他编码代理完成后必须更新的文件
- AI_HANDOFF.md
- AI_CHANGELOG.md
- AI_RUN_LOG.md

## 必须提交的最终报告
- 完成所有工作后，执行方必须提供简要最终报告，包含：完成了什么、哪些测试通过、剩余问题、各更新记录文件的路径

## 任务单路径
- 执行方查找此任务文件的路径：AI_TASK.md（默认在项目根目录）
- 如使用不同路径，在此注明：___________________________

## 完成标准
- 目标全部完成
- 修改范围未越界
- 已执行要求中的测试或验证命令
- 交接与日志文件已更新

## 给执行方的约束
- 你只能执行这里写明的明确任务
- 不允许自由扩展需求
- 不允许大范围重构
- 不允许修改 AI_TASK.md
- 不确定的内容必须写入 AI_HANDOFF.md，不要猜测
- 如果发现任务定义不充分，先停在安全边界内并记录问题
-->
