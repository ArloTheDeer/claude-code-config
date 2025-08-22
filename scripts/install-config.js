const shell = require('shelljs');
const path = require('path');
const os = require('os');

function installConfig() {
  try {
    // Check for --overwrite flag
    const hasOverwriteFlag = process.argv.includes('--overwrite');
    
    console.log('📦 Starting installation...');
    console.log(`Platform: ${process.platform}`);
    console.log(`Overwrite mode: ${hasOverwriteFlag ? 'enabled' : 'disabled'}`);
    
    // Cross-platform target path handling
    const targetDir = path.join(os.homedir(), '.claude', 'commands');
    console.log(`Target directory: ${targetDir}`);
    
    // Get list of .md files to install
    const files = shell.ls('commands/*.md');
    if (files.code !== 0) {
      throw new Error('Commands directory not found or no .md files available');
    }
    console.log(`Found ${files.length} files to install: ${files.map(f => path.basename(f)).join(', ')}`);
    
    // Check for conflicting files
    const conflicts = [];
    files.forEach(file => {
      const filename = path.basename(file);
      const targetPath = path.join(targetDir, filename);
      if (shell.test('-f', targetPath)) {
        conflicts.push(filename);
      }
    });
    
    // If conflicts exist and no --overwrite flag, stop installation
    if (conflicts.length > 0 && !hasOverwriteFlag) {
      console.log(`❌ Found existing files: ${conflicts.join(', ')}`);
      console.log('Use --overwrite flag to overwrite existing files:');
      console.log('npm run install-config -- --overwrite');
      process.exit(1);
    }
    
    if (conflicts.length > 0) {
      console.log(`⚠️  Will overwrite ${conflicts.length} existing files: ${conflicts.join(', ')}`);
    }
    
    // TODO: Implement file copying and directory management
    // TODO: Implement user feedback messages
    
    console.log('✅ Installation complete!');
    
  } catch (error) {
    console.error(`Error: ${error.message}`);
    process.exit(1);
  }
}

// Execute installation if script is run directly
if (require.main === module) {
  installConfig();
}

module.exports = installConfig;