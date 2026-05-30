# AI_RUN_LOG — Command Run Log

> **Role**: Written by **Claude Code or other coding agent (Executor)** to record every significant command execution.
>
> This file is a chronological log of commands, their output, and their outcomes.

---

## Command

- Record the exact command that was executed.

## Working Directory

- Record the directory in which the command was run.

## Timestamp

- Record when the command was executed.

## Dry-Run Result

- If a dry-run was performed before the actual execution, record the result here.
- If no dry-run was applicable, write `N/A`.
- Dry-run commands (if any):
  ```
  <dry-run command here>
  ```
- Dry-run outcome:

## Output Summary

- Summarize the key output of the command.

## Full Error Output

- If errors occurred, record the complete error text here.
- If no errors, write `None`.

## Execution Result

- **Success** / **Failed** / **Partial**
- If Partial, describe what succeeded and what failed.
- Exit code (if available):

## Verification Result

- After execution, was the result verified (e.g., by running tests, checking output, manual inspection)?
- **Verified** / **Not Verified** / **Verification Failed**
- Verification method:
- Verification outcome:

## Conclusion

- Describe the result and impact of this command.

## Report Links

- Link to related files or artifacts produced by this execution:
  - AI_HANDOFF.md: [link or path]
  - AI_CHANGELOG.md: [link or path]
  - Any test output files: [path]
  - Any build artifacts: [path]

---

## <!-- 中文版 -->

<!--
## 运行命令
- 记录执行过的命令

## 运行目录
- 记录命令所在目录

## 运行时间
- 记录时间

## 试运行结果
- 如在实际执行前进行了试运行，在此记录结果
- 如不适用，填写"不适用"
- 试运行命令（如有）：________
- 试运行结果：

## 输出摘要
- 简述关键输出

## 完整错误信息
- 如有报错，请完整记录
- 如无错误，填写"无"

## 执行结果
- 成功 / 失败 / 部分成功
- 如部分成功，描述成功和失败的部分
- 退出码（如有）：

## 验证结果
- 执行后是否对结果进行了验证（如运行测试、检查输出、手动检查）？
- 已验证 / 未验证 / 验证失败
- 验证方式：
- 验证结果：

## 结论
- 说明该命令的结果和影响

## 报告链接
- 关联文件或本次执行产出的链接：
  - AI_HANDOFF.md：
  - AI_CHANGELOG.md：
  - 测试输出文件：
  - 构建产物：
-->
