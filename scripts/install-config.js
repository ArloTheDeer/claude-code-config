const shell = require('shelljs');
const path = require('path');
const os = require('os');
const fs = require('fs');

// Skill names that will be installed (used for old commands cleanup)
const SKILL_NAMES = ['research', 'create-prd', 'create-impl-plan', 'process-task-list', 'acceptance-test'];

/**
 * Check if skill directories already exist in target location
 */
function checkSkillConflicts(skillDirs, targetDir) {
  const conflicts = [];
  skillDirs.forEach(skillPath => {
    const skillName = path.basename(skillPath);
    const targetPath = path.join(targetDir, skillName);
    if (shell.test('-d', targetPath)) {
      conflicts.push(skillName);
    }
  });
  return conflicts;
}

/**
 * Create target directory if it doesn't exist
 */
function createTargetDirectory(targetDir) {
  if (!shell.test('-d', targetDir)) {
    console.log(`📁 Creating directory: ${targetDir}`);
    shell.mkdir('-p', targetDir);
    if (shell.error()) {
      throw new Error(`Failed to create directory: ${shell.error()}`);
    }
  }
}

/**
 * Copy skill directories recursively
 */
function copySkillDirectories(skillDirs, targetDir) {
  console.log('📋 Copying skills...');
  let successCount = 0;
  let errorCount = 0;

  skillDirs.forEach(skillPath => {
    const skillName = path.basename(skillPath);
    const targetPath = path.join(targetDir, skillName);
    console.log(`  Copying ${skillName}/...`);

    // Remove existing directory if it exists (for overwrite mode)
    if (shell.test('-d', targetPath)) {
      shell.rm('-rf', targetPath);
    }

    // Copy entire directory recursively
    shell.cp('-r', skillPath, targetDir);
    if (shell.error()) {
      console.error(`  ❌ Error: Failed to copy ${skillName}`);
      errorCount++;
    } else {
      console.log(`  ✅ Copied ${skillName}/`);
      successCount++;
    }
  });

  return { successCount, errorCount };
}

/**
 * Clean up old commands that have been migrated to skills
 */
function cleanupOldCommands() {
  const commandsDir = path.join(os.homedir(), '.claude', 'commands');
  const cleanedFiles = [];

  if (!shell.test('-d', commandsDir)) {
    return cleanedFiles;
  }

  console.log('🧹 Checking for old commands to clean up...');

  SKILL_NAMES.forEach(skillName => {
    const commandFile = path.join(commandsDir, `${skillName}.md`);
    if (shell.test('-f', commandFile)) {
      shell.rm(commandFile);
      if (!shell.error()) {
        console.log(`  🗑️  Removed old command: ${skillName}.md`);
        cleanedFiles.push(`${skillName}.md`);
      }
    }
  });

  // Also check for acceptance-tester (old agent name)
  const oldAgentCommand = path.join(commandsDir, 'acceptance-tester.md');
  if (shell.test('-f', oldAgentCommand)) {
    shell.rm(oldAgentCommand);
    if (!shell.error()) {
      console.log(`  🗑️  Removed old command: acceptance-tester.md`);
      cleanedFiles.push('acceptance-tester.md');
    }
  }

  return cleanedFiles;
}

/**
 * Clean up old agents directory
 */
function cleanupOldAgents() {
  const agentsDir = path.join(os.homedir(), '.claude', 'agents');
  const cleanedFiles = [];

  if (!shell.test('-d', agentsDir)) {
    return cleanedFiles;
  }

  console.log('🧹 Checking for old agents to clean up...');

  // Check for acceptance-tester agent
  const agentFile = path.join(agentsDir, 'acceptance-tester.md');
  if (shell.test('-f', agentFile)) {
    shell.rm(agentFile);
    if (!shell.error()) {
      console.log(`  🗑️  Removed old agent: acceptance-tester.md`);
      cleanedFiles.push('acceptance-tester.md');
    }
  }

  return cleanedFiles;
}

