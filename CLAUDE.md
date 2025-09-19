# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a specification-driven development workflow command set designed for Claude Code and other AI assistants. The project provides a structured three-step methodology: from requirement clarification to complete implementation, ensuring the development process is clear and traceable through PRD (Product Requirements Document) driven development.

The core value lies in ensuring every feature goes through thorough requirement analysis, has clear implementation plans, and maintains a trackable, interruptible, and resumable execution process.

## Core Architecture

The project follows a three-step specification-driven workflow:

### Step 1: Requirement Clarification (`/create-prd`)
- Interactive Q&A to clarify feature requirements
- Generate comprehensive Product Requirements Document (PRD)
- Output: `docs/specs/[date]-[feature-name]/prd.md`

### Step 2: Implementation Planning (`/create-impl-plan`)
- Analyze PRD and existing codebase architecture
- Generate 5-7 specific implementation tasks with detailed implementation points
- Automatic TDD annotation support and Gherkin acceptance test generation
- Output: `implementation.md` + `acceptance.feature`
- **Enhanced Feature**: Implementation reference information extraction from research and PRD files

### Step 3: Task Execution (`/process-task-list`)
- Execute implementation tasks one by one with automatic git commits
- TDD workflow auto-expansion (7 sub-tasks for red-green-refactor cycle)
- Acceptance testing integration with specialized acceptance-tester agent
- Support for multi-session execution for long-term development

### Supporting Components

#### Installation System (`/scripts/`)
- **install-config.js**: Automated installation to `~/.claude/commands`
- Cross-platform compatibility and conflict detection

#### Documentation Output (`/docs/`)
- **research/**: Research documents (optional auxiliary feature)
- **specs/**: Complete specification folders with PRD, implementation plans, and acceptance tests

## Common Commands

### Development Setup
```bash
# Install workflow commands to Claude Code
npm run install-config

# Force overwrite existing commands
npm run install-config -- overwrite
```

### Project Dependencies
- **shelljs**: For cross-platform shell operations in installation scripts
- **Node.js**: Required for installation scripts execution

## Key Workflow Patterns

### 1. Research-Driven Development
- Start with `/research` command for complex problems
- Output: `docs/research/[date]-[topic].md`
- Focus on problem understanding before solution design

### 2. PRD-First Feature Development
- Use `/create-prd` for new feature requirements
- Output: `docs/specs/[date]-[feature-name]/prd.md`
- Target audience: Junior developers (clear, unambiguous requirements)

### 3. Implementation Planning
- Use `/create-impl-plan` to convert PRD to actionable tasks
- Output: Implementation markdown + Gherkin acceptance tests
- Integrates with Claude Code's TodoWrite tool

### 4. TDD Development Integration
- Use "使用 TDD 開發流程" annotation in implementation tasks
- Automatic expansion into 7 TDD sub-tasks:
  1. Run existing tests first
  2. Confirm interface modification requirements (new/modify/logic-only)
  3. Write test descriptions
  4. Implement test logic
  5. Run tests (red phase)
  6. Implement actual code
  7. Run tests again (green phase)
- Enforces strict red-green-refactor cycles within main context
- Never implements logic before tests are written

### 5. Acceptance Testing Integration
- Automatic detection of acceptance testing tasks
- Launches specialized acceptance-tester agent with complete file context
- Executes Gherkin scenarios through commands and browser automation
- Receives implementation.md, acceptance.feature, and prd.md for comprehensive testing

## File Naming Conventions

- Research documents: `[YYYY-MM-DD]-[topic-slug].md`
- Spec folders: `[YYYY-MM-DD]-[feature-name]/`
- Spec contents: `prd.md`, `implementation.md`, `acceptance.feature`

## Installation Locations

- **Windows**: `C:\Users\[username]\.claude\commands` and `C:\Users\[username]\.claude\agents`
- **macOS/Linux**: `~/.claude/commands` and `~/.claude/agents`

## Language Support

All workflow commands automatically adapt to user's conversation language:
- Chinese conversations → Traditional Chinese documentation
- English conversations → English documentation
- Code, comments, and git commit messages always in English

## Integration Points

### Claude Code TodoWrite Tool
- Task synchronization between internal lists and markdown files
- Bi-directional task state management with persistent storage
- TDD task auto-expansion with 7 sub-tasks management
- Git workflow integration with semantic commit messages

### Testing Framework
- Gherkin format acceptance criteria with Traditional Chinese support
- Support for both terminal commands and browser automation
- AI-executable test scenarios with comprehensive file context
- Acceptance-tester agent integration for systematic validation

### Implementation Context Transfer Enhancement
- Automatic extraction of implementation-related technical information from research and PRD files
- Preservation of code examples, technical decisions, and verified solutions
- Three-tier reference structure: research insights → PRD details → key technical decisions
- Enhanced task execution with complete background context

## Development Best Practices

1. **Three-Step Sequential Workflow**: Follow requirement clarification → implementation planning → task execution
2. **Clarification First**: Thorough Q&A during PRD creation to ensure requirement clarity
3. **Specification-Driven**: Every feature must have clear PRD before implementation
4. **Continuous Sync**: Keep task states updated in real-time with TodoWrite integration
5. **Version Control**: Automatic git commit after each completed task with semantic messages
6. **TDD When Applicable**: Use TDD annotation for complex logic implementation
7. **Comprehensive Testing**: Complete acceptance testing with full context awareness

## Technical Considerations

- Cross-platform installation script using shelljs
- File conflict detection prevents accidental overwrites
- Modular command structure allows independent updates
- Integrated TDD workflow with automatic task expansion
- Acceptance-tester agent integration for comprehensive validation
- Implementation context preservation across research → PRD → implementation phases
- Support for both research-driven and direct PRD development approaches
- Relative path handling for cross-platform compatibility