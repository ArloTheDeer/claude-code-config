const shell = require('shelljs');
const path = require('path');
const os = require('os');

function installConfig() {
  try {
    // Check for overwrite flag
    const hasOverwriteFlag = process.argv.includes('overwrite');
    
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
      console.log('Use overwrite flag to overwrite existing files:');
      console.log('npm run install-config -- overwrite');
      process.exit(1);
    }
    
    if (conflicts.length > 0) {
      console.log(`⚠️  Will overwrite ${conflicts.length} existing files: ${conflicts.join(', ')}`);
    }
    
    // Check and create target directory
    if (!shell.test('-d', targetDir)) {
      console.log(`📁 Creating directory: ${targetDir}`);
      shell.mkdir('-p', targetDir);
      if (shell.error()) {
        throw new Error(`Failed to create directory: ${shell.error()}`);
      }
    }
    
    // Copy files to target directory
    console.log('📋 Copying files...');
    let successCount = 0;
    let errorCount = 0;
    
    files.forEach(file => {
      const filename = path.basename(file);
      console.log(`  Copying ${filename}...`);
      
      shell.cp(file, targetDir);
      if (shell.error()) {
        console.error(`  ❌ Error: Failed to copy ${filename}`);
        errorCount++;
      } else {
        console.log(`  ✅ Copied ${filename}`);
        successCount++;
      }
    });
    
    // Final user feedback
    console.log('');
    if (errorCount > 0) {
      console.log(`⚠️  Installation completed with ${errorCount} errors out of ${files.length} files`);
      process.exit(1);
    } else {
      console.log(`✅ Installation successful! Installed ${successCount} files to ${targetDir}`);
      if (conflicts.length > 0) {
        console.log(`⚠️  Overwritten ${conflicts.length} existing files`);
      }
    }
    
    console.log('');
    console.log('📋 Installed files:');
    files.forEach(file => {
      const filename = path.basename(file);
      console.log(`  • ${filename}`);
    });
    
    console.log('');
    console.log('🎉 You can now use these commands in Claude Code!');
    
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