/**
 * Get list of skill directories to install
 */
function getSkillDirectories() {
  const skillsPattern = 'skills/*';
  const dirs = shell.ls('-d', skillsPattern);

  if (dirs.code !== 0 || dirs.length === 0) {
    return { success: false, dirs: [] };
  }

  // Filter to only include directories that contain SKILL.md
  const validDirs = dirs.filter(dir => {
    const skillFile = path.join(dir, 'SKILL.md');
    return shell.test('-f', skillFile);
  });

  return { success: true, dirs: validDirs };
}

/**
 * Main installation function
 */
function installConfig() {
  try {
    // Check for overwrite flag
    const hasOverwriteFlag = process.argv.includes('overwrite');

    console.log('📦 Starting Skills installation...');
    console.log(`Platform: ${process.platform}`);
    console.log(`Overwrite mode: ${hasOverwriteFlag ? 'enabled' : 'disabled'}`);
    console.log('');

    // Get skill directories
    const { success, dirs: skillDirs } = getSkillDirectories();

    if (!success || skillDirs.length === 0) {
      throw new Error('No valid skill directories found in skills/');
    }

    console.log(`Found ${skillDirs.length} skills to install: ${skillDirs.map(d => path.basename(d)).join(', ')}`);

    const targetDir = path.join(os.homedir(), '.claude', 'skills');
    console.log(`Target directory: ${targetDir}`);
    console.log('');

    // Check for conflicts
    const conflicts = checkSkillConflicts(skillDirs, targetDir);

    if (conflicts.length > 0 && !hasOverwriteFlag) {
      console.log(`❌ Found existing skills: ${conflicts.join(', ')}`);
      console.log('Use overwrite flag to overwrite existing skills:');
      console.log('npm run install-config -- overwrite');
      process.exit(1);
    }

    if (conflicts.length > 0) {
      console.log(`⚠️  Will overwrite ${conflicts.length} existing skills: ${conflicts.join(', ')}`);
      console.log('');
    }

    // Clean up old commands and agents first
    const cleanedCommands = cleanupOldCommands();
    const cleanedAgents = cleanupOldAgents();

    if (cleanedCommands.length > 0 || cleanedAgents.length > 0) {
      console.log('');
    }

    // Create target directory and copy skills
    createTargetDirectory(targetDir);
    const { successCount, errorCount } = copySkillDirectories(skillDirs, targetDir);

    // Final user feedback
    console.log('');
    if (errorCount > 0) {
      console.log(`⚠️  Installation completed with ${errorCount} errors out of ${successCount + errorCount} skills`);
      process.exit(1);
    } else {
      console.log(`✅ Installation successful! Installed ${successCount} skills`);
      if (conflicts.length > 0) {
        console.log(`⚠️  Overwritten ${conflicts.length} existing skills`);
      }
      if (cleanedCommands.length > 0) {
        console.log(`🧹 Cleaned up ${cleanedCommands.length} old commands`);
      }
      if (cleanedAgents.length > 0) {
        console.log(`🧹 Cleaned up ${cleanedAgents.length} old agents`);
      }
    }

    // Display installed skills
    console.log('');
    console.log('📋 Installed skills:');
    skillDirs.forEach(skillPath => {
      const skillName = path.basename(skillPath);
      console.log(`    • ${skillName}/`);
    });

    console.log('');
    console.log('🎉 You can now use these skills in Claude Code!');
    console.log('   Invoke manually with /<skill-name> (e.g., /research, /create-prd)');
    console.log('   Or let Claude automatically detect when to use them.');

  } catch (error) {
    console.error(`Error: ${error.message}`);
    process.exit(1);
  }
}

// Execute installation if script is run directly
if (require.main === module) {
  installConfig();
}

module.exports = {
  installConfig,
  checkSkillConflicts,
  createTargetDirectory,
  copySkillDirectories,
  cleanupOldCommands,
  cleanupOldAgents,
  getSkillDirectories,
  SKILL_NAMES
};
