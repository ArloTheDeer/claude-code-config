# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a standardized workflow command set designed for Claude Code and other AI assistants. The project provides structured methodologies for handling various stages of software development, from requirement research, PRD writing to implementation task management. It includes automated installation scripts for easy deployment to Claude Code environments.

## Core Architecture

The project follows a modular workflow system with four main components:

### 1. Commands System (`/commands/`)
- **research.md**: Deep investigation and analysis workflow
- **create-prd.md**: Product Requirements Document generation process  
- **create-impl-plan.md**: Implementation planning from PRD
- **process-task-list.md**: Task list management and tracking

### 2. Agents System (`/agents/`)
- **tdd-developer.md**: Specialized TDD (Test-Driven Development) agent configuration
- Agents follow strict red-green-refactor cycles for new functionality implementation

### 3. Installation System (`/scripts/`)
- **install-config.js**: Automated installation to `~/.claude/commands` and `~/.claude/agents`
- Handles conflict detection and overwrite scenarios
- Supports both Windows and Unix-like systems

### 4. Documentation Output (`/docs/`)
- **research/**: Research documents with date-topic naming
- **specs/**: Product specification folders with PRD, implementation plans, and acceptance tests

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

### 4. TDD Agent Integration
- Use `tdd-developer` agent for new functionality requiring TDD approach
- Enforces strict red-green-refactor cycles
- Never implements logic before tests are written

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
- Bi-directional task state management
- Git workflow integration with semantic commit messages

### Testing Framework
- Gherkin format acceptance criteria
- Support for both terminal commands and browser automation
- AI-executable test scenarios

## Development Best Practices

1. **Sequential Workflow**: Follow research → PRD → implementation order
2. **Clarification First**: Ask clarifying questions at each stage
3. **Continuous Sync**: Keep task states updated in real-time
4. **Version Control**: Git commit after each completed task
5. **Documentation First**: Record all decisions and progress in documents

## Technical Considerations

- The installation script uses shelljs for cross-platform compatibility
- File conflict detection prevents accidental overwrites
- Modular command structure allows independent updates
- Agent system supports specialized development methodologies